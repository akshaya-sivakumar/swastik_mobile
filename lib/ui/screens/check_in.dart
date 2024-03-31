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
import 'package:swastik_mobile/bloc/customer/customer_bloc.dart';
import 'package:swastik_mobile/main.dart';
import 'package:swastik_mobile/model/checkin_model.dart';
import 'package:swastik_mobile/model/customer_model.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/button.dart';
import 'package:swastik_mobile/ui/widgets/dropdown.dart';
import 'package:swastik_mobile/ui/widgets/logout.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  CheckinModel checkinModel = CheckinModel();
  CustomerBloc customerBloc = CustomerBloc();
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  final _formKey = GlobalKey<FormState>();
  KmsBloc kmsBloc = KmsBloc();

  @override
  void initState() {
    kmsBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is FetchkmsLoad) {
          EasyLoading.show(status: 'Loading...');
        } else if (event is FetchkmsDone) {
          if (firstLaunch) {
            navigatorKey.currentState?.pushNamed("/checkin", arguments: 4);
          } else {
            _getCurrentPosition();
          }
          firstLaunch = false;
        } else {
          if (selectedIndex == 0) {
            _getCurrentPosition();
          }
        }
      });
    if (selectedIndex == 0) {
      if (firstLaunch) {
        kmsBloc.add(FetchkmsEvent());
      } else {
        _getCurrentPosition();
      }
    }
    customerBloc = BlocProvider.of(context);

    customerBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is CheckinDone) {
          EasyLoading.showSuccess('Success!');
          selectedIndex = 1;
          navigatorKey.currentState?.pushNamed("/checkin", arguments: 1);

          checkinModel = CheckinModel();
        }
        if (event is CheckinLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is CheckinError) {
          EasyLoading.showError(event.errorMessage);
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(checkinModel.address);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: TextWidget(
          "Checkin",
          color: Colors.white,
          fontweight: FontWeight.bold,
          size: 22.sp,
        ),
        backgroundColor: HexColor("#135a92"),
        actions: const [LogoutWidget()],
      ),
      bottomNavigationBar: BottomAppBar(
        child: button("Submit", () {
          if (_formKey.currentState!.validate()) {
            if (photo == null) {
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
                          "Check-in",
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
                        TextWidget("Are you sure you want to checkin?"),
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
                      button("Yes", () async {
                        Navigator.pop(navigatorKey.currentContext!);
                        if (checkinModel.isNewCustomer) {
                          checkinModel.customerId =
                              "00000000-0000-0000-0000-000000000000";
                        } else {
                          checkinModel.address = "no";
                          checkinModel.customerAddress = "no";
                        }

                        checkinModel.inTime = DateTime.now().toString();

                        customerBloc.add(CheckinEvent(
                            checkinModel, File(photo?.path ?? "")));
                      }, HexColor("#135a92"))
                    ],
                  );
                },
              );
            }
          }
        }, HexColor("#135a92"), size: 21.sp),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 10.w),
            child: Column(
              children: [
                yesNowidget(),
                SizedBox(
                  height: 30.w,
                ),
                if (checkinModel.isNewCustomer)
                  Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Please enter Company name";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          checkinModel.companyName = value;
                          setState(() {});
                        },
                        decoration: textfirlDecor("Company Name"),
                      ),
                      SizedBox(
                        height: 20.w,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller:
                            TextEditingController.fromValue(TextEditingValue(
                          text: checkinModel.address ?? "",
                          selection: TextSelection.fromPosition(
                            TextPosition(
                                offset: checkinModel.address?.length ?? 0),
                          ),
                        )),
                        onChanged: (value) {
                          checkinModel.address = value;
                          checkinModel.customerAddress = value;
                          setState(() {});
                        },
                        decoration: textfirlDecor("Address"),
                      ),
                      SizedBox(
                        height: 20.w,
                      ),
                      TextFormField(
                        controller:
                            TextEditingController.fromValue(TextEditingValue(
                          text: checkinModel.city ?? "",
                          selection: TextSelection.fromPosition(
                            TextPosition(
                                offset: checkinModel.city?.length ?? 0),
                          ),
                        )),
                        onChanged: (value) {
                          checkinModel.city = value;
                          setState(() {});
                        },
                        decoration: textfirlDecor("City"),
                      ),
                      SizedBox(
                        height: 20.w,
                      ),
                      TextFormField(
                        controller:
                            TextEditingController.fromValue(TextEditingValue(
                          text: checkinModel.district ?? "",
                          selection: TextSelection.fromPosition(
                            TextPosition(
                                offset: checkinModel.district?.length ?? 0),
                          ),
                        )),
                        onChanged: (value) {
                          checkinModel.district = value;
                          setState(() {});
                        },
                        decoration: textfirlDecor("District"),
                      ),
                    ],
                  )
                else
                  BlocBuilder<CustomerBloc, CustomerState>(
                    buildWhen: (previous, current) {
                      return current is CustomerDone ||
                          current is CustomerLoad ||
                          current is CustomerError;
                    },
                    builder: (context, state) {
                      //  if (state is CustomerDone) {
                      return customerDropdown(
                          context, state is CustomerDone ? state.customers : [],
                          loading: state is CustomerLoad,
                          error: state is CustomerError);
                      /*   }
                          if (state is CustomerLoad) {
                            return const CircularProgressIndicator();
                          }
                          return const TextWidget("error"); */
                    },
                  ),
                SizedBox(
                  height: 20.w,
                ),
                SizedBox(
                  height: 300.w,
                  width: 300.w,
                  child: DottedBorder(
                    color: Colors.black,
                    strokeWidth: 1,
                    child: photo == null
                        ? GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) =>
                                      _bottomSheetProfile()));
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
                                File(photo?.path ?? ""),
                                fit: BoxFit.fitWidth,
                                height: 300.w,
                                width: 300.w,
                              ),
                              Positioned(
                                  right: 10.w,
                                  top: 5.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      photo = null;
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomSheetProfile() {
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

                    var image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 50);

                    var decodeImg =
                        img.decodeImage(File(image!.path).readAsBytesSync());

                    img.drawString(
                      decodeImg!,
                      "${DateFormat("MMM dd,yyyy hh:mm:ss a").format(DateTime.now())} \n\n ${checkinModel.address} ",
                      font: img.arial48,
                      x: 20,
                      y: decodeImg.height ~/ 1.4,
                    );

                    var encodeImage = img.encodeJpg(decodeImg, quality: 50);

                    var finalImage = File(image.path)
                      ..writeAsBytesSync(encodeImage);

                    photo = XFile(finalImage.path);
                    final bytes = (await photo!.readAsBytes()).lengthInBytes;
                    final kb = bytes / 1024;
                    print("$kb kb");
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
                    var image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    var decodeImg =
                        img.decodeImage(File(image!.path).readAsBytesSync());

                    var encodeImage = img.encodeJpg(decodeImg!, quality: 50);

                    var finalImage = File(image.path)
                      ..writeAsBytesSync(encodeImage);

                    photo = XFile(finalImage.path);
                    final bytes = (await photo!.readAsBytes()).lengthInBytes;
                    final kb = bytes / 1024;
                    print("$kb kb");
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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      EasyLoading.dismiss();
      return;
    }
    EasyLoading.show(status: 'Fetching Location...');
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      await _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  String? currentAddress;

  Future _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];

      var response = await http.get(
        Uri.parse(
            "http://www.postalpincode.in/api/pincode/${place.postalCode}"),
      );
      print("===============");
      print(json.decode(response.body)["PostOffice"]);

      String district =
          json.decode(response.body)["PostOffice"]?.first["District"];

      currentAddress =
          '${place.street}, ${place.locality},$district,${place.administrativeArea},${place.country}, ${place.postalCode}';

      checkinModel.inLatitude = position.latitude.toString();
      checkinModel.inLongitude = position.longitude.toString();
      checkinModel.address = currentAddress;
      checkinModel.customerAddress = currentAddress;
      checkinModel.city = place.locality;
      checkinModel.district = district;
      print("test${checkinModel.address}");

      if (mounted) {
        setState(() {});
      }
      EasyLoading.dismiss();
      return checkinModel.address;
    }).catchError((e) {
      EasyLoading.showError("Failed to get location");
      debugPrint(e.toString());
    });
  }

  Row yesNowidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            SizedBox(
              width: 25,
              child: Radio(
                activeColor: HexColor("#135a92"),
                value: true,
                groupValue: checkinModel.isNewCustomer,
                onChanged: (val) {
                  setState(() {
                    checkinModel.isNewCustomer = val ?? false;
                    checkinModel.customerId = null;
                    _getCurrentPosition();
                  });
                },
              ),
            ),
            const Text(
              'New Customer',
              //style: style1,
            ),
          ],
        ),
        const SizedBox(
          width: 30,
        ),
        Row(
          children: [
            SizedBox(
              width: 25,
              child: Radio(
                activeColor: HexColor("#135a92"),
                value: false,
                groupValue: checkinModel.isNewCustomer,
                onChanged: (val) {
                  setState(() {
                    checkinModel.isNewCustomer = val ?? false;
                    checkinModel.address = null;
                    checkinModel.city = null;
                    checkinModel.district = null;
                    checkinModel.companyName = null;
                  });
                  customerBloc.add(FetchCustomer());
                },
              ),
            ),
            const Text(
              'Existing Customer',
              //style: style1,
            ),
          ],
        ),
      ],
    );
  }

  Container customerDropdown(BuildContext context, List<CustomerModel> itemList,
      {bool loading = false, bool error = false}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: Colors.grey)),
        child: CustomDropdownButton(
          underline: const Divider(
            color: Colors.transparent,
          ),
          hint: const Text(
            "-- Select customer --",
            style: TextStyle(
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          value: (itemList.isNotEmpty && checkinModel.customerId != null)
              ? itemList
                  .where((element) => element.id == checkinModel.customerId)
                  .toList()
                  .first
              : null,
          icon: error
              ? Container(
                  padding: EdgeInsets.all(8.w),
                  width: 60.sp,
                  height: 60.sp,
                  child: Icon(
                    Icons.error,
                    size: 25.sp,
                    color: Colors.red.shade900,
                  ))
              : loading
                  ? Container(
                      padding: EdgeInsets.all(14.w),
                      width: 60.sp,
                      height: 60.sp,
                      child: const CircularProgressIndicator())
                  : Container(
                      padding: EdgeInsets.all(8.w),
                      width: 60.sp,
                      height: 60.sp,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 50.sp,
                        color: HexColor("#135a92"),
                      ),
                    ),
          onChanged: (value) {
            print(value.id);
            checkinModel.customerId = value.id;

            setState(() {});
          },
          items: itemList.toList().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.companyName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400, color: Colors.black),
              ),
            );
          }).toList(),
        ));
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
        borderSide: BorderSide(
          color: HexColor("#135a92"),
        ),
      ),
      //fillColor: Colors.green
    );
  }
}
