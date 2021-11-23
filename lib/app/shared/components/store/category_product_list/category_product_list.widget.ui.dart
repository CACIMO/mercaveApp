import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mercave/app/shared/components/store/product_list_item/product_list_item.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class CategoryProductListWidgetUI {
  final BuildContext context;
  final Map category;
  final List<dynamic> products;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final ScrollController scrollController;
  final bool loadingMoreProducts;
  final Function onProductTapped;
  final bool fullHeight;

  CategoryProductListWidgetUI({
    @required this.context,
    @required this.category,
    @required this.products,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.scrollController,
    @required this.loadingMoreProducts,
    @required this.onProductTapped,
    @required this.fullHeight,
  });

  Widget build() {
    double percentageHeight = fullHeight ? 82 : 48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: kCustomPrimaryColor,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  StringService.capitalize(category['name']),
                  style: TextStyle(
                    color: kCustomPrimaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Visibility(
                  visible: category['count'] != null,
                  child: Text(
                    products.length.toString() +
                        ' de ' +
                        category['count'].toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * percentageHeight / 100,
          child: _getProductCategoryListWidget(),
        ),
      ],
    );
  }

  Widget _getProductCategoryListWidget() {
    return ListView.builder(
      controller: scrollController,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ProductListItemWidget(
              product: products[index],
              onProductDecreased: onProductDecreased,
              onProductIncreased: onProductIncreased,
              onProductTapped: onProductTapped,
            ),
            Visibility(
              visible: loadingMoreProducts && products.length == (index + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Cargando más productos...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kCustomPrimaryColor,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    SpinKitChasingDots(
                      color: kCustomPrimaryColor,
                      size: 25.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
