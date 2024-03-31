import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_mobile/bloc/addKms/kms_bloc.dart';
import 'package:swastik_mobile/bloc/customer/customer_bloc.dart';
import 'package:swastik_mobile/bloc/expense/expense_bloc.dart';
import 'package:swastik_mobile/main.dart';
import 'package:swastik_mobile/ui/screens/add_kms.dart';
import 'package:swastik_mobile/ui/screens/check_in.dart';
import 'package:swastik_mobile/ui/screens/enquiry_list.dart';
import 'package:swastik_mobile/ui/screens/expense.dart';
import 'package:swastik_mobile/ui/screens/follow_up.dart';

class ScaffoldWidget extends StatefulWidget {
  final int inititalIndex;
  const ScaffoldWidget({super.key, this.inititalIndex = 0});

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.inititalIndex);
    getRole();
    super.initState();
  }

  String role = "";

  getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role") ?? "";
    setState(() {});
    print("Roless$role");
  }

  late final PersistentTabController _controller;
  List<Widget> _buildScreens() {
    return [
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CustomerBloc(),
          ),
          BlocProvider(
            create: (context) => KmsBloc(),
          ),
        ],
        child: const CheckinScreen(),
      ),
      BlocProvider(
        create: (context) => CustomerBloc(),
        child: const EnquiryList(),
      ),
      BlocProvider(
        create: (context) => ExpenseBloc(),
        child: const ExpenseScreen(),
      ),
      BlocProvider(
        create: (context) => CustomerBloc(),
        child: const FollowupScreen(),
      ),
      BlocProvider(
        create: (context) => KmsBloc(),
        child: const AddkmsScreen(),
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        /*  onPressed: (po) {
          selectedIndex = 0;
          //setState(() {});
        }, */
        icon: const Icon(Icons.check_circle),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: ("Check-in"),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        /*  onPressed: (po) {
          selectedIndex = 1;
          //setState(() {});
        }, */
        icon: const Icon(Icons.view_list),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: ("Enquiry"),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        /*  onPressed: (po) {
          selectedIndex = 2;
          //setState(() {});
        }, */
        icon: const Icon(Icons.monetization_on_sharp),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: ("Expense"),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        /*  onPressed: (po) {
          selectedIndex = 3;
          //setState(() {});
        }, */
        icon: const Icon(Icons.follow_the_signs),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: ("Followup"),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.gas_meter),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: ("Kms"),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        onItemSelected: (value) {
          print("selected");
          selectedIndex = value;
          if (selectedIndex != 0) {
            EasyLoading.dismiss();
          }
        },
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: HexColor("#135a92"), // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: false, // Default is true.

        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
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
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }
}
