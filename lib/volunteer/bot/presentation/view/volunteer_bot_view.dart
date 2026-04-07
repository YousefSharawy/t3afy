import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/volunteer/bot/presentation/cubit/chatbot_cubit.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/bot_info_row.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message_list.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chatbot_header.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_input_bar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class VolunteerChatbotView extends StatefulWidget {
  const VolunteerChatbotView({super.key});

  @override
  State<VolunteerChatbotView> createState() => _VolunteerChatbotViewState();
}

class _VolunteerChatbotViewState extends State<VolunteerChatbotView> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _inputBarKey = GlobalKey();

  late final VoidCallback _tutorialListener;
  bool _tutorialShown = false;

  @override
  void initState() {
    super.initState();
    _tutorialListener = () => _checkTutorial();
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTutorial());
  }

  @override
  void dispose() {
    TutorialPhaseService.instance.phaseNotifier.removeListener(
      _tutorialListener,
    );
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _checkTutorial() {
    if (!mounted) return;
    if (_tutorialShown) return;
    final svc = TutorialPhaseService.instance;
    if (!svc.isRunning) return;
    if (svc.currentPhase != 5 || svc.isAdmin) return;

    _tutorialShown = true;
    debugPrint('📘 TUTORIAL: Bot screen starting phase 5');

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _showBotTutorial();
    });
  }

  void _showBotTutorial() {
    final shell = StatefulNavigationShell.of(context);
    final targets = <TargetFocus>[];
    const total = 2;

    if (_headerKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'bot_header',
          keyTarget: _headerKey,
          title: 'المساعد الذكي',
          description: 'اسأل المساعد أي سؤال عن مهامك أو التطبيق أو التوعية',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: total,
        ),
      );
    }

    if (_inputBarKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'bot_input',
          keyTarget: _inputBarKey,
          title: 'اختصارات سريعة',
          description:
              'اكتب سؤالك هنا أو اضغط على أي اختصار للحصول على إجابة فورية',
          contentAlign: ContentAlign.top,
          stepIndex: 2,
          totalSteps: total,
        ),
      );
    }

    if (targets.isEmpty) {
      debugPrint(
        '📘 TUTORIAL: VolunteerBot screen has no targets, completing tutorial',
      );
      _finishPhase5(shell);
      return;
    }

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      textSkip: "تخطي",
      paddingFocus: 10,
      focusAnimationDuration: const Duration(milliseconds: 300),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 600),
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FontConstants.fontFamily),
      onFinish: () => _finishPhase5(shell),
      onSkip: () {
        _finishPhase5(shell); // Finish tutorial since it's the last phase
        return true;
      },
    ).show(context: context, rootOverlay: true);
  }

  void _finishPhase5(StatefulNavigationShellState shell) {
    TutorialPhaseService.instance.complete();
    LocalAppStorage.setVolunteerTutorialCompleted(true);
    shell.goBranch(0);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        TutorialService.showCompletionOverlay(
          context,
          isAdmin: false,
          onDone: () {},
        );
      }
    });
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
          ChatbotHeader(key: _headerKey),
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
              builder: (ctx) => ChatInputBar(
                key: _inputBarKey,
                controller: _textController,
                onSend: () => _sendMessage(ctx),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
