import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swastik_mobile/bloc/expense/expense_bloc.dart';
import 'package:swastik_mobile/main.dart';
import 'package:swastik_mobile/model/addexpense_request.dart';
import 'package:swastik_mobile/model/expensehead_model.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/button.dart';
import 'package:swastik_mobile/ui/widgets/dropdown.dart';
import 'package:swastik_mobile/ui/widgets/logout.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  ExpenseBloc expenseBloc = ExpenseBloc();
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  AddExpenseModel addExpenseModel = AddExpenseModel();
  bool edit = false;
  String imageUrl = "";

  @override
  void initState() {
    expenseBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is AddExpenseDone || event is DeleteExpenseDone) {
          EasyLoading.showSuccess('Success!');
          addExpenseModel = AddExpenseModel();
          photo = null;
          setState(() {});

          expenseBloc.add(FetchExpenses());
        }
        if (event is AddExpenseLoad || event is DeleteExpenseLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is AddExpenseError) {
          EasyLoading.showError(event.message);
        }

        if (event is DeleteExpenseError) {
          EasyLoading.showError(event.message);
        }
      });

    if (selectedIndex == 2) {
      expenseBloc.add(FetchExpensehead());
      expenseBloc.add(FetchExpenses());
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#135a92"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: TextWidget(
          "Expense",
          color: Colors.white,
          fontweight: FontWeight.bold,
          size: 22.sp,
        ),
        actions: const [LogoutWidget()],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
            child: createExpense(context),
          ),
        ),
      ),
    );
  }

  Column createExpense(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              "Add Expense",
              fontweight: FontWeight.bold,
              size: 20.sp,
            ),
          ],
        ),
        SizedBox(
          height: 20.w,
        ),
        BlocBuilder<ExpenseBloc, ExpenseState>(
          buildWhen: (previous, current) {
            return current is ExpenseheadDone ||
                current is ExpenseheadError ||
                current is ExpenseheadLoad;
          },
          builder: (context, state) {
            print(state);
            return expenseDropdown(
                context, state is ExpenseheadDone ? state.heads.item : [],
                loading: state is ExpenseheadLoad,
                error: state is ExpenseheadError);
          },
        ),
        SizedBox(
          height: 15.w,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: TextEditingController.fromValue(TextEditingValue(
            text: addExpenseModel.amount ?? "",
            selection: TextSelection.fromPosition(
              TextPosition(offset: addExpenseModel.amount?.length ?? 0),
            ),
          )),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return "Please enter Amount";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            addExpenseModel.amount = value;
            setState(() {});
          },
          decoration: textfirlDecor("Enter the Amount"),
        ),
        SizedBox(
          height: 15.w,
        ),
        SizedBox(
          height: 180.w,
          width: 180.w,
          child: DottedBorder(
            color: Colors.black,
            strokeWidth: 1,
            child: photo == null
                ? GestureDetector(
                    onTap: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: ((builder) => _bottomSheetProfile()));
                    },
                    child: const Center(
                      child: TextWidget(
                        "Choose Image",
                        color: Colors.grey,
                        textalign: TextAlign.center,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Image.file(
                        File(photo?.path ?? ""),
                        fit: BoxFit.cover,
                        height: 180.w,
                        width: 180.w,
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
        SizedBox(
          height: 20.w,
        ),
        button("   Save     ", () {
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
                          if (edit) {
                            addExpenseModel = AddExpenseModel();
                            photo = null;
                            edit = false;
                            setState(() {});
                          }
                        },
                        Colors.grey,
                      ),
                      button("Save", () async {
                        Navigator.pop(navigatorKey.currentContext!);
                        expenseBloc.add(AddExpenseEvent(
                            addExpenseModel, File(photo?.path ?? "")));
                      }, HexColor("#135a92"))
                    ],
                  );
                },
              );
            }
          }
        }, HexColor("#135a92"), size: 20.sp),
        SizedBox(
          height: 20.w,
        ),
        SizedBox(
          height: 20.w,
        ),
        BlocBuilder<ExpenseBloc, ExpenseState>(
          buildWhen: (previous, current) {
            return current is FetchExpensesLoad ||
                current is FetchExpensesError ||
                current is FetchExpensesDone ||
                current is ExpenseInitial;
          },
          builder: (context, state) {
            if (state is FetchExpensesDone) {
              return DataTable(
                columnSpacing: 25.w,
                columns: [
                  DataColumn(
                      label: Text('Date',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Expense Head',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Amount',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Delete',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold))),
                ],
                rows: <DataRow>[
                  for (int i = 0; i < (state.expenses.item.length); i++)
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          TextWidget(
                            state.expenses.item[i].createdOn,
                            size: 18.sp,
                          ),
                        ),
                        DataCell(TextWidget(
                          state.expenses.item[i].expenseHead.expenseHead,
                          size: 18.sp,
                        )),
                        DataCell(TextWidget(
                          state.expenses.item[i].amount.toString(),
                          size: 18.sp,
                        )),
                        DataCell(GestureDetector(
                          onTap: () async {
                            if (state.expenses.item[i].isVerified == false) {
                              photo = null;
                              addExpenseModel = AddExpenseModel(
                                  amount:
                                      state.expenses.item[i].amount.toString(),
                                  expenseheadId: state
                                      .expenses.item[i].expenseHead.id
                                      .toString(),
                                  id: state.expenses.item[i].id);

                              edit = true;
                              setState(() {});

                              File f = await urlToFile(
                                  state.expenses.item[i].imageUrl);

                              photo = XFile(f.path);
                              setState(() {});
                            }

                            /*  if (!state.expenses.item[i].isVerified) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextWidget(
                                          "Delete",
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
                                        TextWidget(
                                            "Are you sure you want to delete?"),
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
                                      button("Delete", () async {
                                        Navigator.pop(
                                            navigatorKey.currentContext!);
                                        expenseBloc.add(DeleteExpenses(
                                            state.expenses.item[i].id));
                                      }, HexColor("#135a92"))
                                    ],
                                  );
                                },
                              );
                            } */
                          },
                          child: Icon(
                            Icons.edit,
                            size: 25.sp,
                            color: state.expenses.item[i].isVerified
                                ? Colors.grey
                                : Colors.red.shade900,
                          ),
                        ))
                      ],
                    ),
                ],
              );
            }
            if (state is FetchExpensesLoad) {
              return const CircularProgressIndicator();
            }
            if (state is FetchExpensesError) TextWidget(state.message);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 60.w),
              child: const TextWidget("No data"),
            );
          },
        ),
      ],
    );
  }

  Container expenseDropdown(BuildContext context, List<Item> itemList,
      {bool loading = false, bool error = false}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: Colors.grey)),
        child: CustomDropdownButton(
          underline: const Divider(
            color: Colors.transparent,
          ),
          hint: const TextWidget(
            "-- Select Expense Head --",
            color: Colors.grey,
          ),
          value: (addExpenseModel.expenseheadId != null && itemList.isNotEmpty)
              ? itemList
                  .where(
                      (element) => element.id == addExpenseModel.expenseheadId)
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
            addExpenseModel.expenseheadId = value.id;
            // print(value.id);

            setState(() {});
          },
          items: itemList.toList().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.expenseHead,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400, color: Colors.black),
              ),
            );
          }).toList(),
        ));
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
}
