import 'package:flutter/material.dart';
import 'package:online_course/core/utils/app_constant.dart';
import 'package:online_course/src/JSON/users.dart';
import 'package:online_course/src/Views/profile.dart';
import 'package:online_course/src/features/account/presentation/pages/account/account.dart';
import 'package:online_course/src/features/course/pesentation/pages/explore/explore.dart';
import 'package:online_course/src/features/course/pesentation/pages/my_course/my_course.dart';
import 'package:online_course/src/theme/app_color.dart';
import 'package:online_course/src/widgets/bottombar_item.dart';
import 'features/course/pesentation/pages/home/home.dart';

class RootApp extends StatefulWidget {
  final Users? profile;
  const RootApp({super.key, this.profile});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> with TickerProviderStateMixin {
  late final Users? _profile;
  int _activeTab = 0;
<<<<<<< HEAD
  late final List<dynamic> _barItems; // Declare _barItems here

  @override
  void initState() {
    super.initState();
    _profile = widget.profile; // Initialize _profile here
    _barItems = [
      // Initialize _barItems here
      {
        "icon": "assets/icons/home.svg",
        "active_icon": "assets/icons/home.svg",
        "page": const HomePage(),
      },
      {
        "icon": "assets/icons/search.svg",
        "active_icon": "assets/icons/search.svg",
        "page": const CourseSearchPage(),
      },
      {
        "icon": "assets/icons/play.svg",
        "active_icon": "assets/icons/play.svg",
        "page": const MyCoursePage(),
      },
      {
        "icon": "assets/icons/profile.svg",
        "active_icon": "assets/icons/profile.svg",
        "page": Profile(profile: _profile), // Now _profile can be used here
      },
    ];
    _controller.forward();
  }
=======
  final List _barItems = [
    {
      "icon": "assets/icons/home.svg",
      "active_icon": "assets/icons/home.svg",
      "page": const HomePage(),
    },
    {
      "icon": "assets/icons/search.svg",
      "active_icon": "assets/icons/search.svg",
      "page": const CourseSearchPage(),
    },
    {
      "icon": "assets/icons/play.svg",
      "active_icon": "assets/icons/play.svg",
      "page": const MyCoursePage(),
    },
    {
      "icon": "assets/icons/profile.svg",
      "active_icon": "assets/icons/profile.svg",
      "page": const AccountPage(),
    },
  ];
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37

//====== set animation=====
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: AppConstant.animatedBodyMs),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  _buildAnimatedPage(page) {
    return FadeTransition(child: page, opacity: _animation);
  }

  void onPageChanged(int index) {
    if (index == _activeTab) return;
    _controller.reset();
    setState(() {
      _activeTab = index;
    });
    _controller.forward();
  }

//====== end set animation=====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      bottomNavigationBar: _buildBottomBar(),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        _barItems.length,
        (index) => _buildAnimatedPage(_barItems[index]["page"]),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.bottomBarColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(1, 1),
          )
        ],
      ),
      child: _buildBottomIcon(),
    );
  }

  Widget _buildBottomIcon() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        bottom: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _barItems.length,
          (index) => BottomBarItem(
            _barItems[index]["icon"],
            isActive: _activeTab == index,
            activeColor: AppColor.primary,
            onTap: () {
              onPageChanged(index);
            },
          ),
        ),
      ),
    );
  }
}
