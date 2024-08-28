
import 'package:chat/ChatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: Directionality(
      textDirection: TextDirection.ltr,

      child: ChatPage(),
    ),
  );
}















// import 'dart:convert';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:mime/mime.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) =>  MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData.dark(),
//     home: Directionality(
//       textDirection: TextDirection.ltr,
//
//       child: ChatPage(),
//     ),
//   );
// }
//
// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   List<types.Message> _messages = [];
//   final _user = const types.User(
//     id: '82091008-a484-4a89-ae75-a22bf8d6f3ac', // Unique ID for the user
//   );
//
//   final _botUser = const types.User(
//     id: 'bot-123', // Unique ID for the bot user
//   );
//
//   final String _apiUrl = 'https://433f-34-126-95-126.ngrok-free.app/chat';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }
//
//   void _handleAttachmentPressed() {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleImageSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Photo'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleFileSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('File'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Cancel'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleFileSelection() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//     );
//
//     if (result != null && result.files.single.path != null) {
//       final message = types.FileMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: const Uuid().v4(),
//         mimeType: lookupMimeType(result.files.single.path!),
//         name: result.files.single.name,
//         size: result.files.single.size,
//         uri: result.files.single.path!,
//       );
//
//       _addMessage(message);
//     }
//   }
//
//   void _handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );
//
//     if (result != null) {
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);
//
//       final message = types.ImageMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: const Uuid().v4(),
//         name: result.name,
//         size: bytes.length,
//         uri: result.path,
//         width: image.width.toDouble(),
//       );
//
//       _addMessage(message);
//     }
//   }
//
//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;
//
//       if (message.uri.startsWith('http')) {
//         try {
//           final index =
//           _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//           (_messages[index] as types.FileMessage).copyWith(
//             isLoading: true,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//
//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';
//
//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final index =
//           _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//           (_messages[index] as types.FileMessage).copyWith(
//             isLoading: null,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//         }
//       }
//
//       await OpenFilex.open(localPath);
//     }
//   }
//
//   void _handlePreviewDataFetched(
//       types.TextMessage message,
//       types.PreviewData previewData,
//       ) {
//     final index = _messages.indexWhere((element) => element.id == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );
//
//     setState(() {
//       _messages[index] = updatedMessage;
//     });
//   }
//
//   void _handleSendPressed(types.PartialText message) async {
//     final textMessage = types.TextMessage(
//       author: _user, // Message sent by the user
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );
//
//     _addMessage(textMessage);
//
//     // Check if the message contains a YouTube link
//     if (Uri.tryParse(message.text)?.host == 'youtu.be' ||
//         Uri.tryParse(message.text)?.host == 'www.youtube.com') {
//       await _sendYouTubeLinkToApi(message.text);
//     }
//   }
//
//   Future<void> _sendYouTubeLinkToApi(String url) async {
//     // Add a loading message while waiting for the API response
//     final loadingMessage = types.TextMessage(
//       author: _botUser,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: 'Loading...', // Loading message in English
//     );
//
//     _addMessage(loadingMessage);
//
//     try {
//       final response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(<String, String>{
//           'Url': url,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//         final apiResponse = responseBody['response'] as String;
//
//         // Create a message with the API response using the bot user
//         final responseMessage = types.TextMessage(
//           author: _botUser, // Message sent by the bot
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: const Uuid().v4(),
//           text: apiResponse,
//         );
//
//         // Remove the loading message
//         setState(() {
//           _messages.removeWhere((message) => message.id == loadingMessage.id);
//         });
//
//         _addMessage(responseMessage);
//       } else {
//         // Handle error response from the API
//         _showErrorMessage('Failed to get a response from the API');
//       }
//     } catch (e) {
//       // Handle exception during the API call
//       _showErrorMessage('An error occurred while connecting to the API');
//     }
//   }
//
//   void _showErrorMessage(String message) {
//     final errorMessage = types.TextMessage(
//       author: _botUser, // Message sent by the bot
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message,
//     );
//
//     // Remove the loading message
//     setState(() {
//       _messages.removeWhere(
//             (message) =>
//         message is types.TextMessage && message.text == 'Loading...',
//       );
//     });
//
//     _addMessage(errorMessage);
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: Scaffold(
//       appBar: AppBar(
// backgroundColor:  Color(0xFF2B2250),
//         title:Center(child: Text("AI Video Analysis"),)
//       ),
//       body: Chat(
//         messages: _messages,
//         onAttachmentPressed: _handleAttachmentPressed,
//         onMessageTap: _handleMessageTap,
//         onPreviewDataFetched: _handlePreviewDataFetched,
//         onSendPressed: _handleSendPressed,
//         showUserAvatars: true,
//         showUserNames: true,
//         theme: DarkChatTheme(),
//         user: _user,
//       ),
//     ),
//   );
// }
//
