import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class MessageBubble extends StatelessWidget {
  final String messages;
  final String sendertype;
  final String senderName; 
  const MessageBubble({
    super.key,
    required this.messages,
    required this.sendertype,
    required this.senderName, 
  });
  @override
  Widget build(BuildContext context) {
    final isUser = sendertype == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 0.1,
            ),
            child: Text(
              senderName,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isUser ? Colors.deepPurple.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? 3.w : 0.w),
                bottomLeft: Radius.circular(3.w),
                topRight: Radius.circular(3.w),
                bottomRight: Radius.circular(isUser ? 0.w : 3.w),
              ),
              gradient: isUser
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFFE3F2FD), Color(0xFFFFF3E0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
            ),
            child: Text(messages),
          ),
        ],
      ),
    );
  }
}