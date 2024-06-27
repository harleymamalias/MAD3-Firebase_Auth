import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/routing/router.dart';
import 'package:state_change_demo/src/screens/auth/login.screen.dart';
import '../../../app_styles.dart';
import '../../../widgets/customized_input_fields.dart';
import '../../dialogs/waiting_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const String route = '/RegistrationScreen';
  static const String path = "/RegistrationScreen";
  static const String name = "User Registration";

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController usernameController,
      passwordController,
      confirmPasswordController;
  late FocusNode usernameFn, passwordFn, confirmPasswordFn;

  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController(text: 'test@gmail.com');
    passwordController = TextEditingController(text: '12345678ABCabc!');
    confirmPasswordController = TextEditingController();
    usernameFn = FocusNode();
    passwordFn = FocusNode();
    confirmPasswordFn = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameFn.dispose();
    passwordFn.dispose();
    confirmPasswordFn.dispose();
  }

  String? usernameValidator(String? value) {
    return MultiValidator(
      [
        RequiredValidator(
          errorText: 'Please fill out the username',
        ),
        MaxLengthValidator(
          32,
          errorText: "Username cannot exceed 32 characters",
        ),
        EmailValidator(
          errorText: 'Please enter a valid email',
        ),
      ],
    ).call(value);
  }

  String? passwordValidator(String? value) {
    return MultiValidator(
      [
        RequiredValidator(errorText: "Password is required"),
        MinLengthValidator(12,
            errorText: "Password must be at least 12 characters long"),
        MaxLengthValidator(128,
            errorText: "Password cannot exceed 72 characters"),
        PatternValidator(
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
            errorText:
                'Password must contain\n \u2022 At least one symbol (e.g., !, @, #)\n \u2022 One uppercase letter (A-Z)\n \u2022 One lowercase letter (a-z)\n \u2022 One number (0-9)'),
      ],
    ).call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 242, 239),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.3,
                //   child: Image.asset(
                //     'assets/images/CreateAccount-BG.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Row(
                  children: [
                    Text(
                      'Registration,',
                      style: tPoppinsBold.copyWith(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Please create an account',
                      style: tPoppinsRegular.copyWith(
                        fontSize: 17,
                        color: const Color.fromARGB(255, 62, 60, 60),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildLoginForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: tPoppinsRegular,
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        GlobalRouter.I.router.go(LoginScreen.route);
                      },
                      child: Text(
                        'Sign in',
                        style: tPoppinsBold.copyWith(
                          color: const Color(0xff242F9B),
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text('or register with'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSocialMediaIcons('assets/images/google.png', () {
                      // print('Google image tapped');
                    }),
                    const SizedBox(width: 10),
                    buildSocialMediaIcons('assets/images/fb.png', () {
                      // print('Facebook image tapped');
                    }),
                    const SizedBox(width: 10),
                    buildSocialMediaIcons('assets/images/apple-logo.png', () {
                      // print('Apple image tapped');
                    }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,
          future: AuthController.I.register(
              usernameController.text.trim(), passwordController.text.trim()));
    }
  }

  //builder function for social media icons
  Widget buildSocialMediaIcons(String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 239, 231, 231),
            ),
            height: 60,
            width: 60,
            child: Image.asset(imagePath),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          CustomizedInputField(
            controller: usernameController,
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icons.person_outline,
            focusNode: usernameFn,
            onEditingComplete: () {
              passwordFn.requestFocus();
            },
            validator: usernameValidator,
          ),
          const SizedBox(height: 10),
          CustomizedInputField(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
            prefixIcon: Icons.lock_outline,
            suffixIcon: Iconsax.eye_slash,
            focusNode: confirmPasswordFn,
            onEditingComplete: () {
              confirmPasswordFn.requestFocus();
            },
            validator: passwordValidator,
          ),
          const SizedBox(height: 10),
          CustomizedInputField(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              suffixIcon: Iconsax.eye_slash,
              focusNode: passwordFn,
              onEditingComplete: () {
                confirmPasswordFn.unfocus();
              },
              validator: (v) {
                String? doesNotMatchPasswords =
                    passwordController.text == confirmPasswordController.text
                        ? null
                        : 'Password does not match!';
                if (doesNotMatchPasswords != null) {
                  return doesNotMatchPasswords;
                } else {
                  return MultiValidator(
                    [
                      RequiredValidator(errorText: "Password is required"),
                      MinLengthValidator(12,
                          errorText:
                              "Password must be at least 12 characters long"),
                      MaxLengthValidator(128,
                          errorText: "Password cannot exceed 72 characters"),
                      PatternValidator(
                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                          errorText:
                              'Password must contain\n \u2022 At least one symbol (e.g., !, @, #)\n \u2022 One uppercase letter (A-Z)\n \u2022 One lowercase letter (a-z)\n \u2022 One number (0-9)'),
                    ],
                  ).call(v);
                }
              }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // print('forgot password');
                },
                child: Text(
                  'Forgot password?',
                  style: tPoppinsMedium.copyWith(
                    fontSize: 13,
                    color: const Color.fromARGB(255, 96, 94, 94),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onSubmit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff242F9B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: _isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Signing up...',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Sign up',
                      style: tPoppinsBold.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
