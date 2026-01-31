// // import 'package:flutter/material.dart';
// // import '../../common/widgets/primary_button.dart';
// // import '../../../core/network/api_client.dart';
// // import '../../../core/storage/local_storage.dart';
// // import '../../../data/repositories/auth_repository.dart';

// // class ChangePasswordScreen extends StatefulWidget {
// //   const ChangePasswordScreen({super.key});

// //   @override
// //   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// // }

// // class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
// //   final _currentController = TextEditingController();
// //   final _newController = TextEditingController();
// //   final _confirmController = TextEditingController();
// //   final _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
// //   bool _loading = false;

// //   @override
// //   void dispose() {
// //     _currentController.dispose();
// //     _newController.dispose();
// //     _confirmController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _submit() async {
// //     if (_loading) {
// //       return;
// //     }
// //     setState(() => _loading = true);
// //     try {
// //       await _authRepository.changePassword(
// //         _currentController.text,
// //         _newController.text,
// //         _confirmController.text,
// //       );
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Password updated')),
// //         );
// //         Navigator.of(context).pop();
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(e.toString())),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() => _loading = false);
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Change Password')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20),
// //         child: Card(
// //           child: Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               children: [
// //                 TextField(
// //                   controller: _currentController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Current password',
// //                     prefixIcon: Icon(Icons.lock_outline),
// //                   ),
// //                   obscureText: true,
// //                 ),
// //                 const SizedBox(height: 12),
// //                 TextField(
// //                   controller: _newController,
// //                   decoration: InputDecoration(
// //                     labelText: 'New password',
// //                     prefixIcon: Icon(Icons.lock_reset_outlined),
// //                   ),
// //                   obscureText: true,
// //                 ),
// //                 const SizedBox(height: 12),
// //                 TextField(
// //                   controller: _confirmController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Confirm new password',
// //                     prefixIcon: Icon(Icons.lock_reset_outlined),
// //                   ),
// //                   obscureText: true,
// //                 ),
// //                 const SizedBox(height: 20),
// //                 PrimaryButton(
// //                   label: _loading ? 'Updating...' : 'Update Password',
// //                   onPressed: _loading ? () {} : _submit,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import '../../common/widgets/primary_button.dart';
// import '../../../core/network/api_client.dart';
// import '../../../core/storage/local_storage.dart';
// import '../../../data/repositories/auth_repository.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _currentController = TextEditingController();
//   final _newController = TextEditingController();
//   final _confirmController = TextEditingController();
//   final _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
//   final _formKey = GlobalKey<FormState>();

//   bool _loading = false;
//   bool _obscureCurrent = true;
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//   bool _showSuccess = false;

//   // Password strength indicators
//   bool get _hasMinLength => _newController.text.length >= 8;
//   bool get _hasUppercase => _newController.text.contains(RegExp(r'[A-Z]'));
//   bool get _hasLowercase => _newController.text.contains(RegExp(r'[a-z]'));
//   bool get _hasNumber => _newController.text.contains(RegExp(r'[0-9]'));
//   bool get _hasSpecialChar =>
//       _newController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

//   double get _passwordStrength {
//     double strength = 0.0;
//     if (_hasMinLength) strength += 0.2;
//     if (_hasUppercase) strength += 0.2;
//     if (_hasLowercase) strength += 0.2;
//     if (_hasNumber) strength += 0.2;
//     if (_hasSpecialChar) strength += 0.2;
//     return strength;
//   }

//   @override
//   void dispose() {
//     _currentController.dispose();
//     _newController.dispose();
//     _confirmController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (_loading) return;

//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       await _authRepository.changePassword(
//         _currentController.text,
//         _newController.text,
//         _confirmController.text,
//       );

//       if (mounted) {
//         setState(() => _showSuccess = true);
//         await Future.delayed(const Duration(seconds: 2));
//         if (mounted) {
//           Navigator.of(context).pop();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('Password updated successfully'),
//               backgroundColor: Colors.green.shade600,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(e.toString()),
//             backgroundColor: Colors.red.shade600,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _loading = false);
//       }
//     }
//   }

//   String? _validateCurrentPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter current password';
//     }
//     return null;
//   }

//   String? _validateNewPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter new password';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters';
//     }
//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     if (value != _newController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }

//   Color _getStrengthColor() {
//     if (_passwordStrength <= 0.3) return Colors.red;
//     if (_passwordStrength <= 0.6) return Colors.orange;
//     return Colors.green;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: _showSuccess
//           ? _buildSuccessScreen()
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Header Section with Gradient
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.only(
//                       top: 60,
//                       bottom: 40,
//                       left: 24,
//                       right: 24,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.blue.shade700,
//                           Colors.blue.shade900,
//                         ],
//                       ),
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(40),
//                         bottomRight: Radius.circular(40),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Back Button
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () => Navigator.pop(context),
//                               child: Container(
//                                 width: 44,
//                                 height: 44,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.15),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Icon(
//                                   Icons.arrow_back_rounded,
//                                   color: Colors.white,
//                                   size: 22,
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                             Container(
//                               width: 44,
//                               height: 44,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.15),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.security_rounded,
//                                 color: Colors.white,
//                                 size: 22,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 30),

//                         // Title Section
//                         const Text(
//                           'Change Password',
//                           style: TextStyle(
//                             fontSize: 34,
//                             fontWeight: FontWeight.w800,
//                             fontFamily: 'Poppins',
//                             color: Colors.white,
//                             height: 1.2,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           'Secure your account with a strong password',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white.withOpacity(0.85),
//                           ),
//                         ),

//                         // Progress Indicator
//                         const SizedBox(height: 30),
//                         Row(
//                           children: [
//                             Container(
//                               width: 12,
//                               height: 12,
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 height: 3,
//                                 color: Colors.white.withOpacity(0.3),
//                               ),
//                             ),
//                             Container(
//                               width: 12,
//                               height: 12,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.3),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 height: 3,
//                                 color: Colors.white.withOpacity(0.3),
//                               ),
//                             ),
//                             Container(
//                               width: 12,
//                               height: 12,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.3),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Form Section
//                   Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           // Card Container
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(24),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.05),
//                                   blurRadius: 30,
//                                   offset: const Offset(0, 10),
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(24),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Current Password
//                                   _buildPasswordField(
//                                     controller: _currentController,
//                                     label: 'Current Password',
//                                     hint: 'Enter your current password',
//                                     obscureText: _obscureCurrent,
//                                     prefixIcon: Icons.lock_outline_rounded,
//                                     validator: _validateCurrentPassword,
//                                     onToggleVisibility: () {
//                                       setState(() =>
//                                           _obscureCurrent = !_obscureCurrent);
//                                     },
//                                   ),

//                                   const SizedBox(height: 24),

//                                   // New Password
//                                   _buildPasswordField(
//                                     controller: _newController,
//                                     label: 'New Password',
//                                     hint: 'Create a strong password',
//                                     obscureText: _obscureNew,
//                                     prefixIcon: Icons.lock_reset_rounded,
//                                     validator: _validateNewPassword,
//                                     onToggleVisibility: () {
//                                       setState(
//                                           () => _obscureNew = !_obscureNew);
//                                     },
//                                   ),

//                                   // Password Strength Indicator
//                                   if (_newController.text.isNotEmpty) ...[
//                                     const SizedBox(height: 16),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               'Password Strength',
//                                               style: TextStyle(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Colors.grey.shade700,
//                                               ),
//                                             ),
//                                             Text(
//                                               _passwordStrength <= 0.3
//                                                   ? 'Weak'
//                                                   : _passwordStrength <= 0.6
//                                                       ? 'Medium'
//                                                       : 'Strong',
//                                               style: TextStyle(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: _getStrengthColor(),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 8),
//                                         LinearProgressIndicator(
//                                           value: _passwordStrength,
//                                           backgroundColor: Colors.grey.shade200,
//                                           color: _getStrengthColor(),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           minHeight: 8,
//                                         ),
//                                         const SizedBox(height: 12),
//                                         Wrap(
//                                           spacing: 12,
//                                           runSpacing: 8,
//                                           children: [
//                                             _buildRequirementItem(
//                                                 '8+ chars', _hasMinLength),
//                                             _buildRequirementItem(
//                                                 'A-Z', _hasUppercase),
//                                             _buildRequirementItem(
//                                                 'a-z', _hasLowercase),
//                                             _buildRequirementItem(
//                                                 '0-9', _hasNumber),
//                                             _buildRequirementItem(
//                                                 '!@#', _hasSpecialChar),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],

//                                   const SizedBox(height: 24),

//                                   // Confirm Password
//                                   _buildPasswordField(
//                                     controller: _confirmController,
//                                     label: 'Confirm Password',
//                                     hint: 'Re-enter your new password',
//                                     obscureText: _obscureConfirm,
//                                     prefixIcon: Icons.lock_reset_rounded,
//                                     validator: _validateConfirmPassword,
//                                     onToggleVisibility: () {
//                                       setState(() =>
//                                           _obscureConfirm = !_obscureConfirm);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 32),

//                           // Update Button
//                           SizedBox(
//                             width: double.infinity,
//                             height: 58,
//                             child: ElevatedButton(
//                               onPressed: _loading ? null : _submit,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue.shade700,
//                                 foregroundColor: Colors.white,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 shadowColor: Colors.blue.shade300,
//                               ),
//                               child: _loading
//                                   ? Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         SizedBox(
//                                           width: 20,
//                                           height: 20,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2.5,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         const Text(
//                                           'Updating Password...',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   : const Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.lock_reset_rounded,
//                                             size: 22),
//                                         SizedBox(width: 10),
//                                         Text(
//                                           'Update Password',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                             ),
//                           ),

//                           // Security Tips
//                           Container(
//                             margin: const EdgeInsets.only(top: 32),
//                             padding: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.shade50,
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Colors.blue.shade100,
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 44,
//                                   height: 44,
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue.shade100,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Icon(
//                                     Icons.lightbulb_outline_rounded,
//                                     color: Colors.blue.shade700,
//                                     size: 24,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Security Tip',
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.blue.shade800,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         'Use a unique password that you don\'t use elsewhere. Consider using a password manager.',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.blue.shade700,
//                                           height: 1.4,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required bool obscureText,
//     required IconData prefixIcon,
//     required String? Function(String?)? validator,
//     required VoidCallback onToggleVisibility,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: Colors.grey.shade200,
//               width: 1.5,
//             ),
//           ),
//           child: TextFormField(
//             controller: controller,
//             obscureText: obscureText,
//             validator: validator,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontSize: 15,
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 18,
//               ),
//               prefixIcon: Container(
//                 margin: const EdgeInsets.only(left: 12, right: 8),
//                 child: Icon(
//                   prefixIcon,
//                   color: Colors.grey.shade600,
//                   size: 22,
//                 ),
//               ),
//               suffixIcon: Container(
//                 margin: const EdgeInsets.only(right: 8),
//                 child: IconButton(
//                   icon: Icon(
//                     obscureText ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey.shade600,
//                     size: 22,
//                   ),
//                   onPressed: onToggleVisibility,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRequirementItem(String text, bool isMet) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: isMet ? Colors.green.shade50 : Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isMet ? Colors.green.shade200 : Colors.grey.shade300,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isMet ? Icons.check_circle : Icons.circle_outlined,
//             size: 14,
//             color: isMet ? Colors.green : Colors.grey,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: isMet ? Colors.green.shade800 : Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSuccessScreen() {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Animated Checkmark
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.green.shade100,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.green.shade200,
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.check_rounded,
//               size: 60,
//               color: Colors.green,
//             ),
//           ),
//           const SizedBox(height: 40),

//           // Success Message
//           const Text(
//             'Password Updated!',
//             style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.w800,
//               fontFamily: 'Poppins',
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 16),

//           Text(
//             'Your password has been successfully changed.',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 8),

//           Text(
//             'You will be redirected shortly...',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade500,
//             ),
//           ),

//           // Loading Indicator
//           const SizedBox(height: 40),
//           SizedBox(
//             width: 50,
//             height: 50,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//               color: Colors.blue.shade700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../common/widgets/primary_button.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/repositories/auth_repository.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _showSuccess = false;

  // Error messages for external display
  String _currentError = '';
  String _newError = '';
  String _confirmError = '';

  // Password strength indicators
  bool get _hasMinLength => _newController.text.length >= 8;
  bool get _hasUppercase => _newController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _newController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _newController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialChar =>
      _newController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  double get _passwordStrength {
    double strength = 0.0;
    if (_hasMinLength) strength += 0.2;
    if (_hasUppercase) strength += 0.2;
    if (_hasLowercase) strength += 0.2;
    if (_hasNumber) strength += 0.2;
    if (_hasSpecialChar) strength += 0.2;
    return strength;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to clear errors when typing
    _currentController.addListener(_clearCurrentError);
    _newController.addListener(_clearNewError);
    _confirmController.addListener(_clearConfirmError);
  }

  void _clearCurrentError() {
    if (_currentError.isNotEmpty) {
      setState(() => _currentError = '');
    }
  }

  void _clearNewError() {
    if (_newError.isNotEmpty) {
      setState(() => _newError = '');
    }
  }

  void _clearConfirmError() {
    if (_confirmError.isNotEmpty) {
      setState(() => _confirmError = '');
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;

    // Clear previous errors
    setState(() {
      _currentError = '';
      _newError = '';
      _confirmError = '';
    });

    // Validate all fields
    bool isValid = true;

    final currentValidation = _validateCurrentPassword(_currentController.text);
    if (currentValidation != null) {
      setState(() => _currentError = currentValidation);
      isValid = false;
    }

    final newValidation = _validateNewPassword(_newController.text);
    if (newValidation != null) {
      setState(() => _newError = newValidation);
      isValid = false;
    }

    final confirmValidation = _validateConfirmPassword(_confirmController.text);
    if (confirmValidation != null) {
      setState(() => _confirmError = confirmValidation);
      isValid = false;
    }

    if (!isValid) {
      return;
    }

    setState(() => _loading = true);

    try {
      await _authRepository.changePassword(
        _currentController.text,
        _newController.text,
        _confirmController.text,
      );

      if (mounted) {
        setState(() => _showSuccess = true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Password updated successfully'),
              backgroundColor: const Color(0xFF48BB78),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFFC8181),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter current password';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter new password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Color _getStrengthColor() {
    if (_passwordStrength <= 0.3) return const Color(0xFFFC8181);
    if (_passwordStrength <= 0.6) return const Color(0xFFF6AD55);
    return const Color(0xFF48BB78);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _showSuccess
          ? _buildSuccessScreen()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section with Gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.security_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Secure your account with a strong password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Form Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Current Password with external error
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPasswordField(
                                      controller: _currentController,
                                      label: 'Current Password',
                                      hint: 'Enter current password',
                                      obscureText: _obscureCurrent,
                                      hasError: _currentError.isNotEmpty,
                                      onToggleVisibility: () {
                                        setState(() =>
                                            _obscureCurrent = !_obscureCurrent);
                                      },
                                    ),
                                    if (_currentError.isNotEmpty)
                                      _buildErrorBox(_currentError),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // New Password with external error
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPasswordField(
                                      controller: _newController,
                                      label: 'New Password',
                                      hint: 'Enter new password',
                                      obscureText: _obscureNew,
                                      hasError: _newError.isNotEmpty,
                                      onToggleVisibility: () {
                                        setState(
                                            () => _obscureNew = !_obscureNew);
                                      },
                                    ),
                                    if (_newError.isNotEmpty)
                                      _buildErrorBox(_newError),
                                  ],
                                ),

                                // Password Strength
                                if (_newController.text.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Password Strength',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF4A5568),
                                            ),
                                          ),
                                          Text(
                                            _passwordStrength <= 0.3
                                                ? 'Weak'
                                                : _passwordStrength <= 0.6
                                                    ? 'Medium'
                                                    : 'Strong',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: _getStrengthColor(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: _passwordStrength,
                                        backgroundColor:
                                            const Color(0xFFE2E8F0),
                                        color: _getStrengthColor(),
                                        borderRadius: BorderRadius.circular(4),
                                        minHeight: 6,
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: [
                                          _buildRequirementItem(
                                              '8+ chars', _hasMinLength),
                                          _buildRequirementItem(
                                              'A-Z', _hasUppercase),
                                          _buildRequirementItem(
                                              'a-z', _hasLowercase),
                                          _buildRequirementItem(
                                              '0-9', _hasNumber),
                                          _buildRequirementItem(
                                              '!@#', _hasSpecialChar),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],

                                // Confirm Password with external error
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPasswordField(
                                      controller: _confirmController,
                                      label: 'Confirm Password',
                                      hint: 'Confirm new password',
                                      obscureText: _obscureConfirm,
                                      hasError: _confirmError.isNotEmpty,
                                      onToggleVisibility: () {
                                        setState(() =>
                                            _obscureConfirm = !_obscureConfirm);
                                      },
                                    ),
                                    if (_confirmError.isNotEmpty)
                                      _buildErrorBox(_confirmError),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Update Button
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _loading ? null : _submit,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: _loading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Update Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Security Tips
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF2F7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF667eea),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Security Tip',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Use a unique password that you don\'t use elsewhere.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: const Color(0xFF4A5568),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    bool hasError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: hasError ? const Color(0xFFFC8181) : const Color(0xFF4A5568),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // White background for input field
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  hasError ? const Color(0xFFFC8181) : const Color(0xFFE2E8F0),
              width: hasError ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
              fontSize: 14,
              color:
                  hasError ? const Color(0xFFFC8181) : const Color(0xFF2D3748),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: hasError
                    ? const Color(0xFFFC8181).withOpacity(0.7)
                    : const Color(0xFF718096),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 8, right: 6),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: hasError
                      ? const Color(0xFFFC8181)
                      : const Color(0xFF667eea),
                  size: 18,
                ),
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: hasError
                        ? const Color(0xFFFC8181)
                        : const Color(0xFF718096),
                    size: 18,
                  ),
                  onPressed: onToggleVisibility,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBox(String errorMessage) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFED7D7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFC8181).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 14,
            color: const Color(0xFFFC8181),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF9B2C2C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMet ? const Color(0xFFC6F6D5) : const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isMet ? const Color(0xFF9AE6B4) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 12,
            color: isMet ? const Color(0xFF48BB78) : const Color(0xFF718096),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isMet ? const Color(0xFF276749) : const Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF48BB78),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF48BB78).withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Password Updated!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your password has been successfully changed.',
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF4A5568),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You will be redirected shortly...',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: const Color(0xFF667eea),
            ),
          ),
        ],
      ),
    );
  }
}
