import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/firebase_options.dart';

import 'core/theme.dart';
import 'features/habits/presentation/cubit/habits_cubit.dart';
import 'features/habits/presentation/pages/add_habit_page.dart';
import 'features/habits/presentation/pages/habit_detail_page.dart';
import 'features/habits/presentation/pages/settings_page.dart';
import 'features/habits/presentation/pages/today_page.dart';
import 'injection.dart';

CustomTransitionPage _fade(GoRouterState s, Widget c) => CustomTransitionPage(
    key: s.pageKey,
    child: c,
    transitionDuration: const Duration(milliseconds: 450),
    transitionsBuilder: (_, a, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
        child: SlideTransition(
            position: Tween(begin: const Offset(0, .04), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
            child: child)));

final _router = GoRouter(routes: [
  GoRoute(path: '/', pageBuilder: (_, s) => _fade(s, const TodayPage())),
  GoRoute(path: '/add', pageBuilder: (_, s) => _fade(s, const AddHabitPage())),
  GoRoute(
      path: '/habit/:id',
      pageBuilder: (_, s) =>
          _fade(s, HabitDetailPage(id: s.pathParameters['id']!))),
  GoRoute(
      path: '/settings', pageBuilder: (_, s) => _fade(s, const SettingsPage())),
]);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initDi();
  runApp(BlocProvider.value(
      value: sl<HabitsCubit>(),
      child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          routerConfig: _router)));
}
