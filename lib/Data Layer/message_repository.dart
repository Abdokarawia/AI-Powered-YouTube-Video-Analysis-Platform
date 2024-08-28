// data/repositories/message_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageRepository {
  final String apiUrl;

  MessageRepository(this.apiUrl);

  Future<String> sendYouTubeLink(String url) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'Url': url,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['response'] as String;
    } else {
      throw Exception('Failed to get a response from the API');
    }
  }
}
