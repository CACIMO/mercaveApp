import 'package:flutter/foundation.dart';
import 'package:share/share.dart';

import 'package:mercave/app/core/models/coupon_model.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/app/coupon_service.dart';

class CouponBloc extends ChangeNotifier {
  final _service = CouponService();

  bool _mounted = true;
  bool _isLoading = true;
  bool _hasError = false;
  CouponModel _userCoupon;
  List<CouponModel> _acquiredCoupons = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  CouponModel get userCoupon => _userCoupon;
  List<CouponModel> get acquiredCoupons => _acquiredCoupons;

  Future<void> requestCoupons() async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();
      final int userId = await AuthService.getUserIdLogged();
      final result = await _service.requestUserCoupons(userId);
      if (result.isNotEmpty) {
        _userCoupon = result.firstWhere(
          (coupon) => coupon.isShareable,
          orElse: () => null,
        );
        _acquiredCoupons =
            result.where((coupon) => coupon.isNotShareable).toList();
      }
      _isLoading = false;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      notifyListeners();
    }
  }

  void shareCode() {
    if (_userCoupon != null) {
      final message =
          'https://mercave.com.co/cupones.php?code=${_userCoupon.code}';
      Share.share(message);
    }
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
