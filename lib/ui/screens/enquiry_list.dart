import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:swastik_mobile/bloc/customer/customer_bloc.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/logout.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

import '../../main.dart';

class EnquiryList extends StatefulWidget {
  const EnquiryList({super.key});

  @override
  State<EnquiryList> createState() => _EnquiryListState();
}

class _EnquiryListState extends State<EnquiryList> {
  TextEditingController fromdate = TextEditingController();

  TextEditingController todate = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CustomerBloc customerBloc = CustomerBloc();
  @override
  void initState() {
    EasyLoading.dismiss();
    customerBloc = BlocProvider.of(context);
    fromdate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    todate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (selectedIndex == 1) {
      customerBloc.add(FetchEnquiry(fromdate.text, todate.text));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          "Enquiry",
          color: Colors.white,
          fontweight: FontWeight.bold,
          size: 22.sp,
        ),
        backgroundColor: HexColor("#135a92"),
        centerTitle: true,
        actions: const [LogoutWidget()],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 5.w,
            ),
            dateFields(context),
            BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is EnquiryDone) {
                  return state.enquiry.item.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: state.enquiry.item.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    navigatorKey.currentState!
                                        .pushNamed("/checkout",
                                            arguments:
                                                state.enquiry.item[index])
                                        .then((value) {
                                      fromdate.text = DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now());
                                      todate.text = DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now());

                                      customerBloc.add(FetchEnquiry(
                                          fromdate.text, todate.text));
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.w),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.w),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(15.w)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          state.enquiry.item[index].customer
                                              .companyName,
                                          fontweight: FontWeight.bold,
                                          size: 22.sp,
                                        ),
                                        SizedBox(
                                          height: 10.w,
                                        ),
                                        TextWidget(state.enquiry.item[index]
                                            .customer.address)
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 100.w),
                          child: const Center(
                            child: TextWidget("No enquiries"),
                          ),
                        );
                }
                if (state is CustomerLoad || state is CustomerInitial) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 150.w),
                    child: const CircularProgressIndicator(),
                  );
                }
                if (state is CustomerError) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 150.w),
                    child: Center(child: TextWidget(state.message ?? "Error")),
                  );
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 150.w),
                  child: const Center(child: TextWidget("No Data")),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Row dateFields(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
            ),
            decoration: calendarDecoration(),
            readOnly: true,
            autofocus: false,
            validator: (value) {
              if ((value ?? "").isEmpty) {
                return "Select date";
              }
              return null;
            },
            focusNode: null,
            controller: fromdate,
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
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(
                    formattedDate); //formatted date output using intl package =>  2021-03-16
                setState(() {
                  fromdate.text =
                      formattedDate; //set output date to TextField value.
                });
              } else {}
            },
          ),
        ),
        Icon(
          Icons.arrow_forward,
          color: Colors.grey.shade800,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
            ),
            validator: (value) {
              if ((value ?? "").isEmpty) {
                return "Select date";
              }
              return null;
            },
            decoration: calendarDecoration(),
            controller: todate,
            readOnly: true,
            autofocus: false,
            focusNode: null,
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
                  firstDate: DateTime.now(),
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2100));

              if (pickedDate != null) {
                print(
                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(
                    formattedDate); //formatted date output using intl package =>  2021-03-16
                setState(() {
                  todate.text =
                      formattedDate; //set output date to TextField value.
                });
              } else {}
            },
          ),
        ),
        InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              customerBloc.add(FetchEnquiry(fromdate.text, todate.text));
            }
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(25.w)),
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              Icons.check,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
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
}
