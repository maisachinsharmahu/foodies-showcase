import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/helper/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartGroceryList extends StatefulWidget {
  const SmartGroceryList({super.key});

  @override
  State<SmartGroceryList> createState() => _SmartGroceryListState();
}

class _SmartGroceryListState extends State<SmartGroceryList> {
  Map<String, bool> groceryItems = {};

  @override
  void initState() {
    super.initState();
    _loadGroceries();
  }

  Future<void> _loadGroceries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString('grocery_list');
    if (itemsJson != null) {
      if (mounted) {
        setState(() {
          groceryItems = Map<String, bool>.from(json.decode(itemsJson));
        });
      }
    }
  }

  Future<void> _saveGroceries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('grocery_list', json.encode(groceryItems));
  }

  void toggleItem(String key) {
    setState(() {
      groceryItems[key] = !(groceryItems[key] ?? false);
    });
    _saveGroceries();
  }

  void _clearChecked() {
    setState(() {
      groceryItems.removeWhere((key, value) => value == true);
    });
    _saveGroceries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Smart Grocery", style: TextStyle(fontSize: 24.sp)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.cleaning_services_rounded, color: Colors.redAccent),
            onPressed: () => _clearChecked(),
            tooltip: "Clear Checked Items",
          )
        ],
      ),
      body: groceryItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80.sp, color: Colors.grey.shade300),
                  SizedBox(height: 20.h),
                  Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey.shade500),
                  )
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: groceryItems.keys.length,
              itemBuilder: (context, index) {
                String key = groceryItems.keys.elementAt(index);
                bool isChecked = groceryItems[key] ?? false;

                return GestureDetector(
                  onTap: () => toggleItem(key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: isChecked ? Colors.grey.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: FoodieColors.extra, width: 1.5),
                      boxShadow: [
                        if (!isChecked)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                      leading: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (val) => toggleItem(key),
                          activeColor: FoodieColors.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                        ),
                      ),
                      title: Text(
                        key,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                          color: isChecked ? Colors.grey.shade400 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Add this static helper globally to let any page add ingredients:
class GroceryHelper {
  static Future<void> addAllToCart(List<String> ingredients) async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString('grocery_list');
    Map<String, bool> groceryItems = {};
    if (itemsJson != null) {
      groceryItems = Map<String, bool>.from(json.decode(itemsJson));
    }
    
    for (String item in ingredients) {
      if (!groceryItems.containsKey(item)) {
         groceryItems[item] = false;
      }
    }
    
    await prefs.setString('grocery_list', json.encode(groceryItems));
  }
}
