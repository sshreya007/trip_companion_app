// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:trip_planner/features/auth/presentation/state/auth_state.dart';
// import 'package:trip_planner/features/auth/presentation/view_model/auth_view_model.dart';
// import 'package:trip_planner/screens/login.dart';

// class SignupPage extends ConsumerStatefulWidget {
//   const SignupPage({super.key});

//   @override
//   ConsumerState<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends ConsumerState<SignupPage> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authViewModelProvider);

//     /// ✅ LISTEN INSIDE BUILD (Riverpod 3 correct)
//     ref.listen<AuthState>(authViewModelProvider, (previous, next) {
//       // 🔴 Error
//       if (next.status == AuthStatus.error && next.errorMessage != null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
//         ref.read(authViewModelProvider.notifier).clearError();
//       }

//       // 🟢 Registration success
//       if (next.status == AuthStatus.registered) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration successful')),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginPage()),
//         );
//       }
//     });

//     return Scaffold(
//       body: Stack(
//         children: [
//           /// Background Image
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/image 1.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 120),
//                   const Text(
//                     "Create\nAccount",
//                     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 60),

//                   /// Card
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.85),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Sign Up",
//                           style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         _inputField(
//                           controller: firstNameController,
//                           hint: "First Name",
//                           icon: Icons.person,
//                         ),
//                         const SizedBox(height: 12),

//                         _inputField(
//                           controller: lastNameController,
//                           hint: "Last Name",
//                           icon: Icons.person_outline,
//                         ),
//                         const SizedBox(height: 12),

//                         _inputField(
//                           controller: usernameController,
//                           hint: "Username",
//                           icon: Icons.account_circle,
//                         ),
//                         const SizedBox(height: 12),

//                         _inputField(
//                           controller: emailController,
//                           hint: "Email",
//                           icon: Icons.email,
//                         ),
//                         const SizedBox(height: 12),

//                         _inputField(
//                           controller: passwordController,
//                           hint: "Password",
//                           icon: Icons.lock,
//                           obscure: true,
//                         ),
//                         const SizedBox(height: 12),

//                         _inputField(
//                           controller: confirmPasswordController,
//                           hint: "Confirm Password",
//                           icon: Icons.lock_outline,
//                           obscure: true,
//                         ),
//                         const SizedBox(height: 20),

//                         /// Sign Up Button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: authState.status == AuthStatus.loading
//                                 ? null
//                                 : _onRegisterPressed,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                             ),
//                             child: authState.status == AuthStatus.loading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text(
//                                     "Sign Up",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         /// Login Redirect
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text("Already have an account? "),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => const LoginPage(),
//                                   ),
//                                 );
//                               },
//                               child: const Text(
//                                 "Login",
//                                 style: TextStyle(
//                                   color: Colors.blue,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 🔐 Register logic + validation
//   void _onRegisterPressed() {
//     if (firstNameController.text.trim().isEmpty ||
//         lastNameController.text.trim().isEmpty ||
//         usernameController.text.trim().isEmpty ||
//         emailController.text.trim().isEmpty ||
//         passwordController.text.trim().isEmpty ||
//         confirmPasswordController.text.trim().isEmpty) {
//       _showSnackBar('All fields are required');
//       return;
//     }

//     if (passwordController.text.trim().length < 6) {
//       _showSnackBar('Password must be at least 6 characters');
//       return;
//     }

//     if (passwordController.text.trim() !=
//         confirmPasswordController.text.trim()) {
//       _showSnackBar('Passwords do not match');
//       return;
//     }

//     ref
//         .read(authViewModelProvider.notifier)
//         .register(
//           fullName:
//               '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
//           username: usernameController.text.trim(),
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }

//   Widget _inputField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool obscure = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(40),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         decoration: InputDecoration(
//           icon: Icon(icon),
//           border: InputBorder.none,
//           hintText: hint,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     usernameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
// }
