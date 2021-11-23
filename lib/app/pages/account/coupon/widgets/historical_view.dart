import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/core/models/coupon_model.dart';

class HistoricalView extends StatelessWidget {
  final List<CouponModel> coupons;

  const HistoricalView({
    Key key,
    @required this.coupons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Historial',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),
          if (coupons.isEmpty)
            _EmptyHistoricalView()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                return _CouponView(coupon: coupon);
              },
            ),
        ],
      ),
    );
  }
}

class _CouponView extends StatelessWidget {
  final CouponModel coupon;

  const _CouponView({
    Key key,
    @required this.coupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: '-\$${coupon.amount}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ])),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text('Código: '),
                  Text(
                    coupon.code,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistoricalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).unselectedWidgetColor;
    return Column(
      children: [
        Icon(FontAwesomeIcons.inbox, color: color),
        const SizedBox(height: 8.0),
        Text(
          '¿Aún no has compartido tu código?',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          'Comparte y disfruta tus cupones',
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
