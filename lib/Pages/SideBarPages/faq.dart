import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';

class FAQ extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  const FAQ({super.key, required this.recipes, required this.userData});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodieColors.darkSecondary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(26.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text(
                          "FAQ's",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/bg.png'),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(26.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Getting Started",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FAQItem(
                            question: "Why do I need to create an account?",
                            answer:
                                "Creating an account enables personalized experiences like saving recipes, syncing devices, and receiving tailored suggestions. Simply log in with Google to get started.",
                            isExpanded: expandedIndex == 0,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 0)
                                    ? null
                                    : 0;
                              });
                            },
                          ),

                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Recipes",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FAQItem(
                            question: "How many recipes does Foodie offer?",
                            answer:
                                "Foodie boasts a massive library of over 15,000 recipes, ensuring you'll find inspiration for every meal and dietary preference.",
                            isExpanded: expandedIndex == 3,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 3)
                                    ? null
                                    : 3;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question: "How do I search for recipes?",
                            answer:
                                "Use the app's search function to find recipes by ingredient, cuisine, or dish name.",
                            isExpanded: expandedIndex == 1,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 1)
                                    ? null
                                    : 1;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question: "Can I use Foodie offline?",
                            answer:
                                "Absolutely! Foodie lets you access your saved recipes with instructions even without internet, though images may not be available offline.",
                            isExpanded: expandedIndex == 2,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 2)
                                    ? null
                                    : 2;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question:
                                "Are the recipes on Foodie suitable for beginners?",
                            answer:
                                "Foodie has recipes for all skill levels, but check the description and ingredients list to see if it's a good fit for you before you start cooking.",
                            isExpanded: expandedIndex == 4,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 4)
                                    ? null
                                    : 4;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question: "Can I browse recipes by category?",
                            answer:
                                "Yes, you can browse recipes by category by navigating to the category section located in the bottom bar of the app.",
                            isExpanded: expandedIndex == 5,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 5)
                                    ? null
                                    : 5;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Features",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FAQItem(
                            question:
                                "Can Foodie guide me through recipes step-by-step?",
                            answer:
                                "Foodie offers a helpful feature that speaks recipe instructions step-by-step, allowing you to follow along hands-free. This is perfect for multitasking in the kitchen!",
                            isExpanded: expandedIndex == 6,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 6)
                                    ? null
                                    : 6;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question:
                                "Can I search for recipes using voice commands?",
                            answer:
                                "Foodie makes recipe exploration a breeze with voice search functionality. Simply speak the name of an ingredient or dish you're craving, and Foodie will present relevant recipe options.",
                            isExpanded: expandedIndex == 7,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 7)
                                    ? null
                                    : 7;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Saving and Sharing",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FAQItem(
                            question:
                                "Can I save my favorite recipes for later?",
                            answer:
                                "Yes, you can easily save your favorite recipes to revisit later. This feature allows you to create a personalized collection of recipes that you can access anytime.",
                            isExpanded: expandedIndex == 8,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 8)
                                    ? null
                                    : 8;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question: "Can I share recipes with friends?",
                            answer:
                                "Foodie lets you share recipes with loved ones! Export them as PDFs to easily send through email, messaging, or social media.",
                            isExpanded: expandedIndex == 9,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 9)
                                    ? null
                                    : 9;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question: "Can I export recipes to print them?",
                            answer:
                                "Yes, you can export recipes as PDF files, enabling you to print them out for reference while cooking or to share them in a physical format.",
                            isExpanded: expandedIndex == 10,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 10)
                                    ? null
                                    : 10;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Troubleshooting",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FAQItem(
                            question:
                                "I'm having trouble logging in. What should I do?",
                            answer:
                                "If you're experiencing trouble logging in, try clearing the app's data and retrying the login process using your Google account. If the issue persists, please fill the feedback form.",
                            isExpanded: expandedIndex == 11,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 11)
                                    ? null
                                    : 11;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          FAQItem(
                            question:
                                "I'm experiencing bugs or crashes in the app. How can I report them?",
                            answer:
                                "Foodie aims to provide a smooth user experience. If you encounter any bugs or crashes, you can report them directly within the app through the 'Feedback' section. This will help the developer identify and fix the issues for a better user experience.",
                            isExpanded: expandedIndex == 12,
                            onTap: () {
                              setState(() {
                                expandedIndex = (expandedIndex == 12)
                                    ? null
                                    : 12;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const FAQItem({super.key, 
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: const Color.fromRGBO(240, 240, 242, 1),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 120),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            color: Colors.grey.shade800),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.remove : Icons.add,
                      color: const Color.fromRGBO(101, 101, 105, 1),
                    ),
                  ],
                ),
                if (isExpanded) SizedBox(height: 10.h),
                if (isExpanded)
                  Text(
                    answer,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
