import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyam_services/locator.dart';
import 'package:hyam_services/router/app_routes.gr.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/admin_task_cubit/admin_task_cubit.dart';
import 'package:loader_overlay/loader_overlay.dart';

class IncomingJobListScreen extends StatelessWidget {
  const IncomingJobListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDFA),
        body: Stack(
          children: [
            jobList(context),
          ],
        ),
      ),
    );
  }

  Widget jobList(context) {
    final theme = Theme.of(context);
    return BlocBuilder<AdminTaskCubit, AdminTaskState>(
      builder: (context, state) {
        final adminCubit = context.read<AdminTaskCubit>();
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: theme.primaryColor,
                            size: 30,
                          ),
                          onPressed: () {
                            adminCubit.reloadGuard(context);
                          },
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          "assets/images/user.jpeg",
                          height: 60,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Hello, Dispatcher",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  state.incomingJobs != null
                      ? Column(
                          children: List.generate(state.incomingJobs!.length,
                              (index) {
                            final incomingJob = state.incomingJobs![index];
                            return GestureDetector(
                              onTap: () {
                                adminCubit.setSelectedJob(incomingJob);
                                final router = getItInjector<AppRouter>();
                                router.pushNamed('/incoming-job-detail-screen');
                              },
                              child: Container(
                                height: 170,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF6F6F6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        blurRadius: 20.0, // soften the shadow
                                        spreadRadius: 0.0, //extend the shadow
                                        offset: const Offset(
                                          5.0, // Move to right 10  horizontally
                                          5.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ]),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Job #${incomingJob.id}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const Spacer(),
                                            Chip(
                                              label: Text(
                                                incomingJob.jobAssignedStatus ==
                                                        '0'
                                                    ? 'Open'
                                                    : getOnGoingStatus(incomingJob
                                                            .jobOngoingStatus ??
                                                        ''),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: incomingJob
                                                          .jobAssignedStatus ==
                                                      '0'
                                                  ? theme.primaryColor
                                                  : Colors.red,
                                            )
                                          ],
                                        ),
                                        Text(
                                          "${incomingJob.jobName}",
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "${incomingJob.jobAddress}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Total checkpoints: ${incomingJob.jobTotalCheckpoints}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.arrow_right_alt_rounded,
                                              size: 24.0,
                                              semanticLabel:
                                                  'Text to announce in accessibility modes',
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String getOnGoingStatus(String status) {
    switch (status) {
      case "0":
        return 'Not Started';
      case "1":
        return 'Ongoing';
      case "2":
        return 'Completed';
      default:
        return '';
    }
  }
}
