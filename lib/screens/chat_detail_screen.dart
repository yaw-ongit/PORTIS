import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../models/app_models.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late List<MessageModel> _messages;
  final TextEditingController _messageController = TextEditingController();
  Stream<List<MessageModel>>? _messageStream;
  Stream<List<MessageModel>>? get messageStream => _messageStream;

  @override
  void initState() {
    super.initState();
    _messages = List<MessageModel>.from(
      AppData.chatMessages[widget.chat.id] ??
          [
            MessageModel(
              id: 'default-1',
              text:
                  'Halo ${widget.chat.name}, bagaimana saya bisa membantu hari ini?',
              isMe: false,
              time: '10:00',
            ),
          ],
    );

    // Ensure chat doc exists and then initialize the message stream.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ChatViewModel>().ensureChat(widget.chat);
      if (!mounted) return;
      setState(() {
        _messageStream =
            context.read<ChatViewModel>().streamChatMessages(widget.chat.id);
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      time: TimeOfDay.now().format(context),
    );

    _messageController.clear();

    // send via ChatViewModel -> firebase
    final success =
        await context.read<ChatViewModel>().sendMessage(widget.chat, message);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim pesan. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // initialize stream from firebase
    _messageStream ??=
        context.read<ChatViewModel>().streamChatMessages(widget.chat.id);
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6CC2E8),
        elevation: 0,
        title: Text(
          widget.chat.name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              backgroundImage: AssetImage(widget.chat.imagePath),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _messageStream,
              builder: (context, snap) {
                final messages = snap.data ?? _messages;
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final align = message.isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start;
                    final radius = message.isMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: align,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: message.isMe
                                  ? const Color(0xFF6CC2E8)
                                  : Colors.white,
                              borderRadius: radius,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              message.text,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: message.isMe
                                    ? Colors.white
                                    : const Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            message.time,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F7FA),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6CC2E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
