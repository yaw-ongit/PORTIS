import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/firebase_service.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  bool _isSending = false;
  String? _errorMessage;

  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  Stream<List<MessageModel>> streamChatMessages(String chatId) {
    return _firebaseService.streamChatMessages(chatId);
  }

  Stream<List<ChatModel>> streamChatsForUser(String userId) {
    return _firebaseService.streamChatsForUser(userId);
  }

  Future<bool> sendMessage(ChatModel chat, MessageModel message) async {
    try {
      _isSending = true;
      _errorMessage = null;
      notifyListeners();

      await _firebaseService.sendChatMessage(chat, message);
      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSending = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> ensureChat(ChatModel chat) async {
    await _firebaseService.ensureChatExists(chat);
  }
}
