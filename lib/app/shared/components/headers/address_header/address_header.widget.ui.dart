import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/pages/store/_home/home.page.dart';
import 'package:mercave/app/shared/components/buttons/whatsapp_button/whatsapp.button.component.dart';
import 'package:mercave/app/shared/constants/constant.service.dart';
import 'package:mercave/app/ui/constants.dart';

class AddressHeaderWidgetUI {
  final BuildContext context;
  final String title;
  final String subtitle;
  final Map userData;
  final bool userIsLogged;
  final Function onHeaderTitleTapped;
  final Function onUserIconTapped;
  final Function onCartIconTapped;
  final Function onSearchIconTapped;
  final bool showAnimatedWhatsApp;
  final bool enableGoBackBtn;

  int cartProductsQty;

  AddressHeaderWidgetUI(
      {this.context,
      this.title,
      this.userData,
      this.userIsLogged,
      this.subtitle,
      this.onHeaderTitleTapped,
      this.onUserIconTapped,
      this.onSearchIconTapped,
      this.onCartIconTapped,
      this.cartProductsQty,
      this.showAnimatedWhatsApp,
      this.enableGoBackBtn});

  build() {
    return Row(
      children: <Widget>[
        //Burger menu and Whatsapp Icons
        ...getLeftButtonsWidget(),
        SizedBox(width: 10.0),
        //Neighborhood and Address
        getCenterTextWidgets(),
        SizedBox(width: 10.0),
        //Search and Cart Icons
        ...getRightButtonsWidget(),
      ],
    );
  }

  List<Widget> getLeftButtonsWidget() {
    return <Widget>[
      getUserButtonWidget(),
      SizedBox(width: 10.0),
      getWhatsAppButtonWidget(),
    ];
  }

  getCenterTextWidgets() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getTitleTextWidget(),
          getSubtitleTextWidget(),
        ],
      ),
    );
  }

  List<Widget> getRightButtonsWidget() {
    return <Widget>[
      getSearchButtonWidget(),
      SizedBox(width: 5.0),
      getCartDetailButtonWidget(),
    ];
  }

  Widget getUserButtonWidget() {
    if (!enableGoBackBtn) {
      return InkWell(
          onTap: () {
            if (onUserIconTapped != null) {
              onUserIconTapped();
            }
          },
          child: Container(
            width: 37.0,
            height: 30.0,
            padding: EdgeInsets.fromLTRB(0, 0, 15, 1),
            child: Image.asset(
              'assets/icons/burger_menu.png',
              width: 30.0,
            ),
            //child: Icon(Icons.menu, size: 45),
          ));
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,   
            MaterialPageRoute(builder: (BuildContext context) => HomePage()), 
            ModalRoute.withName('/home')
          );
        },
        child: Image.asset(
          'assets/icons/back_arrow.png',
          width: 33.0,
        ),
      );
    }

    // String avatar;
    // if (userData != null) {
    //   avatar = userData['avatar'];
    // }

    // return InkWell(
    //   onTap: () {
    //     if (onUserIconTapped != null) {
    //       onUserIconTapped();
    //     }
    //   },
    //   child: avatar != null
    //       ? Container(
    //           width: 37.0,
    //           height: 37.0,
    //           decoration: new BoxDecoration(
    //             shape: BoxShape.circle,
    //             image: new DecorationImage(
    //               fit: BoxFit.fill,
    //               image: new NetworkImage(avatar),
    //             ),
    //           ),
    //         )
    //       : Image.asset(
    //           'assets/icons/person.png',
    //           width: 38.0,
    //         ),
    // );
  }

  Widget getWhatsAppButtonWidget() {
    return WhatsAppButtonComponent(
      showAnimatedWhatsApp: showAnimatedWhatsApp,
    );
  }

  Widget getSearchButtonWidget() {
    return InkWell(
      onTap: () {
        if (onSearchIconTapped != null) {
          onSearchIconTapped();
        }
      },
      child: Image.asset(
        'assets/icons/search.png',
        width: 38.0,
      ),
    );
  }

  Widget getCartDetailButtonWidget() {
    cartProductsQty ??= 0;

    return InkWell(
      onTap: () {
        onCartIconTapped();
      },
      child: Badge(
        badgeColor: kCustomPrimaryColor,
        badgeContent: Text(
          cartProductsQty.toString(),
          style: TextStyle(
            color: kCustomWhiteColor,
          ),
        ),
        child: Image.asset(
          'assets/icons/cart.png',
          width: 38.0,
        ),
      ),
    );
  }

  Widget getTitleTextWidget() {
    return GestureDetector(
      onTap: () {
        if (onHeaderTitleTapped != null) {
          onHeaderTitleTapped();
        }
      },
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kCustomBlackColor,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getSubtitleTextWidget() {
    return GestureDetector(
      onTap: () {
        if (onHeaderTitleTapped != null) {
          onHeaderTitleTapped();
        }
      },
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kCustomBlackColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
