import 'package:flutter/material.dart';
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
import 'services/localization/localization_provider.dart';
import 'generated/l10n/app_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocalizationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, _) {
        return MaterialApp.router(
          title: 'eCO - Course d\'Orientation',
          debugShowCheckedModeBanner: false,
          locale: localizationProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00609C),
              primary: const Color(0xFF00609C),
              secondary: const Color(0xFFF6731F),
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          routerConfig: _router,
        );
      },
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
