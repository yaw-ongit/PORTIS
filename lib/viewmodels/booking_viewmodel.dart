import 'dart:async';

import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/firebase_service.dart';

class BookingViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  StreamSubscription<List<BookingModel>>? _sub;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // Start streaming bookings for the provided userId
  void startListening(String userId) {
    _sub?.cancel();
    _isLoading = true;
    notifyListeners();

    final stream = _firebaseService.streamBookingsForUser(userId);
    _sub = stream.listen((list) {
      _bookings = list;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> createBooking(BookingModel booking) async {
    try {
      await _firebaseService.createBooking(booking);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _firebaseService.deleteBooking(bookingId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
