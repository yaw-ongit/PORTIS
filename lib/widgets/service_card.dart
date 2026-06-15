import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_models.dart';

// Widget kartu layanan di HomeScreen
class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // ── Foto provider ──
          Positioned.fill(
            child: _buildImage(),
          ),

          // ── Rating badge (kiri atas) ──
          Positioned(
            top: 8,
            left: 8,
            child: _buildRatingBadge(),
          ),

          // ── Nama & profesi (bawah) ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildNameTag(),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Jika path kosong, tunjukkan fallback
    if (service.imagePath.isEmpty) {
      return _buildFallback();
    }

    // Jika path adalah URL, gunakan NetworkImage
    final isNetwork = service.imagePath.startsWith('http');
    if (isNetwork) {
      return Image.network(
        service.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    // Jika bukan URL, coba pakai asset
    return Image.asset(
      service.imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: const Color(0xFFB3DFF0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 50, color: Colors.white.withOpacity(0.7)),
            const SizedBox(height: 4),
            Text(
              service.name.isNotEmpty ? service.name[0] : '?', // Inisial
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 12),
          const SizedBox(width: 2),
          Text(
            service.rating.toString(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            service.name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            service.profession,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
