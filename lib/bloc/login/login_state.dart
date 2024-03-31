abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoad extends LoginState {}

class LoginDone extends LoginState {
  LoginDone();
}

class LoginError extends LoginState {}
