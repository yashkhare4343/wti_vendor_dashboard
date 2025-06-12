import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    authController.initFCM();
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool _obscureText = true;
  // Initialize as true to hide password by default

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userExist = await readData('userExists');
      print('user exist : $userExist');
      authController.verifyAuth(_emailController.text, _passwordController.text, context);

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
                    prefixIcon: const Icon(Icons.email),
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
                  const SizedBox(height: 16),
                  UnderlineTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.greyText1,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    obscureText: _obscureText, // Use state variable here
                    onChanged: (value) {
                      _revalidate();
                    },
                    validator: (value) => value == null || value.length < 6
                        ? 'Min 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 32),
                  Obx(() {
                    return SizedBox(
                      width: 200,
                      child: authController.isLoading == true
                          ? const Loader()
                          : PrimaryButton(
                        text: 'Sign In',
                        onPressed: () {
                          _submitForm();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}