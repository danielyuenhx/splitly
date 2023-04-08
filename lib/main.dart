import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:google_fonts/google_fonts.dart';

import './ui/home.dart';
import 'globals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: PRIMARY_COLOR,
          secondary: SECONDARY_COLOR,
        ),
        // primarySwatch: Color.fromRGBO(41, 196, 160, 1),
        textTheme: GoogleFonts.manropeTextTheme(Theme.of(context).textTheme),
      ),
      home: const AppWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  int currentIndex = 0;
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  void _changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      // HomeScreen(),
      HomeScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: ("Add"),
        activeColorPrimary: PRIMARY_COLOR,
        inactiveColorPrimary: Colors.grey.shade500,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.backup_table),
      //   title: ("Presets"),
      //   activeColorPrimary: PRIMARY_COLOR,
      //   inactiveColorPrimary: Colors.grey.shade500,
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history),
        title: ("History"),
        activeColorPrimary: PRIMARY_COLOR,
        inactiveColorPrimary: Colors.grey.shade500,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: PersistentTabView(
          controller: _controller,
          context,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          screens: _buildScreens(),
          items: _navBarItems(),
          navBarStyle: NavBarStyle.style3,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 350),
          ),
        ));
  }
}
