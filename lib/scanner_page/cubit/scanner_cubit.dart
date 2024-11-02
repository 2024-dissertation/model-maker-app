import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(const ScannerInitial());

  void addPath(String path) {
    final List<String> paths = [...state.paths, path];
    emit(state.copyWith(paths: paths));
  }

  void removePath(int index) {
    final List<String> paths = List<String>.from(state.paths)..removeAt(index);
    emit(state.copyWith(paths: paths));
  }
}
