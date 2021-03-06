import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_flutter/pages/bottom_tab_navigation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///这是设置状态栏的图标和字体的颜色
    ///Brightness.light  一般都是显示为白色
    ///Brightness.dark 一般都是显示为黑色
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      shouldFooterFollowWhenNotFull: (state) {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(172, 154, 237, 1),
          accentColor: Color.fromRGBO(179, 160, 238, 1),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        home: BottomTabNavigation(),
      ),
    );
  }
}
