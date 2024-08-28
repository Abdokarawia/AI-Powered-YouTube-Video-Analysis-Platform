// presentation/cubit/chat_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import '../Domain Layer/send_youtube_link_usecase.dart';

class ChatCubit extends Cubit<List<types.Message>> {
  final SendYouTubeLinkUseCase sendYouTubeLinkUseCase;
  final types.User _user;
  final types.User _botUser;

  ChatCubit(this.sendYouTubeLinkUseCase, this._user, this._botUser) : super([]);

  void sendMessage(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    if (Uri.tryParse(message.text)?.host == 'youtu.be' ||
        Uri.tryParse(message.text)?.host == 'www.youtube.com') {
      await _sendYouTubeLinkToApi(message.text);
    }
  }

  Future<void> _sendYouTubeLinkToApi(String url) async {
    try {
      emit([...state, _loadingMessage()]);

      final response = await sendYouTubeLinkUseCase.execute(url);
      _removeLoadingMessage();

      final responseMessage = types.TextMessage(
        author: _botUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: response,
      );

      _addMessage(responseMessage);
    } catch (e) {
      _removeLoadingMessage();
      _addMessage(_errorMessage('An error occurred while connecting to the API'));
    }
  }

  void _addMessage(types.Message message) {
    emit([message, ...state]);
  }

  void _removeLoadingMessage() {
    emit(state.where((message) => message.id != 'loading').toList());
  }

  types.TextMessage _loadingMessage() {
    return types.TextMessage(
      author: _botUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'loading',
      text: 'Loading...',
    );
  }

  types.TextMessage _errorMessage(String message) {
    return types.TextMessage(
      author: _botUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message,
    );
  }
}
