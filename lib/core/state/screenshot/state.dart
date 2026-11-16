part of '../state.dart';

class ScreenShotState {
  ScreenShotState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is ScreenShotState &&
          hashCode == other.hashCode;

  @override
  int get hashCode => runtimeType.hashCode;

  ScreenShotState copyWith() => ScreenShotState();

  @override
  String toString() => 'ScreenShotState';
}
