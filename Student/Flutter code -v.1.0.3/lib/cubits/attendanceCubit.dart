import 'package:equatable/equatable.dart';
import 'package:eschool/data/models/academicYear.dart';
import 'package:eschool/data/models/attendanceDay.dart';
import 'package:eschool/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AttendanceState extends Equatable {}

class AttendanceInitial extends AttendanceState {
  @override
  List<Object?> get props => [];
}

class AttendanceFetchInProgress extends AttendanceState {
  @override
  List<Object?> get props => [];
}

class AttendanceFetchSuccess extends AttendanceState {
  final List<AttendanceDay> attendanceDays;
  final AcademicYear academicYear;

  AttendanceFetchSuccess(
      {required this.attendanceDays, required this.academicYear});
  @override
  List<Object?> get props => [attendanceDays];
}

class AttendanceFetchFailure extends AttendanceState {
  final String errorMessage;

  AttendanceFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AttendanceCubit extends Cubit<AttendanceState> {
  final StudentRepository _studentRepository;

  AttendanceCubit(this._studentRepository) : super(AttendanceInitial());

  void fetchAttendance(
      {required int month,
      required int year,
      required bool useParentApi,
      int? childId}) {
    emit(AttendanceFetchInProgress());

    _studentRepository
        .fetchAttendance(
            month: month,
            year: year,
            childId: childId ?? 0,
            useParentApi: useParentApi)
        .then((result) => emit(AttendanceFetchSuccess(
            academicYear: result['academicYear'],
            attendanceDays: result['attendanceDays'])))
        .catchError((e) => emit(AttendanceFetchFailure(e.toString())));
  }
}
