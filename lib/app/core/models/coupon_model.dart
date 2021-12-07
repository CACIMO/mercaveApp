import 'package:meta/meta.dart';

@immutable
class CouponModel {
  final String id;
  final String userId;
  final bool active;
  final String code;
  final String amount;
  final String redemption;

  const CouponModel({
    this.id,
    this.userId,
    this.active,
    this.code,
    this.amount,
    this.redemption,
  });

  factory CouponModel.fromMap(Map map) {
    return CouponModel(
      id: map['id'],
      userId: map['user_id'],
      active: map['activo'] == '1',
      code: map['cupon_code'],
      amount: map['monto'],
      redemption: map['redencion'],
    );
  }

  bool get isShareable => redemption == '0';
  bool get isNotShareable => redemption != '0';
}
