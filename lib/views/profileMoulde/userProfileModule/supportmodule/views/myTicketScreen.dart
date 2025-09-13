import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appColors.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/tickets_bloc/ticket_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/tickets_bloc/ticket_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/model/ticketModel.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/views/SupportChatScreen.dart';
import 'package:esimtel/widgets/customBottomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class MyTicketsScrren extends StatefulWidget {
  const MyTicketsScrren({super.key});

  @override
  State<MyTicketsScrren> createState() => _MyTicketsScrrenState();
}

class _MyTicketsScrrenState extends State<MyTicketsScrren> {
  List<Datum>? _listdata = [];
  bool isAnyTicketOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TicketsBloc>().add(TicketEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          context.read<TicketsBloc>().add(TicketEvent());
        });
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("My Tickets")),
          body: BlocConsumer<TicketsBloc, ApiState<TicketsModel>>(
            listener: (context, state) {
              if (state is ApiSuccess) {
                _listdata = state.data?.data?.data?.reversed.toList();
                isAnyTicketOpened = _listdata!.any(
                  (item) => item.status?.toLowerCase().trim() == "open",
                );
                setState(() {});
              }
            },
            builder: (context, state) {
              if (state is ApiLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ApiFailure) {
                return SizedBox.shrink();
              }

              if (_listdata!.isEmpty) {
                return Center(child: Text("You Don't have any Tickets yet!"));
              }

              return ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: _listdata!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => SupportChatScreen(
                          ticketitem: _listdata![index],
                          istileRequired: false,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _listdata![index].status == "open"
                              ? AppColors.darkgreen.withOpacity(0.5)
                              : AppColors.redColor.withOpacity(0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _listdata![index].subject!,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Status: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                            color: AppColors.primaryColor,
                                          ),
                                    ),
                                    TextSpan(
                                      text: _listdata![index].status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                            color:
                                                _listdata![index].status ==
                                                    "open"
                                                ? AppColors.darkgreen
                                                : AppColors.redColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Ticket ID: ${_listdata![index].id}",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  color: AppColors.textColor,
                                ),
                          ),

                          SizedBox(height: 4),
                          Text(
                            "Raised On: ${DateFormat('MMM dd, yyyy HH:mm a').format(DateTime.parse(_listdata![index].createdAt.toString()))}",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  color: AppColors.textColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          bottomSheet: Container(
            padding: EdgeInsets.only(bottom: 10, left: 3.w, right: 3.w),
            child: CustomBottomButton(
              title: "Raise a Ticket",
              onTap: isAnyTicketOpened
                  ? () {
                      global.showToastMessage(
                        message: "You have already an open ticket",
                      );
                    }
                  : () {
                      Get.to(() => SupportChatScreen(istileRequired: true));
                    },
            ),
          ),
        ),
      ),
    );
  }
}
