part of 'kms_bloc.dart';

@immutable
class KmsEvent {}

class AddkmsEvent extends KmsEvent {
  final String kms;
  final File file;
  final bool start;

  AddkmsEvent(this.start, this.file, this.kms);
}

class FetchkmsEvent extends KmsEvent {
  FetchkmsEvent();
}

class FetchVisitsEvent extends KmsEvent {
  FetchVisitsEvent();
}

class AddVisitsEvent extends KmsEvent {
  final CheckinstartModel checkinstartModel;
  final bool checkin;
  AddVisitsEvent(this.checkinstartModel, {this.checkin = true});
}
