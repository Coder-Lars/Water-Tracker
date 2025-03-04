import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/generate_routes.dart';
import 'package:src/helpers/theme_provider.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/screens/navigation_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:src/screens/startup_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //* Initialize Hive Database
  await Hive.initFlutter();
  Hive.registerAdapter(DrinkAmountAdapter());
  await Hive.openBox<DrinkAmount>('drink_amounts');

  //* Lock screen in portrait-mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String themeMode = prefs.getString("theme_mode") ?? "system";

  if (themeMode.isNotEmpty) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkTheme = themeMode != "system"
        ? themeMode == "dark"
        : brightness == Brightness.dark;
    if (isDarkTheme) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: const Color(0xff252525),
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light));
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _intakeAmount = 0;

  void loadIntakeAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _intakeAmount = (prefs.getInt('intake_amount') ?? -1);
    });
  }

  @override
  void initState() {
    super.initState();
    loadIntakeAmount();
  }

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light)); */

    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          title: 'Minimal Water Tracker',
          themeMode: themeProvider.theme,
          darkTheme: MyThemes.darkTheme,
          theme: MyThemes.lightTheme,
          home: _intakeAmount == -1
              ? const StartupNavigation()
              : const NavigationController(
                  initIndex: 0,
                ),
          onGenerateRoute: generateRoutes,
        );
      },
    );
  }
}
