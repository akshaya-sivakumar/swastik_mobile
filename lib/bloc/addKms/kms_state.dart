part of 'kms_bloc.dart';

@immutable
sealed class KmsState {}

final class KmsInitial extends KmsState {}

class AddkmsLoad extends KmsState {}

class AddkmsDone extends KmsState {}

class AddkmsError extends KmsState {
  final String message;

  AddkmsError({required this.message});
}

class FetchkmsLoad extends KmsState {}

class FetchkmsDone extends KmsState {}

class FetchkmsError extends KmsState {
  final String message;

  FetchkmsError({required this.message});
}

class VisitsLoad extends KmsState {}

class VisitsDone extends KmsState {
  final VisitsModel visits;

  VisitsDone(this.visits);
}

class VisitsError extends KmsState {
  final String message;

  VisitsError({required this.message});
}

class AddLoad extends KmsState {}

class AddDone extends KmsState {
  final bool checkin;

  AddDone( this.checkin);
}

class AddError extends KmsState {
  final String message;

  AddError({required this.message});
}
