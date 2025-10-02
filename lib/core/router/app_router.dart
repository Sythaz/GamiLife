import 'package:go_router/go_router.dart';

import '../../presentation/pages/main_page.dart';
import '../../presentation/pages/progress/add_progress_page.dart';
import '../../presentation/pages/progress/progress_page.dart';
import '../../presentation/pages/timer/timer_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    // redirect: (context, state) {
    //   // Cek isLogin
    //   // final isLoggedIn = false;
    //   // if (state.matchedLocation == '/' && !isLoggedIn) {
    //   //   return '/login';
    //   // }
    //   // if (state.matchedLocation == '/' && isLoggedIn) {
    //   //   return '/home';
    //   // }
    //   // return null;
    //   return '/home';
    // },
    routes: [
      // GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        name: 'timer',
        path: '/timer',
        builder: (context, state) => const TimerPage(),
      ),
      // GoRoute(
      //   name: 'profile',
      //   path: '/profile',
      //   builder: (context, state) => const ProfilePage(),
      // ),
      GoRoute(
        name: 'progress',
        path: '/progress',
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        name: 'add-progress',
        path: '/add-progress',
        builder: (context, state) => const AddProgressPage(),
      ),
    ],
  );
}
