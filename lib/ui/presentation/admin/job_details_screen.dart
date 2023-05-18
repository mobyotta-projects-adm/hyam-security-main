import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyam_services/data/models/guard/all_guard_model.dart';
import 'package:hyam_services/locator.dart';
import 'package:hyam_services/router/app_routes.gr.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/admin_task_cubit/admin_task_cubit.dart';
import 'package:hyam_services/utils/logger_utils.dart';
import 'package:loader_overlay/loader_overlay.dart';

class IncomingJobDetailScreen extends StatefulWidget {
  const IncomingJobDetailScreen({Key? key}) : super(key: key);

  @override
  State<IncomingJobDetailScreen> createState() =>
      _IncomingJobDetailScreenState();
}

class _IncomingJobDetailScreenState extends State<IncomingJobDetailScreen> {
  late AdminTaskCubit adminTaskCubit;

  @override
  void initState() {
    adminTaskCubit = context.read<AdminTaskCubit>();
    if (showReport(adminTaskCubit.state.selectedJob?.jobOngoingStatus ?? '')) {
      adminTaskCubit
        ..getIncidentReport(
            jobId: adminTaskCubit.state.selectedJob?.id.toString() ?? '',
            guardId: adminTaskCubit.state.selectedJob?.jobAssignedTo ?? '',
        )
        ..getReportByJobId(
            jobId: adminTaskCubit.state.selectedJob?.id.toString() ?? '',
        )
        ..getActivityLogs(
            jobId: adminTaskCubit.state.selectedJob?.id.toString() ?? '',
            guardId: adminTaskCubit.state.selectedJob?.jobAssignedTo ?? '',
        );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoaderOverlay(
      child: BlocBuilder<AdminTaskCubit, AdminTaskState>(
        builder: (context, state) {
          final adminCubit = context.read<AdminTaskCubit>();
          final routes = getItInjector<AppRouter>();
          if (state.allGuardList == null) {
            adminCubit.loadGuard();
          }
          AppLogger.i(
              'Selected Job On Going Status -> ${state.selectedJob?.jobOngoingStatus}');
          return Scaffold(
              backgroundColor: const Color(0xFFFFFDFA),
              appBar: AppBar(
                centerTitle: false,
                leadingWidth: 0,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black),
                    ),
                    Text(
                      state.selectedJob?.jobName ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  Visibility(
                    visible: showReport(
                        state.selectedJob?.jobOngoingStatus ??
                            ''),
                    child: TextButton(
                      onPressed: () {
                        routes.pushNamed('/job-reports-screen');
                      },
                      child: const Text('View Report'),
                    ),
                  ),
                ],
                elevation: 0,
                backgroundColor: const Color(0xFFFFFDFA),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Type',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryColor),
                              ),
                              Text('${state.selectedJob?.jobType}')
                            ],
                          ),
                          Column(
                            children: [
                              Text('Total check point',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: theme.primaryColor)),
                              Text('${state.selectedJob?.jobTotalCheckpoints}')
                            ],
                          ),
                          Column(
                            children: [
                              Text('Location',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: theme.primaryColor)),
                              Text(
                                '${state.selectedJob?.jobAddress}',
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Job Assign Status -',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor)),
                          Text(
                            state.selectedJob?.jobAssignedStatus == '0'
                                ? 'Open'
                                : 'Assigned',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Job Ongoing Status -',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor)),
                          Text(
                            getOnGoingStatus(state.selectedJob?.jobOngoingStatus
                                    .toString() ??
                                ''),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: getOnGoingStatus(
                          state.selectedJob?.jobOngoingStatus.toString() ??
                              '') ==
                      'Completed'
                  ? Container()
                  : Opacity(
                    opacity:
                        state.selectedJob?.jobOngoingStatus.toString() !=
                                '0'
                            ? 0.4
                            : 0.9,
                    child: GestureDetector(
                      onTap: () async{
                        if(state.selectedJob?.jobOngoingStatus != '0'){

                        }else{
                          if(state.selectedJob?.jobAssignedStatus == '0') {
                            await selectGuardModal(
                                context, state.allGuardList);
                          }else{
                            AppLogger.i('on change job status');
                            final adminCubit = context.read<AdminTaskCubit>();
                            adminCubit.changeJobStatus();
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18.0),
                        width:
                            MediaQuery.of(context).size.width * 0.8,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Text(
                          state.selectedJob?.jobAssignedStatus == '0'
                              ? 'Assign'
                              : 'Re-assign',
                          style:
                          const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
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

  bool showReport(String status) {
    print('status $status -> ${getOnGoingStatus(status)}');
    switch (status) {
      case "0":
        return false;
      case "1":
        return true;
      case "2":
        return true;
      default:
        return false;
    }
  }
}

Future<Guard?> selectGuardModal(
    BuildContext context, List<Guard>? guards) async {
  final selectedGuardNotifier = ValueNotifier<Guard?>(null);
  final theme = Theme.of(context);
  return await showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
            title: const Text('Select Guard'),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                return Navigator.of(context).pop(null);
              },
              isDestructiveAction: true,
              isDefaultAction: true,
              child: const Text('Cancel'),
            ),
            actions: [
              ...guards == null || guards.isEmpty
                  ? [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: const Text(''),
                      )
                    ]
                  : guards.map((e) {
                      return CupertinoActionSheetAction(
                          onPressed: () {
                            selectedGuardNotifier.value = e;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${e.firstname} ${e.lastname}'),
                              ValueListenableBuilder(
                                builder: (_, value, child) {
                                  return Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.primaryColor,
                                          width: 0.7,
                                        )),
                                    child: Center(
                                      child: value == e
                                          ? Icon(
                                              Icons.done,
                                              color: theme.primaryColor,
                                            )
                                          : const SizedBox(),
                                    ),
                                  );
                                },
                                valueListenable: selectedGuardNotifier,
                              ),
                            ],
                          ));
                    }).toList(),
              CupertinoActionSheetAction(
                onPressed: () {
                  if (selectedGuardNotifier.value != null) {
                    final adminCubit = context.read<AdminTaskCubit>();
                    adminCubit.assignJob(
                        selectedGuardNotifier.value?.userid.toString() ?? '');
                    return Navigator.of(context)
                        .pop(selectedGuardNotifier.value);
                  }
                },
                isDestructiveAction: true,
                child: ValueListenableBuilder(
                  builder: (_, value, child) {
                    return Opacity(
                      opacity: value == null ? 0.5 : 0.9,
                      child: Text(
                        'Assign',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    );
                  },
                  valueListenable: selectedGuardNotifier,
                ),
              ),
            ]);
      });
}
