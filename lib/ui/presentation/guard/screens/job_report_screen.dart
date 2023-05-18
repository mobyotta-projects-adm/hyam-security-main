import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../cubits/admin_task_cubit/admin_task_cubit.dart';

class JobReportsScreen extends StatefulWidget {
  const JobReportsScreen({Key? key}) : super(key: key);

  @override
  State<JobReportsScreen> createState() => _JobReportsScreenState();
}

class _JobReportsScreenState extends State<JobReportsScreen> {
  final menuNotifier = ValueNotifier<int>(0);
  final pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    final adminCubit = context.read<AdminTaskCubit>();
    if (adminCubit.state.scanReports == null) {
      adminCubit
        ..getIncidentReport(
          jobId: adminCubit.state.selectedJob?.id.toString() ?? '',
          guardId: adminCubit.state.selectedJob?.jobAssignedTo ?? '',
        )
        ..getReportByJobId(
          jobId: adminCubit.state.selectedJob?.id.toString() ?? '',
        )
        ..getActivityLogs(
          jobId: adminCubit.state.selectedJob?.id.toString() ?? '',
          guardId: adminCubit.state.selectedJob?.jobAssignedTo ?? '',
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
          return Scaffold(
            backgroundColor: const Color(0xFFFFFDFA),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Row(
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.blue.shade50,
                  child: ValueListenableBuilder(
                      valueListenable: menuNotifier,
                      builder: (context, value, child) {
                        return SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      pageController.jumpToPage(0);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: value == 0
                                            ? theme.primaryColor
                                            : Colors.blue.shade50,
                                        border: Border.symmetric(
                                          vertical: BorderSide(
                                            width: 0.2,
                                          )
                                        )
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Checkpoints Reports',
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                            color: value == 0
                                                ? Colors.white
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      pageController.jumpToPage(1);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value == 1
                                            ? theme.primaryColor
                                            : Colors.blue.shade50,
                                          border: Border.symmetric(
                                              vertical: BorderSide(
                                                width: 0.2,
                                              )
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Incident Reports',
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                            color: value == 1
                                                ? Colors.white
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      pageController.jumpToPage(2);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value == 2
                                            ? theme.primaryColor
                                            : Colors.blue.shade50,
                                          border: Border.symmetric(
                                              vertical: BorderSide(
                                                width: 0.2,
                                              )
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Activity Logs',
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                            color: value == 2
                                                ? Colors.white
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    menuNotifier.value = value;
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    state.scanReports != null
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: List.generate(state.scanReports!.length,
                                  (index) {
                                final incomingJob = state.scanReports![index];
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.2),
                                            blurRadius:
                                                20.0, // soften the shadow
                                            spreadRadius:
                                                0.0, //extend the shadow
                                            offset: const Offset(
                                              5.0,
                                              // Move to right 10  horizontally
                                              5.0, // Move to bottom 10 Vertically
                                            ),
                                          )
                                        ]),
                                    child: Card(
                                      margin: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
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
                                                  "Job #${incomingJob.jobId}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Chip(
                                                  label: Text(
                                                    incomingJob.jobName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.place),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${incomingJob.jobAddress}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Text(
                                                      " ${incomingJob.description}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text(
                                                "Total checkpoints: ${incomingJob.chekpointNo ?? ''}",
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                "Report Submitted at - ${getDate(incomingJob.checkpointDateTime ?? '')}",
                                                style: theme.textTheme.caption,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        : Container(),
                    state.incidentReportModel != null
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: List.generate(
                                  state.incidentReportModel!.response!.length,
                                  (index) {
                                final incomingJob =
                                    state.incidentReportModel!.response![index];
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.2),
                                            blurRadius:
                                                20.0, // soften the shadow
                                            spreadRadius:
                                                0.0, //extend the shadow
                                            offset: const Offset(
                                              5.0,
                                              // Move to right 10  horizontally
                                              5.0, // Move to bottom 10 Vertically
                                            ),
                                          )
                                        ]),
                                    child: Card(
                                      margin: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
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
                                                  "Job #${incomingJob.jobId}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Chip(
                                                  label: Text(
                                                    incomingJob.guardName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${incomingJob.incidentDescription}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${incomingJob.narrative}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Place - ${incomingJob.locationName}",
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
                                                Expanded(
                                                  child: Text(
                                                    "Address: ${incomingJob.locationAddress ?? ''}",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Report Submitted at -",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    getDate(incomingJob
                                                            .incidentDateTime ??
                                                        ''),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        : Container(),
                    state.activityLogsModel != null
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: List.generate(
                                  state.activityLogsModel!.activityLogs!.length,
                                  (index) {
                                final activityLog = state
                                    .activityLogsModel!.activityLogs![index];
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.2),
                                            blurRadius:
                                                20.0, // soften the shadow
                                            spreadRadius:
                                                0.0, //extend the shadow
                                            offset: const Offset(
                                              5.0,
                                              // Move to right 10  horizontally
                                              5.0, // Move to bottom 10 Vertically
                                            ),
                                          )
                                        ]),
                                    child: Card(
                                      margin: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text:"Job ",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w800,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:"#${activityLog.jobId}",
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w800,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ]
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: Chip(
                                                      label: Text(
                                                        activityLog.guardName
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${activityLog.actlogDescription}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            FutureBuilder<Address?>(
                                                future: context
                                                    .read<AdminTaskCubit>()
                                                    .getAddressFromPosition(
                                                    activityLog
                                                                .actlogLocation ??
                                                            ''),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.data != null) {
                                                    return Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: RichText(text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text:"Address- ",
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              TextSpan(
                                                                text:snapshot.data?.subAdminArea ?? '',
                                                                style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            ],
                                                          )),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                }),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Time - ",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                            activityLog.actlogTime ?? '',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        : Container(),
                  ],
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  String getDate(String date) {
    if (date.isNotEmpty) {
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date);
      return '${tempDate.day}/${tempDate.month}/${tempDate.year}';
    }
    return '';
  }
}
