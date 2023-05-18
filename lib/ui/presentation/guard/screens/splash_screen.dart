import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/guard_dashboard_cubit/guard_dashboard_cubit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../../constants/image_constants.dart';
import '../cubits/splash_screen_cubit/splash_screen_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashScreenCubit splashScreenCubit;

  @override
  void initState() {
    // TODO: implement initState
    splashScreenCubit = context.read<SplashScreenCubit>()
      ..init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<GuardDashboardCubit, GuardDashboardState>(
      builder: (context, state) {
        return LoaderOverlay(
          child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                body: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   colorFilter: ColorFilter.mode(
                    //       Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    //   image: AssetImage(
                    //     ImageConstant.splashBackground,
                    //   ),
                    // ),
                  ),
                  child: Center(
                    child: Image.asset(ImageConstant.appLogo),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
