import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/guard_profile_cubit/guard_profile_cubit.dart';
import '../../../../../locator.dart';
import '../../../../../router/app_routes.gr.dart';
part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial());

  void init(BuildContext context) async{
    final appRouter = getItInjector<AppRouter>();
    final authCubit = context.read<GuardProfileCubit>();
    await Future.delayed(const Duration(microseconds: 500));
    ///Admin route
    appRouter.replaceNamed('/incoming-job-list-screen');
    ///guard route
    //authCubit.authenticate();
  }
}
