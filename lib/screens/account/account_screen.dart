import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/styles/colors.dart';
import 'package:pharmacyApp/connection/connection.dart';
import 'package:pharmacyApp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_item.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    getUserDetailsFromSharedPrefs();
  }

  Future<void> getUserDetailsFromSharedPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('firstName') ?? '';
      lastName = preferences.getString('lastName') ?? '';
      email = preferences.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: getUserDetailsFromSharedPrefs,
        child: Container(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20),
                ListTile(
                  leading: SizedBox(
                    width: 65,
                    height: 65,
                    child: getImageHeader(),
                  ),
                  title: Text(
                    '$firstName $lastName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$email',
                    style: TextStyle(fontSize: 16, color: Color(0xff7C7C7C)),
                  ),
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
                SizedBox(height: 20),
                logoutButton(context),
                SizedBox(height: 20),
              ],
            ),
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
          backgroundColor: AppColors.redColor,
          textStyle: TextStyle(color: Colors.white),
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          minimumSize: const Size.fromHeight(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.logout),
            ),
            Text(
              "Log Out",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(),
          ],
        ),
        onPressed: () {
          showLogoutConfirmationDialog(context);
        },
      ),
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Log Out'),
              onPressed: () {
                logout();
                Navigator.of(context).pop();
              },
              isDestructiveAction: true,
            ),
          ],
        );
      },
    );
  }

  void logout() {
    final url = API.logout;

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(email: '')),
          (route) => false,
        );
      } else {
        print('Failed to logout. Status code: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Exception occurred: $error');
    });
  }

  Widget getImageHeader() {
    String imagePath = "assets/images/avatar.PNG";
    return CircleAvatar(
      radius: 5.0,
      backgroundImage: AssetImage(imagePath),
      backgroundColor: Colors.blue.withOpacity(0.7),
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
            SizedBox(width: 5),
            SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                  "assets/icons/account_icons/arrow_right_icon.svg"),
            ),
          ],
        ),
      ),
    );
  }
}
