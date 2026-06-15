import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../viewmodels/app_viewmodels.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _profileImagePath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _profileImagePath = widget.user.profileImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickGalleryImage() async {
    final picker = ImagePicker();
    final result =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (result != null) {
      setState(() {
        _profileImagePath = result.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);

    final updatedUser = widget.user.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      profileImageUrl: _profileImagePath,
    );

    final success = await context.read<AuthViewModel>().updateUser(updatedUser);
    if (!mounted) return;

    setState(() => _saving = false);

    if (success) {
      Navigator.pop(context);
    } else {
      final message = context.read<AuthViewModel>().errorMessage ??
          'Gagal menyimpan profil';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Widget _buildProfileImage() {
    Widget image;
    if (_profileImagePath != null && _profileImagePath!.isNotEmpty) {
      if (_profileImagePath!.startsWith('http')) {
        // Network image
        image = Image.network(_profileImagePath!, fit: BoxFit.cover);
      } else if (_profileImagePath!.startsWith('assets/')) {
        // Asset image
        image = Image.asset(_profileImagePath!, fit: BoxFit.cover);
      } else {
        // Untuk path lokal, tampilkan icon (kompatibel cross-platform)
        image = const Icon(Icons.person, color: Colors.white, size: 48);
      }
    } else {
      image = const Icon(Icons.person, color: Colors.white, size: 48);
    }

    return GestureDetector(
      onTap: _pickGalleryImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4BAFD4),
              border: Border.all(color: Colors.white, width: 4),
            ),
            clipBehavior: Clip.antiAlias,
            child: image,
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 18, color: Color(0xFF6CC2E8)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6CC2E8),
        elevation: 0,
        title: Text('Edit Profil',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildProfileImage()),
            const SizedBox(height: 24),
            Text('Nama',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nama lengkap',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Email',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Telepon',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Nomor telepon',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6CC2E8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Simpan Perubahan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
