import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/bot/presentation/cubit/chatbot_cubit.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_bubble.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.onChipTap,
  });
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final Function(String) onChipTap;
  @override
  Widget build(BuildContext context) {
    final quickActions = context.read<ChatbotCubit>().quickActions;
    int lastBotIndex = -1;
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].sender == MessageSender.bot) {
        lastBotIndex = i;
        break;
      }
    }
    return Container(
      color: ColorManager.background,
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s18,
          vertical: AppHeight.s16,
        ),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final chips =
              (index == lastBotIndex && message.sender == MessageSender.bot)
              ? quickActions
              : <String>[];
          final enriched = ChatMessage(
            text: message.text,
            sender: message.sender,
            timestamp: message.timestamp,
            quickActions: chips,
          );
          return ChatBubble(message: enriched, onChipTap: onChipTap);
        },
      ),
    );
  }
}
