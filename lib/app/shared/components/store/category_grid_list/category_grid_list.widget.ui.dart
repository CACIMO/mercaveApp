import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class CategoryGridListWidgetUI {
  final BuildContext context;
  final List<dynamic> categories;
  final Function onCategoryTapped;

  double screenWidth;
  double horizontalPadding;

  CategoryGridListWidgetUI({
    @required this.context,
    @required this.categories,
    @required this.onCategoryTapped,
  }) {
    _setDimensions();
  }

  void _setDimensions() {
    double viewportFraction = 0.9;
    screenWidth = MediaQuery.of(context).size.width;
    horizontalPadding = (screenWidth - screenWidth * viewportFraction) / 2;
  }

  Widget build() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: _getGridViewWidget(),
      ),
    );
  }

  Widget _getGridViewWidget() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: categories.map((category) {
        return Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              onCategoryTapped(category);
            },
            child: _getBackgroundImageDecoration(category: category),
          );
        });
      }).toList(),
    );
  }

  Widget _getBackgroundImageDecoration({Map category}) {
    return CachedNetworkImage(
      imageUrl: category['principal_image'],
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: _getCenterTextWidget(category: category),
      ),
      placeholder: (context, url) => Image.asset(kCustomPlaceholderCategory),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _getCenterTextWidget({Map category}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            StringService.capitalize(category['name']),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
