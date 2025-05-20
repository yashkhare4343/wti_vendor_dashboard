import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/common_widgets/buttons/primary_button.dart';
import 'package:wti_vendor_dashboard/common_widgets/loader/loader.dart';
import 'package:wti_vendor_dashboard/core/controller/auth/auth_controller.dart';
import 'package:wti_vendor_dashboard/utility/constants/colors/app_colors.dart';

import '../../common_widgets/textformfield/under_line_form_field/under_line_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  var _obscureText = false;


  void _revalidate() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  Future<String?> readData(String key) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      authController.verifyAuth(_emailController.text, _passwordController.text, context);
     final userExists = await readData('userExists');
      if(userExists == 'false'){
          const SnackBar(content: Text('User does not exists, please register first', style: TextStyle(
            color: Colors.white
          ),), backgroundColor: Colors.redAccent,);
    }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill correct details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.scaffoldBgPrimary,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/wti_logo.png', // Your splash screen image
                      width: 120,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    const Text(
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Email field
                    UnderlineTextFormField(
                      controller: _emailController,
                      label: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      onChanged: (value) {
                        _revalidate();
                      },
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    UnderlineTextFormField(
                      controller: _passwordController,
                      label: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: _obscureText
                          ? Icon(
                              Icons.visibility_off,
                              color: AppColors.greyText1,
                            )
                          : Icon(
                              Icons.visibility,
                              color: AppColors.greyText1,
                            ),
                      obscureText: true,
                      onChanged: (value) {
                        _revalidate();
                      },
                      onSuffixTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      validator: (value) => value == null || value.length < 6
                          ? 'Min 6 characters'
                          : null,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Obx((){
                      return SizedBox(
                          width: 200,
                          child: authController.isLoading == true ? Loader() : PrimaryButton(
                              text: 'Sign In',
                              onPressed: () {
                                _submitForm();
                              }));
                    })

                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
