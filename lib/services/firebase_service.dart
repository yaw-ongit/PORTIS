import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════
  // ──────────── AUTHENTICATION METHODS ──────────────
  // ═══════════════════════════════════════════════════════════

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream untuk monitor auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up dengan email & password
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      // Create auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');

      // Create user document di Firestore
      final userModel = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  // Sign In dengan email & password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Sign in failed');

      // Get user data dari Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception('User data not found');

      return UserModel.fromMap(userDoc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return null;

      return UserModel.fromMap(userDoc.data()!);
    } catch (e) {
      return null;
    }
  }

  // Update current user data
  Future<UserModel?> updateCurrentUser(UserModel userModel) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(userModel.toMap());
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ──────────── ASSISTANT CRUD METHODS ──────────────
  // ═══════════════════════════════════════════════════════════

  // Get all assistants
  Future<List<AssistantModel>> getAllAssistants() async {
    try {
      final querySnapshot = await _firestore.collection('assistants').get();
      return querySnapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return AssistantModel.fromMap(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get assistants by type
  Future<List<AssistantModel>> getAssistantsByType(AssistantType type) async {
    try {
      final querySnapshot = await _firestore
          .collection('assistants')
          .where('type', isEqualTo: type.label)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return AssistantModel.fromMap(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get single assistant by ID
  Future<AssistantModel> getAssistantById(String id) async {
    try {
      final doc = await _firestore.collection('assistants').doc(id).get();
      if (!doc.exists) throw Exception('Assistant not found');
      final data =
          Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
      data['id'] = doc.id;
      return AssistantModel.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }

  // Create assistant
  Future<AssistantModel> createAssistant(AssistantModel assistant) async {
    try {
      final docRef = _firestore.collection('assistants').doc(assistant.id);
      await docRef.set(assistant.toMap());
      return assistant;
    } catch (e) {
      rethrow;
    }
  }

  // Update assistant
  Future<void> updateAssistant(AssistantModel assistant) async {
    try {
      await _firestore
          .collection('assistants')
          .doc(assistant.id)
          .update(assistant.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Delete assistant
  Future<void> deleteAssistant(String id) async {
    try {
      await _firestore.collection('assistants').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ──────────── REAL-TIME STREAM METHODS ──────────────
  // ═══════════════════════════════════════════════════════════

  // Stream all assistants (real-time)
  Stream<List<AssistantModel>> streamAssistants() {
    return _firestore.collection('assistants').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return AssistantModel.fromMap(data);
      }).toList();
    });
  }

  // Stream assistants by type (real-time)
  Stream<List<AssistantModel>> streamAssistantsByType(AssistantType type) {
    return _firestore
        .collection('assistants')
        .where('type', isEqualTo: type.label)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return AssistantModel.fromMap(data);
      }).toList();
    });
  }

  // ─── BOOKING CRUD ───
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final docRef = _firestore.collection('bookings').doc(booking.id);
      await docRef.set(booking.toMap());
      return booking;
    } catch (e) {
      rethrow;
    }
  }

  Future<BookingModel?> getBookingById(String id) async {
    try {
      final doc = await _firestore.collection('bookings').doc(id).get();
      if (!doc.exists) return null;
      final data =
          Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
      return BookingModel.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookingModel>> getBookingsForUser(String userId) async {
    try {
      final query = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();
      return query.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        data['id'] = d.id;
        return BookingModel.fromMap(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Stream bookings for a user (real-time)
  Stream<List<BookingModel>> streamBookingsForUser(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        data['id'] = d.id;
        return BookingModel.fromMap(data);
      }).toList();
    });
  }

  Future<void> updateBooking(BookingModel booking) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(booking.id)
          .update(booking.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBooking(String id) async {
    try {
      await _firestore.collection('bookings').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // ─── CHAT PERSISTENCE ───
  Future<void> sendChatMessage(ChatModel chat, MessageModel message) async {
    try {
      final chatDoc = _firestore.collection('chats').doc(chat.id);
      final msgDoc = chatDoc.collection('messages').doc(message.id);

      final String uid = chat.userId ?? _auth.currentUser?.uid ?? '';
      final String nowIso = DateTime.now().toIso8601String();

      await _firestore.runTransaction((tx) async {
        tx.set(msgDoc, {
          'id': message.id,
          'text': message.text,
          'isMe': message.isMe,
          // store ISO timestamp for consistent ordering
          'time': nowIso,
        });

        tx.set(
          chatDoc,
          {
            'name': chat.name,
            'imagePath': chat.imagePath,
            // ensure userId exists so queries by user find this chat
            'userId': uid,
            'assistantId': chat.assistantId,
            'lastMessage': message.text,
            'time': nowIso,
          },
          SetOptions(merge: true),
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Ensure the chat document exists with proper user/assistant ids and timestamp.
  Future<void> ensureChatExists(ChatModel chat) async {
    try {
      final chatDoc = _firestore.collection('chats').doc(chat.id);
      final String uid = chat.userId ?? _auth.currentUser?.uid ?? '';
      final String nowIso = DateTime.now().toIso8601String();

      await chatDoc.set({
        'name': chat.name,
        'imagePath': chat.imagePath,
        'userId': uid,
        'assistantId': chat.assistantId,
        'lastMessage': chat.lastMessage,
        'time': nowIso,
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MessageModel>> streamChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((snap) {
      return snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        return MessageModel(
          id: data['id'] ?? d.id,
          text: data['text'] ?? '',
          isMe: data['isMe'] ?? false,
          time: data['time'] ?? '',
        );
      }).toList();
    });
  }

  Future<List<ChatModel>> getChatsForUser(String userId) async {
    try {
      final query = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .get();
      final chats = query.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        return ChatModel.fromMap(data, doc.id);
      }).toList();
      chats.sort((a, b) => b.time.compareTo(a.time));
      return chats;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ChatModel>> streamChatsForUser(String userId) {
    return _firestore
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      final chats = snap.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        return ChatModel.fromMap(data, doc.id);
      }).toList();
      chats.sort((a, b) => b.time.compareTo(a.time));
      return chats;
    });
  }
}
