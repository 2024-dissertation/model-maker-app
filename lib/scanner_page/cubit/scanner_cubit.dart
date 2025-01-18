import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/helpers.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/repositories/my_user_repository.dart';

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

  void removePath(int index) {
    if (state is! ScannerLoaded) return;
    final List<String> paths = List<String>.from((state as ScannerLoaded).paths)
      ..removeAt(index);
    safeEmit((state as ScannerLoaded).copyWith(paths: paths));
  }

  void createTask() async {
    if (state is! ScannerLoaded) return;
    try {
      final data = await _myUserRepository.createTask({
        'title': 'Task',
        'description': 'Description',
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
