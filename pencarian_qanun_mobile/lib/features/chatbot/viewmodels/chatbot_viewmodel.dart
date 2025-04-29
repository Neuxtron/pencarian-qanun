import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/features/chatbot/models/message.dart';
import 'package:pencarian_qanun_mobile/features/chatbot/repositories/chatbot_repository.dart';

class ChatbotViewmodel extends ChangeNotifier {
  final _repository = ChatbotRepository();

  List<Message> _listMessages = [];

  List<Message> get listMessages => _listMessages;

  Future createMessage(String content) async {
    final message = Message(
      isSender: true,
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _listMessages = [..._listMessages, message];
    notifyListeners();

    final responseMessage = await _repository.createMessage(message);
    _listMessages.add(responseMessage);
    notifyListeners();
  }

  Future getMessage() async {
    _listMessages = await _repository.getMessages();
    notifyListeners();
  }
}
