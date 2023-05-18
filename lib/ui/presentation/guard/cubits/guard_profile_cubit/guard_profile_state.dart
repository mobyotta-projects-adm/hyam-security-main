part of 'guard_profile_cubit.dart';

class GuardProfileState extends Equatable {
  const GuardProfileState({this.guard, this.assignedJobModel,this.selectedJob});

  const GuardProfileState.init({this.guard, this.assignedJobModel,this.selectedJob});

  final User? guard;
  final List<AssignedJobModel>? assignedJobModel;
  final AssignedJobModel? selectedJob;

  GuardProfileState copyWith(
      {User? guard, List<AssignedJobModel>? assignedJobModel,AssignedJobModel? selectedJob}) {
    return GuardProfileState(
      guard: guard ?? this.guard,
      assignedJobModel: assignedJobModel ?? this.assignedJobModel,
      selectedJob: selectedJob ?? this.selectedJob,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        guard,
        assignedJobModel,
         selectedJob,
      ];
}
