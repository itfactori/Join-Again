import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:join/screens/auth/email_and_pass/sign_up_screen.dart';
import 'package:join/services/auth_service.dart';
import 'package:join/widgets/custom_input.dart';
import 'package:join/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Center(
              child: Image.asset(
                "assets/splash.png",
                height: 60,
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            CustomInput(
              controller: emailController,
              hintText: "E-mail",
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 10),
            CustomInput(
              controller: passwordController,
              hintText: "Password",
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerRight,
              child: Text("Forgot Password?"),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onTap: () {
                signIn();
              },
              title: "Login",
            ),
            const SizedBox(height: 20),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
              },
              child: const Center(
                child: Text(
                  "Don't Have an Account? SignUp",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  signIn() async {
    if (emailController.text.isEmpty) {
      EasyLoading.showError("Email Must Be Filled");
    } else if (passwordController.text.isEmpty) {
      EasyLoading.showError("Password Must Be Filled");
    } else {
      await AuthServices.signIn(context: context, email: emailController.text, password: passwordController.text);
    }
  }
}
