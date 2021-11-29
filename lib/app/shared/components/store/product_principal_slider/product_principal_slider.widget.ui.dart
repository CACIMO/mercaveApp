import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/product_image/product-image.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class ProductPrincipalSliderWidgetUI {
  final BuildContext context;
  final List<dynamic> products;
  final Function onProductTapped;

  double viewportFraction;
  double carouselHeight;

  ProductPrincipalSliderWidgetUI({
    @required this.context,
    @required this.products,
    @required this.onProductTapped,
  }) {
    _setDimensions();
  }

  void _setDimensions() {
    viewportFraction = 0.9;
    carouselHeight = MediaQuery.of(context).size.height * 35 / 100;
  }

  Widget build() {
    return CarouselSlider(
      height: carouselHeight,
      viewportFraction: viewportFraction,
      autoPlay: true,
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      items: products.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return _getCarouselSliderItem(product: product);
          },
        );
      }).toList(),
    );
  }

  Widget _getCarouselSliderItem({product}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
      ),
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              _getTopPrincipalSliderWidget(product: product),
              _getBottomPrincipalSliderWidget(product: product),
            ],
          )),
    );
  }

  Widget _getTopPrincipalSliderWidget({product}) {
    return Expanded(
      flex: 5,
      child: Container(
        child: Row(
          children: <Widget>[
            _getTopLeftPrincipalSliderWidget(product: product),
            _getTopRightPrincipalSliderWidget(product: product),
          ],
        ),
      ),
    );
  }

  Widget _getTopLeftPrincipalSliderWidget({product}) {
    return Expanded(
      flex: 5,
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).copyWith().size.width / 3,
              child: ProductImageWidget(
                imageHeight: 130,
                product: product,
                onProductTapped: (product) {
                  onProductTapped(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTopRightPrincipalSliderWidget({product}) {
    bool visiblePrice = product['price'] != null;
    bool visibleRegularPrice =
        product['regular_price'] != null && product['regular_price'] != null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0),
        ),
        color: kCustomPrimaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                product['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.right,
              ),
              width: 100.0,
            ),
            Visibility(
              visible: visiblePrice,
              child: Text(
                StringService.getPriceFormat(number: product['price']),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 28.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black,
                      offset: Offset(3.0, 4.0),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: visibleRegularPrice,
              child: Text(
                StringService.getPriceFormat(number: product['regular_price']),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 23.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBottomPrincipalSliderWidget({product}) {
    String shortDescription = product['short_description'] != null
        ? product['short_description']
        : '';

    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          color: kCustomGrayColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(
                  shortDescription,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Ver más',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      color: kCustomSecondaryColor,
                      onPressed: () {
                        onProductTapped(product);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
