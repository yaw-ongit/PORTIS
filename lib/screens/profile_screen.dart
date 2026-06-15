import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../widgets/profile_menu_item.dart';
import '../viewmodels/app_viewmodels.dart';
import 'edit_profile_screen.dart';

// ProfileScreen menampilkan info pengguna dan menu preferensi
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          final UserModel? user = authVM.currentUser;

          return Column(
            children: [
              // ── Header biru dengan foto profil ──
              _buildProfileHeader(
                context,
                user,
              ),

              // ── Konten scrollable ──
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Bagian Info Pengguna ──
                      _buildInfoSection(user),

                      const SizedBox(height: 8),

                      // ── Bagian Preferensi ──
                      _buildPreferencesSection(context),

                      // ── Versi aplikasi ──
                      _buildVersionText(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Header Biru ───
  Widget _buildProfileHeader(BuildContext context, UserModel? user) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6CC2E8), Color(0xFF90D4F0)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Judul halaman
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              child: Text(
                'Profil',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            // ── Avatar ──
            GestureDetector(
              onTap: user == null
                  ? null
                  : () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(user: user),
                        ),
                      );
                    },
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipOval(child: _buildProfileImage(user)),
              ),
            ),

            const SizedBox(height: 16),

            // ── Nama & Email ──
            Text(
              user?.name ?? 'User',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),

            // ── Tombol Edit Profil ──
            OutlinedButton(
              onPressed: user == null
                  ? null
                  : () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(user: user),
                        ),
                      );
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Edit Profil',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Bagian Info Pengguna ───
  Widget _buildInfoSection(UserModel? user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Info Pengguna',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 12),

          // Nama
          Text(
            user?.name ?? 'Nama Pengguna',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 6),

          // Email dengan tanda verifikasi
          Row(
            children: [
              Expanded(
                child: Text(
                  user?.phoneNumber ?? 'No. Telepon belum diisi',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.verified,
                color: Color(0xFF6CC2E8),
                size: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bagian Preferensi ───
  Widget _buildPreferencesSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferensi',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),

          // Menu-menu preferensi menggunakan ProfileMenuItem widget
          ProfileMenuItem(
            icon: Icons.home_outlined,
            label: 'Alamat',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.security_outlined,
            label: 'Privasi dan Keamanan',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.translate_outlined,
            label: 'Bahasa',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.dark_mode_outlined,
            label: 'Mode Gelap',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.help_outline,
            label: 'Bantuan dan Masukan',
            onTap: () {},
          ),
          const SizedBox(height: 16),

          // ── Tombol Sign Out ──
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _handleSignOut(context),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text(
                'Sign Out',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Sign Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthViewModel>().signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/signin');
              }
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ── Versi App ───
  Widget _buildProfileImage(UserModel? user) {
    if (user?.profileImageUrl != null && user!.profileImageUrl!.isNotEmpty) {
      final imageUrl = user.profileImageUrl!;
      if (imageUrl.startsWith('assets/')) {
        return Image.asset(imageUrl, fit: BoxFit.cover);
      }
      if (imageUrl.startsWith('http')) {
        return Image.network(imageUrl, fit: BoxFit.cover);
      }
      // Untuk local path, gunakan asset default (kompatibel cross-platform)
      return Image.asset(
        'assets/images/profile1.jpg',
        fit: BoxFit.cover,
        errorBuilder: (ctx, e, s) => Container(
          color: const Color(0xFF4BAFD4),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 52,
          ),
        ),
      );
    }

    return Image.asset(
      'assets/images/profile1.jpg',
      fit: BoxFit.cover,
      errorBuilder: (ctx, e, s) => Container(
        color: const Color(0xFF4BAFD4),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 52,
        ),
      ),
    );
  }

  Widget _buildVersionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Versi Aplikasi 1.0.0',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
