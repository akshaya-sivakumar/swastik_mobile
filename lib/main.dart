import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/src/screenutil_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pref = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

bool firstLaunch = true;

late SharedPreferences pref;
int selectedIndex = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      scale: 1.2,
      designSize: const Size(826.9, 392.7),
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Agro Tech',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          builder: EasyLoading.init(),
          onGenerateRoute: generateRoute,
          initialRoute:
              ((pref.getString("token") ?? "").isNotEmpty) ? "/visits" : "/",
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}
