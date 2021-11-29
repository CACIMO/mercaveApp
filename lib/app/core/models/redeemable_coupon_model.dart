import 'package:meta/meta.dart';

@immutable
class RedeemableCouponModel {
  final int id;
  final String amount;
  final String minimunAmount;
  final String maximunAmount;
  final String code;
  final String discountType;
  final String expirationDate;

  const RedeemableCouponModel({
    @required this.id,
    @required this.amount,
    @required this.minimunAmount,
    @required this.maximunAmount,
    @required this.code,
    @required this.discountType,
    @required this.expirationDate,
  });

  factory RedeemableCouponModel.fromMap(Map map) {
    final expirationDate =
        map['date_expires'] != null && map['date_expires'] is Map
            ? map['date_expires']['date']
            : null;
    return RedeemableCouponModel(
      id: map['id'],
      amount: map['amount'],
      minimunAmount: map['minimum_amount'] ?? '',
      maximunAmount: map['maximum_amount'] ?? '',
      code: map['code'],
      discountType: map['discount_type'],
      expirationDate: expirationDate,
    );
  }

  Map<String, Object> toMap() => {
        'code': code,
        'amount': amount,
        'minimum_amount': minimunAmount,
        'maximum_amount': maximunAmount,
        'discount_type': discountType,
        'date_expires': expirationDate,
      };
}
