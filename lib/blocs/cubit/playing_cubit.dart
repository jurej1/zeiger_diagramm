import 'package:bloc/bloc.dart';

part 'playing_state.dart';

class PlayingCubit extends Cubit<PlayingState> {
  PlayingCubit() : super(PlayingState.stop);

  void buttonPressed() {
    if (state == PlayingState.playing) {
      emit(PlayingState.stop);
    } else {
      emit(PlayingState.playing);
    }
  }

  void reset() {
    emit(PlayingState.stop);
  }
}
