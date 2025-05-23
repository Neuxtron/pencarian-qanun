import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/features/chatbot/models/message.dart';
import 'package:pencarian_qanun_mobile/features/chatbot/viewmodels/chatbot_viewmodel.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_radius.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';
import 'package:pencarian_qanun_mobile/shared/utils/app_utils.dart';
import 'package:provider/provider.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _contentController = TextEditingController();
  bool _isLoading = false;

  _createMessage(BuildContext context) {
    final content = _contentController.text;
    if (content.isEmpty) return;
    setState(() => _isLoading = true);
    context.read<ChatbotViewmodel>().createMessage(content).then((_) {
      setState(() => _isLoading = false);
    });
    _contentController.text = "";
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatbotViewmodel>().getMessage();
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listMessages =
        context.watch<ChatbotViewmodel>().listMessages.reversed.toList();

    return Scaffold(
      appBar: AppUtils.emptyAppBar(),
      body: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.face,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Chatbot",
                      style: AppTextStyles.titleLarge
                          .apply(color: AppColors.primary),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    color: AppColors.accent,
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 2,
            thickness: 2,
            color: AppColors.primary,
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: listMessages.length,
              itemBuilder: (context, index) {
                final message = listMessages[index];
                return _MessageItem(message: message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.fromLTRB(64, 0, 64, 24),
              child: LinearProgressIndicator(),
            ),
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    style: const TextStyle(fontSize: 14),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Message",
                      hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      fillColor: AppColors.primary.withOpacity(.2),
                      enabledBorder: _buildInputBorder(),
                      focusedBorder: _buildInputBorder(),
                      border: _buildInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MaterialButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _createMessage(context);
                        },
                  minWidth: 0,
                  color: AppColors.primary,
                  disabledColor: AppColors.primary.withOpacity(.6),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: AppRadius.small,
      borderSide: BorderSide.none,
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    final sendColor =
        Color.alphaBlend(AppColors.accent.withOpacity(.3), Colors.white);
    final receiveColor =
        Color.alphaBlend(AppColors.primary.withOpacity(.3), Colors.white);
    final maxWidth = MediaQuery.of(context).size.width - 64;

    return Align(
      alignment:
          message.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: message.isSender ? sendColor : receiveColor,
          borderRadius: AppRadius.small,
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message.content,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
