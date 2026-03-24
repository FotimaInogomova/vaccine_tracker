import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_state.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/pin_gate_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.data!) {
          return const LoginScreen();
        }

        return const MainNavigationScreen();
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );

  await themeService.loadTheme();

  final appState = AppState();
  await appState.loadLocale();

  await NotificationService.instance.init();

  runApp(VaccineTrackerApp(appState: appState));
}

class VaccineTrackerApp extends StatefulWidget {
  const VaccineTrackerApp({super.key, required this.appState});

  final AppState appState;

  static AppState of(BuildContext context) =>
      _VaccineTrackerAppState.of(context);

  @override
  State<VaccineTrackerApp> createState() => _VaccineTrackerAppState();
}

class _VaccineTrackerAppState extends State<VaccineTrackerApp>
    with WidgetsBindingObserver {
  late final AppState _appState;

  static AppState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_VaccineTrackerAppState>();
    return state!._appState;
  }

  DateTime? _backgroundAt;
  bool _isPinOpen = false;
  bool _isAuthenticating = false;
  static const Duration _lockTimeout = Duration(seconds: 3);

  void changeLanguage(String code) {
    _appState.changeLanguage(code);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appState = widget.appState;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _backgroundAt = DateTime.now();
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (_backgroundAt == null) return;

      final diff = DateTime.now().difference(_backgroundAt!);
      if (diff < _lockTimeout) return;

      final pinEnabled = await AuthService.instance.isPinEnabled();
      if (!pinEnabled) return;
      if (_isPinOpen || _isAuthenticating) return;

      _isPinOpen = true;
      _isAuthenticating = true;

      navigatorKey.currentState
          ?.push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const PinGateScreen(child: AuthGate()),
            ),
          )
          .then((_) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _isPinOpen = false;
              _isAuthenticating = false;
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_appState, themeService]),
      builder: (context, _) {
        final locale = _appState.locale;
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          themeMode: themeService.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AuthGate(),
        );
      },
    );
  }
}
