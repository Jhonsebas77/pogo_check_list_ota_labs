part of '../state.dart';

NotifierProvider<ScreenShotViewModel, ScreenShotState>
screenShotViewModelNotifier =
    NotifierProvider<ScreenShotViewModel, ScreenShotState>(
      ScreenShotViewModel.new,
      name: 'ScreenShotViewModel',
    );
