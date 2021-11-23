import 'package:flutter/material.dart';

import 'package:mercave/app/pages/account/coupon/bloc/coupon_bloc.dart';
import 'package:mercave/app/pages/account/coupon/widgets/historical_view.dart';
import 'package:mercave/app/pages/account/coupon/widgets/share_coupon_view.dart';
import 'package:mercave/app/pages/account/coupon/widgets/user_credits_view.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class CouponPage extends StatefulWidget {
  /// Anonymous route for [CouponPage].
  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => CouponPage());
  }

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  final _bloc = CouponBloc();

  @override
  void initState() {
    super.initState();
    _bloc.requestCoupons();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bloc,
      builder: (context, _) {
        if (_bloc.isLoading || _bloc.hasError) {
          return PageLoaderWidget(
            error: _bloc.hasError,
            onError: _bloc.requestCoupons,
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: kCustomWhiteColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Cupones',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontSize: 18.0),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                UserCreditsView(),
                const Divider(),
                ShareCouponView(
                  code: _bloc.userCoupon.code ?? '',
                  onShare: _bloc.shareCode,
                ),
                const SizedBox(height: 16.0),
                HistoricalView(
                  coupons: _bloc.acquiredCoupons,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
