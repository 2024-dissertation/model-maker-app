import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/helpers.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/repositories/my_user_repository.dart';
import 'package:go_router/go_router.dart';

part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final MyUserRepository _myUserRepository = getIt();

  ScannerCubit() : super(const ScannerLoaded([], null));

  void clear() {
    safeEmit(const ScannerLoaded([], null));
  }

  void addPath(String path) {
    if (state is! ScannerLoaded) return;
    final List<String> paths = [...(state as ScannerLoaded).paths, path];
    safeEmit((state as ScannerLoaded).copyWith(paths: paths));
  }

  void addPaths(List<String> paths) {
    if (state is! ScannerLoaded) return;
    final List<String> newPaths = [...(state as ScannerLoaded).paths, ...paths];
    safeEmit((state as ScannerLoaded).copyWith(paths: newPaths));
  }

  void removePath(int index) {
    if (state is! ScannerLoaded) return;
    final List<String> paths = List<String>.from((state as ScannerLoaded).paths)
      ..removeAt(index);
    safeEmit((state as ScannerLoaded).copyWith(paths: paths));
  }

  Future<void> createTask(BuildContext context) async {
    if (state is! ScannerLoaded) return;
    try {
      final details = await showCupertinoDialog<Map<String, dynamic>?>(
          context: context,
          builder: (context) {
            final TextEditingController titleController =
                TextEditingController();
            final TextEditingController descriptionController =
                TextEditingController();

            return CupertinoAlertDialog(
              title: const Text('Task Details'),
              content: Column(
                spacing: 4,
                children: [
                  CupertinoTextField(
                    placeholder: 'Title',
                    controller: titleController,
                  ),
                  CupertinoTextField(
                    placeholder: 'Description',
                    controller: descriptionController,
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    context.pop(null);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Create'),
                  onPressed: () {
                    context.pop({
                      'title': titleController.text,
                      'description': descriptionController.text,
                    });
                  },
                ),
              ],
            );
          });

      if (details == null) return;

      final data = await _myUserRepository.createTask({
        'title': details['title'] == null
            ? 'Title'
            : details['title']!.isEmpty
                ? 'Title'
                : details['title'],
        'description': details['description'] == null
            ? 'Description'
            : details['description']!.isEmpty
                ? 'Description'
                : details['description'],
      });

      safeEmit((state as ScannerLoaded).copyWith(createdTask: data));
      await uploadImages();
    } catch (e, stack) {
      logger.d("$e\n$stack");
      safeEmit(ScannerError(e.toString()));
    }
  }

  Future<void> uploadImages() async {
    if (state is! ScannerLoaded) return;
    final taskId = (state as ScannerLoaded).createdTask?.id;
    if (taskId == null) return;
    final paths = (state as ScannerLoaded).paths;
    await _myUserRepository.uploadImages(taskId, paths);
  }
}
