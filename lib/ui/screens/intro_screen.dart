import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:swastik_mobile/bloc/addKms/kms_bloc.dart';
import 'package:swastik_mobile/model/checkin_start_req.dart';
import 'package:swastik_mobile/model/visits_model.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/button.dart';
import 'package:swastik_mobile/ui/widgets/dialog_widget.dart';
import 'package:swastik_mobile/ui/widgets/logout.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  KmsBloc kmsBloc = KmsBloc();
  CheckinstartModel checkinstartModel = CheckinstartModel();
  final startKey = GlobalKey<FormState>();
  final endKey = GlobalKey<FormState>();
  @override
  void initState() {
    kmsBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is AddLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is AddDone) {
          EasyLoading.showSuccess(event.checkin
              ? 'Check In was updated successfully!'
              : "Check Out was updated successfully.");
          nameCtr.clear();
          purposeCtr.clear();
          meetPointctr.clear();
          startKm.clear();
          endKm.clear();
          kmsBloc.add(FetchVisitsEvent());
        } else if (event is AddError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    _getCurrentPosition();
    kmsBloc.add(FetchVisitsEvent());
    super.initState();
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

  TextEditingController startKm = TextEditingController();
  TextEditingController endKm = TextEditingController();

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
  double lat = 0;
  double long = 0;

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

      checkinstartModel.checkInLatitude = position.latitude;
      checkinstartModel.checkInLongitude = position.longitude;
      lat = position.latitude;
      long = position.longitude;

      setState(() {});
      print(checkinstartModel.checkInLongitude);

      EasyLoading.dismiss();
      return currentAddress;
    }).catchError((e) {
      EasyLoading.showError("Failed to get location");
      debugPrint(e.toString());
    });
  }

  List<Item> item = [];

  List<Item> startItem = [];
  TextEditingController nameCtr = TextEditingController();
  TextEditingController meetPointctr = TextEditingController();
  TextEditingController purposeCtr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<KmsBloc, KmsState>(
        buildWhen: (previous, current) {
          return current is VisitsLoad ||
              current is VisitsDone ||
              current is VisitsError;
        },
        builder: (context, state) {
          if (state is VisitsDone) {
            startItem = state.visits.item
                .where(
                    (element) => element.customerName.toLowerCase() == "start")
                .toList();
            return (startItem.isNotEmpty && startItem[0].isCheckOut == false)
                ? BottomAppBar(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          button("Check-In", () {
                            DialogWidget().dialogWidget(
                                navigatorKey.currentContext!, "Check-In", () {
                              nameCtr.clear();
                              purposeCtr.clear();
                              meetPointctr.clear();
                              navigatorKey.currentState?.pop();
                            }, () {
                              DialogWidget().dialogWidget(
                                  navigatorKey.currentContext!,
                                  "Are you sure you want to Check-In?",
                                  () => navigatorKey.currentState?.pop(), () {
                                navigatorKey.currentState?.pop();
                                navigatorKey.currentState?.pop();
                                checkinstartModel = CheckinstartModel(
                                    id: "00000000-0000-0000-0000-000000000000",
                                    userId: "no",
                                    date:
                                        "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                                    checkInTime:
                                        "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                                    isCheckIn: true,
                                    isCheckOut: false,
                                    customerName: nameCtr.text,
                                    meetingPoints: "start",
                                    checkOutTime:
                                        "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                                    purpose: purposeCtr.text,
                                    checkOutLatitude: 0,
                                    checkOutLongitude: 0,
                                    checkInLatitude: lat,
                                    checkInLongitude: long,
                                    startKm: 0,
                                    endKm: 0);
                                kmsBloc.add(AddVisitsEvent(checkinstartModel));
                              }, okText: "Check-In");
                            },
                                notefield: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // const TextWidget("Meeting Points"),
                                    // TextFormField(
                                    //   controller: meetPointctr,
                                    //   maxLines: 2,
                                    //   decoration: InputDecoration(
                                    //     border: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.circular(5.0),
                                    //       borderSide: const BorderSide(
                                    //         color: Colors.grey,
                                    //       ),
                                    //     ),
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.circular(5.0),
                                    //       borderSide: BorderSide(
                                    //         color: HexColor("#135a92"),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5.w),
                                      child: const TextWidget("Customer name"),
                                    ),
                                    TextFormField(
                                      controller: nameCtr,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: HexColor("#135a92"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5.w),
                                      child: const TextWidget("Purpose"),
                                    ),
                                    TextFormField(
                                      maxLines: 1,
                                      controller: purposeCtr,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: HexColor("#135a92"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                okText: "Submit");
                          }, HexColor("#135a92")),
                        ]),
                  )
                : Container(
                    height: 1,
                  );
          }
          return Container(
            height: 1,
          );
        },
      ),
      appBar: AppBar(
        leadingWidth: 160.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Image.asset(
            "assets/appLogo.png",
            fit: BoxFit.fill,
            height: 50.w,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const TextWidget(
          "Visits",
          fontweight: FontWeight.bold,
        ),
        actions: const [LogoutWidget()],
      ),
      body: BlocBuilder<KmsBloc, KmsState>(
        buildWhen: (previous, current) {
          return current is VisitsLoad ||
              current is VisitsDone ||
              current is VisitsError;
        },
        builder: (context, state) {
          if (state is VisitsLoad) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VisitsDone) {
            item = state.visits.item;
            //     .where(
            //         (element) => element.customerName.toLowerCase() != "start")
            //   .toList();
            if (state.visits.item.isNotEmpty) {
              return item.isEmpty
                  ? const Center(child: TextWidget("No checkin"))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.w, horizontal: 10.w),
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: item[index].isCheckIn == true &&
                                  item[index].isCheckOut == true
                              ? null
                              : () {
                                  DialogWidget().dialogWidget(
                                      navigatorKey.currentContext!, "Check-Out",
                                      () {
                                    nameCtr.clear();
                                    purposeCtr.clear();
                                    meetPointctr.clear();
                                    navigatorKey.currentState?.pop();
                                  }, () {
                                    DialogWidget().dialogWidget(
                                        navigatorKey.currentContext!,
                                        "Are you sure you want to Check-Out?",
                                        () => navigatorKey.currentState?.pop(),
                                        () {
                                      navigatorKey.currentState?.pop();
                                      navigatorKey.currentState?.pop();
                                      checkinstartModel = CheckinstartModel(
                                        id: item[index].id,
                                        userId: item[index].userId,
                                        date:
                                            "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                                        checkInTime: item[index].checkInTime,
                                        isCheckIn: false,
                                        isCheckOut: true,
                                        customerName: item[index].customerName,
                                        meetingPoints: meetPointctr.text,
                                        checkOutTime:
                                            "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                                        purpose: item[index].purpose,
                                        checkOutLatitude: lat,
                                        checkOutLongitude: long,
                                        checkInLatitude:
                                            item[index].checkInLatitude,
                                        checkInLongitude:
                                            item[index].checkInLongitude,
                                      );
                                      kmsBloc.add(AddVisitsEvent(
                                          checkinstartModel,
                                          checkin: false));
                                    }, okText: "Check-Out");
                                  },
                                      notefield: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const TextWidget("Meeting Points"),
                                          SizedBox(
                                            height: 10.w,
                                          ),
                                          TextFormField(
                                            controller: meetPointctr,
                                            maxLines: 2,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                borderSide: BorderSide(
                                                  color: HexColor("#135a92"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      okText: "Submit");
                                },
                          child: Container(
                            decoration: BoxDecoration(
                                color: item[index].isCheckIn &&
                                        item[index].isCheckOut
                                    ? Colors.grey.shade300
                                    : HexColor("#135a92").withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10.w)),
                            margin: EdgeInsets.symmetric(vertical: 5.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index != 0)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const TextWidget("Customer Name : "),
                                          TextWidget(
                                            item[index].customerName,
                                            fontweight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const TextWidget("Purpose : "),
                                              TextWidget(item[index].purpose)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const TextWidget("Date : "),
                                              TextWidget(
                                                item[index].checkInTimeAsString,
                                                fontweight: FontWeight.bold,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                if (index == 0)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextWidget(
                                        "Started",
                                        fontweight: FontWeight.bold,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const TextWidget("Date : "),
                                              TextWidget(
                                                item[index].checkInTimeAsString,
                                                fontweight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                          if (startItem[0].isCheckOut == false)
                                            button("End", () {
                                              DialogWidget().dialogWidget(
                                                navigatorKey.currentContext!,
                                                "Enter End Km",
                                                () {
                                                  navigatorKey.currentState
                                                      ?.pop();

                                                  endKm.clear();
                                                },
                                                () {
                                                  if (endKey.currentState
                                                          ?.validate() ??
                                                      false) {
                                                    DialogWidget().dialogWidget(
                                                        navigatorKey
                                                            .currentContext!,
                                                        "Are you sure you want to end?",
                                                        () => navigatorKey
                                                            .currentState
                                                            ?.pop(), () {
                                                      navigatorKey.currentState
                                                          ?.pop();
                                                      checkinstartModel = CheckinstartModel(
                                                          id: startItem[0].id,
                                                          userId: startItem[0]
                                                              .userId,
                                                          date:
                                                              "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                                                          checkInTime:
                                                              startItem[0]
                                                                  .checkInTime,
                                                          isCheckIn: true,
                                                          isCheckOut: true,
                                                          customerName:
                                                              startItem[0]
                                                                  .customerName,
                                                          meetingPoints:
                                                              meetPointctr.text,
                                                          checkOutTime:
                                                              "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                                                          purpose: startItem[0]
                                                              .purpose,
                                                          checkOutLatitude: lat,
                                                          checkOutLongitude:
                                                              long,
                                                          checkInLatitude:
                                                              startItem[0]
                                                                  .checkInLatitude,
                                                          checkInLongitude:
                                                              startItem[0]
                                                                  .checkInLongitude,
                                                          startKm: startItem[0]
                                                              .startKm,
                                                          endKm: int.tryParse(
                                                                  endKm.text) ??
                                                              0);
                                                      kmsBloc.add(
                                                          AddVisitsEvent(
                                                              checkinstartModel,
                                                              checkin: false));
                                                    }, okText: "End");
                                                  } else {}
                                                },
                                                okText: "Submit",
                                                notefield: Form(
                                                  key: endKey,
                                                  child: TextFormField(
                                                    controller: endKm,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    maxLines: 1,
                                                    validator: (value) {
                                                      if ((value?.isEmpty ??
                                                          true)) {
                                                        return "End km required";
                                                      } else if (((int.tryParse(
                                                                  endKm.text) ??
                                                              0) <
                                                          startItem[0]
                                                              .startKm)) {
                                                        return "End km should be greater than start km";
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        borderSide: BorderSide(
                                                          color: HexColor(
                                                              "#135a92"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }, Colors.red)
                                        ],
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    );
            } else {
              return Center(
                child: button("Start", () {
                  DialogWidget().dialogWidget(
                    navigatorKey.currentContext!,
                    "Enter Start Km",
                    () {
                      navigatorKey.currentState?.pop();

                      startKm.clear();
                    },
                    () {
                      if (startKey.currentState?.validate() ?? false) {
                        DialogWidget().dialogWidget(
                            navigatorKey.currentContext!,
                            "Are you sure you want to start?",
                            () => navigatorKey.currentState?.pop(), () {
                          navigatorKey.currentState?.pop();
                          navigatorKey.currentState?.pop();
                          checkinstartModel = CheckinstartModel(
                              id: "00000000-0000-0000-0000-000000000000",
                              userId: "no",
                              date:
                                  "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                              checkInTime:
                                  "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                              isCheckIn: true,
                              isCheckOut: false,
                              customerName: "start",
                              meetingPoints: "start",
                              checkOutTime:
                                  "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                              purpose: "start",
                              checkOutLatitude: 0,
                              checkOutLongitude: 0,
                              checkInLatitude: lat,
                              checkInLongitude: long,
                              startKm: int.tryParse(startKm.text) ?? 0,
                              endKm: 0);
                          kmsBloc.add(AddVisitsEvent(checkinstartModel));
                        }, okText: "Start");
                      }
                    },
                    okText: "Submit",
                    notefield: Form(
                      key: startKey,
                      child: TextFormField(
                        controller: startKm,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if ((value?.isEmpty ?? true)) {
                            return "Start km required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
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
                        ),
                      ),
                    ),
                  );
                  // DialogWidget().dialogWidget(
                  //     navigatorKey.currentContext!,
                  //     "Are you sure you want to start?",
                  //     () => navigatorKey.currentState?.pop(), () {
                  //   navigatorKey.currentState?.pop();
                  //   checkinstartModel = CheckinstartModel(
                  //       id: "00000000-0000-0000-0000-000000000000",
                  //       userId: "no",
                  //       date:
                  //           "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                  //       checkInTime:
                  //           "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                  //       isCheckIn: true,
                  //       isCheckOut: false,
                  //       customerName: "start",
                  //       meetingPoints: "start",
                  //       checkOutTime:
                  //           "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                  //       purpose: "start",
                  //       checkOutLatitude: 0,
                  //       checkOutLongitude: 0,
                  //       checkInLatitude: lat,
                  //       checkInLongitude: long);
                  //   kmsBloc.add(AddVisitsEvent(checkinstartModel));
                  // }, okText: "Start");
                }, Colors.green),
              );
            }
          }
          return Center(
            child: button("Start", () {
              DialogWidget().dialogWidget(
                  navigatorKey.currentContext!,
                  "Are you sure you want to start?",
                  () => navigatorKey.currentState?.pop(), () {
                checkinstartModel = CheckinstartModel(
                    id: "00000000-0000-0000-0000-000000000000",
                    userId: "no",
                    date:
                        "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                    checkInTime:
                        "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                    isCheckIn: true,
                    isCheckOut: false,
                    customerName: "start",
                    meetingPoints: "start",
                    checkOutTime:
                        "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())}Z",
                    purpose: "start",
                    checkOutLatitude: 0,
                    checkOutLongitude: 0,
                    checkInLatitude: lat,
                    checkInLongitude: long);
                kmsBloc.add(AddVisitsEvent(checkinstartModel));
              });
            }, Colors.green),
          );
        },
      ),
    );
  }
}
