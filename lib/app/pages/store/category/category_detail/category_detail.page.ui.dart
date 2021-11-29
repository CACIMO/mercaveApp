import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/headers/address_header/address_header.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/components/store/category_list/category_list.widget.dart';
import 'package:mercave/app/shared/components/store/category_product_list/category_product_list.widget.dart';
import 'package:mercave/app/shared/components/store/product_principal_slider/product_principal_slider.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class CategoryDetailPageUI {
  final BuildContext context;
  final Map currentCategory;
  final List<dynamic> recommendedProducts;
  final List<dynamic> otherProducts;
  final List<dynamic> categories;

  final Function onError;
  final Function onHeaderTitleTapped;
  final Function onCategoryListItemTap;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final Function onProductTapped;
  final Function onUserIconTapped;
  final Function onCartIconTapped;
  final Function onSearchIconTapped;

  final ScrollController scrollController;
  final bool loading;
  final bool error;
  final bool showCategoryList;
  final bool loadingMoreProducts;

  final Map userData;
  final bool userIsLogged;
  final int cartProductsQty;
  final bool hideRecommendedProducts;

  CategoryDetailPageUI({
    @required this.context,
    @required this.currentCategory,
    @required this.recommendedProducts,
    @required this.otherProducts,
    @required this.categories,
    @required this.userData,
    @required this.userIsLogged,
    @required this.cartProductsQty,
    @required this.loading,
    @required this.error,
    @required this.onError,
    @required this.showCategoryList,
    @required this.onHeaderTitleTapped,
    @required this.onCategoryListItemTap,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.onProductTapped,
    @required this.onUserIconTapped,
    @required this.scrollController,
    @required this.loadingMoreProducts,
    @required this.onCartIconTapped,
    @required this.onSearchIconTapped,
    @required this.hideRecommendedProducts,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppBar(),
      body: _getBody(),
    );
  }

  Widget _getAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: AddressHeaderWidget(
        title: currentCategory != null ? currentCategory['name'] : '-',
        subtitle: kCustomChangeCounter,
        userData: userData,
        userIsLogged: userIsLogged,
        cartProductsQty: cartProductsQty,
        enableGoBackButton: true,
        onHeaderTitleTapped: () {
          onHeaderTitleTapped();
        },
        onUserIconTapped: () {
          onUserIconTapped();
        },
        onCartIconTapped: () {
          onCartIconTapped();
        },
        onSearchIconTapped: () {
          onSearchIconTapped();
        },
      ),
    );
  }

  Widget _getBody() {
    if (showCategoryList) {
      return CategoryListWidget(
        categories: categories,
        onCategoryTapped: onCategoryListItemTap,
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Visibility(
            visible: recommendedProducts.length > 0 && !hideRecommendedProducts,
            child: _getPrincipalSliderOfFeaturedCategoryProductsWidget(context),
          ),
          _getProductListWidget(),
        ],
      ),
    );
  }

  Widget _getPrincipalSliderOfFeaturedCategoryProductsWidget(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: kCustomWhiteColor,
      ),
      child: ProductPrincipalSliderWidget(
        products: recommendedProducts,
        onProductTapped: (product) {
          onProductTapped(product);
        },
      ),
    );
  }

  Widget _getProductListWidget() {
    return CategoryProductListWidget(
        category: currentCategory,
        products: otherProducts,
        onProductDecreased: onProductDecreased,
        onProductIncreased: onProductIncreased,
        scrollController: scrollController,
        loadingMoreProducts: loadingMoreProducts,
        onProductTapped: onProductTapped,
        fullHeight: hideRecommendedProducts);
  }
}
