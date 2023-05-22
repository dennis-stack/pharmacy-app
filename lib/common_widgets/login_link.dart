import 'package:flutter/material.dart';
import 'package:pharmacyApp/styles/colors.dart';

class LoginLink extends StatelessWidget {
  final VoidCallback? onTap;

  const LoginLink({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: "Already have an account? Click ",
          style: DefaultTextStyle.of(context).style,
          children: const <TextSpan>[
            TextSpan(
                text: "here",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.primaryColor)),
            TextSpan(text: " to login."),
          ],
        ),
      ),
    );
  }
}
