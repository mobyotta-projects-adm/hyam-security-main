// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:hyam_services/ui/presentation/admin/incoming_job_list_screen.dart'
    as _i5;
import 'package:hyam_services/ui/presentation/admin/job_details_screen.dart'
    as _i6;
import 'package:hyam_services/ui/presentation/guard/screens/guard_dashboard_screen.dart'
    as _i2;
import 'package:hyam_services/ui/presentation/guard/screens/guard_profile_screen.dart'
    as _i7;
import 'package:hyam_services/ui/presentation/guard/screens/job_report_screen.dart'
    as _i8;
import 'package:hyam_services/ui/presentation/guard/screens/signin_screen.dart'
    as _i3;
import 'package:hyam_services/ui/presentation/guard/screens/signup_screen.dart'
    as _i4;
import 'package:hyam_services/ui/presentation/guard/screens/splash_screen.dart'
    as _i1;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    SplashScreen.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    GuardDashboardScreen.name: (routeData) {
      return _i9.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.GuardDashboardScreen(),
          opaque: true,
          barrierDismissible: false);
    },
    SignInScreen.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.SignInScreen());
    },
    SignUpScreen.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.SignUpScreen());
    },
    IncomingJobListScreen.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.IncomingJobListScreen());
    },
    IncomingJobDetailScreen.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.IncomingJobDetailScreen());
    },
    GuardProfileScreen.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.GuardProfileScreen());
    },
    JobReportsScreen.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.JobReportsScreen());
    }
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(SplashScreen.name, path: '/'),
        _i9.RouteConfig(GuardDashboardScreen.name,
            path: '/guard-dashboard-screen'),
        _i9.RouteConfig(SignInScreen.name, path: '/sign-in-screen'),
        _i9.RouteConfig(SignUpScreen.name, path: '/sign-up-screen'),
        _i9.RouteConfig(IncomingJobListScreen.name,
            path: '/incoming-job-list-screen'),
        _i9.RouteConfig(IncomingJobDetailScreen.name,
            path: '/incoming-job-detail-screen'),
        _i9.RouteConfig(GuardProfileScreen.name, path: '/guard-profile-screen'),
        _i9.RouteConfig(JobReportsScreen.name, path: '/job-reports-screen')
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashScreen extends _i9.PageRouteInfo<void> {
  const SplashScreen() : super(SplashScreen.name, path: '/');

  static const String name = 'SplashScreen';
}

/// generated route for
/// [_i2.GuardDashboardScreen]
class GuardDashboardScreen extends _i9.PageRouteInfo<void> {
  const GuardDashboardScreen()
      : super(GuardDashboardScreen.name, path: '/guard-dashboard-screen');

  static const String name = 'GuardDashboardScreen';
}

/// generated route for
/// [_i3.SignInScreen]
class SignInScreen extends _i9.PageRouteInfo<void> {
  const SignInScreen() : super(SignInScreen.name, path: '/sign-in-screen');

  static const String name = 'SignInScreen';
}

/// generated route for
/// [_i4.SignUpScreen]
class SignUpScreen extends _i9.PageRouteInfo<void> {
  const SignUpScreen() : super(SignUpScreen.name, path: '/sign-up-screen');

  static const String name = 'SignUpScreen';
}

/// generated route for
/// [_i5.IncomingJobListScreen]
class IncomingJobListScreen extends _i9.PageRouteInfo<void> {
  const IncomingJobListScreen()
      : super(IncomingJobListScreen.name, path: '/incoming-job-list-screen');

  static const String name = 'IncomingJobListScreen';
}

/// generated route for
/// [_i6.IncomingJobDetailScreen]
class IncomingJobDetailScreen extends _i9.PageRouteInfo<void> {
  const IncomingJobDetailScreen()
      : super(IncomingJobDetailScreen.name,
            path: '/incoming-job-detail-screen');

  static const String name = 'IncomingJobDetailScreen';
}

/// generated route for
/// [_i7.GuardProfileScreen]
class GuardProfileScreen extends _i9.PageRouteInfo<void> {
  const GuardProfileScreen()
      : super(GuardProfileScreen.name, path: '/guard-profile-screen');

  static const String name = 'GuardProfileScreen';
}

/// generated route for
/// [_i8.JobReportsScreen]
class JobReportsScreen extends _i9.PageRouteInfo<void> {
  const JobReportsScreen()
      : super(JobReportsScreen.name, path: '/job-reports-screen');

  static const String name = 'JobReportsScreen';
}
