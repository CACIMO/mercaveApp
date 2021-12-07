import 'package:flutter/material.dart';
import 'package:mercave/app/pages/account/coupon/widgets/share_coupon_button.dart';

class ShareCouponView extends StatelessWidget {
  final String code;
  final VoidCallback onShare;

  const ShareCouponView({
    Key key,
    @required this.code,
    @required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            '¡Comparte tu código!',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16.0),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Regala '),
                TextSpan(
                  text: r'$5000',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                    text:
                        ' a tus vecinos y amigos en cupones para mercar, y cuando hagan su primer pedido, tu cuenta será cargada con '),
                TextSpan(
                  text: r'$5000',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 24.0),
          Container(
            decoration: ShapeDecoration(
              shape: StadiumBorder(
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                    ),
                    child: Text(code),
                  ),
                ),
                ShareCouponButton(onTap: onShare),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
