import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/screens/login_screen.dart';
import 'package:pharmacyApp/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_item.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';

    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final firstName = snapshot.data!['firstName'];
                  final lastName = snapshot.data!['lastName'];
                  return ListTile(
                    leading: SizedBox(
                        width: 65, height: 65, child: getImageHeader()),
                    title: AppText(
                      text: "$firstName $lastName",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: AppText(
                      text: email,
                      color: Color(0xff7C7C7C),
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              Column(
                children: getChildrenWithSeperator(
                  widgets: accountItems.map((e) {
                    return getAccountItemWidget(e, context);
                  }).toList(),
                  seperator: Divider(
                    thickness: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              logoutButton(context),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 0,
          backgroundColor: Color(0xffF2F3F2),
          textStyle: TextStyle(
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          minimumSize: const Size.fromHeight(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                "assets/icons/account_icons/logout_icon.svg",
              ),
            ),
            Text(
              "Log Out",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor),
            ),
            Container()
          ],
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }

  Widget getImageHeader() {
    String imagePath = "assets/images/avatar.PNG";
    return CircleAvatar(
      radius: 5.0,
      backgroundImage: AssetImage(imagePath),
      backgroundColor: AppColors.primaryColor.withOpacity(0.7),
    );
  }

  List<Widget> getChildrenWithSeperator({
    required List<Widget> widgets,
    required Widget seperator,
  }) {
    List<Widget> children = [];

    for (int i = 0; i < widgets.length; i++) {
      children.add(widgets[i]);

      if (i != widgets.length - 1) {
        children.add(seperator);
      }
    }

    return children;
  }

  Widget getAccountItemWidget(AccountItem item, BuildContext context) {
    return GestureDetector(
      onTap: () => item.onTap(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(item.iconPath),
            ),
            SizedBox(width: 20),
            Expanded(
              child: AppText(
                text: item.label,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            SvgPicture.asset("assets/icons/account_icons/arrow_right_icon.svg"),
          ],
        ),
      ),
    );
  }
}
