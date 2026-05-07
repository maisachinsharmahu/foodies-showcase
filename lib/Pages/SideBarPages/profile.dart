import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class foodieProfile extends StatefulWidget {
  final Map<String, dynamic> userData;
  const foodieProfile({super.key, required this.userData});

  @override
  State<foodieProfile> createState() => _foodieProfileState();
}

class _foodieProfileState extends State<foodieProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
                color: FoodieColors.darkSecondary,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r))),
            height: 300.h,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(26.0.w),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.white.withOpacity(0.6),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 130.0.h,
            ),
            child: Card(
              elevation: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Container(
                width: 0.9.sw,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.r)),
                height: 250.h,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 70.0.h,
            ),
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/home/1.png'),
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    height: 100.h,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "${widget.userData['firstName']} ${widget.userData['lastName']}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.sp),
                ),
                Text(
                  "Foodies Member",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.grey.shade600),
                ),
                Text(
                  "Joined Since: ${_getJoinedSinceText(widget.userData['joinDate'])}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getJoinedSinceText(String? joinDateString) {
    if (joinDateString != null) {
      DateTime joinDateTime = DateTime.parse(joinDateString);
      DateTime now = DateTime.now();
      return timeago.format(joinDateTime, locale: 'en_short');
    } else {
      return "Unknown";
    }
  }
}
