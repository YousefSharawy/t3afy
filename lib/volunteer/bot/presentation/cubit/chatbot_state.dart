part of 'chatbot_cubit.dart';

@freezed
class ChatbotState with _$ChatbotState {
  const factory ChatbotState.initial() = _Initial;
  const factory ChatbotState.loaded({
    required List<ChatMessage> messages,
  }) = _Loaded;
}