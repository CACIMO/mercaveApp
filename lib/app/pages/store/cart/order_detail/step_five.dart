import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/app/config.api.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail.controller.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_five_cupon_dialog.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class StepFive extends StatefulWidget {
  double total;
  Map couponData;
  String couponError;
  String couponSubtitle;
  double couponDiscountTotal;
  double totalResume;
  double savedResume;
  List deliveryDays;

  String selectedStreet;
  String textCtrlPlatePart1;
  String textCtrlPlatePart2;
  String textCtrlPlatePart3;
  String neighborhoodSelected;
  String paymentMethodSelected;
  String shippingDaySelected;
  String shippingHourSelected;
  String billingName;
  String billingIdentificationType;
  String billingIdentificationNumber;
  Function updateCartWithCoupon;

  StepFive({
    @required this.total,
    @required this.couponData,
    @required this.couponError,
    @required this.couponSubtitle,
    @required this.couponDiscountTotal,
    @required this.totalResume,
    @required this.savedResume,
    @required this.deliveryDays,
    @required this.selectedStreet,
    @required this.textCtrlPlatePart1,
    @required this.textCtrlPlatePart2,
    @required this.textCtrlPlatePart3,
    @required this.neighborhoodSelected,
    @required this.paymentMethodSelected,
    @required this.shippingDaySelected,
    @required this.shippingHourSelected,
    @required this.billingName,
    @required this.billingIdentificationType,
    @required this.billingIdentificationNumber,
    @required this.updateCartWithCoupon,
  });

  @override
  _StepFiveState createState() => _StepFiveState();
}

class _StepFiveState extends State<StepFive> {
  bool error = false;
  bool loading = false;
  List deliveryDays;

  String address;
  String shippingDay;
  String paymentMethodText;
  String paymentMethodSubtitle;
  String deliveryDate;
  String daySelected;
  String hourSelected;
  List deliveryHoursDaySelected;

  double subtotalResume = 0.0;

  TextEditingController orderNotesController = TextEditingController();

  List menuItems = [];

  // Responsive parameter
  bool InputIsDense = false;
  double paddingVertical = 10.0;
  double fontSizeSummary = 16.0;
  double minHeightListItem = 40;
  double heightArrowCupon = 30;
  double paddingInfoFinish = 8;
  double paddingTextFieldVertical = 13;
  int textMaxLines = 2;
  TextOverflow textOverflow = TextOverflow.visible;

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() async {
    if (widget.deliveryDays != null) deliveryDays = widget.deliveryDays;

    loadStepFiveData();
  }

  loadStepFiveData() async {
    //Put together the Address
    if (widget.selectedStreet != null) {
      address = widget.selectedStreet +
          ' ' +
          widget.textCtrlPlatePart1 +
          ' ' +
          widget.textCtrlPlatePart2 +
          ' ' +
          widget.textCtrlPlatePart3;
    }
    //Put together the Shipping info
    if (widget.shippingDaySelected != null &&
        widget.shippingHourSelected != null) {
      var daySelected = deliveryDays
          .where((day) => day['id'] == widget.shippingDaySelected)
          .toList();

      if (daySelected.length > 0) {
        this.daySelected = widget.shippingDaySelected;
      }

      if (this.daySelected != null) {
        var existHourSelected = daySelected[0]['horarios_de_entrega']
            .where((hour) => hour['id'] == widget.shippingHourSelected)
            .toList();

        if (existHourSelected.length > 0) {
          this.hourSelected = widget.shippingHourSelected;
        }

        getDeliveryHoursDaySelected();
      }
    }

    //Put together the Payment method
    if (widget.paymentMethodSelected != null) {
      if (widget.paymentMethodSelected == 'cash')
        paymentMethodText = 'Efectivo';
      else if (widget.paymentMethodSelected == 'online')
        paymentMethodText = 'En linea';
      else
        paymentMethodText = 'Datafono';
    }

    paymentMethodSubtitle = widget.billingIdentificationType +
        ' - ' +
        widget.billingIdentificationNumber +
        ' - ' +
        widget.billingName;

    orderNotesController.text = await SessionService.getItem(key: 'orderNotes');
    //setState(() {});
  }

  getDeliveryHoursDaySelected() {
    List daySelected = deliveryDays.where((deliveryDay) {
      return deliveryDay['id'] == this.daySelected;
    }).toList();

    if (daySelected != null) {
      setState(() {
        deliveryHoursDaySelected = daySelected[0]['horarios_de_entrega'];
      });
    }

    this.shippingDay = daySelected[0]['nombre_dia'] +
        ' ' +
        daySelected[0]['dia'] +
        ' de ' +
        daySelected[0]['nombre_mes'] +
        ', ' +
        daySelected[0]['anio'] +
        ' de ' +
        deliveryHoursDaySelected[0]['hora_inicio'] +
        ' a ' +
        deliveryHoursDaySelected[0]['hora_fin'];
  }

  @override
  Widget build(BuildContext context) {
    //Responsive check
    double deviceHeight = MediaQuery.of(context).size.height;
    print('device height:' + deviceHeight.toString());
    if (deviceHeight < 736 && deviceHeight >= 667) {
      InputIsDense = true;
      fontSizeSummary = 15.0;
      minHeightListItem = 35;
      textMaxLines = 1;
      textOverflow = TextOverflow.ellipsis;
    }
    if (deviceHeight < 667 && deviceHeight >= 592) {
      paddingVertical = 5;
      InputIsDense = true;
      fontSizeSummary = 13.0;
      minHeightListItem = 25;
      heightArrowCupon = 25;
      paddingInfoFinish = 4;
      paddingTextFieldVertical = 4;
      textMaxLines = 1;
      textOverflow = TextOverflow.ellipsis;
    }
    if (loading || error) {
      return Container(
        height: MediaQuery.of(context).size.height * .5,
        child: PageLoaderWidget(
          error: error,
          onError: () async {
            await _init();
          },
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(FontAwesomeIcons.home, color: kCustomPrimaryColor),
              SizedBox(width: 30.0),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: minHeightListItem),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dirección: ' + address,
                        style: TextStyle(
                          color: kCustomStrongGrayColor,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        'Cali - Barrio ' + widget.neighborhoodSelected,
                        maxLines: textMaxLines,
                        overflow: textOverflow,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(FontAwesomeIcons.solidCalendarAlt,
                  color: kCustomPrimaryColor),
              SizedBox(width: 30.0),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: minHeightListItem),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Entrega: ' + shippingDay,
                        style: TextStyle(
                          color: kCustomStrongGrayColor,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(FontAwesomeIcons.solidCreditCard,
                  color: kCustomPrimaryColor),
              SizedBox(width: 30.0),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: minHeightListItem),
                  width: MediaQuery.of(context).size.width * .6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Pago: ' + paymentMethodText,
                        style: TextStyle(
                          color: kCustomStrongGrayColor,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        paymentMethodSubtitle,
                        maxLines: textMaxLines,
                        overflow: textOverflow,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(color: Colors.black),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return CouponDialog(
                      couponData: widget.couponData,
                      cartTotal: widget.total,
                      savedValidCoupon: (coupon) async {
                        if (coupon != null) {
                          await SessionService.setItem(
                            key: 'couponData',
                            value: json.encode(coupon),
                          );
                        }

                        widget.updateCartWithCoupon();
                      },
                      removeValidCoupon: () async {
                        await SessionService.removeItem(key: 'couponData');
                        widget.updateCartWithCoupon();
                      },
                    );
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(FontAwesomeIcons.ticketAlt, color: kCustomPrimaryColor),
                SizedBox(width: 30.0),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(minHeight: minHeightListItem),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.couponData != null
                              ? widget.couponData['code'].toUpperCase() +
                                  ': ' +
                                  widget.couponSubtitle +
                                  ' ' +
                                  (widget.couponError != null
                                      ? widget.couponError
                                      : '')
                              : 'Agregar créditos o cupón',
                          style: TextStyle(
                            color: widget.couponError != null
                                ? Colors.red
                                : kCustomStrongGrayColor,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: heightArrowCupon,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Divider(color: Colors.black),
          _getOrderNotesField(context: context),
          _getCartResumeWidget(context: context)
        ],
      ),
    );
  }

  Widget _getOrderNotesField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Notas de la orden',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: kCustomPrimaryColor,
            ),
          ),
          SizedBox(height: paddingVertical),
          TextField(
            controller: orderNotesController,
            maxLines: 1,
            decoration: InputDecoration(
              isDense: InputIsDense,
              contentPadding: EdgeInsets.symmetric(
                  vertical: paddingTextFieldVertical, horizontal: 16.0),
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

  /// ======================================================================
  /// Return Costs summary including "Finalizar compra" action button
  /// ======================================================================
  Widget _getCartResumeWidget({BuildContext context}) {
    subtotalResume = widget.total;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Container(
                      color: kCustomGrayColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: paddingInfoFinish,
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
                        fontSize: fontSizeSummary,
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
                        fontSize: fontSizeSummary,
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
                        fontSize: fontSizeSummary,
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
                      StringService.getPriceFormat(number: 5000),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: fontSizeSummary,
                        color: kCustomBlackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: widget.couponDiscountTotal != null,
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
                          fontSize: fontSizeSummary,
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
                          number: widget.couponDiscountTotal,
                        ),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: fontSizeSummary,
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
                        fontSize: fontSizeSummary,
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
                      StringService.getPriceFormat(
                          number: widget.totalResume + 5000),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: fontSizeSummary,
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
                        fontSize: fontSizeSummary,
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
                      StringService.getPriceFormat(number: widget.savedResume),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: fontSizeSummary,
                        color: kCustomPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
