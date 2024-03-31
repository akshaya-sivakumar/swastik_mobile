import 'dart:convert';
import 'dart:io';
import 'dart:math';

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
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_mobile/bloc/customer/customer_bloc.dart';
import 'package:swastik_mobile/model/checkout_model.dart';
import 'package:swastik_mobile/model/enquiry_model.dart';
import 'package:swastik_mobile/model/productlist_model.dart' as product;
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/button.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final Item item;
  const CheckoutScreen({super.key, required this.item});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutModel checkoutModel = CheckoutModel();
  CustomerBloc customerBloc = CustomerBloc();
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    customerBloc = BlocProvider.of(context);

    _getCurrentPosition();
    customerBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is CheckinDone) {
          EasyLoading.showSuccess('Success!');
          Navigator.pop(context);
        }
        if (event is CheckinLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is CheckinError) {
          EasyLoading.showError(event.errorMessage);
        }
      });
    checkoutModel.id = widget.item.id;
    checkoutModel.customerId = widget.item.customerId;

    if (widget.item.outTime != "" &&
        widget.item.outLatitude != 0 &&
        widget.item.outLongitude != 0) {
      checkoutModel.contactPersonName = widget.item.contactPersonName;
      checkoutModel.contactPersonPhone = widget.item.contactPersonPhone;
      checkoutModel.meetingPoints = widget.item.meetingPoints;
      checkoutModel.customerEmail = widget.item.customer.emailId;
      checkoutModel.officePhoneNumber = widget.item.customer.officePhoneNumber;
      checkoutModel.landLineNumber = widget.item.customer.landLineNumber;
      checkoutModel.hasNextFolloup = widget.item.hasNextFolloup;
      checkoutModel.nextFollowupDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(widget.item.nextFollowupDate));

      if (widget.item.outPhotoUrl.isNotEmpty) {
        getImage();
      }
    }

    customerBloc.add(GetProducts());

    super.initState();
  }

  bool loading = false;

  getImage() async {
    loading = true;
    setState(() {});
    File f = await urlToFile(widget.item.outPhotoUrl);
    photo = XFile(f.path);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: TextWidget(
          "Checkout",
          color: Colors.white,
          fontweight: FontWeight.bold,
          size: 22.sp,
        ),
        backgroundColor: HexColor("#135a92"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Logout",
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
                            TextWidget("Are you sure you want to logout?"),
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
                          button("Ok", () async {
                            Navigator.pop(navigatorKey.currentContext!);
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.clear();
                            navigatorKey.currentState?.pushNamedAndRemoveUntil(
                              "/",
                              (route) {
                                return false;
                              },
                            );
                          }, HexColor("#135a92"))
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.logout)),
          )
        ],
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
                          "Checkout",
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
                        TextWidget("Are you sure you want to checkout?"),
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
                        checkoutModel.outTime = DateTime.now().toString();

                        customerBloc.add(CheckoutEvent(
                            checkoutModel, File(photo?.path ?? "")));
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
                //  yesNowidget(),
                SizedBox(
                  height: 30.w,
                ),

                Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: widget.item.customer.companyName),
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: textfirlDecor("Company Name"),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    BlocBuilder<CustomerBloc, CustomerState>(
                      builder: (context, state) {
                        return productDropdown(
                            context,
                            state is ProductsDone
                                ? state.products.item
                                : (<product.Item>[]),
                            loading: state is ProductsLoad);
                      },
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController.fromValue(TextEditingValue(
                        text: checkoutModel.contactPersonName ?? "",
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset:
                                  checkoutModel.contactPersonName?.length ?? 0),
                        ),
                      )),
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return "Please enter Name";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        checkoutModel.contactPersonName = value;
                        setState(() {});
                      },
                      decoration: textfirlDecor("Contact Person Name"),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController.fromValue(TextEditingValue(
                        text: checkoutModel.contactPersonPhone ?? "",
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset:
                                  checkoutModel.contactPersonPhone?.length ??
                                      0),
                        ),
                      )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        /*   final RegExp regExp1 = RegExp(r'^\+\d{2}-\d{10}$');
                        final RegExp regExp2 =
                            RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)'); */

                        if ((value ?? "").isEmpty) {
                          return "Please enter Phone.No";
                        } /* else if (!regExp1.hasMatch(value ?? "") &&
                            !regExp2.hasMatch(value ?? "")) {
                          return 'Please enter valid mobile number';
                        } */
                        return null;
                      },
                      onChanged: (value) {
                        checkoutModel.contactPersonPhone = value;
                        setState(() {});
                      },
                      decoration: textfirlDecor("Contact Person Phone"),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController.fromValue(TextEditingValue(
                        text: checkoutModel.meetingPoints ?? "",
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset: checkoutModel.meetingPoints?.length ?? 0),
                        ),
                      )),
                      maxLines: 3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return "Please enter Meeting points";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        checkoutModel.meetingPoints = value;
                        setState(() {});
                      },
                      decoration: textfirlDecor("Meeting Points"),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController.fromValue(TextEditingValue(
                        text: checkoutModel.customerEmail ?? "",
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset: checkoutModel.customerEmail?.length ?? 0),
                        ),
                      )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return "Please enter Email";
                        }
                        /*  if (!isEmailValid(value ?? "")) {
                          return "Please enter valid Mail";
                        } */
                        return null;
                      },
                      onChanged: (value) {
                        checkoutModel.customerEmail = value;
                        setState(() {});
                      },
                      decoration: textfirlDecor("Customer Email"),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController.fromValue(TextEditingValue(
                        text: checkoutModel.officePhoneNumber ?? "",
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset:
                                  checkoutModel.officePhoneNumber?.length ?? 0),
                        ),
                      )),
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        /*  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(patttern); */
                        if ((value ?? "").isEmpty) {
                          return "Please enter Phone.Number";
                        } /* else if (!regExp.hasMatch(value ?? "")) {
                          return 'Please enter valid Phone number';
                        } */
                        return null;
                      },
                      onChanged: (value) {
                        checkoutModel.officePhoneNumber = value;
                        setState(() {});
                      },
                      decoration: textfirlDecor("Office Phone Number"),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController.fromValue(TextEditingValue(
                        text: checkoutModel.landLineNumber ?? "",
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset:
                                  checkoutModel.landLineNumber?.length ?? 0),
                        ),
                      )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        /*   String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(patttern); */
                        if ((value ?? "").isEmpty) {
                          return "Please enter Landline.No";
                        } /* else if (!regExp.hasMatch(value ?? "")) {
                          return 'Please enter valid Landline number';
                        } */
                        return null;
                      },
                      onChanged: (value) {
                        checkoutModel.landLineNumber = value;
                        setState(() {});
                      },
                      decoration: textfirlDecor("Landline Number"),
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: HexColor("#135a92"),
                          value: checkoutModel.hasNextFolloup,
                          onChanged: (bool? value) {
                            if (value == false) {
                              checkoutModel.nextFollowupDate = null;
                            }
                            setState(() {
                              checkoutModel.hasNextFolloup = value;
                            });
                            print(checkoutModel.hasNextFolloup);
                          },
                        ),
                        const TextWidget("Has Next FollowUp")
                      ],
                    ),
                    if (checkoutModel.hasNextFolloup ?? false)
                      dateField(context),
                  ],
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

                              /*    photo = await picker.pickImage(
                                  source: ImageSource.camera, imageQuality: 50);
                              setState(() {}); */
                            },
                            child: Center(
                              child: loading
                                  ? CircularProgressIndicator(
                                      color: HexColor("#135a92"),
                                    )
                                  : const TextWidget(
                                      "Choose Image",
                                      color: Colors.grey,
                                    ),
                            ),
                          )
                        : Stack(
                            children: [
                              Image.file(
                                File(photo?.path ?? ""),
                                fit: BoxFit.cover,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container dateField(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(vertical: 10.w),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
        ),
        decoration: textfirlDecor("Next Followup date",
            icon: const Icon(Icons.calendar_month)),
        readOnly: true,
        autofocus: false,
        validator: (value) {
          if ((value ?? "").isEmpty &&
              (checkoutModel.hasNextFolloup ?? false)) {
            return "Select date";
          }
          return null;
        },
        focusNode: null,
        controller: TextEditingController(text: checkoutModel.nextFollowupDate),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,

            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: HexColor("#135a92"),
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child ?? const Text(""),
              );
            },
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            print(
                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            print(
                formattedDate); //formatted date output using intl package =>  2021-03-16
            setState(() {
              checkoutModel.nextFollowupDate =
                  formattedDate; //set output date to TextField value.
            });
          } else {}
        },
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
    if (!hasPermission) return;
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

      checkoutModel.outLatitude = position.latitude;
      checkoutModel.outLongitude = position.longitude;

      setState(() {});
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  InputDecoration textfirlDecor(String label, {Widget? icon}) {
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
      ),
      //fillColor: Colors.green
    );
  }

  InputDecoration calendarDecoration() {
    return InputDecoration(
      suffixIcon: Icon(
        Icons.calendar_month,
        color: Colors.grey.shade800,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      fillColor: Colors.red,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.black, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.black, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.black, width: 0.5),
      ),
    );
  }

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    print(emailRegex.hasMatch(email));
    return emailRegex.hasMatch(email);
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
                      "${DateFormat("MMM dd,yyyy hh:mm:ss a").format(DateTime.now())} \n\n $currentAddress ",
                      font: img.arial48,
                      x: 20,
                      y: decodeImg.height ~/ 1.4,
                    );

                    var encodeImage = img.encodeJpg(decodeImg, quality: 50);

                    var finalImage = File(image.path)
                      ..writeAsBytesSync(encodeImage);

                    photo = XFile(finalImage.path);
                    setState(() {});
                    /*  photo = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 50);
                    setState(() {}); */
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

  Future<File> urlToFile(String imageUrl) async {
    // generate random number.
    var rng = Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = File('$tempPath${rng.nextInt(100)}.png');
    // call http.get method and pass imageurl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
    // write bodybytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  productDropdown(BuildContext context, List<product.Item> itemList,
      {bool loading = false, bool error = false}) {
    List items = [];
    for (var element in itemList) {
      items.add(DropdownModel(id: element.id, name: "Section-1"));
    }
    return Column(
      children: [
        IgnorePointer(
          ignoring: loading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: MultiSelectDialogField(
              items: itemList
                  .map((e) => MultiSelectItem(e, e.productName))
                  .toList(),
              initialValue: const [],
              title: const Text("Select Products"),
              selectedColor: Colors.black,
              dialogHeight:
                  (MediaQuery.of(context).size.height * 0.07) * itemList.length,
              selectedItemsTextStyle: const TextStyle(color: Colors.black),
              decoration: BoxDecoration(
                // color: HexColor("#d4ac2c").withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              buttonIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              buttonText: const Text(
                "Select products",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              onSelectionChanged: (p0) {},
              onConfirm: (results) {
                checkoutModel.enquiryProducts = [];
                for (var element in results) {
                  checkoutModel.enquiryProducts?.add({
                    "id": element.id,
                    "enquiryId": element.id,
                    "productId": element.id
                  });
                  print(element.id);
                }

                //_selectedAnimals = results;
              },
            ),
          ),
        ),
        loading
            ? LinearProgressIndicator(
                backgroundColor: HexColor("#135a92"), color: Colors.white)
            : Container()
      ],
    );
  }
}

class DropdownModel {
  final String id;
  final String name;

  DropdownModel({
    required this.id,
    required this.name,
  });
}
