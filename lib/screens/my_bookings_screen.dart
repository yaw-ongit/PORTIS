import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/booking_viewmodel.dart';
import '../viewmodels/app_viewmodels.dart';
import 'booking_detail_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthViewModel>().currentUser;
    if (auth != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BookingViewModel>().startListening(auth.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF6CC2E8),
      ),
      body: Consumer<BookingViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.bookings.isEmpty) {
            return Center(
              child: Text('Belum ada booking', style: GoogleFonts.poppins()),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: vm.bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final b = vm.bookings[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                title: Text(b.recipientName,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle: Text('${b.scheduleDate} • ${b.scheduleTime}',
                    style: GoogleFonts.poppins()),
                trailing: Text(b.status,
                    style: GoogleFonts.poppins(color: Colors.grey)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BookingDetailScreen(booking: b)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
