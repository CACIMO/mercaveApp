import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/app/config.api.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/core/services/woocommerce/woocommerce.service.dart';
import 'package:mercave/app/pages/account/address/address.page.dart';
import 'package:mercave/app/pages/account/login/login.page.dart';
import 'package:mercave/app/pages/account/register/register.page.dart';
import 'package:mercave/app/pages/store/cart/delivery_date/delivery_date.page.dart';
import 'package:mercave/app/pages/store/cart/gateway/gateway.page.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail.controller.dart';
import 'package:mercave/app/pages/store/cart/payment_method/payment_method.page.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class CartOrderDetailPage extends StatefulWidget {
  @override
  _CartOrderDetailState createState() => _CartOrderDetailState();
}

class _CartOrderDetailState extends State<CartOrderDetailPage> {
  String neighborhood = '';
  String address = '';
  double total = 0.0;
  double saved = 0.0;
  double couponDiscountTotal;

  double subtotalResume = 0.0;
  double totalResume = 0.0;
  double savedResume = 0.0;

  List menuItems = [];
  Map userData;
  bool userIsLogged = false;
  String shippingDay;
  double toPayWithCash = 0;
  Map couponData;
  String couponError;

  String paymentMethodOrderText;
  String paymentMethod;
  String subPaymentMethod;
  String clientType;
  String billingName;
  String billingIdentificationType;
  String billingIdentificationNumber;

  TextEditingController orderNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getCartData();
  }

  void _getUserData() async {
    int userId = await AuthService.getUserIdLogged();
    userData = await UserDBService.getUserById(id: userId);
    setState(() {});

    address = '- # -';
    neighborhood = 'No definido';

    if (userData != null) {
      if (userId > 0)
        setState(() {
          userIsLogged = true;
        });

      if (userData['neighborhood'] != null && userData['neighborhood'] != '') {
        setState(() {
          neighborhood = userData['neighborhood'];
        });
      }

      if (userData['type_of_road'] != null) {
        setState(() {
          address = userData['type_of_road'] +
              ' ' +
              userData['plate_part_1'] +
              ' # ' +
              userData['plate_part_2'] +
              ' -' +
              userData['plate_part_3'];
        });
      }
    }

    paymentMethodOrderText = 'No definido';
    paymentMethod = userData['payment_method'];

    if (paymentMethod != null) {
      paymentMethod = userData['payment_method'];
      subPaymentMethod = userData['subpayment_method'];
      clientType = userData['client_type'];
      billingName = userData['billing_name'];
      billingIdentificationType = userData['billing_identification_type'];
      billingIdentificationNumber = userData['billing_identification_number'];

      /// ======================================================================
      /// Get the payment method text
      /// ======================================================================
      if (paymentMethod == 'upon-delivery') {
        paymentMethodOrderText = 'Contraentrega';
      } else if (paymentMethod == 'online') {
        paymentMethodOrderText = 'En línea';
      }

      /// ======================================================================
      /// Get the payment method text
      /// ======================================================================
      if (subPaymentMethod == 'cash') {
        paymentMethodOrderText += ' - Efectivo';
      } else if (subPaymentMethod == 'dataphone') {
        paymentMethodOrderText += ' - Datafono';
      }

      /// ======================================================================
      /// Get the billing info
      /// ======================================================================
      paymentMethodOrderText +=
          '\n$billingIdentificationType $billingIdentificationNumber - '
          '$billingName';
    }

    /// ======================================================================
    /// Get the shipping date and the order notes
    /// ======================================================================
    shippingDay = await SessionService.getItem(key: 'shipping_day');
    orderNotesController.text = await SessionService.getItem(key: 'orderNotes');

    setState(() {});
  }

  void _getCartData() {
    CartService.getCart().then((cart) {
      setState(() {
        total = cart['cart_total'];
        saved = cart['amount_saved'];

        _updateCartWithCoupon();
      });
    }).catchError((error) {});
  }

  void _updateCartWithCoupon() async {
    String couponDataSession = await SessionService.getItem(key: 'couponData');

    if (couponDataSession != null) {
      setState(() {
        couponData = json.decode(couponDataSession);
      });
    } else {
      setState(() {
        couponData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String couponSubtitle = '';
    couponDiscountTotal = null;

    if (couponData != null) {
      String discountType = couponData['discount_type'];
      double discountQuantity = double.tryParse(couponData['amount']);

      couponError = OrderDetailController().getCouponError(
        couponData: couponData,
        cartTotal: total,
      );

      if (discountType == 'percent') {
        couponSubtitle += ' -$discountQuantity %';
      } else if (discountType == 'fixed_cart') {
        couponSubtitle += ' -\$ $discountQuantity';
      }

      if (couponError == null) {
        if (discountType == 'percent') {
          couponDiscountTotal = total * discountQuantity / 100;
        } else if (discountType == 'fixed_cart') {
          couponDiscountTotal = discountQuantity;
        }
      }
    }

    menuItems = [
      {
        'left_icon': FontAwesomeIcons.home,
        'title': Text(
          'Dirección: ' + address.toString(),
          style: TextStyle(
            color: kCustomStrongGrayColor,
            fontSize: 13.0,
          ),
        ),
        'subtitle': 'Cali - Barrio ' + neighborhood,
        'on_tap': () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressPage(),
            ),
          );

          _getUserData();
        },
      },
      {
        'left_icon': FontAwesomeIcons.solidCalendarAlt,
        'title': Text(
          'Entrega: ' + (shippingDay != null ? shippingDay : 'No definida'),
          style: TextStyle(
            color: kCustomStrongGrayColor,
            fontSize: 13.0,
          ),
        ),
        'on_tap': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliveryDatePage(),
              ));

          _getUserData();
        },
      },
      {
        'left_icon': FontAwesomeIcons.solidCreditCard,
        'title': Text(
          'Pago: ' + (paymentMethodOrderText ?? ''),
          style: TextStyle(
            color: kCustomStrongGrayColor,
            fontSize: 13.0,
          ),
        ),
        'on_tap': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentMethodPage(),
              ));

          _getUserData();
        },
      },
      {
        'left_icon': FontAwesomeIcons.ticketAlt,
        'title': Text(
          couponData != null
              ? couponData['code'].toUpperCase() +
                  ': ' +
                  couponSubtitle +
                  ' ' +
                  (couponError != null ? couponError : '')
              : 'Agregar créditos o cupón',
          style: TextStyle(
            color: couponError != null ? Colors.red : kCustomStrongGrayColor,
            fontSize: 13.0,
          ),
        ),
        'on_tap': () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CouponDialog(
                  couponData: couponData,
                  cartTotal: total,
                  savedValidCoupon: (coupon) async {
                    if (coupon != null) {
                      await SessionService.setItem(
                        key: 'couponData',
                        value: json.encode(coupon),
                      );
                    }

                    _updateCartWithCoupon();
                  },
                  removeValidCoupon: () async {
                    await SessionService.removeItem(key: 'couponData');
                    _updateCartWithCoupon();
                  },
                );
              });
        },
      },
      {
        'left_icon': null,
        'title': _getPayWithCash(context: context),
        'on_tap': () {},
      },
      {
        'left_icon': null,
        'title': _getOrderNotesField(context: context),
        'on_tap': () {},
      },
    ];

    return Scaffold(
      appBar: _getAppBarWidget(context),
      body: _getBodyWidget(context),
      bottomNavigationBar: _getCartResumeWidget(context: context),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kCustomWhiteColor,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/icons/back_arrow.png',
                    width: 25.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Confirmar Pedido'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return _getMenuItemsWidget(context: context);
  }

  Widget _getMenuItemsWidget({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.separated(
        itemCount: menuItems.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
          height: 1.0,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            leading: menuItems[index]['left_icon'] != null
                ? Icon(
                    menuItems[index]['left_icon'],
                    color: kCustomPrimaryColor,
                  )
                : null,
            title: menuItems[index]['title'],
            subtitle: menuItems[index]['subtitle'] != null
                ? Text(menuItems[index]['subtitle'])
                : null,
            trailing: Visibility(
              visible: index + 2 < menuItems.length,
              child: Icon(
                Icons.chevron_right,
                size: 30.0,
                color: Colors.black,
              ),
            ),
            onTap: () {
              menuItems[index]['on_tap']();
            },
          );
        },
      ),
    );
  }

  Widget _getOrderNotesField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Notas de la orden',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: kCustomPrimaryColor,
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: orderNotesController,
            maxLines: 1,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderSide: new BorderSide(
                  color: kCustomPrimaryColor,
                ),
              ),
              hintText: 'Ingrese las notas de la orden. e.j. indicaciones'
                  ' para llegar a la dirección de entrega, etc.',
              hintStyle: TextStyle(
                fontSize: 14.0,
              ),
            ),
            onChanged: (text) async {
              await SessionService.setItem(
                key: 'orderNotes',
                value: text,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getPayWithCash({BuildContext context}) {
    return Visibility(
      visible: subPaymentMethod == 'cash',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Text(
              'A pagar con \$:',
              style: TextStyle(
                color: kCustomPrimaryColor,
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  // ignore: deprecated_member_use
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onChanged: (text) async {
                  setState(() {
                    toPayWithCash = double.tryParse(text);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCartResumeWidget({BuildContext context}) {
    subtotalResume = total;
    totalResume = total;
    savedResume = saved;

    if (couponDiscountTotal != null) {
      totalResume -= couponDiscountTotal;
      savedResume += couponDiscountTotal;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ColoredBox(
        color: kCustomWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      color: kCustomGrayColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'Al finalizar la compra estarás aceptando los ' +
                              'términos y condiciones',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      'Subtotal:',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomBlackColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      StringService.getPriceFormat(number: subtotalResume),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomBlackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      'Costo domicilio:',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomBlackColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      StringService.getPriceFormat(number: 4000.0),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomBlackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: couponDiscountTotal != null,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Text(
                        'Descuento Cupón:',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kCustomBlackColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Text(
                        StringService.getPriceFormat(
                          number: couponDiscountTotal,
                        ),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kCustomBlackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      StringService.getPriceFormat(number: totalResume),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      'Estás ahorrando:',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomPrimaryColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      StringService.getPriceFormat(number: savedResume),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                height: 50.0,
                minWidth: MediaQuery.of(context).size.width,
                child: RoundButtonWidget(
                  text: 'Finalizar compra',
                  onPressed: () async {
                    String errorMessage = '';
                    LoaderService.showLoader(
                        context: context, text: 'Validando información...');

                    /// ====================================================
                    /// Se valida si el usuario se encuentra logueado.
                    /// ====================================================
                    await SessionService.removeItem(
                      key: 'redirectToOrderWhenLogin',
                    );

                    if (!userIsLogged) {
                      await SessionService.setItem(
                        key: 'redirectToOrderWhenLogin',
                        value: '1',
                      );

                      LoaderService.dismissLoader(context: context);
                      AlertService.showNoLoginAlert(
                          context: context,
                          title: 'Usuario no logueado',
                          description:
                              'Para poder realizar un pedido debe estar ' +
                                  'logueado primero',
                          onTapLogin: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          onTapRegister: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          });
                      return;
                    }

                    Map config = await ConfigAPIService.getConfig();
                    var orderNotes = await SessionService.getItem(
                      key: 'orderNotes',
                    );

                    /// ====================================================
                    /// Se valida si existe un error con el cupón
                    /// ====================================================
                    if (couponData != null) {
                      try {
                        await OrderDetailController().validateCoupon(
                          couponCode: couponData['code'],
                          cartTotal: total,
                        );
                      } catch (e) {
                        LoaderService.dismissLoader(context: context);

                        AlertService.showErrorAlert(
                          context: context,
                          title: 'Error al validar el cupón',
                          description: e,
                        );

                        return;
                      }

                      String orderCouponError =
                          OrderDetailController().getCouponError(
                        couponData: couponData,
                        cartTotal: total,
                      );

                      if (orderCouponError != null) {
                        LoaderService.dismissLoader(context: context);

                        AlertService.showErrorAlert(
                          context: context,
                          title: 'Error',
                          description: orderCouponError,
                        );

                        return;
                      }
                    }

                    /// ====================================================
                    /// Se valida el valor mínimo del pedido por contra
                    /// entrega.
                    /// ====================================================
                    if (paymentMethod == 'upon-delivery') {
                      if (subPaymentMethod == 'cash' &&
                          config['min_order_value_in_cash'] != null &&
                          subtotalResume < config['min_order_value_in_cash']) {
                        LoaderService.dismissLoader(context: context);

                        AlertService.showErrorAlert(
                          context: context,
                          title: 'Error valor mínimo',
                          description: 'El valor mínimo del pedido para pago '
                                  'contraentrega en efectivo es de: \n\n' +
                              StringService.getPriceFormat(
                                number: double.parse(
                                  config['min_order_value_in_cash'].toString(),
                                ),
                              ) +
                              '.',
                        );
                        return;
                      } else if (subPaymentMethod == 'dataphone' &&
                          config['min_order_value_in_dataphone'] != null &&
                          subtotalResume <
                              config['min_order_value_in_dataphone']) {
                        LoaderService.dismissLoader(context: context);

                        AlertService.showErrorAlert(
                          context: context,
                          title: 'Error valor mínimo',
                          description: 'El valor mínimo del pedido para pago '
                                  'contraentrega con datafono es de: \n\n' +
                              StringService.getPriceFormat(
                                number: double.parse(
                                  config['min_order_value_in_dataphone']
                                      .toString(),
                                ),
                              ) +
                              '.',
                        );
                        return;
                      } else if (paymentMethod == 'upon-delivery' &&
                          subtotalResume < config['min_order_value_in_cash']) {
                        LoaderService.dismissLoader(context: context);

                        AlertService.showErrorAlert(
                          context: context,
                          title: 'Error valor mínimo',
                          description: 'El valor mínimo del pedido para pago '
                                  'contraentrega es de: \n\n' +
                              StringService.getPriceFormat(
                                number: double.parse(
                                  config['min_order_value_in_cash'].toString(),
                                ),
                              ) +
                              '.',
                        );
                        return;
                      }
                    }

                    /// ====================================================
                    /// Se valida el valor mínimo del pedido por medio
                    /// online.
                    /// ====================================================
                    if (paymentMethod == 'online' &&
                        subtotalResume < config['min_order_value_online']) {
                      LoaderService.dismissLoader(context: context);
                      AlertService.showErrorAlert(
                        context: context,
                        title: 'Error valor mínimo',
                        description: 'El valor mínimo del pedido para pago en '
                                'línea es de: \n\n' +
                            StringService.getPriceFormat(
                              number: double.parse(
                                config['min_order_value_online'].toString(),
                              ),
                            ) +
                            '.',
                      );
                      return;
                    }

                    /// ====================================================
                    /// Se valida que el usuario haya ingresado todos los
                    /// campos.
                    /// ====================================================
                    if (shippingDay == null) {
                      errorMessage = ' - Fecha de entrega.';
                    }

                    if (paymentMethod == null) {
                      errorMessage = ' - Método de pago.';
                    }

                    /// Se valida el ingreso de la dirección
                    if (userData['neighborhood'] == null ||
                        userData['neighborhood'] == '' ||
                        userData['type_of_road'] == null ||
                        userData['type_of_road'] == '' ||
                        userData['plate_part_1'] == null ||
                        userData['plate_part_1'] == '' ||
                        userData['plate_part_2'] == null ||
                        userData['plate_part_2'] == '' ||
                        userData['plate_part_3'] == null ||
                        userData['plate_part_3'] == '') {
                      errorMessage += '\n - Dirección completa.';
                    }

                    /// Se valida si el pago se va a realizar con efectivo
                    /// que el valor con el cual se va a pagar sea valido
                    if (subPaymentMethod == 'cash') {
                      if (toPayWithCash == null) {
                        errorMessage +=
                            '\n - Valor valido a pagar con efectivo.';
                      } else {
                        if (toPayWithCash < totalResume) {
                          LoaderService.dismissLoader(context: context);

                          AlertService.showErrorAlert(
                            context: context,
                            title: 'Error',
                            description: 'El valor total de la compra es de ' +
                                StringService.getPriceFormat(number: total) +
                                ' ' +
                                ' y usted va a pagar con ' +
                                StringService.getPriceFormat(
                                    number: toPayWithCash) +
                                '. \n\nIngrese un valor mayor o igual al '
                                    'valor total de la compra.',
                          );

                          return;
                        }

                        await SessionService.setItem(
                          key: 'toPayWithCash',
                          value: toPayWithCash.toString(),
                        );
                      }
                    }

                    if (errorMessage != null && errorMessage != '') {
                      LoaderService.dismissLoader(context: context);

                      AlertService.showErrorAlert(
                        context: context,
                        title: 'Error',
                        description:
                            'Por favor ingrese la siguiente información:\n\n' +
                                errorMessage,
                      );

                      return;
                    }

                    /// ====================================================
                    /// Se confirma si el usuario en realidad desea crear
                    /// el pedido.
                    /// ====================================================
                    LoaderService.dismissLoader(context: context);
                    AlertService.showConfirmAlert(
                      context: context,
                      title: 'Crear Pedido?',
                      description:
                          'Antes de crear el pedido por favor valide la ' +
                              'información ingresada.\n\nEn realidad desea ' +
                              'crear el pedido?',
                      onTapCancel: () {},
                      onTapOk: () async {
                        LoaderService.showLoader(
                          context: context,
                          text: 'Finalizando pedido',
                        );

                        try {
                          /// ==============================================
                          /// Se valida la existencia de los productos
                          /// ==============================================
                          Map validProductsResponse =
                              await OrderDetailController()
                                  .validateCartProductsInStock(
                            context: context,
                          );

                          if (!validProductsResponse['validProducts']) {
                            LoaderService.dismissLoader(context: context);

                            AlertService.showDynamicErrorAlert(
                              context: context,
                              title: Text(
                                'Productos sin existencia',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              description: Text(
                                validProductsResponse['message'],
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            );

                            return;
                          }

                          /// ==============================================
                          /// Se crea la orden
                          /// ==============================================
                          var orderCreatedData = await WooCommerceService()
                              .saveOrder(
                                  couponData: couponData,
                                  couponDiscountTotal: couponDiscountTotal);

                          var toPayWithText = '';
                          if (subPaymentMethod == 'cash') {
                            toPayWithText = 'A pagar con: ' +
                                StringService.getPriceFormat(
                                    number: toPayWithCash);
                          }

                          await WooCommerceService().saveOrderNote(
                            orderId: orderCreatedData['id'],
                            orderNote: 'Notas generales: ' +
                                (orderNotes ??= 'No hay notas') +
                                '. ' +
                                'Pago ' +
                                paymentMethodOrderText +
                                '. ' +
                                toPayWithText,
                          );

                          LoaderService.dismissLoader(
                            context: context,
                          );

                          /// ==============================================
                          /// Se limpia la información del carrito
                          /// ==============================================
                          await CartProductDBService.deleteCartProducts(
                            cartId: 1,
                          );

                          await SessionService.removeItem(key: 'couponData');

                          /// ==============================================
                          /// Se limpia la información de la orden
                          /// ==============================================
                          await SessionService.removeItem(
                              key: 'deliveryDayIdSelected');
                          await SessionService.removeItem(
                              key: 'deliveryHourIdSelected');
                          await SessionService.removeItem(
                              key: 'deliveryDateSelected');
                          await SessionService.removeItem(
                              key: 'deliverFromHourSelected');
                          await SessionService.removeItem(
                              key: 'deliverToHourSelected');
                          await SessionService.removeItem(key: 'shipping_day');

                          await SessionService.removeItem(
                            key: 'toPayWithCash',
                          );

                          String redirectText = '';
                          if (paymentMethod == 'online') {
                            redirectText = '\n\nNOTA: En un momento será '
                                'redirigido a nuestra aplicación web '
                                'para que puede realizar el pago de la '
                                'orden desde la plataforma TuCompra.';
                          }

                          if (paymentMethod != 'online') {
                            AlertService.showErrorAlert(
                                context: context,
                                title: 'Pedido No. ' +
                                    orderCreatedData['id'].toString(),
                                description:
                                    'Su pedido ha sido realizado exitosamente.' +
                                        redirectText,
                                onClose: () {
                                  Navigator.of(context).popUntil(
                                    (route) => route.isFirst,
                                  );
                                });
                          }

                          await SessionService.removeItem(
                            key: 'orderNotes',
                          );

                          await SessionService.setItem(
                            key: 'reloadHomePage',
                            value: '1',
                          );

                          /// ==============================================
                          /// Si el método de pago es tucompra se realiza
                          /// una redirección a la aplicación web para
                          /// realizar el pago.
                          /// ==============================================
                          if (paymentMethod == 'online') {
                            String orderId = orderCreatedData['id'].toString();
                            String orderKey = orderCreatedData['order_key'];
                            String redirectUrl =
                                'https://www.mercave.com.co/finalizar-compra/?key=$orderKey&order-pay=$orderId';
                            print(redirectUrl);

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GatewayPage(
                                  checkoutUrl: redirectUrl,
                                  orderId: orderId,
                                ),
                              ),
                            );

                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            );
                            /*
                            Future.delayed(
                                const Duration(milliseconds: 3000),
                                () async {
                              String orderId =
                                  orderCreatedData['id'].toString();
                              String orderKey =
                                  orderCreatedData['order_key'];
                              String redirectUrl =
                                  'https://www.mercave.com.co/finalizar-compra/order-pay/$orderId/?key=$orderKey&from_mobile_app=true';
                              if (await canLaunch(redirectUrl)) {
                                await launch(
                                  redirectUrl,
                                  forceSafariVC: false,
                                );

                                Navigator.of(context).popUntil(
                                  (route) => route.isFirst,
                                );
                              }
                            });
                             */
                          }
                        } catch (e) {
                          LoaderService.dismissLoader(context: context);

                          AlertService.showErrorAlert(
                            context: context,
                            title: 'Error al crear el pedido',
                            description: e.message,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponDialog extends StatefulWidget {
  final Map couponData;
  final double cartTotal;
  final Function savedValidCoupon;
  final Function removeValidCoupon;

  CouponDialog({
    @required this.couponData,
    @required this.cartTotal,
    @required this.savedValidCoupon,
    @required this.removeValidCoupon,
  });

  @override
  _CouponDialogState createState() => _CouponDialogState();
}

class _CouponDialogState extends State<CouponDialog> {
  TextEditingController couponTextController = TextEditingController();
  String couponError;
  String couponCode;
  Map couponData;

  @override
  void initState() {
    super.initState();
    couponData = widget.couponData;
    init();
  }

  init() {
    couponTextController.text = '';

    setState(() {
      couponError = null;
      couponCode = null;
    });

    if (couponData != null) {
      couponCode = couponData['code'].toUpperCase();
      couponTextController.text = couponCode;

      setState(() {
        couponError = OrderDetailController().getCouponError(
          couponData: couponData,
          cartTotal: widget.cartTotal,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      title: Text(
        'Cupón',
        style: TextStyle(
          color: kCustomPrimaryColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          couponData != null
              ? Row(
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onTap: () {
                        widget.removeValidCoupon();
                        couponData = null;
                        init();
                      },
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      couponData['code'].toUpperCase(),
                      style: TextStyle(
                        color: kCustomPrimaryColor,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Ingrese el código del cupón a utilizar:',
                ),
          SizedBox(height: 10.0),
          TextField(
            autofocus: true,
            cursorColor: kCustomPrimaryColor,
            controller: couponTextController,
            maxLines: 1,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderSide: new BorderSide(
                  color: kCustomPrimaryColor,
                ),
              ),
              hintText: 'Ej. NG7EZCA3',
              hintStyle: TextStyle(
                fontSize: 14.0,
              ),
            ),
            onChanged: (text) async {
              setState(() {
                couponCode = text;
              });
            },
          ),
          Visibility(
            visible: couponError != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                couponError != null ? couponError : '',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            AlertService.dismissAlert(context: context);
          },
          child: Text('Cerrar'),
        ),
        TextButton(
          onPressed: () async {
            if (couponCode != null && couponCode != '') {
              LoaderService.showLoader(
                  context: context, text: 'Validando cupón...');

              try {
                final coupon = await OrderDetailController().validateCoupon(
                  couponCode: couponCode,
                  cartTotal: widget.cartTotal,
                );
                widget.savedValidCoupon(coupon);
                LoaderService.dismissLoader(context: context);
                AlertService.dismissAlert(context: context);
              } catch (error) {
                if (error is String) {
                  setState(() {
                    couponError = error;
                  });
                } else {
                  setState(() {
                    couponError = 'Algo salió mal, intenta de nuevo.';
                  });
                }
                LoaderService.dismissLoader(context: context);
              }
            }
          },
          child: Text('Validar'),
        ),
      ],
    );
  }
}
