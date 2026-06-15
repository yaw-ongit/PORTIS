import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../viewmodels/app_viewmodels.dart';
import 'chat_screen.dart';
import 'checkout_screen.dart';

class AssistantDetailScreen extends StatefulWidget {
  final AssistantModel assistant;

  const AssistantDetailScreen({
    super.key,
    required this.assistant,
  });

  @override
  State<AssistantDetailScreen> createState() => _AssistantDetailScreenState();
}

class _AssistantDetailScreenState extends State<AssistantDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Optionally load full details dari database
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssistantViewModel>().selectAssistant(widget.assistant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final assistant = context.watch<AssistantViewModel>().selectedAssistant ??
        widget.assistant;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            backgroundColor: const Color(0xFF6CC2E8),
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF6CC2E8)),
              ),
            ),
            actions: [],
          ),

          // ── Profile Section ──
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF6CC2E8),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                children: [
                  // ── Avatar ──
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildAssistantImage(),
                  ),
                  const SizedBox(height: 16),

                  // ── Name & Type ──
                  Text(
                    assistant.name,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assistant.type.label,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 16),

                  // ── Rating ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < assistant.rating.toInt()
                              ? Colors.amber
                              : Colors.white30,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${assistant.rating}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Action Buttons ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              assistant: assistant,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message),
                      label: Text(
                        'P-Chat',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6CC2E8),
                        side: const BorderSide(color: Color(0xFF6CC2E8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutScreen(assistant: assistant),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6CC2E8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Booking',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Description ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    assistant.description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Info Section ──
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Info Asisten',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.person,
                    label: assistant.name,
                    value: assistant.age > 0
                        ? '${assistant.age} Tahun'
                        : 'Usia tidak tersedia',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.email,
                    label: assistant.email.isNotEmpty
                        ? assistant.email
                        : 'Email tidak tersedia',
                    value: '',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.phone,
                    label: assistant.phoneNumber.isNotEmpty
                        ? assistant.phoneNumber
                        : 'Nomor telepon tidak tersedia',
                    value: '',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.location_on,
                    label: assistant.location.isNotEmpty
                        ? assistant.location
                        : 'Lokasi tidak tersedia',
                    value: '',
                  ),
                ],
              ),
            ),
          ),

          // ── Detail Kualifikasi ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Kualifikasi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Pendidikan',
                    assistant.education.isNotEmpty
                        ? [assistant.education]
                        : ['Pendidikan tidak tersedia'],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Pengalaman',
                    assistant.qualifications.isNotEmpty
                        ? assistant.qualifications
                        : ['Pengalaman tidak tersedia'],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Sertifikasi',
                    assistant.certifications.isNotEmpty
                        ? assistant.certifications
                        : ['Sertifikasi tidak tersedia'],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Keahlian Teknis',
                    assistant.expertise.isNotEmpty
                        ? assistant.expertise
                        : ['Keahlian tidak tersedia'],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildAssistantImage() {
    final assistant = context.watch<AssistantViewModel>().selectedAssistant ??
        widget.assistant;

    if (assistant.imagePath.isEmpty) {
      return const Center(
        child: Icon(Icons.person, size: 60, color: Color(0xFF6CC2E8)),
      );
    }

    if (assistant.imagePath.startsWith('assets/')) {
      return Image.asset(assistant.imagePath, fit: BoxFit.cover);
    }

    return Image.network(assistant.imagePath, fit: BoxFit.cover);
  }

  Widget _buildDetailCard(String title, List<String> lines) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          ...lines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        line,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF414141),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6CC2E8), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
