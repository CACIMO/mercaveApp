import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail.controller.dart';
import 'package:mercave/app/ui/constants.dart';


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
