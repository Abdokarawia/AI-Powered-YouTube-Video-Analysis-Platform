// domain/usecases/send_youtube_link_usecase.dart
import '../Data Layer/message_repository.dart';

class SendYouTubeLinkUseCase {
  final MessageRepository repository;

  SendYouTubeLinkUseCase(this.repository);

  Future<String> execute(String url) async {
    return await repository.sendYouTubeLink(url);
  }
}
