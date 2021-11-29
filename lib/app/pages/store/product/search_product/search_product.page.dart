import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/woocommerce/woocommerce.service.dart';
import 'package:mercave/app/pages/store/product/search_product/search_product.page.ui.dart';

class SearchProductPage extends StatefulWidget {
  final String textToSearch;

  SearchProductPage({this.textToSearch});

  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  String textToSearch = '';
  bool loading = false;
  bool loaded = false;
  bool error = false;
  int cartProductsQty = 0;

  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    textToSearch = widget.textToSearch;

    if (textToSearch != null) {
      onSearchSubmitted(text: textToSearch);
    }
  }

  void searchProducts({@required String textToSearch}) {
    setState(() {
      loading = true;
      loaded = false;
      error = false;
      products = [];
    });

    WooCommerceService()
        .getProductsBySearch(textToSearch: textToSearch)
        .then((productsResponse) {
      setState(() {
        products = productsResponse;
        loaded = true;
        loading = false;
      });
    }).catchError((error) {
      setState(() {
        loading = false;
        loaded = true;
        error = true;
      });
    });
  }

  void onSearchSubmitted({text}) {
    setState(() {
      textToSearch = text;
      if (textToSearch == '') {
        loaded = false;
      }
    });

    if (textToSearch != '') {
      searchProducts(textToSearch: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchProductPageUI(
        context: context,
        textToSearch: textToSearch,
        products: products,
        error: error,
        loading: loading,
        loaded: loaded,
        onError: () {},
        onSearchSubmitted: (textToSearchParam) {
          onSearchSubmitted(text: textToSearchParam);
        },
        onCloseButtonTapped: () {
          Navigator.pop(context, false);
        }).build();
  }
}
