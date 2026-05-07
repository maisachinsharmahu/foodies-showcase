import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class items extends StatefulWidget {
  const items({super.key});

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  final List<ItemData> itemsFood = [
    ItemData(
      color: Colors.white,
      image: 'assets/images/home/items/paneer.png',
      name: 'Paneer',
    ),
    ItemData(
      color: Colors.white,
      image: 'assets/images/home/items/bro.png',
      name: 'Vegetables',
    ),
    ItemData(
      color: Colors.white,
      image: 'assets/images/home/items/chiken.png',
      name: 'Chicken',
    ),
    ItemData(
      color: Colors.white,
      image: 'assets/images/home/items/dood.png',
      name: 'Milk',
    ),
    ItemData(
      color: Colors.white,
      image: 'assets/images/home/items/burger.png',
      name: 'Burger',
    ),
    ItemData(
      color: Colors.white,
      image: 'assets/images/home/items/eggs.png',
      name: 'Egg',
    ),

    // ItemData(color: Colors.green, image: 'assets/image2.jpg', name: 'Item 2'),
    // Add more items as needed
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return index != 5
              ? Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(
                                  0.3), // You can adjust the color and opacity here
                              spreadRadius:
                                  0.5, // You can adjust the spread radius
                              blurRadius: 5, // You can adjust the blur radius
                              offset: Offset(0, 3), // You can adjust the offset
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0.w),
                          child: Image.asset(
                            itemsFood[index].image,
                            height: 80.h,
                            width: 80.w,
                            // fit: BoxFit.co,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        itemsFood[index].name,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Column(
                    children: [
                      Container(
                        height: 90.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(
                                  0.3), // You can adjust the color and opacity here
                              spreadRadius:
                                  0.5, // You can adjust the spread radius
                              blurRadius: 5, // You can adjust the blur radius
                              offset: Offset(0, 3), // You can adjust the offset
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(4.0.w),
                            child: Icon(Icons.east)),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class ItemData {
  final Color color;
  final String image;
  final String name;

  ItemData({
    required this.color,
    required this.image,
    required this.name,
  });
}
