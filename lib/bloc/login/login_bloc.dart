import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/login_repo.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<Login>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      emit(LoginLoad());
      try {
        final response = await LoginRepository().data(event.request);
        /*  prefs.setString("email", response.email);
        prefs.setString("password", event.request.password ?? ""); */
        prefs.setString("token", response.successMessage);
        /*  prefs.setString("role", response.roles);
        prefs.setString("userId", response.id.toString());
        prefs.setString("username", response.username.toString()); */

        emit(LoginDone());
      } catch (e) {
        emit(LoginError());
        throw ("error");
      }
    });
  }
}
