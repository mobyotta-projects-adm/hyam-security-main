import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyam_services/locator.dart';
import 'package:hyam_services/router/app_routes.gr.dart';
import 'package:hyam_services/ui/presentation/guard/cubits/guard_profile_cubit/guard_profile_cubit.dart';
import 'package:hyam_services/ui/presentation/guard/widgets/widgets.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../utils/logger_utils.dart';
import '../cubits/guard_dashboard_cubit/guard_dashboard_cubit.dart';
import '../widgets/guard_profile_list_item_view.dart';

class GuardDashboardScreen extends StatefulWidget {
  const GuardDashboardScreen({Key? key}) : super(key: key);

  @override
  State<GuardDashboardScreen> createState() => _GuardDashboardScreenState();
}

class _GuardDashboardScreenState extends State<GuardDashboardScreen> {
  late final GuardDashboardCubit guardDashboardCubit;
  QRViewController? qrScanController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    guardDashboardCubit = context.read<GuardDashboardCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoaderOverlay(
      child: BlocBuilder<GuardProfileCubit, GuardProfileState>(
        builder: (context, profileState) {
          return BlocBuilder<GuardDashboardCubit, GuardDashboardState>(
              builder: (context, state) {
            AppLogger.i('Job Ongoing -> ${state.isJobOnGoing}');
            return WillPopScope(
              onWillPop: () async {
                if (state.isJobOnGoing) {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                } else {
                  getItInjector<AppRouter>().removeLast();
                }
                return true;
              },
              child: Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                resizeToAvoidBottomInset: false,
                appBar: const AppBarGone(),
                body: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 100,
                              width: 100,
                            ),
                          ),
                          state.scanActive
                              ? Container(
                                  margin: const EdgeInsets.only(top: 40),
                                  height: 300,
                                  width: 300,
                                  child: _buildQrView(context))
                              : Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 10, left: 10),
                                        child: const Text(
                                          'About this Job -',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      ProfileListItem(
                                        icon: LineAwesomeIcons.word_file,
                                        text: 'Job - ',
                                        subText:
                                            '${profileState.selectedJob?.jobName}',
                                      ),
                                      ProfileListItem(
                                        icon: LineAwesomeIcons.location_arrow,
                                        text: 'Job Address - ',
                                        subText:
                                            '${profileState.selectedJob?.jobAddress}',
                                      ),
                                      ProfileListItem(
                                        icon: LineAwesomeIcons.helping_hands,
                                        text: 'Job Instruction - ',
                                        subText:
                                            '${profileState.selectedJob?.jobInstructions}',
                                      ),
                                      ProfileListItem(
                                        icon: LineAwesomeIcons.pointer__hand_,
                                        text: 'Total Checkpoints - ',
                                        subText:
                                            ' ${profileState.selectedJob?.jobTotalCheckpoints}',
                                      ),
                                      ProfileListItem(
                                        icon: LineAwesomeIcons.typo3,
                                        text: 'My Job Type -',
                                        subText:
                                            ' ${profileState.selectedJob?.jobType}',
                                      ),
                                      ProfileListItem(
                                        icon: LineAwesomeIcons.business_time,
                                        text: 'Job Joining Date - ',
                                        subText:
                                            '${profileState.selectedJob?.jobStartDate}',
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Visibility(
                            visible: state.isJobOnGoing,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!state.scanActive) {
                                            qrScanController?.resumeCamera();
                                          } else {
                                            qrScanController?.pauseCamera();
                                          }
                                          guardDashboardCubit
                                              .changeScanActiveStatus();
                                        },
                                        child: Container(
                                          height: 110,
                                          color: Colors.orange,
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Text(
                                                  state.scanActive
                                                      ? 'Stop'
                                                      : 'Scan',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: ActivityLogReport(),
                                                title:
                                                    Text('Activity Log Report'),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 110,
                                          color: Colors.red,
                                          child: const Center(
                                            child: Text(
                                              'Activity Log',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
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
                                      child: InkWell(
                                        onTap: () {
                                          guardDashboardCubit.onOffTorch();
                                        },
                                        child: Container(
                                          height: 110,
                                          color: Colors.blueGrey,
                                          child: Center(
                                              child: state.flashOn
                                                  ? const Icon(
                                                      Icons
                                                          .flashlight_off_rounded,
                                                      color: Colors.white,
                                                      size: 35,
                                                    )
                                                  : const Icon(
                                                      Icons.flashlight_on,
                                                      color: Colors.white,
                                                      size: 35,
                                                    )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: IncidentReport(),
                                                title: Text(
                                                    'Add incident report & narrative'),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 110,
                                          color: Colors.tealAccent[700],
                                          child: const Center(
                                            child: Text(
                                              'Incident Report',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                if (state.isJobOnGoing) {
                                  guardDashboardCubit.endJob();
                                } else {
                                  guardDashboardCubit.startJob();
                                }
                              },
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.green[800],
                                    child: state.isJobOnGoing
                                        ? const Text('End')
                                        : const Text('Start')),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniEndTop,
                floatingActionButton: Visibility(
                  visible: state.isJobOnGoing,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: FloatingActionButton(
                      onPressed: () async {
                        guardDashboardCubit.onSosTap();
                      },
                      child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12, width: 5),
                            color: Colors.red,
                          ),
                          child: const Icon(
                            Icons.sos,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: 200),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
    // return QRView(
    //   key: qrKey,
    //   onQRViewCreated: _onQRViewCreated,
    //   onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    // );
    //
  }

  void _onQRViewCreated(QRViewController controller) {
    qrScanController = controller;
    qrScanController?.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      qrScanController?.pauseCamera();
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: ScanReport(
              scanData: scanData,
            ),
          );
        },
      );
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    AppLogger.i('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    if (qrScanController != null) {
      qrScanController?.dispose();
    }
    super.dispose();
  }
}

class ActivityLogReport extends StatefulWidget {
  const ActivityLogReport({Key? key}) : super(key: key);

  @override
  State<ActivityLogReport> createState() => _ActivityLogReportState();
}

class _ActivityLogReportState extends State<ActivityLogReport> {
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  late final GuardDashboardCubit guardDashboardCubit;
  TimeOfDay? timeOfDay;

  @override
  void initState() {
    // TODO: implement initState
    guardDashboardCubit = context.read<GuardDashboardCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 40,
        ),
        TextField(
          controller: timeController,
          decoration: InputDecoration(
              hintText: ' Pick time',
              hintStyle: theme.textTheme.caption,
              border: const OutlineInputBorder()),
          style: theme.textTheme.titleSmall,
          readOnly: true,
          onTap: () async{
            final dateTime = await showTimePicker(
              initialTime: TimeOfDay.now(),
              context: context,
            );
            if(dateTime!=null){
              timeController.text = '${dateTime.hour.toString()}:${dateTime.minute.toString()}';
              timeOfDay = dateTime;
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
              hintText: ' Activity log description',
              hintStyle: theme.textTheme.caption,
              border: const OutlineInputBorder()),
          style: theme.textTheme.titleSmall,
          maxLines: 7,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (descriptionController.text.isNotEmpty && timeOfDay!=null) {
                    guardDashboardCubit
                        .sendActivityLogReport(descriptionController.text,timeOfDay!);
                    Navigator.of(context).pop();
                  } else {}
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

class IncidentReport extends StatefulWidget {
  const IncidentReport({Key? key}) : super(key: key);

  @override
  State<IncidentReport> createState() => _IncidentReportState();
}

class _IncidentReportState extends State<IncidentReport> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late final GuardDashboardCubit guardDashboardCubit;

  @override
  void initState() {
    // TODO: implement initState
    guardDashboardCubit = context.read<GuardDashboardCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'Incident title',
            hintStyle: theme.textTheme.caption,
            border: const OutlineInputBorder(),
          ),
          style: theme.textTheme.titleSmall,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 40,
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration.collapsed(
              hintText: '  Incident Narrative',
              hintStyle: theme.textTheme.caption,
              border: const OutlineInputBorder()),
          style: theme.textTheme.titleSmall,
          maxLines: 7,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    guardDashboardCubit.sendIncidentReport(
                        titleController.text, descriptionController.text);
                    Navigator.of(context).pop();
                  } else {}
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

class ScanReport extends StatefulWidget {
  const ScanReport({Key? key, required this.scanData}) : super(key: key);

  final Barcode scanData;

  @override
  State<ScanReport> createState() => _ScanReportState();
}

class _ScanReportState extends State<ScanReport> {
  final reportController = TextEditingController();
  late final GuardDashboardCubit guardDashboardCubit;

  @override
  void initState() {
    // TODO: implement initState
    guardDashboardCubit = context.read<GuardDashboardCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Add Report'),
        const SizedBox(
          height: 60,
        ),
        Material(
          type: MaterialType.transparency,
          elevation: 0,
          shadowColor: Colors.transparent,
          child: TextField(
            controller: reportController,
            decoration: InputDecoration(
                hintText: 'Report in description',
                hintStyle: theme.textTheme.caption,
                border: const OutlineInputBorder()),
            style: theme.textTheme.titleSmall,
            textInputAction: TextInputAction.done,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Material(
            type: MaterialType.transparency,
            elevation: 0,
            shadowColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (reportController.text.isNotEmpty) {
                        guardDashboardCubit.onScanResultUpdate(
                          widget.scanData,
                          reportController.text,
                        );
                        Navigator.of(context).pop();
                      } else {}
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    reportController.dispose();
    super.dispose();
  }
}
