import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
//import 'package:mercave/app/core/services/facebook/facebook.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
//import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
//import 'package:mercave/app/core/services/wordpress/wodpress.service.dart';
import 'package:mercave/app/pages/account/login/login.page.dart';
import 'package:mercave/app/pages/account/register/register.page.dart';
import 'package:mercave/app/pages/account/user_menu/user_menu.page.dart';
import 'package:mercave/app/shared/components/buttons/link_button/link_button.widget.dart';
import 'package:mercave/app/shared/components/buttons/round_icon_text_button/round_icon_text_button.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class HomeLoginPage extends StatefulWidget {
  @override
  _HomeLoginPageState createState() => _HomeLoginPageState();
}

class _HomeLoginPageState extends State<HomeLoginPage> {
  //final facebookLogin = FacebookLogin();
  bool privacyPoliciesAccepted;

  @override
  void initState() {
    super.initState();
    privacyPoliciesAccepted = false;
  }

  void _loginWithFB(BuildContext context) async {
    /* 
    FacebookService.login().then((profile) async {
      if (profile != null) {
        LoaderService.showLoader(
          context: context,
          text: 'Validando...',
        );

        try {
          /// ==================================================================
          /// Create the facebook user as a wordPress user
          /// ==================================================================
          Map userCreated =
              await WordPressService.createUserWithFacebookUserData(
            profile: profile,
          );

          userCreated['avatar'] = profile['picture']['data']['url'];

          createLocalUserAndRedirect(
            context: context,
            userCreated: userCreated,
          );
        } catch (e) {
          LoaderService.dismissLoader(context: context);

          AlertService.showErrorAlert(
            context: context,
            title: 'Error',
            description: 'Error: ' + e.message,
          );
        }
      }
    }).catchError((e) {
      AlertService.showErrorAlert(
        context: context,
        title: 'Error',
        description: e.toString(),
      );
    }); */
  }

  void createLocalUserAndRedirect(
      {BuildContext context, Map userCreated}) async {
    /// ==================================================================
    /// Save the user data in the database and set as logged
    /// ==================================================================
    Map userData = {
      'id': userCreated['id'],
      'first_name': userCreated['first_name'],
      'last_name': userCreated['last_name'],
      'email': userCreated['email'],
      'avatar': userCreated['avatar']
    };

    await UserDBService.createUpdateUser(userData: userData);
    await AuthService.setUserIdLogged(userId: userCreated['id']);
    LoaderService.dismissLoader(context: context);

    /// ========================================================================
    /// Copy the address of the anonymous user if no one is set for the logged
    /// user.
    /// ========================================================================
    Map anonymousUser = await UserDBService.getUserById(id: 0);
    Map currentUser = await UserDBService.getUserById(id: userCreated['id']);

    if (anonymousUser != null &&
        anonymousUser['neighborhood'] != null &&
        currentUser['neighborhood'] == null) {
      userData['neighborhood'] = anonymousUser['neighborhood'];
      userData['type_of_road'] = anonymousUser['type_of_road'];
      userData['plate_part_1'] = anonymousUser['plate_part_1'];
      userData['plate_part_2'] = anonymousUser['plate_part_2'];
      userData['plate_part_3'] = anonymousUser['plate_part_3'];
      userData['address_info'] = anonymousUser['address_info'];

      userData['id'] = userCreated['id'];
      await UserDBService.createUpdateUser(userData: userData);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserMenuPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBarWidget(context),
        body: _getBodyWidget(context),
        bottomNavigationBar: _getBottomNavigation(context),
      ),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kCustomWhiteColor,
      elevation: 0,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.pop(context, false),
                  child: Image.asset(
                    'assets/icons/back_arrow.png',
                    width: 25.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo-mercave.jpg',
            width: MediaQuery.of(context).size.width * 45 / 100,
          ),
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: <Widget>[
                _getFacebookLoginButtonWidget(context),
                _getMailLoginButtonWidget(context),
                SizedBox(height: 25.0),
                _getRegisterLinkWidget(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBottomNavigation(BuildContext context) {
    return Container(
      height: 100.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            _getAgreeWithTermsAndConditionsWidget(context),
            SizedBox(height: 15.0),
            _getTermsAndPoliciesLinksWidget(context)
          ],
        ),
      ),
    );
  }

  Widget _getAgreeWithTermsAndConditionsWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: privacyPoliciesAccepted,
          activeColor: kCustomPrimaryColor,
          onChanged: (value) {
            setState(() {
              privacyPoliciesAccepted = value;
            });
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  privacyPoliciesAccepted = !privacyPoliciesAccepted;
                });
              },
              child: Text(
                kCustomAgreePoliciesTermsText,
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getTermsAndPoliciesLinksWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: LinkButtonWidget(
            text: kCustomViewTermsAndConditionsText,
            url: kCustomTermAndConditionsUrlText,
          ),
        ),
        Expanded(
          flex: 1,
          child: LinkButtonWidget(
            text: kCustomPrivacyPoliciesText,
            url: kCustomPrivacyPoliciesUrlText,
          ),
        )
      ],
    );
  }

  Widget _getFacebookLoginButtonWidget(BuildContext context) {
    return RoundIconTextButton(
      text: kCustomLoginFacebookText,
      textColor: kCustomWhiteColor,
      backgroundColor: kCustomFacebookColor,
      icon: Icon(
        FontAwesomeIcons.facebookSquare,
        color: kCustomWhiteColor,
      ),
      onTapped: () {
        _loginWithFB(context);
      },
    );
  }

  Widget _getMailLoginButtonWidget(BuildContext context) {
    return RoundIconTextButton(
      text: kCustomLoginMailText,
      textColor: kCustomWhiteColor,
      backgroundColor: kCustomMailColor,
      icon: Icon(
        Icons.mail,
        color: kCustomWhiteColor,
      ),
      onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
    );
  }

  Widget _getRegisterLinkWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(),
          ),
        );
      },
      child: Text(
        kCustomRegisterText,
        style: TextStyle(
          color: kCustomMailColor,
        ),
      ),
    );
  }
}
