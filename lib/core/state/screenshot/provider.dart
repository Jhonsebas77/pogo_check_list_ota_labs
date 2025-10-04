part of com.pogo_check_list_ota_labs.app.state;

NotifierProvider<ScreenShotViewModel, ScreenShotState>
screenShotViewModelNotifier =
    NotifierProvider<ScreenShotViewModel, ScreenShotState>(
      ScreenShotViewModel.new,
      name: 'ScreenShotViewModel',
    );
