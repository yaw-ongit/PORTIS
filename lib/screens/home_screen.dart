import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../widgets/service_card.dart';
import '../viewmodels/app_viewmodels.dart';
import 'assistant_detail_screen.dart';

// HomeScreen memiliki state untuk kategori yang dipilih
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load assistants when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssistantViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header Lokasi ──
            SliverToBoxAdapter(child: _buildLocationHeader()),

            // ── Search Bar ──
            SliverToBoxAdapter(child: _buildSearchBar()),

            // Category chips removed per request

            // ── Section: Rekomendasi Terdekat ──
            SliverToBoxAdapter(
                child: _buildSectionHeader('Rekomendasi Terdekat')),

            // ── Grid Layanan ──
            SliverToBoxAdapter(child: _buildServiceGrid()),

            // ── Section: Untuk Anda ──
            SliverToBoxAdapter(child: _buildSectionHeader('Untuk Anda')),

            // ── Banner Apotek ──
            SliverToBoxAdapter(child: _buildApotekBanner()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  // ── Header Lokasi ───
  Widget _buildLocationHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lokasi',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                'Jakarta',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6CC2E8)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          // Input pencarian
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Layanan di Sekitar mu',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Header ───
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'See more',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF6CC2E8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Grid Layanan 2x2 ───
  Widget _buildServiceGrid() {
    return Consumer<AssistantViewModel>(
      builder: (context, assistantVM, _) {
        if (assistantVM.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6CC2E8)),
                ),
              ),
            ),
          );
        }

        if (assistantVM.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'Error: ${assistantVM.errorMessage}',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
            ),
          );
        }

        final assistants = assistantVM.filteredAssistants;

        if (assistants.isEmpty) {
          // Jika tidak ada dari Firebase, tampilkan contoh statis agar UI tetap terlihat interaktif
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: AppData.services.length,
              itemBuilder: (context, index) {
                final s = AppData.services[index];
                return GestureDetector(
                  onTap: () {
                    final fallback = _assistantFromService(s);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AssistantDetailScreen(assistant: fallback),
                      ),
                    );
                  },
                  child: ServiceCard(service: s),
                );
              },
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: assistants.length,
            itemBuilder: (context, index) {
              final assistant = assistants[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AssistantDetailScreen(assistant: assistant),
                    ),
                  );
                },
                child: ServiceCard(
                  service: ServiceModel.fromAssistant(assistant),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Buat AssistantModel fallback dari ServiceModel (contoh data)
  AssistantModel _assistantFromService(ServiceModel s) {
    switch (s.id) {
      case '1':
        return AssistantModel(
          id: s.id,
          name: 'Dania Permaisuri',
          type: AssistantType.suster,
          rating: s.rating,
          imagePath: s.imagePath,
          description:
              'Lulusan Keperawatan STIKes Jakarta dengan 5 tahun pengalaman khusus di perawatan lansia dan penyakit kronis. Ahli dalam pemberian obat, perawatan luka, dan pemantauan tanda vital. Bersertifikasi Perawat Terdaftar (RN) dan Basic Life Support (BLS). Terampil menggunakan alat medis dan dokumentasi elektronik. Berkomitmen memberikan perawatan holistik berbasis bukti klinis.',
          phoneNumber: '+628123456789',
          location: 'Kebon Jeruk, Jakarta Barat, DKI Jakarta',
          email: 'DaniaPermai@gmail.com',
          age: 30,
          experience: 5,
          education: 'D3 Keperawatan\nSTIKES Jakarta (Lulus 2019)',
          certifications: [
            'Perawat Terdaftar (RN) - IDI',
            'Basic Life Support (BLS) - AHA',
            'Pelatihan Khusus Perawatan Paliatif',
          ],
          qualifications: [
            '5 tahun perawatan pasien geriatri',
            'Manajemen penyakit kronis (diabetes, hipertensi)',
            'Perawatan luka dekubitus & pasca-operasi',
            'Koordinasi dengan tim medis multidisiplin',
          ],
          expertise: [
            'Perawat Terdaftar (RN) - IDI',
            'Basic Life Support (BLS) - AHA',
            'Pelatihan Khusus Perawatan Paliatif',
          ],
        );
      case '3':
        return AssistantModel(
          id: s.id,
          name: 'Sista Wulandari',
          type: AssistantType.suster,
          rating: s.rating,
          imagePath: s.imagePath,
          description:
              'Perawat profesional lulusan D3 Keperawatan dengan fokus perawatan lansia dan dukungan pasien kronis. Berpengalaman dalam pemantauan tanda vital, perawatan luka, dan penyesuaian terapi obat. Menerapkan pendekatan empatik sekaligus kolaboratif bersama tim medis dan keluarga pasien.',
          phoneNumber: '+6281122334455',
          location: 'Kebayoran, Jakarta Selatan, DKI Jakarta',
          email: 'sista.care@gmail.com',
          age: 29,
          experience: 4,
          education: 'D3 Keperawatan\nAkademi Keperawatan Jakarta (Lulus 2020)',
          certifications: [
            'Basic Life Support (BLS) - AHA',
            'Pelatihan Perawatan Paliatif',
            'Pelatihan Manajemen Nyeri',
          ],
          qualifications: [
            '4 tahun perawatan pasien lansia',
            'Dukungan manajemen penyakit kronis',
            'Perawatan luka dan pemulihan pasca-operasi',
            'Kolaborasi dengan dokter dan keluarga pasien',
          ],
          expertise: [
            'Perawatan lansia dan kronis',
            'Pemantauan tanda vital dan pemberian obat',
            'Dokumentasi medis elektronik',
            'Komunikasi pasien dan keluarga',
          ],
        );
      case '2':
        return AssistantModel(
          id: s.id,
          name: 'Betty Suryani',
          type: AssistantType.art,
          rating: s.rating,
          imagePath: s.imagePath,
          description:
              'Asisten Rumah Tangga berpengalaman 5 tahun yang terbiasa menjaga kebersihan rumah, mengelola cucian dan persediaan, serta membantu persiapan makanan sederhana dan tugas harian keluarga. Telaten, disiplin, dan mudah beradaptasi dengan rutinitas keluarga.',
          phoneNumber: '+628139876543',
          location: 'Palmerah, Jakarta Barat, DKI Jakarta',
          email: 'betty.suryani@gmail.com',
          age: 27,
          experience: 5,
          education: 'SMKN 2411 Jakarta',
          certifications: ['Pelatihan Kebersihan Rumah'],
          qualifications: [
            '5 tahun membantu urusan rumah tangga sehari-hari',
            'Terbiasa mendukung aktivitas keluarga dan menjaga kenyamanan rumah',
            'Mampu membersihkan area rumah, merawat pakaian, dan merapikan ruang',
            'Dapat bekerja rapi, cepat, dan mengikuti arahan penghuni',
          ],
          expertise: [
            'Menjaga kebersihan rumah dan mengelola cucian',
            'Menyiapkan makanan rumah sederhana',
            'Mengikuti instruksi dan menyesuaikan rutinitas harian',
          ],
        );
      case '4':
        return AssistantModel(
          id: s.id,
          name: 'Siti Kumalasari',
          type: AssistantType.art,
          rating: s.rating,
          imagePath: s.imagePath,
          description:
              'Berpengalaman 5 tahun sebagai Asisten Rumah Tangga yang membantu kebutuhan harian keluarga. Terbiasa menangani pekerjaan rumah seperti membersihkan, mencuci, memasak sederhana, serta membantu aktivitas harian anggota keluarga bila diperlukan. Bekerja dengan rapi, disiplin, dan bertanggung jawab, serta memiliki sikap sabar, jujur, dan dapat dipercaya.',
          phoneNumber: '+62812827421',
          location: 'Taman Sari, Jakarta Barat, DKI Jakarta',
          email: 'Sikum@gmail.com',
          age: 26,
          experience: 5,
          education: 'SMAN ABC Jakarta',
          certifications: [],
          qualifications: [
            'Pengalaman 5 tahun membantu kebutuhan rumah tangga sehari-hari',
            'Terbiasa mendampingi dan membantu aktivitas harian anggota keluarga',
            'Mampu menjaga kebersihan, kerapian, dan kenyamanan rumah',
            'Dapat mengikuti arahan pengguna jasa dan berkoordinasi dengan anggota keluarga',
          ],
          expertise: [
            'Mampu mencuci, menyetrika, dan mengatur pakaian dengan rapi',
            'Dapat memasak makanan rumahan sederhana',
            'Mampu mengikuti instruksi kerja dan menyesuaikan dengan kebutuhan pengguna jasa',
          ],
        );
      default:
        return AssistantModel(
          id: s.id,
          name: s.name,
          type: AssistantType.suster,
          rating: s.rating,
          imagePath: s.imagePath,
          description: '${s.name} - contoh deskripsi layanan.',
          phoneNumber: '0812-3456-7890',
          location: 'Jakarta',
          email: '${s.name.toLowerCase()}@example.com',
          age: 28,
          experience: 1,
          education: 'SMK Kesehatan Jakarta',
          certifications: ['Pelatihan Dasar Keperawatan'],
          qualifications: ['Bersih', 'Disiplin'],
          expertise: [s.profession],
        );
    }
  }

  // ── Banner Apotek ───
  Widget _buildApotekBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Gambar apotek
            Container(
              width: 100,
              color: const Color(0xFFB3DFF0),
              child: Image.asset(
                'assets/images/apotek.jpg',
                fit: BoxFit.cover,
                errorBuilder: (ctx, e, s) => const Center(
                  child:
                      Icon(Icons.local_pharmacy, size: 40, color: Colors.white),
                ),
              ),
            ),

            // Teks
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'Apotek Jakarta',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
