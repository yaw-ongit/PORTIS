import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/firebase_service.dart';

// ═══════════════════════════════════════════════════════════
// ──────────── AUTH VIEW MODEL ──────────────
// ═══════════════════════════════════════════════════════════

class AuthViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel() {
    _initializeAuthState();
  }

  // Initialize auth state
  void _initializeAuthState() {
    _firebaseService.authStateChanges.listen((user) async {
      if (user != null) {
        _currentUser = await _firebaseService.getCurrentUserData();
        _isAuthenticated = true;
      } else {
        _currentUser = null;
        _isAuthenticated = false;
      }
      notifyListeners();
    });
  }

  // Sign Up
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _firebaseService.signUp(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );

      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign In
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _firebaseService.signIn(
        email: email,
        password: password,
      );

      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update current user data
  Future<bool> updateUser(UserModel updatedUser) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _firebaseService.updateCurrentUser(updatedUser);
      if (user == null) {
        _errorMessage = 'Failed to update user';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════
// ──────────── ASSISTANT VIEW MODEL ──────────────
// ═══════════════════════════════════════════════════════════

class AssistantViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<AssistantModel> _allAssistants = [];
  List<AssistantModel> _filteredAssistants = [];
  AssistantModel? _selectedAssistant;
  bool _isLoading = false;
  String? _errorMessage;
  AssistantType? _currentFilter;

  // Getters
  List<AssistantModel> get allAssistants => _allAssistants;
  List<AssistantModel> get filteredAssistants => _filteredAssistants;
  AssistantModel? get selectedAssistant => _selectedAssistant;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AssistantType? get currentFilter => _currentFilter;

  // Initialize - load all assistants
  Future<void> initialize() async {
    await loadAllAssistants();
  }

  // Load all assistants
  Future<void> loadAllAssistants() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _allAssistants = await _firebaseService.getAllAssistants();
      _filteredAssistants = _allAssistants;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter by type
  Future<void> filterByType(AssistantType type) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentFilter = type;
      notifyListeners();

      _filteredAssistants = await _firebaseService.getAssistantsByType(type);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear filter
  void clearFilter() {
    _currentFilter = null;
    _filteredAssistants = _allAssistants;
    notifyListeners();
  }

  // Get assistant by ID
  Future<void> selectAssistant(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      _selectedAssistant = await _firebaseService.getAssistantById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Jika assistant tidak ditemukan di Firestore, jangan set global errorMessage
      final msg = e.toString();
      if (msg.toLowerCase().contains('not found')) {
        _selectedAssistant = null;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // Create assistant (for admin)
  Future<bool> createAssistant(AssistantModel assistant) async {
    try {
      await _firebaseService.createAssistant(assistant);
      _allAssistants.add(assistant);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update assistant (for admin)
  Future<bool> updateAssistant(AssistantModel assistant) async {
    try {
      await _firebaseService.updateAssistant(assistant);
      final index = _allAssistants.indexWhere((a) => a.id == assistant.id);
      if (index != -1) {
        _allAssistants[index] = assistant;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete assistant (for admin)
  Future<bool> deleteAssistant(String id) async {
    try {
      await _firebaseService.deleteAssistant(id);
      _allAssistants.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ─── BOOKING VIEWMODEL HELPERS ───
  Future<bool> createBooking(BookingModel booking) async {
    try {
      await _firebaseService.createBooking(booking);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<BookingModel>> getBookingsForUser(String userId) async {
    try {
      return await _firebaseService.getBookingsForUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<void> sendChatMessage(ChatModel chat, MessageModel message) async {
    try {
      await _firebaseService.sendChatMessage(chat, message);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Stream<List<MessageModel>> streamChatMessages(String chatId) {
    return _firebaseService.streamChatMessages(chatId);
  }
}
