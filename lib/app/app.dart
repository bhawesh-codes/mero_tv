import 'package:mero_tv/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:mero_tv/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:mero_tv/ui/views/home/home_view.dart';
import 'package:mero_tv/ui/views/main_view/main_view.dart';
import 'package:mero_tv/ui/views/startup/startup_view.dart';
import 'package:mero_tv/ui/views/video_player/video_player_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: MainView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: VideoPlayerView),
    MaterialRoute(page: HomeView)
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
