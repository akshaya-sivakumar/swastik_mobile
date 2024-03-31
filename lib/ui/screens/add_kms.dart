import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swastik_mobile/bloc/addKms/kms_bloc.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/button.dart';
import 'package:swastik_mobile/ui/widgets/logout.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class AddkmsScreen extends StatefulWidget {
  const AddkmsScreen({super.key});

  @override
  State<AddkmsScreen> createState() => _AddkmsScreenState();
}

class _AddkmsScreenState extends State<AddkmsScreen> {
  KmsBloc kmsBloc = KmsBloc();
  final ImagePicker picker = ImagePicker();
  XFile? startphoto;
  XFile? endphoto;
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  @override
  void initState() {
    EasyLoading.dismiss();
    _getCurrentPosition();
    kmsBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is AddkmsDone) {
          EasyLoading.showSuccess('Success!');
          startController.text = "";
          endController.text = "";
          startphoto = null;
          endphoto = null;
          setState(() {});
        } else if (event is AddkmsLoad) {
          EasyLoading.show(status: 'loading...');
        } else if (event is AddkmsError) {
          EasyLoading.showError(event.message);
          /*  startController.clear();
          endController.clear();
          startphoto = null;
          endphoto = null;
          setState(() {}); */
        }
      });
    kmsBloc.add(FetchkmsEvent());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    EasyLoading.show(status: 'Fetching Location...');
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  String? currentAddress;
  Position? _currentPosition;

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];

      var response = await http.get(
        Uri.parse(
            "http://www.postalpincode.in/api/pincode/${place.postalCode}"),
      );

      String district =
          json.decode(response.body)["PostOffice"].first["District"];

      currentAddress =
          '${place.street}, ${place.locality},$district,${place.administrativeArea},${place.country}, ${place.postalCode}';

      if (mounted) {
        setState(() {});
      }
      //  print(currentAddress);
      EasyLoading.dismiss();
    }).catchError((e) {
      EasyLoading.showError("Failed to get location");
      debugPrint(e.toString());
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: TextWidget(
            "Add Kms",
            color: Colors.white,
            fontweight: FontWeight.bold,
            size: 22.sp,
          ),
          backgroundColor: HexColor("#135a92"),
          actions: const [LogoutWidget()],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
          child: BlocBuilder<KmsBloc, KmsState>(
            buildWhen: (previous, current) {
              return current is FetchkmsDone ||
                  current is FetchkmsError ||
                  current is FetchkmsLoad;
            },
            builder: (context, state) {
              print(state);
              if (state is FetchkmsLoad) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FetchkmsDone) {
                return Column(
                  children: [
                    const TextWidget(
                      "Add Start Kms",
                      fontweight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    mainWidget(context, true),
                    SizedBox(
                      height: 15.w,
                    ),
                  ],
                );
              } else if (state is FetchkmsError) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20.w,
                    ),
                    const TextWidget(
                      "Add End Kms",
                      fontweight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    mainWidget(context, false),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Column mainWidget(BuildContext context, bool start) {
    return Column(children: [
      TextFormField(
        controller: start ? startController : endController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return "Please enter ${start ? "Start" : "End"} kms";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {},
        decoration: textfirlDecor("Enter the ${start ? "Start" : "End"} Km"),
      ),
      SizedBox(
        height: 15.w,
      ),
      SizedBox(
        height: 300.w,
        width: 300.w,
        child: DottedBorder(
          color: Colors.black,
          strokeWidth: 1,
          child: (start ? startphoto : endphoto) == null
              ? GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => _bottomSheetProfile(start)));
                  },
                  child: const Center(
                    child: TextWidget(
                      "Choose Image",
                      color: Colors.grey,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Image.file(
                      File((start ? startphoto : endphoto)?.path ?? ""),
                      fit: BoxFit.cover,
                      height: 300.w,
                      width: 300.w,
                    ),
                    Positioned(
                        right: 10.w,
                        top: 5.w,
                        child: GestureDetector(
                          onTap: () {
                            if (start) {
                              startphoto = null;
                            } else {
                              endphoto = null;
                            }
                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.all(3.w),
                              color: Colors.white,
                              child: Icon(
                                Icons.close,
                                size: 17.sp,
                              )),
                        )),
                  ],
                ),
        ),
      ),
      SizedBox(
        height: 10.w,
      ),
      button("   Save     ", () {
        if (_formKey.currentState!.validate()) {
          if ((start ? startphoto : endphoto) == null) {
            Fluttertoast.showToast(
                msg: "Please Choose Image",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        "Save",
                        fontweight: FontWeight.bold,
                        size: 22.sp,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget("Are you sure you want to save?"),
                    ],
                  ),
                  actions: [
                    button(
                      "Cancel",
                      () async {
                        Navigator.pop(context);
                      },
                      Colors.grey,
                    ),
                    button("Save", () async {
                      Navigator.pop(navigatorKey.currentContext!);
                      kmsBloc.add(AddkmsEvent(
                          start,
                          File((start ? startphoto : endphoto)?.path ?? ""),
                          start ? startController.text : endController.text));
                    }, HexColor("#135a92"))
                  ],
                );
              },
            );
          }
        }
      }, HexColor("#135a92"), size: 20.sp),
    ]);
  }

  Widget _bottomSheetProfile(bool start) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Choose a Photo",
            style: TextStyle(fontSize: 20.sp, color: Colors.black),
          ),
          SizedBox(
            height: 20.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (start) {
                      var image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);

                      var decodeImg =
                          img.decodeImage(File(image!.path).readAsBytesSync());

                      img.drawString(
                        decodeImg!,
                        "${DateFormat("MMM dd,yyyy hh:mm:ss a").format(DateTime.now())} \n\n $currentAddress ",
                        font: img.arial48,
                        x: 20,
                        y: decodeImg.height ~/ 1.4,
                      );

                      var encodeImage = img.encodeJpg(decodeImg, quality: 50);

                      var finalImage = File(image.path)
                        ..writeAsBytesSync(encodeImage);

                      startphoto = XFile(finalImage.path);
                    } else {
                      var image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);

                      var decodeImg =
                          img.decodeImage(File(image!.path).readAsBytesSync());

                      img.drawString(
                        decodeImg!,
                        "${DateFormat("MMM dd,yyyy hh:mm:ss a").format(DateTime.now())} \n\n $currentAddress ",
                        font: img.arial48,
                        x: 20,
                        y: decodeImg.height ~/ 1.4,
                      );

                      var encodeImage = img.encodeJpg(decodeImg, quality: 50);

                      var finalImage = File(image.path)
                        ..writeAsBytesSync(encodeImage);

                      endphoto = XFile(finalImage.path);
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    color: HexColor("#135a92"),
                    size: 30,
                  )),
              IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (start) {
                      startphoto = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 50);
                    } else {
                      endphoto = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 50);
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.image,
                    color: HexColor("#135a92"),
                    size: 30,
                  ))
            ],
          ),
          SizedBox(
            height: 20.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Camera",
                style: TextStyle(fontSize: 18.sp, color: HexColor("#135a92")),
              ),
              Text(
                "Gallery",
                style: TextStyle(fontSize: 18.sp, color: HexColor("#135a92")),
              )
            ],
          )
        ],
      ),
    );
  }

  InputDecoration textfirlDecor(String label) {
    return InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.black54,
        ),
        labelText: label,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        )
        //fillColor: Colors.green
        );
  }
}
