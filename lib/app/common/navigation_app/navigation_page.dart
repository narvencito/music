// ignore_for_file: must_be_immutable, lines_longer_than_80_chars, unnecessary_lambdas, cascade_invocations, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:music/app/common/model/menu_model.dart';
import 'package:music/app/common/navigation_app/app_tab_bar.dart';
import 'package:music/app/config/routes_app.dart';
import 'package:music/app/modules/music/audio.dart';
import 'package:music/utils/constans.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({
    super.key,
    this.selectedIndex,
  });
  int? selectedIndex;

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  GlobalKey<AppTapBarState> tapbarKey = GlobalKey<AppTapBarState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController();
  int currentIndex = 0;
  final screens = <dynamic>[];

  static final List<MenuModel> list = [
    ListMenu().menuAudio,
    ListMenu().menuVideo,
    ListMenu().menuRadio,
  ];

  @override
  void initState() {
    super.initState();
    screens.add(const AudioListPage());

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedIndex != null) {
        onChangePageFromSelectedIndex();
      }
    });

    // getDataNotice();
  }

  void onChangePageFromSelectedIndex() {
    currentIndex = widget.selectedIndex!;
    onChangePageApp(currentIndex);
    tapbarKey.currentState!.onChangeSelectedTab(currentIndex);
  }

  void onChangePageApp(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(currentIndex);
    _scaffoldKey.currentState!.closeDrawer();
  }

  Future<void> getDataNotice() async {}

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              drawerScrimColor: Colors.black26,
              extendBody: true,
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: screens.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return screens[index] as Widget;
                },
              ),
              bottomNavigationBar: constraints.maxWidth < 1000
                  ? AppTapBar(
                      key: tapbarKey,
                      selectedColor: ConstantsApp.blueTertiaryColor,
                      initialIndex: currentIndex,
                      onTapChanged: (index) async {
                        onChangePageApp(index);
                      },
                      items: [
                        ItemTapBar(
                          iconData: Icons.audio_file,
                          label: 'Music',
                        ),
                        ItemTapBar(
                          iconData: Icons.video_collection,
                          label: 'Video',
                        ),
                        ItemTapBar(
                          iconData: Icons.radio,
                          label: 'Radio',
                        ),
                      ],
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class ListMenu {
  MenuModel menuAudio = MenuModel(
    name: 'Audio',
    icon: '',
    route: RoutesApp.audio,
  );
  MenuModel menuVideo = MenuModel(
    name: 'Video',
    icon: '',
    route: RoutesApp.video,
  );
  MenuModel menuRadio = MenuModel(
    name: 'Radio',
    icon: '',
    route: RoutesApp.radio,
  );
}
