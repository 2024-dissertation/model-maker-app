import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/chatbox/cubit/chatbox_cubit.dart';
import 'package:frontend/ui/chatbox_card.dart';

class TaskChatboxPage extends StatelessWidget {
  const TaskChatboxPage({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatboxCubit(taskId: taskId),
      child: _TaskChatboxPage(),
    );
  }
}

class _TaskChatboxPage extends StatelessWidget {
  const _TaskChatboxPage();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BlocBuilder<ChatboxCubit, ChatboxState>(
        builder: (context, state) {
          if (state is ChatboxInitial || state is ChatboxLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is ChatboxError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is ChatboxLoaded) {
            return Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CupertinoTextField(),
                ),
                CustomScrollView(
                  slivers: [
                    CupertinoSliverNavigationBar(
                      largeTitle: const Text(
                        'Chats',
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final chatMessage = state.chats[index];
                          return Row(
                            mainAxisAlignment: chatMessage.isAI
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [ChatboxCard(chatmessage: chatMessage)],
                          );
                        },
                        childCount: state.chats.length,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
