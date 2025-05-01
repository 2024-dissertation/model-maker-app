import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/scanner_page/scanner/scanner_state.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';

export 'scanner_state.dart';

class ScannerCubit extends SafeCubit<ScannerState> {
  final TaskRepository _taskRepository = getIt();

  ScannerCubit() : super(const ScannerState([], null, null));

  void clear() {
    safeEmit(const ScannerState([], null, null));
  }

  void addPath(String path) {
    final List<String> paths = [...(state).paths, path];
    safeEmit((state).copyWith(paths: paths));
  }

  void addPaths(List<String> paths) {
    try {
      final List<String> newPaths = [...(state).paths, ...paths];
      safeEmit((state).copyWith(paths: newPaths));
      logger.d("Paths: $newPaths");
    } catch (e, stack) {
      logger.d("$e\n$stack");
      safeEmit(state.copyWith(error: e.toString()));
    }
  }

  void removePath(int index) {
    final List<String> paths = List<String>.from((state).paths)
      ..removeAt(index);
    safeEmit((state).copyWith(paths: paths));
  }

  Future<bool> createTask() async {
    if (state.createdTask != null) return true;

    try {
      final data = await _taskRepository.createTask({});
      safeEmit(ScannerState(state.paths, data, null));

      return true;
    } catch (e, stack) {
      logger.d("$e\n$stack");
      safeEmit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  Future<bool> uploadImages() async {
    if (state.createdTask == null) return false;

    try {
      await _taskRepository.uploadImages(state.createdTask!.id, state.paths);
      Fluttertoast.showToast(
        msg: "Images uploaded successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: CupertinoColors.activeGreen,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    } catch (e, stack) {
      logger.d("$e\n$stack");
      safeEmit(state.copyWith(error: "Something went wrong"));
      return false;
    }
  }
}
