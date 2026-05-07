// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:foodie/Pages/MainStart/start.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_button/sign_in_button.dart';
// import '../Google services/firebase_services.dart';

// class LognPage extends StatelessWidget {
//   const LognPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Google SignIn"),
//       ),
//       body: StreamBuilder<User?>(
//         stream: FirebaseServices.authInstance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//           if (snapshot.hasData) {
//             return Start();
//           } else {
//             return _googleSignInButton();
//           }
//         },
//       ),
//     );
//   } 

//   Widget _googleSignInButton() {
//     return Center(
//       child: SizedBox(
//         height: 50.h,
//         child: SignInButton(
//           Buttons.google,
//           text: "Sign in with Google",
//           onPressed: () async {
//             await FirebaseServices.signInWithGoogle();
//           },
//         ),
//       ),
//     );
//   }

//   Widget userInfo() {
//     return Center(
//       child: MaterialButton(
//         onPressed: () async {
//           await FirebaseServices.signOut();
//         },
//         color: Colors.amber,
//       ),
//     );
//   }
// }

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//       future: FirebaseServices.getUserData(
//           FirebaseServices.authInstance.currentUser!.uid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (snapshot.hasData) {
//           var userData = snapshot.data!.data();
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Name: ${userData?['displayName']}"),
//               Text("Email: ${userData?['email']}"),
//               MaterialButton(
//                 onPressed: () async {
//                   await FirebaseServices.signOut();
//                 },
//                 color: Colors.amber,
//               ),
//               // Add more user data fields as needed
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Text("Error: ${snapshot.error}");
//         } else {
//           return Text("No data available");
//         }
//       },
//     );
//   }
// }
