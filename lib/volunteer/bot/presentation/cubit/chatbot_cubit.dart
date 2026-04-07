import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message.dart';

part 'chatbot_state.dart';
part 'chatbot_cubit.freezed.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(ChatbotState.loaded(messages: [])) {
    _sendBotMessage('مرحبا! انا مساعدك الذكى. كيف يمكنى مساعدتك اليوم؟');
  }

  static const Map<List<String>, String> _faqResponses = {
    [
      'مستلزمات',
      'المستلزمات',
      'مهام',
    ]: 'يمكنك معرفة المستلزمات المطلوبة من:\n① صفحة المهام\n② اضغط على المهمة\n③ اضغط على المستلزمات',
    [
      'تقييم',
      'تقييمي',
      'ارفع تقييمي',
    ]: 'لرفع تقييمك:\n① أكمل المهام في الوقت المحدد\n② حافظ على الحضور والالتزام\n③ شارك في أكبر عدد من الحملات',
    [
      'تقرير',
      'تقريري',
      'ارفع تقريري',
    ]: 'لرفع تقريرك:\n① اذهب لصفحة المهام\n② اختر المهمة المكتملة\n③ اضغط على رفع تقرير وأرفق الملفات',
    [
      'حملات',
      'الحملات القادمة',
      'قادمة',
    ]: 'يمكنك الاطلاع على الحملات القادمة من صفحة المهام. ستجد جميع المهام القادمة مع تفاصيلها.',
    [
      'مخدرات',
      'انواع',
      'جديدة',
    ]: 'للاطلاع على أنواع المخدرات الجديدة، تابع قسم التحديثات في التطبيق. يتم تحديثه بشكل دوري بمعلومات جديدة.',
    ['ساعات', 'ساعات التطوع']:
        'يمكنك متابعة ساعات التطوع من الصفحة الرئيسية في قسم الإحصائيات.',
    [
      'موقع',
      'خريطة',
      'مكان',
    ]: 'لمعرفة موقع المهمة، اضغط على المهمة ثم اضغط على "فتح في الخريطة" في قسم الموقع.',
    [
      'مشرف',
      'تواصل',
      'اتصال',
    ]: 'يمكنك التواصل مع المشرف من صفحة تفاصيل المهمة. ستجد رقم الهاتف وأزرار الاتصال والرسائل.',
  };

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text, sender: MessageSender.user);
    final currentMessages = state.maybeWhen(
      loaded: (messages) => List<ChatMessage>.from(messages),
      orElse: () => <ChatMessage>[],
    );

    currentMessages.add(userMessage);
    emit(ChatbotState.loaded(messages: currentMessages));

    // Simulate typing delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final response = _getResponse(text);
      _sendBotMessage(response);
    });
  }

  void _sendBotMessage(String text) {
    final botMessage = ChatMessage(text: text, sender: MessageSender.bot);
    final currentMessages = state.maybeWhen(
      loaded: (messages) => List<ChatMessage>.from(messages),
      orElse: () => <ChatMessage>[],
    );

    currentMessages.add(botMessage);
    emit(ChatbotState.loaded(messages: currentMessages));
  }

  String _getResponse(String input) {
    final lower = input.toLowerCase();

    for (final entry in _faqResponses.entries) {
      for (final keyword in entry.key) {
        if (lower.contains(keyword)) {
          return entry.value;
        }
      }
    }

    return 'عذراً، لم أفهم سؤالك. يمكنك تجربة أحد الأسئلة المقترحة أو إعادة صياغة سؤالك.';
  }

  List<String> get quickActions => [
    'أنواع المخدرات الجديدة',
    'الحملات القادمة',
    'كيف أرفع تقريري؟',
    'كيف أرفع تقييمي؟',
  ];
}
