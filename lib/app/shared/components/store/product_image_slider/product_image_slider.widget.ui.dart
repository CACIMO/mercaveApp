import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/ui/constants.dart';

class ProductImageSliderWidgetUI {
  final BuildContext context;
  final List<dynamic> products;
  final Function onProductTapped;
  final double viewportFraction = 0.9;

  CarouselSlider carouselSliderWidget;

  double horizontalPadding;
  double carouselHeight = 100.0;
  double carouselControlWidth = 40.0;
  double carouselListImageWidth;
  CarouselController controllerCarousel = CarouselController();

  ProductImageSliderWidgetUI({
    this.context,
    this.products,
    this.onProductTapped,
  }) {
    _setDimensions();
  }

  void _setDimensions() {
    double screenWidth = MediaQuery.of(context).size.width;
    horizontalPadding = (screenWidth - screenWidth * viewportFraction) / 2;

    carouselListImageWidth =
        screenWidth - (horizontalPadding * 2) - (carouselControlWidth * 2) - 2;
  }

  Widget build() {
    carouselSliderWidget = _getCarouselSliderWidget();

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Container(
            decoration: _getCarouselDecoration(),
            child: Row(
              children: <Widget>[
                _getCarouselPreviousButtonWidget(),
                _getCarouselContainerWidget(),
                _getCarouselNextButtonWidget()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getCarouselSliderWidget() {
    return CarouselSlider(
      carouselController: controllerCarousel,
      options: CarouselOptions(
          height: carouselHeight,
          viewportFraction: 0.30,
          enableInfiniteScroll: true,
          autoPlay: false,
          pauseAutoPlayOnTouch: true,
          initialPage: 1),
      items: products.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                onProductTapped(item);
              },
              child: Container(
                width: MediaQuery.of(context).copyWith().size.width / 5,
                child: CachedNetworkImage(
                  imageUrl: item['principal_image'],
                  placeholder: (context, url) =>
                      Image.asset(kCustomPlaceholderImage),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Decoration _getCarouselDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: kCustomPrimaryColor,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    );
  }

  Widget _getCarouselContainerWidget() {
    return Container(
      width: carouselListImageWidth,
      child: carouselSliderWidget,
    );
  }

  Widget _getCarouselPreviousButtonWidget() {
    return Container(
      height: carouselHeight,
      width: carouselControlWidth,
      child: FlatButton(
        onPressed: () {
          controllerCarousel.previousPage(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
          );
        },
        child: Icon(
          FontAwesomeIcons.caretLeft,
          color: kCustomPrimaryColor,
        ),
      ),
    );
  }

  Widget _getCarouselNextButtonWidget() {
    return Container(
      height: carouselHeight,
      width: carouselControlWidth,
      child: FlatButton(
        onPressed: () {
          controllerCarousel.nextPage(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
          );
        },
        child: Icon(
          FontAwesomeIcons.caretRight,
          color: kCustomPrimaryColor,
        ),
      ),
    );
  }
}
