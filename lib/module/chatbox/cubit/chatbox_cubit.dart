import 'package:equatable/equatable.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/chatbox/models/chat_message.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';

part 'chatbox_state.dart';

class ChatboxCubit extends SafeCubit<ChatboxState> {
  final TaskRepository _taskRepository = getIt();

  final int taskId;

  ChatboxCubit({required this.taskId}) : super(ChatboxInitial());

  Future<void> fetchChats() async {
    if (state is ChatboxInitial) {
      safeEmit(ChatboxLoading());
    }

    try {
      final chats = await _taskRepository.getChatMessages(taskId);
      emit(ChatboxLoaded(chats: chats));
    } catch (e) {
      logger.e(e);
      emit(ChatboxError(message: e.toString()));
    }
  }
}
