import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/headers/address_header/address_header.widget.ui.dart';

class AddressHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Map userData;
  final bool userIsLogged;
  final int cartProductsQty;
  final Function onHeaderTitleTapped;
  final Function onUserIconTapped;
  final Function onCartIconTapped;
  final Function onSearchIconTapped;
  final bool showAnimatedWhatsApp;

  AddressHeaderWidget(
      {this.title,
      this.subtitle,
      this.userData,
      this.userIsLogged,
      this.onHeaderTitleTapped,
      this.onUserIconTapped,
      this.onSearchIconTapped,
      this.onCartIconTapped,
      this.cartProductsQty,
      this.showAnimatedWhatsApp});

  @override
  Widget build(BuildContext context) {
    return AddressHeaderWidgetUI(
      context: context,
      title: title,
      subtitle: subtitle,
      userData: userData,
      userIsLogged: userIsLogged,
      cartProductsQty: cartProductsQty,
      showAnimatedWhatsApp: showAnimatedWhatsApp,
      onHeaderTitleTapped: () {
        if (onHeaderTitleTapped != null) {
          onHeaderTitleTapped();
        }
      },
      onUserIconTapped: () {
        if (onUserIconTapped != null) {
          onUserIconTapped();
        }
      },
      onSearchIconTapped: () {
        if (onSearchIconTapped != null) {
          onSearchIconTapped();
        }
      },
      onCartIconTapped: () {
        onCartIconTapped();
      },
    ).build();
  }
}
