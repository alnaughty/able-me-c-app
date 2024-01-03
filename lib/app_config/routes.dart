import 'package:able_me/views/authentication/forgot_password_page.dart';
import 'package:able_me/views/authentication/login.dart';
import 'package:able_me/views/authentication/recovery_code.dart';
import 'package:able_me/views/authentication/register.dart';
import 'package:able_me/views/landing_page/landing_page.dart';
import 'package:able_me/views/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouterObserver extends NavigatorObserver {
  GoRouterObserver({required this.analytics});
  final FirebaseAnalytics analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    analytics.setCurrentScreen(screenName: route.settings.name);
  }
}

class RouteConfig {
  RouteConfig._pr();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);
  static final RouteConfig _instance = RouteConfig._pr();
  static RouteConfig get instance => _instance;
  final GoRouter _router = GoRouter(
    observers: [GoRouterObserver(analytics: analytics)],
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
          type: ZTransitionAnim.fade,
        ),
        routes: <RouteBase>[
          GoRoute(
            name: 'login-auth',
            path: 'login-auth',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final String? tag = state.extra as String?;
              print("TAG $tag");
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: LoginPage(
                  tag: tag,
                ),
                type: ZTransitionAnim.slideLR,
              );
              // return LoginPage(
              //   tag: tag,
              // );
            },
          ),
          GoRoute(
            name: 'register',
            path: 'register',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const RegisterPage(),
                type: ZTransitionAnim.slideLR,
              );
            },
          ),
          GoRoute(
            name: 'forgot-password',
            path: 'forgot-password',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ForgotPasswordPage(),
                type: ZTransitionAnim.slideLR,
              );
            },
          ),
          GoRoute(
            name: 'recovery-page',
            path: 'recovery-page',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const RecoveryCodePage(),
                type: ZTransitionAnim.slideLR,
              );
            },
          ),
        ],
      ),
      GoRoute(
          path: '/landing-page/:index',
          pageBuilder: (BuildContext context, GoRouterState state) {
            print(state.fullPath);
            return buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: LandingPage(
                initIndex: int.parse(state.pathParameters['index'] ?? "0"),
              ),
              type: ZTransitionAnim.slideLR,
            );
          }),
    ],
  );

  GoRouter get router => _router;
}

enum ZTransitionAnim { fade, scale, rotate, slideRL, slideLR, slideTB, slideBT }

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required ZTransitionAnim type,
  Alignment? alignment,
  Curve? curve,
}) {
  return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (type) {
          case ZTransitionAnim.fade:
            return FadeTransition(opacity: animation, child: child);
          case ZTransitionAnim.scale:
            alignment ??= Alignment.center;
            assert((alignment != null) || (curve != null), """
                When using type "scale" you need argument: 'alignment && curve'
                """);
            // this.curve = Curves.linear
            return ScaleTransition(
              alignment: alignment!,
              scale: CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: curve!,
                ),
              ),
              child: child,
            );
          case ZTransitionAnim.slideRL:
            var slideTransition = SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
            return slideTransition;
          case ZTransitionAnim.slideLR:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case ZTransitionAnim.slideBT:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case ZTransitionAnim.slideTB:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          default:
            return FadeTransition(opacity: animation, child: child);
        }
      }
      // transition ?? FadeTransition(opacity: animation, child: child),
      );
}

// Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
//         Widget child) =>
//     (BuildContext context, GoRouterState state) {
//       return buildPageWithDefaultTransition<T>(
//         context: context,
//         state: state,
//         child: child,
//         type: ZTransitionAnim.fade,
//       );
//     };
