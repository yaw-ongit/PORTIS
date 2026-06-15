import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../viewmodels/booking_viewmodel.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;
  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Detail', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF6CC2E8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Penerima',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(booking.recipientName,
                style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 12),
            Text('Jadwal',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('${booking.scheduleDate} • ${booking.scheduleTime}',
                style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 12),
            Text('Alamat',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(booking.address, style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 12),
            Text('Catatan',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(booking.notes.isNotEmpty ? booking.notes : '-',
                style: GoogleFonts.poppins(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () async {
                  final ok = await context
                      .read<BookingViewModel>()
                      .cancelBooking(booking.id);
                  if (ok) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Gagal membatalkan booking')));
                  }
                },
                child: Text('Batalkan Pesanan',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
