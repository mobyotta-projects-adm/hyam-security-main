import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyam_services/cubit/theme_cubit.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/guard_profile_cubit/guard_profile_cubit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../../constants/theme.dart';
import '../../../../locator.dart';
import '../../../../router/app_routes.gr.dart';
import '../widgets/guard_profile_list_item_view.dart';
import '../widgets/primary_button.dart';

class GuardProfileScreen extends StatefulWidget {
  const GuardProfileScreen({Key? key}) : super(key: key);

  @override
  State<GuardProfileScreen> createState() => _GuardProfileScreenState();
}

class _GuardProfileScreenState extends State<GuardProfileScreen> {
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return LoaderOverlay(
      child: BlocBuilder<GuardProfileCubit, GuardProfileState>(
        builder: (context, state) {
          final profileCubit = context.read<GuardProfileCubit>();
          return Scaffold(
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IconButton(icon: Icon(Icons.refresh,color: theme.primaryColor,size: 30,), onPressed: () {
                        profileCubit.refreshAssignedJob();
                      },),
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset("assets/images/logo.png",height: 100,width: 100,),
                ),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  child: Text(
                    '${state.guard?.firstname} ${state.guard?.lastname}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${state.guard?.email}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: (){
                    profileCubit.logout();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 30, right: 30,),
                        decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '  Logout  ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: whiteshade),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20, bottom: 10, left: 40),
                  child: const Text(
                    'Assigned Jobs -',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                ),
                ...[
                  if (state.assignedJobModel == null)
                    const LinearProgressIndicator()
                  else if (state.assignedJobModel!.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 40),
                      child: const Text(
                        'No Job Assigned yet.',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    )
                  else
                    Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10,right: 10),
                        child: state.assignedJobModel != null &&
                            state.assignedJobModel!.isNotEmpty
                            ? Column(
                          children: state.assignedJobModel!
                              .map((e) => Container(
                            margin: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 20.0,
                                ),
                              ],
                            ),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white,
                                      width: 1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10))),
                              child: InkWell(
                                onTap: () {
                                  profileCubit.setSelectedJob(e);
                                  final router =
                                  getItInjector<AppRouter>();
                                  router.pushNamed(
                                      '/guard-dashboard-screen');
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ProfileListItem(
                                      icon: LineAwesomeIcons
                                          .word_file,
                                      text:
                                      'Job - ',
                                      subText: '${e.jobName}',
                                      hasNavigation: true,
                                    ),
                                    ProfileListItem(
                                      icon: LineAwesomeIcons
                                          .location_arrow,
                                      text:
                                      'Job Address - ',
                                      subText: '${e.jobAddress}',
                                    ),
                                    ProfileListItem(
                                      icon: LineAwesomeIcons
                                          .helping_hands,
                                      text:
                                      'Job Instruction - ',
                                      subText: '${e.jobInstructions}',
                                    ),
                                    ProfileListItem(
                                      icon: LineAwesomeIcons
                                          .pointer__hand_,
                                      text:
                                      'Total Checkpoints - ',
                                      subText: ' ${e.jobTotalCheckpoints}',
                                    ),
                                    ProfileListItem(
                                      icon: LineAwesomeIcons.typo3,
                                      text:
                                      'My Job Type -',
                                      subText: ' ${e.jobType}',
                                    ),
                                    ProfileListItem(
                                      icon: LineAwesomeIcons
                                          .business_time,
                                      text:
                                      'Job Joining Data - ',
                                      subText: '${e.jobStartDate}',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      margin: const EdgeInsets.only(right: 10,left: 10),
                                      width: MediaQuery.of(context).size.width,
                                      child: PrimaryButton(
                                        title: 'Start this Job',
                                        onTap: () {
                                          profileCubit.setSelectedJob(e);
                                          final router =
                                          getItInjector<AppRouter>();
                                          router.pushNamed(
                                              '/guard-dashboard-screen');
                                        },
                                        disable: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          )
                              .toList(),
                        )
                            : Column()),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
