part of 'chatbox_cubit.dart';

sealed class ChatboxState extends Equatable {
  const ChatboxState();

  @override
  List<Object> get props => [];
}

final class ChatboxInitial extends ChatboxState {}

final class ChatboxLoading extends ChatboxState {}

final class ChatboxLoaded extends ChatboxState {
  final List<ChatMessage> chats;

  const ChatboxLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

final class ChatboxError extends ChatboxState {
  final String message;

  const ChatboxError({required this.message});

  @override
  List<Object> get props => [message];
}
