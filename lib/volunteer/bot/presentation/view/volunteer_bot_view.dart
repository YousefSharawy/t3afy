import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/bot/presentation/cubit/chatbot_cubit.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/bot_info_row.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message_list.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chatbot_header.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_input_bar.dart';

class VolunteerChatbotView extends StatefulWidget {
  const VolunteerChatbotView({super.key});

  @override
  State<VolunteerChatbotView> createState() => _VolunteerChatbotViewState();
}

class _VolunteerChatbotViewState extends State<VolunteerChatbotView> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    context.read<ChatbotCubit>().sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: AppHeight.s10),
          const ChatbotHeader(),
          SizedBox(height: AppHeight.s8),
          const BotInfoRow(),
          SizedBox(height: AppHeight.s8),
          Expanded(
            child: BlocConsumer<ChatbotCubit, ChatbotState>(
              listener: (context, state) => _scrollToBottom(),
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (messages) => ChatMessageList(
                    messages: messages,
                    scrollController: _scrollController,
                    onChipTap: (action) {
                      context.read<ChatbotCubit>().sendMessage(action);
                      _scrollToBottom();
                    },
                  ),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppHeight.s80),
            child: Builder(
              builder: (context) => ChatInputBar(
                controller: _textController,
                onSend: () => _sendMessage(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
