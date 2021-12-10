import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/config.api.service.dart';
import 'package:mercave/app/core/services/app/shipping.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/core/services/woocommerce/woocommerce.service.dart';
import 'package:mercave/app/core/services/wordpress/wodpress.service.dart';
import 'package:mercave/app/pages/account/login/login.page.dart';
import 'package:mercave/app/pages/account/register/register.page.dart';
import 'package:mercave/app/pages/store/cart/gateway/gateway.page.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail.controller.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';

class OrderDetailStepperController {
  static Future saveStepOneDataToLocalStorage(
      String selectedNeighborhood,
      String selectedStreet,
      String textCtrlPlatePart1,
      String textCtrlPlatePart2,
      String textCtrlPlatePart3,
      String textCtrlAdditionalInfo,
      int userId,
      BuildContext context,
      bool showLoadingNotification) async {
    //Address information is requested in the AddressPage and the OrderDetailSteper components but
    //this loading notifications is only required to be displayed on the Address Page Component
    if (showLoadingNotification) {
      LoaderService.showLoader(
        context: context,
        text: 'Guardando...',
      );
    }

    try {
      Map userData = {
        'id': userId,
        'neighborhood': selectedNeighborhood,
        'type_of_road': selectedStreet,
        'plate_part_1': textCtrlPlatePart1,
        'plate_part_2': textCtrlPlatePart2,
        'plate_part_3': textCtrlPlatePart3,
        'address_info': textCtrlAdditionalInfo
      };

      /// ==================================================================
      /// Update wordPress meta user info
      /// ==================================================================
      if (userId > 0) {
        dynamic metadata = {
          "barrio": selectedNeighborhood,
          "via": selectedStreet,
          "placa_no_1": textCtrlPlatePart1,
          "placa_no_2": textCtrlPlatePart2,
          "placa_no_3": textCtrlPlatePart3,
          "informacion_direccion": textCtrlAdditionalInfo,
        };

        await WordPressService.updateWordPressUserMetadata(
          userId: userId,
          metadata: metadata,
        );
      }

      /// ==================================================================
      /// Update local user info
      /// ==================================================================
      await UserDBService.createUpdateUser(
        userData: userData,
      );

      if (showLoadingNotification) {
        LoaderService.dismissLoader(context: context);
      }

      return Future.value(true);
    } catch (e) {
      if (showLoadingNotification) {
        LoaderService.dismissLoader(context: context);

        AlertService.showErrorAlert(
          context: context,
          title: 'Error',
          description: e.message,
          onClose: () {},
        );
      }

      return Future.error(false);
    }
  }

  static saveStepTwoDataToLocalStorage(
      List deliveryDays, String dayIdSelected, String hourIdSelected) async {
    Map daySelected = deliveryDays
        .where((deliveryDay) => deliveryDay['id'] == dayIdSelected)
        .toList()[0];
    Map hourSelected = daySelected['horarios_de_entrega']
        .where((deliveryHour) => deliveryHour['id'] == hourIdSelected)
        .toList()[0];

    String deliveryDate = daySelected['nombre_dia'] +
        ' ' +
        daySelected['dia'] +
        ' de ' +
        daySelected['nombre_mes'] +
        ', ' +
        daySelected['anio'] +
        ' de ' +
        hourSelected['hora_inicio'] +
        ' a ' +
        hourSelected['hora_fin'];

    await SessionService.setItem(
      key: 'deliveryDayIdSelected',
      value: dayIdSelected,
    );

    await SessionService.setItem(
      key: 'deliveryHourIdSelected',
      value: hourIdSelected,
    );

    await SessionService.setItem(
      key: 'deliveryDateSelected',
      value: daySelected['fecha_entrega'],
    );

    await SessionService.setItem(
      key: 'deliveryFromHourSelected',
      value: hourSelected['hora_desde'],
    );

    await SessionService.setItem(
      key: 'deliveryToHourSelected',
      value: hourSelected['hora_hasta'],
    );

    await SessionService.setItem(key: 'shipping_day', value: deliveryDate);
  }

  static saveStepThreeDataToLocalStorage(
      BuildContext context, int userId, String paymentMethodSelected) async {
    LoaderService.showLoader(
      context: context,
      text: 'Guardando...',
    );

    try {
      /// ==================================================================
      /// Update local user info
      /// ==================================================================
      Map userData = {
        'id': userId,
        'payment_method': paymentMethodSelected,
      };

      await UserDBService.createUpdateUser(
        userData: userData,
      );

      LoaderService.dismissLoader(context: context);
    } catch (e) {
      LoaderService.dismissLoader(context: context);

      AlertService.showErrorAlert(
        context: context,
        title: 'Error al actualizar la información de facturación.',
        description: e.message,
      );
    }
  }

  static saveStepFourDataToLocalStorage(BuildContext context,
      Map userBilledData, int userId, String customerTypeSelected) async {
    LoaderService.showLoader(
      context: context,
      text: 'Guardando...',
    );

    try {
      /// ==================================================================
      /// Update local user info
      /// ==================================================================
      Map userData = {
        'id': userId,
        'client_type': customerTypeSelected,
        'billing_name': userBilledData['full_name'],
        'billing_identification_type': userBilledData['identification_type'],
        'billing_identification_number':
            userBilledData['identification_number'],
      };

      await UserDBService.createUpdateUser(
        userData: userData,
      );

      LoaderService.dismissLoader(context: context);
    } catch (e) {
      LoaderService.dismissLoader(context: context);

      AlertService.showErrorAlert(
        context: context,
        title: 'Error al actualizar la información de facturación.',
        description: e.message,
      );
    }
  }

  static setLoggedInUserData(
      Map userData, int userId, BuildContext context) async {
    await saveStepOneDataToLocalStorage(
        userData['neighborhood'],
        userData['type_of_road'],
        userData['plate_part_1'],
        userData['plate_part_2'],
        userData['plate_part_3'],
        userData['address_info'],
        userId,
        context,
        false);
    await saveStepThreeDataToLocalStorage(
        context, userId, userData['payment_method']);

    Map userBilledData = {
      'full_name': userData['billing_name'],
      'identification_type': userData['billing_identification_type'],
      'identification_number': userData['billing_identification_number']
    };
    await saveStepFourDataToLocalStorage(
        context, userBilledData, userId, userData['client_type']);
  }

  static checkout(
      BuildContext context,
      bool userIsLogged,
      Map couponData,
      double total,
      String paymentMethod,
      double subtotalResume,
      double toPayWithCash,
      double totalResume,
      double couponDiscountTotal,
      Map userBilledData,
      Function confirmOrderCreation) async {
    /// Se valida si el usuario se encuentra logueado.
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
          title: 'Usuario no registrado',
          description:
              'Para poder realizar un pedido debe estar ' + 'logueado primero',
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

    //Get payment minimun values for three different methods
    //In-cash, in-dataphone & online. Also obtain Payment
    //Methods relevant information
    var orderNotes = await SessionService.getItem(
      key: 'orderNotes',
    );
    var toPayWithText = '';
    if (paymentMethod == 'cash') {
      toPayWithText =
          'A pagar con: ' + StringService.getPriceFormat(number: toPayWithCash);
      await SessionService.setItem(
        key: 'toPayWithCash',
        value: toPayWithCash.toString(),
      );
    }

    // Se valida si existe un error con el cupón
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

      String orderCouponError = OrderDetailController().getCouponError(
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

    try {
      /// ==============================================
      /// Se crea la orden
      /// ==============================================

      var orderCreatedData = await WooCommerceService().saveOrder(
          couponData: couponData, couponDiscountTotal: couponDiscountTotal);

      // DESARROLLO
      // var orderCreatedData = {
      //   'id':44,
      //   'order_key':'444'
      // };

      //Inform order_detail_stepper component that order was created so modifications are made to the interface accordingly
      confirmOrderCreation();

      //Notas generales: Compra realizada con version anterior apk. Pago Contraentrega - Efectivo
      //CC 99999999 - DEJ Software. A pagar con: $ 45.000
      String paymentMethodOrderText =
          getPaymentMethodOrderText(paymentMethod, userBilledData);
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

      LoaderService.dismissLoader(context: context);

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
      await SessionService.removeItem(key: 'deliveryDayIdSelected');
      await SessionService.removeItem(key: 'deliveryHourIdSelected');
      await SessionService.removeItem(key: 'deliveryDateSelected');
      await SessionService.removeItem(key: 'deliverFromHourSelected');
      await SessionService.removeItem(key: 'deliverToHourSelected');
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
        String orderId = orderCreatedData['id'].toString();
        await ShippingAPIService.updateShippingValue(orderId);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              title: Text(
                'Pedido No. ' + orderCreatedData['id'].toString(),
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              content: Text(
                'Su pedido ha sido realizado exitosamente.' + redirectText,
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');

                    Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    );
                  },
                  child: Text('Cerrar'),
                ),
              ],
            ),
          ),
        );
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

        await ShippingAPIService.updateShippingValue(orderId);

        String redirectUrl =
            'https://www.mercave.com.co/finalizar-compra/order-pay/$orderId/?key=$orderKey&from_mobile_app=true';

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
      }
    } catch (e) {
      LoaderService.dismissLoader(context: context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            title: Text(
              'Error al crear el pedido',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            content: Text(
              e.message,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
        ),
      );
    }
  }

  static Future<dynamic> verifyCartProductsInventory(
      BuildContext context, Function getCart) async {
    Map validProductsResponse =
        await OrderDetailController().validateCartProductsInStock(
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
              fontSize: 14.0,
            ),
          ),
          onClose: getCart);

      return validProductsResponse['validProducts'];
    } else
      return validProductsResponse['validProducts'];
  }

  static minimumPaymentValue(
      BuildContext context, String paymentMethod, double subtotalResume) async {
    Map config = await ConfigAPIService.getConfig();
    bool enoughAmount = true;

    if (paymentMethod == 'cash' &&
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
      return enoughAmount = false;
    } else if (paymentMethod == 'dataphone' &&
        config['min_order_value_in_dataphone'] != null &&
        subtotalResume < config['min_order_value_in_dataphone']) {
      LoaderService.dismissLoader(context: context);

      AlertService.showErrorAlert(
        context: context,
        title: 'Error valor mínimo',
        description: 'El valor mínimo del pedido para pago '
                'contraentrega con datafono es de: \n\n' +
            StringService.getPriceFormat(
              number: double.parse(
                config['min_order_value_in_dataphone'].toString(),
              ),
            ) +
            '.',
      );
      return enoughAmount = false;
    } else if (paymentMethod == 'online' &&
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
      return enoughAmount = false;
    }

    return enoughAmount;
  }

  static String getPaymentMethodOrderText(
      String paymentMethodSelected, Map userBilledData) {
    String paymentMethodOrderText = '';
    String billingName = userBilledData['full_name'];
    String billingIdentificationType = userBilledData['identification_type'];
    String billingIdentificationNumber =
        userBilledData['identification_number'];

    /// ======================================================================
    /// Get the payment method text
    /// ======================================================================
    if (paymentMethodSelected == 'cash') {
      paymentMethodOrderText = 'Contraentrega - Efectivo';
    } else if (paymentMethodSelected == 'dataphone') {
      paymentMethodOrderText = 'Contraentrega - Datafono';
    } else if (paymentMethodSelected == 'online') {
      paymentMethodOrderText = 'En línea';
    }

    /// ======================================================================
    /// Get the billing info
    /// ======================================================================
    paymentMethodOrderText +=
        '\n$billingIdentificationType $billingIdentificationNumber - '
        '$billingName';
    return paymentMethodOrderText;
  }
}
