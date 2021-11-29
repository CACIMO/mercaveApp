import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/woocommerce/woocommerce.service.dart';
import 'package:mercave/app/pages/account/_home/home.page.dart';
import 'package:mercave/app/pages/account/user_menu/user_menu.page.dart';
import 'package:mercave/app/pages/store/cart/cart_detail/cart_detail.page.dart';
import 'package:mercave/app/pages/store/category/category_detail/category_detail.page.ui.dart';
import 'package:mercave/app/pages/store/product/product_detail/product_detail.page.dart';
import 'package:mercave/app/pages/store/product/search_product/search_product.page.dart';
import 'package:mercave/app/ui/constants.dart';

class CategoryDetailPage extends StatefulWidget {
  final dynamic categoryParam;
  final bool showAllRecommendedProducts;
  final bool showAllOnOfferedProducts;

  CategoryDetailPage({
    @required this.categoryParam,
    this.showAllRecommendedProducts = false,
    this.showAllOnOfferedProducts = false,
  });

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  bool loading = true;
  bool error = false;
  bool noMoreProducts = false;
  bool loadingMoreProducts = false;

  Map currentCategory;
  List<dynamic> categories = [];
  bool showCategoryList = false;
  int offset = 0;

  Map userData;
  String avatar;
  bool userIsLogged = false;
  int cartProductsQty = 0;

  List<dynamic> recommendedProducts = [];
  List<dynamic> otherProducts = [];
  ScrollController scrollController;
  bool hideRecommendedProducts = false;

  bool showAllRecommendedProducts;
  bool showAllOnOfferedProducts;

  @override
  initState() {
    super.initState();
    currentCategory = widget.categoryParam;
    showAllRecommendedProducts = widget.showAllRecommendedProducts;
    showAllOnOfferedProducts = widget.showAllOnOfferedProducts;

    if (showAllRecommendedProducts) {
      currentCategory = {
        'name': 'Recomendados',
      };
    } else if (showAllOnOfferedProducts) {
      currentCategory = {
        'name': '¡ Ofertas !',
      };
    }

    _initScrollController();
    loadData();
  }

  _initScrollController() {
    setState(() {
      scrollController = new ScrollController();
      noMoreProducts = false;
      loadingMoreProducts = false;
      offset = 0;
    });

    scrollController.addListener(() async {
      if (scrollController == null) {
        return;
      }

      if (!noMoreProducts &&
          !loadingMoreProducts &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        setState(() {
          offset += 10;
          loadingMoreProducts = true;
          hideRecommendedProducts = true;
        });

        try {
          List<dynamic> moreProducts = [];
          if (showAllRecommendedProducts) {
            moreProducts = await WooCommerceService().getRecommendedProducts(
              categoryId: null,
              offset: offset,
            );
          } else if (showAllOnOfferedProducts) {
            moreProducts = await WooCommerceService().getProductsOnOffers(
              offset: offset,
            );
          } else {
            moreProducts = await WooCommerceService().getProductsByCategory(
              categoryId: currentCategory['id'],
              offset: offset,
            );
          }

          if (moreProducts.length < 10) {
            setState(() {
              noMoreProducts = true;
            });
          }

          setState(() {
            otherProducts.addAll(moreProducts);
            loadingMoreProducts = false;
          });
        } catch (e) {
          setState(() {
            loadingMoreProducts = false;
          });
        }
      }

      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        setState(() {
          if (recommendedProducts.length > 0) {
            hideRecommendedProducts = false;
          }
        });
      }
    });
  }

  loadData() async {
    setState(() {
      error = false;
      loading = true;
    });

    try {
      if (showAllRecommendedProducts) {
        otherProducts = await WooCommerceService().getRecommendedProducts(
          categoryId: null,
          offset: offset,
        );
      } else if (showAllOnOfferedProducts) {
        otherProducts = await WooCommerceService().getProductsOnOffers(
          offset: offset,
        );
      } else {
        recommendedProducts = await WooCommerceService()
            .getRecommendedProducts(categoryId: currentCategory['id']);

        otherProducts = await WooCommerceService().getProductsByCategory(
          categoryId: currentCategory['id'],
          offset: offset,
        );
      }

      categories = await WooCommerceService().getCategories();

      setState(() {
        if (recommendedProducts.length == 0) {
          hideRecommendedProducts = true;
        }

        loading = false;
      });

      _getCart();
      _getUserData();
    } catch (e) {
      setState(() {
        loading = true;
        error = true;
      });
    }
  }

  void _getUserData() async {
    int userIdLogged = await AuthService.getUserIdLogged();

    userData = null;
    avatar = null;
    userIsLogged = false;

    if (userIdLogged != null) {
      userData = await UserDBService.getUserById(id: userIdLogged);
    }

    if (userData != null) {
      setState(() {
        userIsLogged = true;
        avatar = userData['avatar'];
      });
    } else {
      setState(() {
        userIsLogged = false;
        avatar = null;
      });
    }
  }

  void _getCart() {
    CartService.getCart().then((cart) {
      cartProductsQty = 0;

      for (int i = 0; i < cart['products'].length; i++) {
        cartProductsQty += cart['products'][i]['quantity'];
      }

      setState(() {});
    }).catchError((error) {});
  }

  void refreshProducts() {
    CartService.getCart().then((cart) {
      cartProductsQty = 0;
      for (int i = 0; i < cart['products'].length; i++) {
        cartProductsQty += cart['products'][i]['quantity'];
      }

      for (int i = 0; i < recommendedProducts.length; i++) {
        recommendedProducts[i]['quantity'] = 0;
      }

      for (int i = 0; i < otherProducts.length; i++) {
        otherProducts[i]['quantity'] = 0;
      }

      for (int i = 0; i < cart['products'].length; i++) {
        for (int j = 0; j < otherProducts.length; j++) {
          if (otherProducts[j]['id'] == cart['products'][i]['id']) {
            otherProducts[j]['quantity'] = cart['products'][i]['quantity'];
          }
        }

        for (int j = 0; j < recommendedProducts.length; j++) {
          if (recommendedProducts[j]['id'] == cart['products'][i]['id']) {
            recommendedProducts[j]['quantity'] =
                cart['products'][i]['quantity'];
          }
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      debugShowCheckedModeBanner: false,
      home: CategoryDetailPageUI(
        context: context,
        currentCategory: currentCategory,
        recommendedProducts: recommendedProducts,
        otherProducts: otherProducts,
        categories: categories,
        userData: userData,
        userIsLogged: userIsLogged,
        cartProductsQty: cartProductsQty,
        loading: loading,
        loadingMoreProducts: loadingMoreProducts,
        hideRecommendedProducts: hideRecommendedProducts,
        error: error,
        onError: loadData,
        showCategoryList: showCategoryList,
        onHeaderTitleTapped: () {
          setState(() {
            showCategoryList = !showCategoryList;
          });
        },
        onProductTapped: (product) async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                productParam: product,
              ),
            ),
          );

          refreshProducts();
        },
        onSearchIconTapped: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchProductPage(),
            ),
          );

          refreshProducts();
        },
        onProductDecreased: (product) {
          int newProductQuantity = product['quantity'] - 1;

          CartService.updateProductQuantity(
            product,
            newProductQuantity,
          ).then((response) {
            setState(() {
              product['quantity'] = newProductQuantity;
            });

            refreshProducts();
          });
        },
        onProductIncreased: (product) {
          bool inStock = product['in_stock'];
          int stockQuantity = product['stock_quantity'];

          if (inStock && product['quantity'] + 1 <= stockQuantity) {
            int newProductQuantity = product['quantity'] + 1;

            CartService.updateProductQuantity(
              product,
              newProductQuantity,
            ).then((response) {
              setState(() {
                product['quantity'] = newProductQuantity;
              });

              refreshProducts();
            });
          } else {
            AlertService.showErrorAlert(
              context: context,
              title: 'Stock',
              description:
                  'Solo existe $stockQuantity existencia(s) del producto ' +
                      product['name'],
            );
          }
        },
        onCategoryListItemTap: (category) {
          setState(() {
            showCategoryList = false;
            currentCategory = category;
            hideRecommendedProducts = false;
            scrollController.dispose();
            scrollController = null;
            showAllRecommendedProducts = false;
            showAllOnOfferedProducts = false;
          });

          _initScrollController();
          loadData();
        },
        onUserIconTapped: () async {
          if (!userIsLogged) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeLoginPage(),
              ),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserMenuPage(),
              ),
            );
          }

          _getUserData();
        },
        onCartIconTapped: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartDetailPage(),
            ),
          );

          _getUserData();
          refreshProducts();
        },
        scrollController: scrollController,
      ).build(),
    );
  }
}
