import 'package:flutter/material.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/Pages/Index/sections/mainsection.dart';
import 'package:foodie/Pages/Onboarding/onboard.dart';
import 'package:foodie/Pages/login/login.dart';
import 'package:foodie/helper/darkmode.dart';
import 'package:foodie/theme/engine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final prefs = await SharedPreferences.getInstance();
  final onbaording = prefs.getBool("onboarding") ?? false;
  final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecommendedRecipesProvider()),
        // ChangeNotifierProvider(create: (_) => RecipeProvider()),
        // ChangeNotifierProvider(create: (_) => RecommendedRecipesProvider2()),
        // ChangeNotifierProvider(create: (_) => AllRecipiesProvider()),
        ChangeNotifierProvider(create: (_) => DarkModeProvider()),
        ChangeNotifierProvider(create: (_) => ActionStatusProvider()),

        // Add more providers if needed
      ],
      child: MyWidget(
        onbarding: onbaording,
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

class MyWidget extends StatefulWidget {
  final bool onbarding;
  final bool isLoggedIn;
  const MyWidget({super.key, required this.onbarding, required this.isLoggedIn});

  // const MyWidget({Key key, required this.onboarding}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Removed RecipeTracking.cleaarall() to ensure data persistence
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: 'foodie-ev7vcki',
      secret: 'MrsMriK65jU_TWQxRq6kyl3feHDzD6JM',
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: Provider.of<DarkModeProvider>(context).isDarkMode
                ? ThemeEngine.darkTheme
                : ThemeEngine.lightTheme,
            debugShowCheckedModeBanner: false,
            home: widget.onbarding
                ? (widget.isLoggedIn ? const PapaHuPapa() : const LoginPage())
                : const Onboard(),
          );
        },
      ),
    );
  }
}



// import 'package:shared_preferences/shared_preferences.dart';

