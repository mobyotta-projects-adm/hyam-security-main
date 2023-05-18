import 'package:auto_route/annotations.dart';
import 'package:hyam_services/ui/presentation/admin/job_details_screen.dart';
import 'package:hyam_services/ui/presentation/guard/screens/job_report_screen.dart';
import '../ui/presentation/admin/incoming_job_list_screen.dart';
import '../ui/presentation/guard/screens/guard_dashboard_screen.dart';
import '../ui/presentation/guard/screens/guard_profile_screen.dart';
import '../ui/presentation/guard/screens/signin_screen.dart';
import '../ui/presentation/guard/screens/signup_screen.dart';
import '../ui/presentation/guard/screens/splash_screen.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        page: SplashScreen,
        initial: true,
    ),
    CustomRoute(
        page: GuardDashboardScreen,
    ),
    AutoRoute(
        page: SignInScreen,
    ),
    AutoRoute(
      page: SignUpScreen,
    ),
    AutoRoute(
      page: IncomingJobListScreen,
    ),
    AutoRoute(
      page: IncomingJobDetailScreen,
    ),
    AutoRoute(
      page: GuardProfileScreen,
    ),
    AutoRoute(
      page: JobReportsScreen,
    ),

  ],
)
class $AppRouter {}
