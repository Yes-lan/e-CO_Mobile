import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/choice_screen.dart';
import 'screens/teacher_login_screen.dart';
import 'screens/teacher_home_screen.dart';
import 'screens/teacher_course_placement_screen.dart';
import 'screens/teacher_create_session_screen.dart';
import 'screens/participant_join_screen.dart';
import 'screens/participant_scan_screen.dart';
import 'screens/participant_enter_code_screen.dart';
import 'screens/participant_race_screen.dart';
import 'models/course.dart';
import 'models/beacon.dart';
import 'models/session.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();
  
  runApp(MyApp(localeProvider: localeProvider));
}

class MyApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  
  const MyApp({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: localeProvider,
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00609C),
                primary: const Color(0xFF00609C),
                secondary: const Color(0xFFF6731F),
              ),
              useMaterial3: true,
              fontFamily: 'Roboto',
            ),
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}



final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Écran de choix Professeur/Participant
    GoRoute(
      path: '/choice',
      builder: (context, state) => const ChoiceScreen(),
    ),
    
    // Routes Professeur
    GoRoute(
      path: '/teacher-login',
      builder: (context, state) => const TeacherLoginScreen(),
    ),
    GoRoute(
      path: '/teacher-home',
      builder: (context, state) => const TeacherHomeScreen(),
    ),
    GoRoute(
      path: '/teacher-course-placement',
      builder: (context, state) {
        final course = state.extra as Course;
        return TeacherCoursePlacementScreen(course: course);
      },
    ),
    GoRoute(
      path: '/teacher-create-session',
      builder: (context, state) => const TeacherCreateSessionScreen(),
    ),
    
    // Routes Participant
    GoRoute(
      path: '/participant-join',
      builder: (context, state) => const ParticipantJoinScreen(),
    ),
    GoRoute(
      path: '/participant-scan',
      builder: (context, state) => const ParticipantScanScreen(),
    ),
    GoRoute(
      path: '/participant-enter-code',
      builder: (context, state) => const ParticipantEnterCodeScreen(),
    ),
    GoRoute(
      path: '/participant-race',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return ParticipantRaceScreen(
          beacon: args['beacon'] as Beacon?,
          session: args['session'] as Session?,
          runnerName: args['runnerName'] as String,
        );
      },
    ),
  ],
);
