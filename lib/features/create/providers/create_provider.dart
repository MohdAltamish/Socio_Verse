import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RecordingState { idle, recording, recorded, editing }

final createStateProvider =
    StateNotifierProvider<CreateNotifier, RecordingState>((ref) {
      return CreateNotifier();
    });

class CreateNotifier extends StateNotifier<RecordingState> {
  CreateNotifier() : super(RecordingState.idle);

  void startRecording() {
    state = RecordingState.recording;
  }

  void stopRecording() {
    state = RecordingState.recorded;
  }

  void startEditing() {
    state = RecordingState.editing;
  }

  void reset() {
    state = RecordingState.idle;
  }
}
