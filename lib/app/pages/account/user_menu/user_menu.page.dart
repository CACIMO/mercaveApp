import 'package:flutter/material.dart';
import 'package:mercave/app/pages/store/_home/home.page.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail_stepper.dart';
import 'package:package_info/package_info.dart';

import 'package:mercave/app/core/services/api/woocommerce/order/wc_order.api.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/pages/account/user_form/user_form.page.dart';
import 'package:mercave/app/pages/account/user_orders/order_list/order_list.page.dart';
import 'package:mercave/app/pages/account/coupon/coupon_page.dart';
import 'package:mercave/app/ui/constants.dart';

class UserMenuPage extends StatefulWidget {
  @override
  _UserMenuPageState createState() => _UserMenuPageState();
}

class _UserMenuPageState extends State<UserMenuPage> {
  int ordersCount;
  String firstName;
  String avatar;
  bool showRedirectToOrderWhenLogin = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserData();
    });
  }

  Future<void> _getUserData() async {
    int userId = await AuthService.getUserIdLogged();
    Map userData = await UserDBService.getUserById(id: userId);
    if (!mounted) return;
    if (userData != null) {
      setState(() {
        firstName = userData['first_name'];
        avatar = userData['avatar'];
      });

      List orders = await WCOrderAPIService().getOrdersByUserId(userId: userId);
      if (!mounted) return;

      setState(() {
        ordersCount = orders.length;
      });
    } else {
      setState(() {
        firstName = null;
        avatar = null;
      });
    }

    this._validateRedirectToOrderWhenLogin(context);
  }

  void _validateRedirectToOrderWhenLogin(BuildContext context) {
    if (!showRedirectToOrderWhenLogin) {
      return;
    }

    setState(() {
      showRedirectToOrderWhenLogin = false;
    });

    SessionService.getItem(key: 'redirectToOrderWhenLogin').then((value) {
      if (value != null) {
        AlertService.showConfirmAlert(
          context: context,
          title: 'Pedido en proceso',
          description:
              'En el momento usted tiene un pedido en proceso. Desea ir a realizar el pedido?',
          onTapOk: () async {
            AlertService.dismissAlert(context: context);
            await SessionService.removeItem(key: 'redirectToOrderWhenLogin');

            Navigator.push(
              context,
              MaterialPageRoute(
                //builder: (context) => CartOrderDetailPage(),
                builder: (context) => OrderDetailStepper(),
              ),
            );
          },
          onTapCancel: () async {
            await SessionService.removeItem(key: 'redirectToOrderWhenLogin');
          },
        );
      }
    });
  }

  Future<void> _openUserAccount() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserFormPage()),
    );
    _getUserData();
  }

  void _openUserOrders() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderListPage()),
    );
  }

  void openHomePage() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _openCouponPage() {
    Navigator.of(context).push(CouponPage.route());
  }

  void _openLogOutDialog() {
    AlertService.showConfirmAlert(
      context: context,
      title: 'Salir',
      description: 'En realidad deseas salir de tu sesión?',
      onTapOk: () async {
        await SessionService.removeItem(
          key: AuthService.USER_ID_LOGGED_KEY,
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _validateRedirectToOrderWhenLogin(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return Future.value(false);
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: DividerThemeData(space: 2.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _getAppBarWidget(context),
          body: _getBodyWidget(context),
          bottomNavigationBar: const _LogoVersionWidget(),
        ),
      ),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kCustomWhiteColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 26.0,
        onPressed: () {
          openHomePage();
        },
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8.0),
          _getUserHeaderInfoWidget(context),
          _getDividerWidget(context),
          _getMenuItemsWidget(context),
        ],
      ),
    );
  }

  Widget _getUserHeaderInfoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          _getUserAvatarWidget(context),
          const SizedBox(width: 15.0),
          _getUserInfoWidget(context),
        ],
      ),
    );
  }

  Widget _getUserAvatarWidget(BuildContext context) {
    Widget widget;

    if (avatar != null) {
      widget = Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(avatar),
          ),
        ),
      );
    } else {
      widget = Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/icons/person.png'),
          ),
        ),
      );
    }
    return widget;
  }

  Widget _getUserInfoWidget(BuildContext context) {
    return Container(
      child: Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            firstName != null
                ? Text(
                    firstName,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _getMenuItemsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          _MenuItemView(
            asset: 'assets/icons/person.png',
            title: 'Tu cuenta',
            onTap: _openUserAccount,
          ),
          const Divider(),
          _MenuItemView(
            asset: 'assets/icons/order.png',
            title: 'Tus pedidos',
            onTap: _openUserOrders,
          ),
          const Divider(),
          _MenuItemView(
            asset: 'assets/icons/cart.png',
            title: 'Comprar Ahora',
            onTap: openHomePage,
          ),
          const Divider(),
          _MenuItemView(
            asset: 'assets/icons/coupon.png',
            title: 'Cupón de referido',
            onTap: _openCouponPage,
          ),
          const Divider(),
          _CouponAdView(onTap: _openCouponPage),
          const Divider(),
          _MenuItemView(
            asset: 'assets/icons/logout_colored.png',
            title: 'Cerrar sesión',
            showNavIcon: false,
            onTap: _openLogOutDialog,
          ),
        ],
      ),
    );
  }

  Widget _getDividerWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Container(
        height: 1.0,
        width: MediaQuery.of(context).size.width,
        color: kCustomGrayColor,
      ),
    );
  }
}

class _MenuItemView extends StatelessWidget {
  final String asset;
  final String title;
  final VoidCallback onTap;
  final bool showNavIcon;

  const _MenuItemView({
    Key key,
    @required this.asset,
    @required this.title,
    @required this.onTap,
    this.showNavIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
        asset,
        width: 38.0,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: showNavIcon ? kCustomStrongGrayColor : kCustomPrimaryColor,
          fontSize: 18.0,
        ),
      ),
      trailing: Visibility(
        visible: showNavIcon,
        child: Icon(
          Icons.chevron_right,
          size: 30.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _LogoVersionWidget extends StatelessWidget {
  const _LogoVersionWidget();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8.0),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            var versionName = '0.0.0';
            if (snapshot.hasData) {
              versionName = snapshot.data.version;
            }
            return Text(
              'Versión $versionName',
              style: TextStyle(fontSize: 12.0),
            );
          },
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}

class _CouponAdView extends StatelessWidget {
  final VoidCallback onTap;

  const _CouponAdView({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.0);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 5 / 2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 6.0),
                blurRadius: 6.0,
                spreadRadius: 3,
                color: kCustomPrimaryColor.withOpacity(0.20),
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.8],
              colors: [
                kCustomSecondaryColor,
                kCustomPrimaryColor,
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              splashColor: Colors.white12,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kCustomSecondaryColor,
                            width: 2.0,
                          ),
                        ),
                        child: Image.asset(
                          'assets/icons/logo_mercave_round.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r'Gana $5.000',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'por cada amigo que\nrefieras',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
