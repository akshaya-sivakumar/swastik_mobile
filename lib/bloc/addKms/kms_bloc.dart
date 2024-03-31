import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:swastik_mobile/model/checkin_start_req.dart';
import 'package:swastik_mobile/model/kms_model.dart';
import 'package:swastik_mobile/model/visits_model.dart';
import 'package:swastik_mobile/repository/addkms_repo.dart';

part 'kms_event.dart';
part 'kms_state.dart';

class KmsBloc extends Bloc<KmsEvent, KmsState> {
  KmsBloc() : super(KmsInitial()) {
    on<AddkmsEvent>((event, emit) async {
      emit(AddkmsLoad());
      try {
        var response = await AddkmsRepository()
            .addExpense(event.kms, event.file, event.start);
        emit(AddkmsDone());
      } catch (e) {
        print(e);
        emit(AddkmsError(message: e.toString()));
      }
    });

    on<FetchkmsEvent>((event, emit) async {
      emit(FetchkmsLoad());
      try {
        FetchkmsModel response = await AddkmsRepository().getKms();
        if (response.item == null) {
          emit(FetchkmsDone());
        } else {
          emit(FetchkmsError(message: ""));
        }
      } catch (e) {
        print(e);
        emit(FetchkmsError(message: e.toString()));
      }
    });

    on<FetchVisitsEvent>((event, emit) async {
      emit(VisitsLoad());
      try {
        VisitsModel response = await AddkmsRepository().getVisits();
        if (response.item == null) {
          emit(VisitsError(message: ""));
        } else {
          emit(VisitsDone(response));
        }
      } catch (e) {
        print(e);
        emit(VisitsError(message: e.toString()));
      }
    });

    on<AddVisitsEvent>((event, emit) async {
      emit(AddLoad());
      try {
        Response response = await AddkmsRepository()
            .addVisits(event.checkinstartModel, event.checkin);

        emit(AddDone(event.checkin));
      } catch (e) {
        print(e);
        emit(AddError(message: e.toString()));
      }
    });
  }
}
