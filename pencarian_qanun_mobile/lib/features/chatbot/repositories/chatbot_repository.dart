import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pencarian_qanun_mobile/core/services/database_service.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';
import 'package:pencarian_qanun_mobile/features/chatbot/models/message.dart';

class ChatbotRepository {
  final _endpoint = "https://api.openai.com/v1/chat/completions";
  final _databaseService = DatabaseService();

  Future<Message> createMessage(Message message) async {
    try {
      await _databaseService.saveMessage(message);

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Authorization": "Bearer ${AppConstants.openaiApiKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4.1",
          "messages": [
            {
              "role": "developer",
              "content":
                  "You are an expert in Qanun laws in Aceh. Respond only based on the provided Qanun laws."
            },
            {
              "role": "user",
              "content": message.content,
            },
          ],
        }),
      );

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body);
        final responseMessage = Message.fromJson(dataJson);
        _databaseService.saveMessage(responseMessage);
        return responseMessage;
      }
      final responseMessage = Message(
        isSender: false,
        content: "Maaf, permintaan Anda tidak dapat diproses",
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      _databaseService.saveMessage(responseMessage);
      return responseMessage;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Message>> getMessages() async {
    try {
      final messagesMap = await _databaseService.getMessages();
      return messagesMap.map((e) => Message.fromDatabase(e)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
