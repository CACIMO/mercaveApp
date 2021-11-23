import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/buttons/increase_decrease_button/increase_decrease_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/components/store/product_image/product-image.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class ProductDetailPageUI {
  final BuildContext context;
  final dynamic productParam;
  final Map currentProduct;
  final bool loading;
  final bool error;
  final Function onError;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final Function onProductTapped;

  ProductDetailPageUI({
    @required this.context,
    @required this.productParam,
    @required this.currentProduct,
    @required this.loading,
    @required this.error,
    @required this.onError,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.onProductTapped,
  });

  Widget build() {
    if (loading || error) {
      return PageLoaderWidget(
        error: error,
        onError: () async {
          await onError();
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBarWidget(),
        bottomNavigationBar: _getFooterWidget(),
        body: _getBodyWidget(),
      ),
    );
  }

  Widget _getAppBarWidget() {
    return AppBar(
      title: Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _getBodyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _getProductImageWidget(),
          _getProductInfoWidget(),
          _getProductDescriptionWidget(),
        ],
      ),
    );
  }

  Widget _getProductInfoWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Column(
        children: <Widget>[
          _getProductTitleWidget(),
          _getProductUnitMeasureWidget(),
          _getProductPricesWidget(),
          _getProductAmountSavedWidget(),
        ],
      ),
    );
  }

  Widget _getProductAmountSavedWidget() {
    bool visible = currentProduct['amount_saved'] != null &&
        currentProduct['amount_saved'] > 0;

    return Visibility(
      visible: visible,
      child: Text(
        kCustomYouAreSavingText +
            ' \$ ' +
            currentProduct['amount_saved'].toString(),
        style: TextStyle(
          fontSize: 15,
          color: kCustomPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _getProductPricesWidget() {
    bool visible = currentProduct['price'] != null ||
        currentProduct['regular_price'] != null;

    bool visiblePrice =
        currentProduct['price'] != null && currentProduct['price'] > 0;

    bool visibleRegularPrice = currentProduct['regular_price'] != null &&
        currentProduct['regular_price'] > 0;

    return Visibility(
      visible: visible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Visibility(
            visible: visiblePrice,
            child: Text(
              StringService.getPriceFormat(number: currentProduct['price']),
              style: TextStyle(
                fontSize: 30,
                color: kCustomBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Visibility(
            visible: visibleRegularPrice,
            child: Text(
              StringService.getPriceFormat(
                  number: currentProduct['regular_price']),
              style: TextStyle(
                fontSize: 25,
                color: kCustomStrongGrayColor,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProductUnitMeasureWidget() {
    return Visibility(
      visible: false,
      child: Text(
        currentProduct['unit_measure'],
        style: TextStyle(
          fontSize: 16.0,
          color: kCustomStrongGrayColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _getProductTitleWidget() {
    return Text(
      currentProduct['name'],
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22.0,
        color: kCustomPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _getProductImageWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ProductImageWidget(
        product: currentProduct,
        onProductTapped: (currentProduct) {
          onProductTapped(currentProduct);
        },
        imageHeight: 300.0,
      ),
    );
  }

  Widget _getProductDescriptionWidget() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 60.0,
          color: kCustomGrayColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                kCustomDetailText,
                style: TextStyle(
                  fontSize: 25.0,
                  color: kCustomPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            currentProduct['description'],
            style: TextStyle(
              fontSize: 18.0,
              color: kCustomGrayTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  Widget _getFooterWidget() {
    bool visible = !loading && !error && !currentProduct['hide_actions'];
    bool allowAddToCart =
        currentProduct != null && currentProduct['allow_add_to_cart'];

    return Visibility(
      visible: visible,
      child: Stack(
        children: [
          new Container(
            height: 70.0,
            color: kCustomSecondaryColor,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: allowAddToCart
                ? _getIncreaseDecreaseButtonWidget()
                : _getNoProductAvailableTextWidget(),
          ),
        ],
      ),
    );
  }

  Widget _getIncreaseDecreaseButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IncreaseDecreaseButton(
              quantity: currentProduct['quantity'],
              onDecreased: () {
                onProductDecreased(currentProduct);
              },
              onIncreased: () {
                onProductIncreased(currentProduct);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _getNoProductAvailableTextWidget() {
    return Container(
      height: 70.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            kCustomNoProductAvailableDescriptionText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: kCustomPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
