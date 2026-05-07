import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';

class loadtopSection extends StatefulWidget {
  final String? Name;
  const loadtopSection({super.key, required this.Name});

  @override
  State<loadtopSection> createState() => _loadtopSectionState();
}

class _loadtopSectionState extends State<loadtopSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.r), bottomRight: Radius.circular(40.r)),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/bg3.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      height: 200.h,
      width: 1.sw,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CircleAvatar(
                    radius: 24.r,
                    backgroundImage: const AssetImage(
                      'assets/images/home/1.png',
                    ),
                    backgroundColor: FoodieColors.darkSecondary,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                        children: const [
                          TextSpan(
                            text: "Hello ",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "What do you want to cook today?",
                      style: TextStyle(color: FoodieColors.grey3, fontSize: 12.sp),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.segment,
                  size: 30.sp,
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Search Food and Recipies",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.h),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: FoodieColors.darkSecondary,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Icon(
                    Icons.search,
                    size: 26.sp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// IconButton(
//                     onPressed: () {
//                       FirebaseServices.signOut();
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => LoginPage()));
//                     },
//                     icon: Icon(Icons.abc_outlined))