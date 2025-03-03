import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class SafeCubit<T> extends Cubit<T> {
  SafeCubit(super.initialState);

  void safeEmit(T state) {
    if (!isClosed) {
      emit(state);
    }
  }
}

abstract class SafeHydratedCubit<T> extends HydratedCubit<T> {
  SafeHydratedCubit(super.initialState);

  void safeEmit(T state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
