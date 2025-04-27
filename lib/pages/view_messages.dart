import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/chatbox/models/chat_message.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:remixicon/remixicon.dart';

class TaskMessagePage extends StatefulWidget {
  const TaskMessagePage({super.key, required this.taskId});

  final int taskId;

  @override
  State<TaskMessagePage> createState() => _TaskMessagePageState();
}

class _TaskMessagePageState extends State<TaskMessagePage> {
  List<ChatMessage> messages = [];

  final TaskRepository _taskRepository = getIt();

  final TextEditingController _textEditingController = TextEditingController();

  void _startMessagePolling() {
    Future.delayed(Duration(seconds: 5), () {
      _taskRepository.getChatMessages(widget.taskId).then((value) {
        setState(() {
          messages = value;
        });
      });
      if (mounted) {
        _startMessagePolling();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _taskRepository.getChatMessages(widget.taskId).then((value) {
      setState(() {
        messages = value;
      });
    });

    _startMessagePolling();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text("All Messages"),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              if (messages.isEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.lg),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: const ThemedText(
                        "No messages",
                        color: TextColor.muted,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final message = messages[index];
                        bool isLastMessage = index == messages.length - 1;
                        return Container(
                          margin: EdgeInsets.only(
                              bottom: isLastMessage ? 128 : AppPadding.sm),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (message.isUser)
                                Flexible(flex: 1, child: Container()),
                              Expanded(
                                child: ThemedCard(
                                  child: ThemedText(message.message),
                                ),
                              ),
                              if (message.isAI)
                                Flexible(flex: 1, child: Container()),
                            ],
                          ),
                        );
                      },
                      childCount: messages.length,
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 84,
            left: AppPadding.lg,
            right: AppPadding.lg,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: CupertinoTextField(controller: _textEditingController),
                ),
                IconButton.filled(
                  onPressed: () {
                    _taskRepository
                        .sendMessage(widget.taskId, _textEditingController.text)
                        .then((value) {
                      setState(() {
                        messages.add(value);
                        _textEditingController.clear();
                      });
                    });
                  },
                  color: CupertinoColors.white,
                  icon: Icon(
                    RemixIcons.send_plane_fill,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
