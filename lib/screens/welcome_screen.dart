import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/screens/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  final String imagePath = "assets/images/background.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Spacer(),
                  icon(),
                  welcomeTextWidget(),
                  SizedBox(height: 10),
                  sloganText(),
                  SizedBox(height: 40),
                  getButton(context),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget icon() {
    String iconPath = "assets/icons/shop_icon.svg";
    return SvgPicture.asset(
      iconPath,
      width: 32,
      height: 32,
    );
  }

  Widget welcomeTextWidget() {
    return Column(
      children: [
        AppText(
          text: "Welcome",
          fontSize: 48,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(108, 252, 252, 252).withOpacity(0.9),
        ),
        AppText(
          text: "to our store",
          fontSize: 48,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(108, 252, 252, 252).withOpacity(0.7),
        ),
      ],
    );
  }

  Widget sloganText() {
    return AppText(
      text: "Access healthcare at the palm of your hand",
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 182, 90, 102).withOpacity(0.99),
    );
  }

  Widget getButton(BuildContext context) {
    return AppButton(
      label: "Get Started",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 25),
      onPressed: () {
        onGetStartedClicked(context);
      },
    );
  }

  void onGetStartedClicked(BuildContext context) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) {
        return LoginPage(
          email: '',
        );
      },
    ));
  }
}
