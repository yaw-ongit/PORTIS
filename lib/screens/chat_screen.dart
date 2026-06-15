import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../widgets/chat_list_item.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../viewmodels/app_viewmodels.dart';
import 'chat_detail_screen.dart';

// ChatScreen menampilkan daftar percakapan
class ChatScreen extends StatelessWidget {
  final AssistantModel? assistant;

  const ChatScreen({super.key, this.assistant});

  @override
  Widget build(BuildContext context) {
    if (assistant != null) {
      final userId = context.read<AuthViewModel>().currentUser?.uid;
      final chatId = userId != null
          ? ChatModel.buildChatId(userId, assistant!.id)
          : assistant!.id;
      final chat = ChatModel(
        id: chatId,
        name: assistant!.name,
        lastMessage: 'Mulai percakapan dengan ${assistant!.name}',
        time: '',
        imagePath: assistant!.imagePath,
        userId: userId,
        assistantId: assistant!.id,
      );

      return ChatDetailScreen(chat: chat);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildChatList(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title = assistant != null ? assistant!.name : 'P-Chat';
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6CC2E8), Color(0xFF90D4F0)],
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ikon chat
          const Icon(Icons.chat, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  // ── Daftar Chat ───
  Widget _buildChatList(BuildContext context) {
    final userId =
        Provider.of<AuthViewModel>(context, listen: false).currentUser?.uid;
    if (userId == null) {
      return Center(
        child: Text('Silakan login untuk melihat chat.',
            style: GoogleFonts.poppins()),
      );
    }

    return Consumer<ChatViewModel>(
      builder: (context, chatVM, _) {
        return StreamBuilder<List<ChatModel>>(
          stream: chatVM.streamChatsForUser(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Gagal memuat percakapan: $err',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.red[700]),
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final chats = snapshot.data ?? [];
            if (chats.isEmpty) {
              return Center(
                child:
                    Text('Belum ada percakapan.', style: GoogleFonts.poppins()),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chats.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[100],
                indent: 76,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(chat: chat),
                      ),
                    );
                  },
                  child: ChatListItem(chat: chat),
                );
              },
            );
          },
        );
      },
    );
  }
}
