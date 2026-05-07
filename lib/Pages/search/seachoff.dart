// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:foodie/Pages/DetailsPage/fully%20funcitonal.dart';
// import 'package:foodie/Pages/Index/index%20copy.dart';
// import 'package:foodie/Pages/ListPage/toast.dart';
// import 'package:foodie/helper/addtofav.dart';
// import 'package:foodie/helper/colors.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:like_button/like_button.dart';

// class searchlist extends StatefulWidget {
//  final List<dynamic> suggestions;
//   const searchlist({super.key, required this.suggestions});

//   @override
//   State<searchlist> createState() => _searchlistState();
// }

// class _searchlistState extends State<searchlist> {
//   @override
//   Widget build(BuildContext context) {
//     bool _isfullmode = false;
//     return Column(
//       children: [
//         widget.suggestions.length == 0
//                   ? Container()
//                   : Row(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: 20.0.w, top: 10.h, bottom: 10.h),
//                           child: Text(
//                             "${widget.suggestions.length} results",
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ),
//                         Spacer(),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             left: 20.0.w,
//                             top: 10.h,
//                           ),
//                           child: IconButton(
//                             icon: Icon(_isfullmode
//                                 ? Icons.view_list
//                                 : Icons
//                                     .view_module), // Change icon based on view mode
//                             onPressed: () {
//                               setState(() {
//                                 _isfullmode = !_isfullmode; // Toggle view mode
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//         Expanded(
//                     child: ListView.builder(
//                       itemCount: widget.suggestions.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final recipe = widget.suggestions[index];
//                         return _isfullmode
//                             ? Padding(
//                                 padding: index == 0
//                                     ? EdgeInsets.only(top: 20.0.h)
//                                     : EdgeInsets.symmetric(vertical: 0.0.h),
//                                 child: Column(
//                                   children: [
//                                     ListTile(
//                                       selectedColor: FoodieColors.darkSecondary,
//                                       title: Container(
//                                         child: Row(
//                                           children: [
//                                             Stack(children: [
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(30.r)),
//                                                 height: 150.h,
//                                                 width: Screen.screenWidth(context) *
//                                                     0.43,
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(30.r),
//                                                   child: CachedNetworkImage(
//                                                     imageUrl:
//                                                         "${widget.suggestions[index]['Image']}",
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 height: 150.h,
//                                                 width: Screen.screenWidth(context) *
//                                                     0.43,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(30.r),
//                                                   gradient: LinearGradient(
//                                                     begin: Alignment.topRight,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [
//                                                       Colors.transparent,
//                                                       Colors.black.withOpacity(
//                                                           0.4), // Adjust opacity as needed
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 bottom: 10.h,
//                                                 right: 10.w,
//                                                 child: CircleAvatar(
//                                                   radius: 18,
//                                                   backgroundColor: Colors.white,
//                                                   child: Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 3.0.w, top: 2.h),
//                                                     child: LikeButton(
//                                                       onTap: (isLiked) {
//                                                         FavoriteFunctions
//                                                             .toggleFavorite(
//                                                                 widget.suggestions[index]
//                                                                     ['id']);
        
//                                                         if (isLiked) {
//                                                           // Recipe is being removed from favorites
//                                                           FavoriteFunctions
//                                                               .toggleFavorite(
//                                                                   widget.suggestions[index]
//                                                                       ['id']);
//                                                           showRecipeRemovedToast(
//                                                               context);
//                                                         } else {
//                                                           // Recipe is being added to favorites
//                                                           FavoriteFunctions
//                                                               .toggleFavorite(
//                                                                   widget.suggestions[
//                                                                       index]['id']);
//                                                           showRecipeSavedToast(
//                                                               context);
//                                                         }
        
//                                                         return Future.value(
//                                                             !isLiked); // Reverse the liked status // Reverse the liked status
//                                                       },
//                                                       isLiked: FavoriteFunctions
//                                                           .favoriteRecipes
//                                                           .contains(
//                                                               widget.suggestions[index]
//                                                                   ['id']),
//                                                       likeBuilder: (bool isLiked) {
//                                                         return Icon(
//                                                           isLiked
//                                                               ? Icons.favorite
//                                                               : Icons
//                                                                   .favorite_border_outlined,
//                                                           color: isLiked
//                                                               ? Colors.red
//                                                               : Colors.black,
//                                                         );
//                                                       },
//                                                       // size: 2,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                             ]),
//                                             SizedBox(
//                                               width: 15.w,
//                                             ),
//                                             Expanded(
//                                               child: Container(
//                                                 height: 150.h,
//                                                 child: Padding(
//                                                   padding:
//                                                       EdgeInsets.symmetric(
//                                                           vertical: 8.0.h),
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text(
//                                                         "${widget.suggestions[index]['Name']}",
//                                                         maxLines: 2,
//                                                         style: TextStyle(
//                                                             overflow: TextOverflow
//                                                                 .ellipsis,
//                                                             fontWeight:
//                                                                 FontWeight.w500),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 5.h,
//                                                       ),
//                                                       Text(
//                                                         "${widget.suggestions[index]['Dish Overview'][0]}",
//                                                         maxLines: 3,
//                                                         style: TextStyle(
//                                                           fontSize: 13.sp,
//                                                           overflow:
//                                                               TextOverflow.ellipsis,
//                                                         ),
//                                                       ),
//                                                       Spacer(),
//                                                       Divider(
//                                                         color: Colors.grey[300],
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           Icon(
//                                                             Iconsax.clock,
//                                                             color: FoodieColors
//                                                                 .darkSecondary,
//                                                             size: 20.sp,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 5.w,
//                                                           ),
//                                                           Text(
//                                                             widget.suggestions[index][
//                                                                             'Total Time']
//                                                                         .length <
//                                                                     20
//                                                                 ? "${widget.suggestions[index]['Total Time']}"
//                                                                 : "${widget.suggestions[index]['Total Time']}"
//                                                                     .substring(
//                                                                         0, 20),
//                                                             style: TextStyle(
//                                                                 fontSize: 13.sp),
//                                                           )
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => RecipeDetails(
//                                               recipe: recipe,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : ListTile(
//                                 title: Text(recipe['Name']),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => RecipeDetails(
//                                         recipe: recipe,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                       },
//                     ),
//                   ),
//       ],
//     );
//   }
// }