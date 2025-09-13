import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appColors.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/raiseticket_bloc/raiseticket_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/raiseticket_bloc/raiseticket_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/model/raiseTicketModel.dart'
    hide Message;
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/model/ticketModel.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/views/messageinputcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'MessageBubble.dart';

class SupportChatScreen extends StatefulWidget {
  final Datum? ticketitem;
  final bool istileRequired;
  const SupportChatScreen({
    super.key,
    this.ticketitem,
    this.istileRequired = false,
  });

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  List<Message> _mymessages = [];

  @override
  void initState() {
    super.initState();

    _mymessages = widget.ticketitem?.messages ?? [];
  }

  void _sendMessage() {
    context.read<RaiseTicketsBloc>().add(
      RaiseTicketEvent(
        title: _titleController.text.trim(),
        subTitle: _subtitleController.text.trim(),
        isfirsttimechat: false,
        ticketid: widget.ticketitem?.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: BlocListener<RaiseTicketsBloc, ApiState<RaiseTicketModel>>(
            listener: (context, state) {
              if (state is ApiSuccess) {
                widget.ticketitem?.is_reply = 0;
                _mymessages.add(
                  Message(
                    senderType: "user",
                    message: _subtitleController.text.trim(),
                  ),
                );
                setState(() {});
              }
              if (state is ApiFailure) {
                global.showToastMessage(message: state.error!);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.ticketitem?.id != null
                    ? Text(
                        'Ticket Id ${widget.ticketitem?.id}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const SizedBox.shrink(),
                widget.ticketitem?.status != null
                    ? Text(
                        "Status: ${widget.ticketitem?.status}",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : Text(
                        'Create Ticket',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: AppColors.whiteColor,
                        ),
                      ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _mymessages.length,
                itemBuilder: (context, index) {
                  final senderName = _mymessages[index].senderType == "user"
                      ? "You"
                      : "Admin";

                  return MessageBubble(
                    messages: "${_mymessages[index].message}",
                    sendertype: "${_mymessages[index].senderType}",
                    senderName: senderName,
                  );
                },
              ),
            ),

            widget.ticketitem?.is_reply == 0
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.w),
                      color: Colors.grey.shade300,
                    ),
                    height: 10.h,
                    child: Center(child: Text("Wait for admin reply")),
                  )
                : MessageInput(
                    subTitleController: _subtitleController,
                    titleController: _titleController,
                    onSend: _sendMessage,
                    canSend: true,
                    istitleRequired: widget.istileRequired,
                  ),
          ],
        ),
      ),
    );
  }
}
