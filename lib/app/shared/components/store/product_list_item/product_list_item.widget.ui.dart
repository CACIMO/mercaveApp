import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/buttons/increase_decrease_button/increase_decrease_button.widget.dart';
import 'package:mercave/app/shared/components/store/product_image/product-image.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class ProductListItemWidgetUI {
  final BuildContext context;
  final Map product;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final Function onProductTapped;

  ProductListItemWidgetUI({
    @required this.context,
    @required this.product,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.onProductTapped,
  });

  build() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kCustomGrayColor, width: 2.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          children: <Widget>[
            _getProductImageWidget(),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getProductPromotionTextWidget(),
                    _getProductNameTextWidget(),
                    Row(
                      children: <Widget>[
                        _getProductPriceTextWidget(),
                        _getProductRegularPriceTextWidget(),
                      ],
                    ),
                    _getProductAmountSavedTextWidget(),
                    _getProductIncreaseDecreaseButtonWidget(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getProductImageWidget() {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          ProductImageWidget(
            product: product,
            onProductTapped: onProductTapped,
          ),
        ],
      ),
    );
  }

  Widget _getProductPromotionTextWidget() {
    bool visible = product['discount'] != null;

    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          'PROMOCIÓN',
          style: TextStyle(
            color: kCustomPrimaryColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _getProductNameTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Text(
        product['name'],
        style: TextStyle(
          color: kCustomGrayTextColor,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getProductPriceTextWidget() {
    bool visible = product['price'] != null;

    String priceText = StringService.getPriceFormat(number: product['price']);

    if (product['show_quantity_in_price']) {
      priceText = product['quantity'].toString() + " x " + priceText;
    }

    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 2.0, right: 8.0),
        child: Text(
          priceText,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _getProductRegularPriceTextWidget() {
    bool visible = product['price'] != null && product['regular_price'] != null;

    return Visibility(
      visible: visible,
      child: Text(
        StringService.getPriceFormat(number: product['regular_price']),
        style: TextStyle(
          fontSize: 18.0,
          decoration: TextDecoration.lineThrough,
          color: kCustomGrayTextColor,
        ),
      ),
    );
  }

  Widget _getProductAmountSavedTextWidget() {
    bool visible =
        product['amount_saved'] != null && product['amount_saved'] > 0;

    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Text(
          kCustomYouAreSavingText + ' \$ ' + product['amount_saved'].toString(),
          style: TextStyle(
            color: kCustomPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _getProductIncreaseDecreaseButtonWidget() {
    bool allowAddToCart = product['allow_add_to_cart'] ?? false;
    bool hideActions = product['hide_actions'] ?? false;

    if (allowAddToCart) {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 20.0,
              ),
              child: IncreaseDecreaseButton(
                quantity: product['quantity'],
                onDecreased: () {
                  onProductDecreased(product);
                },
                onIncreased: () {
                  onProductIncreased(product);
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(''),
          )
        ],
      );
    } else if (hideActions) {
      return SizedBox();
    } else {
      return Row(
        children: <Widget>[
          Text(
            'Agotado',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      );
    }
  }
}
