import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swastik_mobile/model/login_request.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';
import '../../route_generator.dart';
import '../widgets/auth_button.dart';
import '../widgets/text_field.dart';
import '../widgets/text_widget.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();
  bool locationAccess = true;
  String get phonenumber => usernameController.text.trim();
  String get otp => pwdController.text.trim();
  String? verifiedId;
  LoginBloc loginBloc = LoginBloc();
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Location location = Location();

  turnonLocation() async {
    await location.requestService();
    await Permission.locationWhenInUse.request();
    print(await Permission.locationWhenInUse.status);
    if (await Permission.locationWhenInUse.isDenied ||
        await Permission.locationWhenInUse.isPermanentlyDenied) {
      Fluttertoast.showToast(msg: "Turn on location to login");
    }
  }

  List<CameraDescription> _cameras = <CameraDescription>[];
  getCams() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      print(_cameras);
    } on CameraException catch (e) {
      log("${e.code} ${e.description}");
    }
  }

  @override
  void initState() {
    EasyLoading.dismiss();

    turnonLocation();
    loginBloc = BlocProvider.of<LoginBloc>(context)
      ..stream.listen((event) {
        if (event is LoginLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is LoginDone) {
          EasyLoading.showSuccess('Success!');
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            "/visits",
            (route) {
              return false;
            },
          );
        } else if (event is LoginError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30.w),
                height: MediaQuery.of(context).size.height * 0.18,
                width: 100,
                child: Image.asset(
                  "assets/appLogo.png",
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: HexColor("#135a92"),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100.w),
                          topRight: Radius.circular(100.w))),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 100.w, horizontal: 30.w),
                          child: TextWidget(
                            "LOGIN",
                            color: HexColor("#434344"),
                            style: GoogleFonts.sono(
                                fontWeight: FontWeight.bold,
                                fontSize: 50.w,
                                color: Colors.white,
                                shadows: [
                                  const Shadow(
                                    offset: Offset(3, 0),
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                  ),
                                  const Shadow(
                                    offset: Offset(3, 0),
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 24.w,
                        ),
                        CustomFormField(
                          validator: (p0) {
                            if ((p0 ?? "").isEmpty) {
                              return "Please enter username";
                            }
                            return null;
                          },
                          headingText: "Username",
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          obsecureText: false,
                          suffixIcon: const SizedBox(
                            width: 3,
                          ),
                          controller: usernameController,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.029,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.009,
                        ),
                        CustomFormField(
                          validator: (p0) {
                            if ((p0 ?? "").isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          headingText: "Password",
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          obsecureText: obscureText,
                          suffixIcon: IconButton(
                            onPressed: _toggle,
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                          ),
                          controller: pwdController,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        AuthButton(
                          onTap: () async {
                            if (await Permission.locationWhenInUse.isGranted) {
                              if (_formKey.currentState!.validate()) {
                                loginBloc.add(Login(LoginRequest(
                                    username: usernameController.text,
                                    password: pwdController.text)));
                              }
                            } else {
                              turnonLocation();
                            }
                          },
                          text: "SIGN IN",
                          color: Colors.white,
                          fontColor: HexColor("#135a92"),
                          fontweight: FontWeight.bold,
                          fontsize: 20.sp,
                        )
                        /*  AuthButton(
                          onTap: () async {
                            
                          },
                          text: 'LOGIN',
                          fontweight: FontWeight.bold,
                        ), */
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
