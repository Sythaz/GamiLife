import 'package:gamilife/presentation/pages/main_page.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/timer/timer_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Cek isLogin
      // final isLoggedIn = false;
      // if (state.matchedLocation == '/' && !isLoggedIn) {
      //   return '/login';
      // }
      // if (state.matchedLocation == '/' && isLoggedIn) {
      //   return '/home';
      // }
      // return null;
      return '/home';
    },
    routes: [
      // GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const MainPage()),
      GoRoute(path: '/timer', builder: (context, state) => const TimerPage()),
    ],
  );
}
