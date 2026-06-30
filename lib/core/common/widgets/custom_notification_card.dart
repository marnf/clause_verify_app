
import 'package:flutter/material.dart';
import 'package:clause_verify/core/common/widgets/custom_text.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';

class CustomNotificationCard extends StatelessWidget {
  final dynamic notification; // notification model
  final bool showCheckbox;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;

  const CustomNotificationCard({
    super.key,
    required this.notification,
    required this.showCheckbox,
    this.onTap,
    this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:  EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        padding:  EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.isSelected
              ? Colors.blue.withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading: Checkbox or Avatar
            showCheckbox
                ? Checkbox(
                    value: notification.isSelected,
                    onChanged: onCheckboxChanged,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(notification.senderImage),
                    radius: 20,
                  ),
             SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: notification.senderName,
                    fontWeight: FontWeight.bold,
                  ),
                   SizedBox(height: 4.h),
                  CustomText(
                    text: notification.title,
                    color: Colors.grey[700]!,
                  ),
                ],
              ),
            ),

            // Trailing: Time + unread dot
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  notification.time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                 // SizedBox(height: 4.h),
                // if (!notification.isRead)
                //   Container(
                //     width: 10.w,
                //     height: 10.h,
                //     decoration: const BoxDecoration(
                //       color: Colors.blue,
                //       shape: BoxShape.circle,
                //     ),
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
