import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_models.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final AssistantModel assistant;
  final String orderId;
  final String recipientName;

  const OrderConfirmationScreen(
      {super.key,
      required this.assistant,
      required this.orderId,
      required this.recipientName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle,
                        size: 70, color: Color(0xFF6CC2E8)),
                    const SizedBox(height: 12),
                    Text('Terima Kasih!',
                        style: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Layananmu #$orderId sedang diproses.',
                        style: GoogleFonts.poppins(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                  'Waktu Pemesanan: ${DateTime.now().toLocal().toString().split('.').first}',
                  style: GoogleFonts.poppins(fontSize: 13)),
              const SizedBox(height: 16),
              Text('Info Asisten',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE3E3E3)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: assistant.imagePath.isNotEmpty
                              ? (assistant.imagePath.startsWith('assets/')
                                  ? Image.asset(assistant.imagePath,
                                      fit: BoxFit.cover)
                                  : Image.network(assistant.imagePath,
                                      fit: BoxFit.cover))
                              : const Icon(Icons.person,
                                  color: Color(0xFF6CC2E8), size: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(assistant.name,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(assistant.type.label,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                        'Email',
                        assistant.email.isNotEmpty
                            ? assistant.email
                            : 'Tidak tersedia'),
                    _buildDetailRow('Telepon', assistant.phoneNumber),
                    _buildDetailRow('Lokasi', assistant.location),
                    _buildDetailRow(
                        'Pengalaman', '${assistant.experience} tahun'),
                    _buildDetailRow('Rating', assistant.rating.toString()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text('Asisten akan datang dalam 30 menit',
                          style: GoogleFonts.poppins()))
                ]),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F1F17),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text('Kembali',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700])),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
