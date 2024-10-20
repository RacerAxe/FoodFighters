// Import necessary Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// Import custom authentication and Firebase related files
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';
import 'backend/firebase/firebase_config.dart';

// Import FlutterFlow related files
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';

/// The main entry point for the application
void main() async {
  // Ensure that Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure GoRouter options
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // Initialize Firebase
  await initFirebase();

  // Initialize FlutterFlow theme
  await FlutterFlowTheme.initialize();

  // Run the app
  runApp(const MyApp());
}

/// The root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  /// Allows accessing the app state from anywhere in the widget tree
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    // Initialize app state and routing
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    
    // Set up user authentication stream
    userStream = biteWiseFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    
    // Listen for JWT token changes
    jwtTokenStream.listen((_) {});
    
    // Delay to stop showing splash image
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();
    super.dispose();
  }

  /// Updates the app's theme mode
  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BiteWise',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
