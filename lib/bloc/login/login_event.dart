import 'package:swastik_mobile/model/login_request.dart';

abstract class LoginEvent {}

class Login extends LoginEvent {
  final LoginRequest request;
  Login(this.request);
}
