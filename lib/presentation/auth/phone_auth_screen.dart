import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _otpSent = false;
  String _verificationId = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_phoneController.text.trim().isEmpty) {
      _showSnackBar('Please enter your phone number');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final phone = '+91${_phoneController.text.trim()}';
      await _authService.signUpWithPhone(phone);

      setState(() {
        _otpSent = true;
        _isLoading = false;
      });

      _showSnackBar('OTP sent successfully');
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Failed to send OTP: ${e.toString()}');
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().isEmpty) {
      _showSnackBar('Please enter the OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final phone = '+91${_phoneController.text.trim()}';
      final response =
          await _authService.verifyOTP(phone, _otpController.text.trim());

      if (response.user != null) {
        // Check if user profile exists
        final profile = await _authService.getUserProfile();

        if (profile == null) {
          // Navigate to role selection for new users
          Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
        } else {
          // Navigate based on user role
          if (profile.role == 'worker') {
            Navigator.pushReplacementNamed(context, AppRoutes.workerDashboard);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.userHomeScreen);
          }
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Invalid OTP: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              // App Logo
              Container(
                  height: 12.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppValues.borderRadius)),
                  child: Icon(Icons.work, size: 8.h, color: Colors.white)),

              SizedBox(height: 4.h),

              // App Name & Tagline
              Text(AppStrings.appName,
                  style: GoogleFonts.inter(
                      fontSize: 28.sp, fontWeight: FontWeight.bold)),

              SizedBox(height: 1.h),

              Text(AppStrings.appTagline,
                  style: GoogleFonts.inter(fontSize: 14.sp),
                  textAlign: TextAlign.center),

              SizedBox(height: 6.h),

              // Phone Number Input (if OTP not sent)
              if (!_otpSent) ...[
                Text('Enter your phone number',
                    style: GoogleFonts.inter(
                        fontSize: 16.sp, fontWeight: FontWeight.w600)),

                SizedBox(height: 2.h),

                Row(children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius:
                              BorderRadius.circular(AppValues.borderRadius)),
                      child: Text('+91',
                          style: GoogleFonts.inter(
                              fontSize: 16.sp, fontWeight: FontWeight.w500))),
                  SizedBox(width: 3.w),
                  Expanded(
                      child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                              hintText: AppStrings.phoneNumberHint,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppValues.borderRadius)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h)),
                          style: GoogleFonts.inter(fontSize: 16.sp)))
                ]),

                SizedBox(height: 4.h),

                // Send OTP Button
                SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendOTP,
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppValues.borderRadius))),
                        child: _isLoading
                            ? SizedBox(
                                height: 2.h,
                                width: 2.h,
                                child: const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text(AppStrings.sendOtp,
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)))),
              ],

              // OTP Input (if OTP sent)
              if (_otpSent) ...[
                Text('Enter OTP sent to +91${_phoneController.text}',
                    style: GoogleFonts.inter(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),

                SizedBox(height: 2.h),

                TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(AppValues.otpLength),
                    ],
                    decoration: InputDecoration(
                        hintText: AppStrings.otpHint,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppValues.borderRadius)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h)),
                    style:
                        GoogleFonts.inter(fontSize: 18.sp, letterSpacing: 2.0),
                    textAlign: TextAlign.center),

                SizedBox(height: 3.h),

                // Verify OTP Button
                SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTP,
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppValues.borderRadius))),
                        child: _isLoading
                            ? SizedBox(
                                height: 2.h,
                                width: 2.h,
                                child: const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text(AppStrings.verifyOtp,
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)))),

                SizedBox(height: 2.h),

                // Resend OTP Button
                TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() => _otpSent = false);
                            _otpController.clear();
                          },
                    child: Text(AppStrings.resendOtp,
                        style: GoogleFonts.inter(
                            fontSize: 14.sp, fontWeight: FontWeight.w500))),
              ],

              const Spacer(),

              // Terms and Privacy
              Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy',
                      style: GoogleFonts.inter(fontSize: 12.sp),
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }
}
