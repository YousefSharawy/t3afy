import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/bot/presentation/cubit/chatbot_cubit.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_bubble.dart';

import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/quick_actions_chips.dart';

class VolunteerChatbotView extends StatefulWidget {
  const VolunteerChatbotView({super.key});

  @override
  State<VolunteerChatbotView> createState() => _VolunteerChatbotViewState();
}

class _VolunteerChatbotViewState extends State<VolunteerChatbotView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          _buildHeader(),
          SizedBox(height: AppHeight.s8),
          _buildBotInfo(),
          SizedBox(height: AppHeight.s8),
          // Messages
          Expanded(
            child: BlocConsumer<ChatbotCubit, ChatbotState>(
              listener: (context, state) {
                _scrollToBottom();
              },
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (messages) => _buildMessageList(messages),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
          // Quick actions
          BlocBuilder<ChatbotCubit, ChatbotState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
                child: QuickActionChips(
                  actions: context.read<ChatbotCubit>().quickActions,
                  onTap: (action) {
                    context.read<ChatbotCubit>().sendMessage(action);
                    _scrollToBottom();
                  },
                ),
              );
            },
          ),
          SizedBox(height: 100.sp),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'المساعد الذكى',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.blueOne900,
              fontSize: FontSize.s16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                ImageAssets.botAvatar,
                width: AppWidth.s40,
                height: AppHeight.s40,
              ),
            ],
          ),
          SizedBox(width: 8.sp),
          Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .start,
            children: [
              Text(
                "مساعد الصندوق",
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.blueOne900,
                ),
              ),
              Text(
                " متاح الان",
                style: getMediumStyle(
                  fontSize: FontSize.s13,
                  fontFamily: FontConstants.fontFamily,
                  color: Color(0xff319F43),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s18,
        vertical: AppHeight.s8,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(message: messages[index]);
      },
    );
  }
}
