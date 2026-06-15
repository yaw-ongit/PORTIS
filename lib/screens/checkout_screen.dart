import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_viewmodels.dart';
import '../models/app_models.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final AssistantModel assistant;

  const CheckoutScreen({super.key, required this.assistant});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _recipientController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedAddress = 'Rumah Ayah 1';
  int _selectedPaymentIndex = 0;

  @override
  void initState() {
    super.initState();
    _recipientController.text = '';
    _ageController.text = '';
    _phoneController.text = '';
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assistant = widget.assistant;
    // Simple pricing calculation
    final pricePerHour = 30000.0;
    final durationHours = 6;
    final transport = 10000.0;
    final admin = 5000.0;
    final subtotal = pricePerHour * durationHours + transport + admin;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
            centerTitle: true,
            title: Text('Checkout',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Info Penerima Layanan',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildTextField('Nama*', _recipientController, hint: ''),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField('Usia*', _ageController,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildTextField(
                              'Nomor Telepon', _phoneController,
                              hint: '+628...')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('Catatan untuk Asisten*', _notesController,
                      maxLines: 3),
                  const SizedBox(height: 20),
                  Text('Alamat',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedAddress,
                    items: ['Rumah Ayah 1', 'Rumah Sendiri', 'Alamat Lain']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(
                        () => _selectedAddress = v ?? _selectedAddress),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[50]),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map),
                    label: Text('Pilih di Peta', style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey[300]!)),
                  ),
                  const SizedBox(height: 20),
                  Text('Pembayaran',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildPaymentOption(0, 'Portisku'),
                  _buildPaymentOption(1, 'Qris'),
                  _buildPaymentOption(2, 'Mitra'),
                  _buildPaymentOption(3, 'Transfer Bank (Axim Bank ****4578)'),
                  const SizedBox(height: 24),
                  Text('Detail Layanan',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildDetailRow('Tipe Asisten', assistant.type.label),
                  _buildDetailRow('Durasi Layanan', '~$durationHours jam'),
                  _buildDetailRow(
                      'Biaya per jam', 'Rp${pricePerHour.toInt()},00'),
                  _buildDetailRow(
                      'Biaya Transportasi', 'Rp${transport.toInt()}'),
                  _buildDetailRow('Biaya Admin', 'Rp${admin.toInt()}'),
                  const Divider(),
                  _buildDetailRow('Total', 'Rp${subtotal.toInt()},00',
                      isBold: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Simple validation
                        final recipient = _recipientController.text.trim();
                        if (recipient.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Masukkan nama penerima')));
                          return;
                        }

                        // Generate order id
                        final orderId =
                            'BE${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

                        // Build booking model
                        final user = context.read<AuthViewModel>().currentUser;
                        final booking = BookingModel(
                          id: orderId,
                          userId: user?.uid ?? 'anonymous',
                          assistantId: assistant.id,
                          recipientName: recipient,
                          phoneNumber: _phoneController.text.trim(),
                          address: _selectedAddress,
                          scheduleDate: DateTime.now().toIso8601String(),
                          scheduleTime: '09:00-15:00',
                          status: 'pending',
                          notes: _notesController.text.trim(),
                          price: subtotal,
                          createdAt: DateTime.now(),
                        );

                        final ok = await context
                            .read<AssistantViewModel>()
                            .createBooking(booking);

                        if (ok) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderConfirmationScreen(
                                assistant: assistant,
                                orderId: orderId,
                                recipientName: recipient,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Gagal membuat pesanan')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F1F17),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text('Pesan',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController c,
      {String hint = '',
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700])),
        const SizedBox(height: 8),
        TextField(
            controller: c,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)))),
      ],
    );
  }

  Widget _buildPaymentOption(int index, String label) {
    return RadioListTile<int>(
      value: index,
      groupValue: _selectedPaymentIndex,
      onChanged: (v) => setState(() => _selectedPaymentIndex = v ?? 0),
      title: Text(label, style: GoogleFonts.poppins(fontSize: 14)),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }
}
