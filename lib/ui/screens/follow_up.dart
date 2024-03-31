import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swastik_mobile/main.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/logout.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

import '../../bloc/customer/customer_bloc.dart';

class FollowupScreen extends StatefulWidget {
  const FollowupScreen({super.key});

  @override
  State<FollowupScreen> createState() => _FollowupScreenState();
}

class _FollowupScreenState extends State<FollowupScreen> {
  CustomerBloc customerBloc = CustomerBloc();
  @override
  void initState() {
    customerBloc = BlocProvider.of(context);
    if (selectedIndex == 3) {
      print("followupsssss");
      customerBloc.add(FetchFollowup());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#135a92"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: TextWidget(
          "Followup",
          color: Colors.white,
          fontweight: FontWeight.bold,
          size: 22.sp,
        ),
        actions: const [LogoutWidget()],
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        buildWhen: (previous, current) {
          return current is CustomerLoad ||
              current is CustomerError ||
              current is FollowupDone;
        },
        builder: (context, state) {
          print("state$state");
          if (state is FollowupDone) {
            return state.followups.item.isNotEmpty
                ? ListView.builder(
                    itemCount: state.followups.item.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.w),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.w)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              state.followups.item[index].customerName,
                              fontweight: FontWeight.bold,
                            ),
                            /*  SizedBox(
                              height: 5.w,
                            ),
                            TextWidget(state.followups.item[index].officePhone), */
                            SizedBox(
                              height: 5.w,
                            ),
                            Row(
                              children: [
                                const TextWidget("NextFollowup Date : "),
                                TextWidget(
                                  state.followups.item[index].date
                                      .replaceAll("T00:00:00", ""),
                                  fontweight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: TextWidget("No Followups"));
          }
          if (state is CustomerLoad || state is CustomerInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          return const TextWidget("error");
        },
      ),
    );
  }
}
