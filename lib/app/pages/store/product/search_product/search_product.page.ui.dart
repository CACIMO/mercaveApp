import 'package:flutter/material.dart';
import 'package:mercave/app/pages/store/product/product_detail/product_detail.page.dart';
import 'package:mercave/app/shared/components/headers/search_header/search_header.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class SearchProductPageUI {
  final BuildContext context;
  final String textToSearch;
  final List<dynamic> products;
  final bool loading;
  final bool loaded;
  final bool error;
  final Function onError;
  final Function onSearchSubmitted;
  final Function onCloseButtonTapped;

  SearchProductPageUI({
    @required this.context,
    @required this.textToSearch,
    @required this.products,
    @required this.loading,
    @required this.loaded,
    @required this.error,
    @required this.onError,
    @required this.onSearchSubmitted,
    @required this.onCloseButtonTapped,
  });

  Widget build() {
    Widget homeWidget;

    if (loading || error) {
      homeWidget = PageLoaderWidget(
        error: error,
        onError: onError,
      );
    } else if (!loaded) {
      homeWidget = _getNoSearchWidget();
    } else if (loaded) {
      if (products.length > 0) {
        homeWidget = _getProductListWidget();
      } else {
        homeWidget = _getNoProductsFoundWidget();
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBar(),
        body: homeWidget,
      ),
    );
  }

  Widget _getAppBar() {
    return AppBar(
      titleSpacing: 0.0,
      title: SearchHeaderWidget(
        textToSearch: textToSearch,
        onSearchSubmitted: onSearchSubmitted,
        onCloseButtonTapped: onCloseButtonTapped,
      ),
    );
  }

  Widget _getNoSearchWidget() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿ Qué estás buscando ?',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 28.0,
                    color: kCustomGrayColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icons/store_search.png',
                  width: MediaQuery.of(context).size.width * 70 / 100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getProductListWidget() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: FadeInImage.assetNetwork(
            height: 50.0,
            placeholder: kCustomPlaceholderImage,
            image: products[index]['principal_image'],
          ),
          title: Text(products[index]['name']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  productParam: products[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getNoProductsFoundWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No se ha encontrado resultados para la búsqueda ingresada: ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              textToSearch,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kCustomPrimaryColor,
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
