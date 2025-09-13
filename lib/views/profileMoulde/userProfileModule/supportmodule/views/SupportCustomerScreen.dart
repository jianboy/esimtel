import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/faq_bloc/faq_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/faq_bloc/faq_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/model/FaqModel.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/views/myTicketScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'SupportCard.dart';

class SupportCustomerScreen extends StatefulWidget {
  const SupportCustomerScreen({super.key});

  @override
  State<SupportCustomerScreen> createState() => _SupportCustomerScreenState();
}

class _SupportCustomerScreenState extends State<SupportCustomerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FAQBloc>().add(FaqEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Frequently Asked Questions',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              BlocBuilder<FAQBloc, ApiState<FaqModel>>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ApiSuccess) {
                    final faqList = state.data?.data ?? [];
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: faqList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(1),
                          margin: EdgeInsets.only(bottom: 2.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0,
                              ),
                              title: Text(
                                "${faqList[index].question}",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    "${faqList[index].answer}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ApiFailure) {
                  } else {
                    return SizedBox.shrink();
                  }
                  return SizedBox.shrink();
                },
              ),
              SizedBox(height: 20),
              SupportCard(
                onContactSupport: () {
                  Get.to(() => MyTicketsScrren());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
