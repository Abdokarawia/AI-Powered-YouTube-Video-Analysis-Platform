// presentation/pages/chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'Data Layer/chat_cubit.dart';
import 'Data Layer/message_repository.dart';
import 'Domain Layer/send_youtube_link_usecase.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2B2250),
        title: Center(child: Text("AI Video Analysis")),
      ),
      body: BlocProvider(
        create: (context) => ChatCubit(
          SendYouTubeLinkUseCase(MessageRepository('Your URl Api')),
          const types.User(id: 'user-id'),
          const types.User(id: 'bot-id'),
        ),
        child: BlocBuilder<ChatCubit, List<types.Message>>(
          builder: (context, messages) {
            return Chat(
              messages: messages,
              onAttachmentPressed: () {
                // Handle attachment logic
              },
              onMessageTap: (context, message) {
                // Handle message tap logic
              },
              onPreviewDataFetched: (message, previewData) {
                // Handle preview data fetched logic
              },
              onSendPressed: (message) {
                context.read<ChatCubit>().sendMessage(message);
              },
              showUserAvatars: true,
              showUserNames: true,
              theme: DarkChatTheme(),
              user: const types.User(id: 'user-id'),
            );
          },
        ),
      ),
    );
  }
}
