
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/constant_colors.dart';
import '../const/contant_style.dart';

class MedicineCard extends StatelessWidget {
  final String medicineName;
  final String doctorName;
  final String durationTime;
  final String time;
  final String remainingDose;
  final String memberName;
  final String image;
 final VoidCallback editOnTap;
 final VoidCallback deleteOnTap;

  const MedicineCard({
    super.key,
    required this.medicineName,
    required this.doctorName,
    required this.durationTime,
    required this.time,
    required this.remainingDose,
    required this.memberName,
    required this.image,
    required this.editOnTap,
    required this.deleteOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: kPriemryColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Colors.cyan,
            backgroundImage: NetworkImage(image),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medicine',
                  style: kHeading1.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                      color: kWhit

                  ),
                ),Text(
                  medicineName,
                  style: kHeading1.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Doctor',
                  style: kSmallTitle1.copyWith(fontWeight: FontWeight.bold,
                      color: kWhit
                  ),
                ),Text(
                  doctorName,
                  style: kSmallTitle1.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Duration",
                  style: kSmallTitle1.copyWith(
                    color: kWhit
                  ),
                ),Text(
                  "$durationTime days",
                  style: kSmallTitle1,
                ),
                Row(
                  children: [
                    Icon(Icons.timelapse, size: 16.w),
                    SizedBox(width: 4.w),
                    Text(time, style: kSmallTitle1),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: editOnTap,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: deleteOnTap,
                    ),
                  ],
                ),
              ),
              Text(
                'Remaining Dose',
                style: kSmallTitle1.copyWith(
                  color: kWhit
                ),
              ),
              Text(
                remainingDose,
                style: kSmallTitle1,
              ),
              Text(
                'Member Name',
                style: kSmallTitle1.copyWith(
                    color: kWhit
                ),
              ),
              Text(
                memberName,
                style: kSmallTitle1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}