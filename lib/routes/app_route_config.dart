import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop_wijaya/presentation/screens/error_page/error_page.dart';
import 'package:furniture_shop_wijaya/presentation/screens/login_page/login.dart';
import 'package:furniture_shop_wijaya/presentation/screens/main_dashboard/main_dashboard.dart';
import 'package:furniture_shop_wijaya/routes/route_constants.dart';
import 'package:go_router/go_router.dart';

class WFRouter {
  GoRouter router = GoRouter(
    initialLocation:
        FirebaseAuth.instance.currentUser != null ? '/home' : '/login',
    debugLogDiagnostics: true,
    routerNeglect: true,
    routes: <RouteBase>[
      GoRoute(
        name: WFRouteConstants.mainDashboard,
        path: '/home',
        pageBuilder: (context, state) {
          return const MaterialPage(child: MainDashboard());
        },
      ),
      GoRoute(
        name: WFRouteConstants.loginPage,
        path: '/login',
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginPage());
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: ErrorPage());
    },
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      if (isLoggedIn && state.uri.path == '/login') {
        return '/home';
      } else if (!isLoggedIn && state.uri.path == '/home') {
        return '/login';
      } else {
        return null;
      }
    },
  );
}
