import 'package:flutter/material.dart';
import 'package:frontend/helpers/theme.dart';
import 'package:frontend/module/chatbox/models/chat_message.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class ChatboxCard extends StatelessWidget {
  const ChatboxCard({super.key, required this.chatmessage});

  final ChatMessage chatmessage;

  @override
  Widget build(BuildContext context) {
    return ThemedCard(
        color: chatmessage.isAI
            ? CustomCupertinoTheme.of(context).bgColor1
            : CustomCupertinoTheme.of(context).bgColor2,
        child: ThemedText(chatmessage.message));
  }
}
