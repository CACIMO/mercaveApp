import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/app/config.api.service.dart';
import 'package:mercave/app/core/services/app/neighborhood.api.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail.controller.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail_stepper_controller.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_five.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_four.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_one.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_three.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_two.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class OrderDetailStepper extends StatefulWidget {
  BuildContext context;
  OrderDetailStepper({key, this.context}) : super(key: key);

  @override
  _OrderDetailStepperState createState() => _OrderDetailStepperState();
}

class _OrderDetailStepperState extends State<OrderDetailStepper> {
  bool error = false;
  bool loading = false;
  int userId;
  bool userIsLogged = false;
  bool checkoutSuccessful = false;

  int _currentStep = 0;
  Map userData;
  List deliveryDays;
  double heightStepContent = 0;

  //Data related to Step One
  List<String> neighborhoods = [];
  final _stepOneForm = GlobalKey<FormState>();
  TextEditingController selectedNeighborhood = TextEditingController();
  TextEditingController selectedStreet = TextEditingController();
  TextEditingController textCtrlPlatePart1 = TextEditingController();
  TextEditingController textCtrlPlatePart2 = TextEditingController();
  TextEditingController textCtrlPlatePart3 = TextEditingController();
  TextEditingController textCtrlAdditionalInfo = TextEditingController();

  //Data related to Step Two
  String dayIdSelected;
  String hourIdSelected;
  bool deliveryDateHourError = false;

  //Data related to Step Three
  String paymentMethodSelected;
  bool paymentMethodError = false;

  //Data related to Step Four
  final _stepFourForm = GlobalKey<FormState>();
  String customerType;
  String typeIdSelected;
  bool customerTypeError = false;

  Map userBilledData = {
    'user_id': '',
    'full_name': '',
    'identification_type': '',
    'identification_number': ''
  };

  //Data related to Step Five
  final _cashAmountForm = GlobalKey<FormState>();
  TextEditingController amountCashToPayWith = TextEditingController();
  double total = 0.0;
  double totalResume = 0.0;
  double savedResume = 0.0;
  Map couponData;
  String couponError;
  String couponSubtitle = '';
  double couponDiscountTotal;
  String amountCashError;

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() async {
    setState(() {
      loading = true;
      error = false;
    });

    try {
      deliveryDays = await ConfigAPIService.getDeliveryDays();
      userId = await AuthService.getUserIdLogged();
      userData = await UserDBService.getUserById(id: userId);

      // In case that in the first use of the app, user decides not to log in and then they add products to the cart and go through the steps filling out forms,
      // they might decide to checkout, during that process the user is promted to login after doing so, user is redirected back here and the user data associated to user id 0 is
      // assigned to this logged in user
      if (userData != null) {
        if ((userData['neighborhood'] == null ||
                userData['payment_method'] == null ||
                userData['client_type'] == null) &&
            userId != 0) {
          Map userZeroData = await UserDBService.getUserById(id: 0);

          if (userZeroData != null) {
            await OrderDetailStepperController.setLoggedInUserData(
                userZeroData, userId, context);

            userData = await UserDBService.getUserById(id: userId);
          }
        }

        getUserData();
      }

      var neighborhoodsData = await NeighborhoodAPIService.getNeighborhoods();
      setNeighborhoodsData(neighborhoodsData);

      if (userData != null) {
        if (userId > 0) setState(() => userIsLogged = true);
      }

      getCartData();

      setState(() {
        loading = false;
        error = false;
      });
    } catch (e) {
      if (this.mounted) {
        setState(() {
          loading = false;
          error = true;
        });
      }
    }
  }

  setNeighborhoodsData(List neighborhoodsData) {
    for (var i = 0; i < neighborhoodsData.length; i++) {
      if (neighborhoodsData[i]['active']) {
        neighborhoods.add(neighborhoodsData[i]['neighborhood']);
      }
    }

    neighborhoods.sort((a, b) => a.compareTo(b));
  }

  getUserData() async {
    //STEO ONE INFO
    if (userData['neighborhood'] != null &&
        userData['type_of_road'] != null &&
        userData['plate_part_1'] != null &&
        userData['plate_part_2'] != null &&
        userData['plate_part_3'] != null) {
      setState(() {
        selectedNeighborhood.text = userData['neighborhood'];
        selectedStreet.text = userData['type_of_road'];
        textCtrlPlatePart1.text = userData['plate_part_1'];
        textCtrlPlatePart2.text = userData['plate_part_2'];
        textCtrlPlatePart3.text = userData['plate_part_3'];
      });

      if (userData['address_info'] != null && userData['address_info'] != '')
        setState(() => textCtrlAdditionalInfo.text = userData['address_info']);
    }

    //STEP TWO INFO
    var dayIdSelectedSession =
        await SessionService.getItem(key: 'deliveryDayIdSelected');
    var hourIdSelectedSession =
        await SessionService.getItem(key: 'deliveryHourIdSelected');

    if (dayIdSelectedSession != null) {
      var daySelected = this
          .deliveryDays
          .where((day) => day['id'] == dayIdSelectedSession)
          .toList();

      if (daySelected.length > 0) {
        dayIdSelected = dayIdSelectedSession;
      }

      if (this.dayIdSelected != null) {
        var existHourSelected = daySelected[0]['horarios_de_entrega']
            .where((hour) => hour['id'] == hourIdSelectedSession)
            .toList();

        if (existHourSelected.length > 0) {
          hourIdSelected = hourIdSelectedSession;
        }
      }
    }

    //STEP THREE INFO
    if (userData['payment_method'] != null) {
      setState(() => paymentMethodSelected = userData['payment_method']);
    }
    //STEP FOUR INFO
    if (userData['client_type'] != null &&
        userData['billing_name'] != null &&
        userData['billing_identification_type'] != null &&
        userData['billing_identification_number'] != null) {
      setState(() {
        customerType = userData['client_type'];
        userBilledData['full_name'] = userData['billing_name'];
        userBilledData['identification_type'] =
            userData['billing_identification_type'];
        userBilledData['identification_number'] =
            userData['billing_identification_number'];
      });
    }
  }

  updateCartWithCoupon() async {
    String couponDataSession = await SessionService.getItem(key: 'couponData');

    if (couponDataSession != null) {
      setState(() => couponData = json.decode(couponDataSession));
    } else {
      setState(() => couponData = null);
    }

    /// Process type and amount of discount
    if (couponData != null) {
      String discountType = couponData['discount_type'];
      double discountQuantity = double.tryParse(couponData['amount']);

      couponError = OrderDetailController().getCouponError(
        couponData: couponData,
        cartTotal: total,
      );

      setState(() {
        if (discountType == 'percent') {
          couponSubtitle += ' -$discountQuantity %';
        } else if (discountType == 'fixed_cart') {
          couponSubtitle += ' -\$ $discountQuantity';
        }
      });

      setState(() {
        if (couponError == null) {
          if (discountType == 'percent') {
            couponDiscountTotal = total * discountQuantity / 100;
          } else if (discountType == 'fixed_cart') {
            couponDiscountTotal = discountQuantity;
          }

          totalResume -= couponDiscountTotal;
          savedResume += couponDiscountTotal;
        }
      });
    }
  }

  getCartData() {
    CartService.getCart().then((cart) {
      setState(() {
        total = cart['cart_total'];
        savedResume = cart['amount_saved'];
        totalResume = cart['cart_total'];

        updateCartWithCoupon();
      });
    }).catchError((error) {});
  }

  next() {
    if (_currentStep == 4) {
      verifyCheckoutInfo();
    } else {
      if (_currentStep == 0 && !_stepOneForm.currentState.validate()) {
        return;
      } else if ((_currentStep == 1 && dayIdSelected == null) ||
          (_currentStep == 1 && hourIdSelected == null)) {
        setState(() => deliveryDateHourError = true);
      } else if (_currentStep == 2 && paymentMethodSelected == null) {
        setState(() => paymentMethodError = true);
        return;
      } else if (_currentStep == 3) {
        if (_stepFourForm.currentState != null)
          _stepFourForm.currentState.save();

        if (customerType == null) {
          setState(() => customerTypeError = true);
          return;
        } else if (userBilledData['full_name'] == '' ||
            userBilledData['identification_number'] == '') {
          _stepFourForm.currentState.validate();
          return;
        } else {
          OrderDetailStepperController.saveStepFourDataToLocalStorage(
              context, userBilledData, userId, customerType);

          setState(() => _currentStep++);
        }
      } else {
        if (_currentStep == 0) {
          OrderDetailStepperController.saveStepOneDataToLocalStorage(
              selectedNeighborhood.text,
              selectedStreet.text,
              textCtrlPlatePart1.text,
              textCtrlPlatePart2.text,
              textCtrlPlatePart3.text,
              textCtrlAdditionalInfo.text,
              userId,
              context,
              false);
        } else if (_currentStep == 1) {
          OrderDetailStepperController.saveStepTwoDataToLocalStorage(
              deliveryDays, dayIdSelected, hourIdSelected);
        } else if (_currentStep == 2) {
          OrderDetailStepperController.saveStepThreeDataToLocalStorage(
              context, userId, paymentMethodSelected);
        }

        setState(() => _currentStep++);
      }
    }
  }

  onStepTapped(int index) {
    if (checkoutSuccessful)
      return; //Disable step buttons when checkout is successful

    bool canGoToTappedStep = false;
    var i;

    if (index > _currentStep) {
      for (i = _currentStep; i <= index; i++) {
        if (i == 0 && !_stepOneForm.currentState.validate()) {
          break;
        } else if (i == 1 && index != 1) {
          if (dayIdSelected == null || hourIdSelected == null) {
            setState(() => deliveryDateHourError = true);
            canGoToTappedStep = false;
            break;
          }
        } else if (i == 2 && index != 2) {
          if (paymentMethodSelected == null) {
            setState(() => paymentMethodError = true);
            canGoToTappedStep = false;
            break;
          }
        } else if (i == 3 && index != 3) {
          if (_stepFourForm.currentState != null)
            _stepFourForm.currentState.save();

          if (customerType == null) {
            setState(() => customerTypeError = true);
            break;
          } else if (userBilledData['full_name'] != '' &&
              userBilledData['identification_number'] != '') {
            OrderDetailStepperController.saveStepFourDataToLocalStorage(
                context, userBilledData, userId, customerType);
            canGoToTappedStep = true;
          } else {
            _stepFourForm.currentState.validate();
            break;
          }
        } else {
          if (_currentStep == 0) {
            _stepOneForm.currentState.save();
            OrderDetailStepperController.saveStepOneDataToLocalStorage(
                selectedNeighborhood.text,
                selectedStreet.text,
                textCtrlPlatePart1.text,
                textCtrlPlatePart2.text,
                textCtrlPlatePart3.text,
                textCtrlAdditionalInfo.text,
                userId,
                context,
                false);
          } else if (_currentStep == 1) {
            OrderDetailStepperController.saveStepTwoDataToLocalStorage(
                deliveryDays, dayIdSelected, hourIdSelected);
          } else if (_currentStep == 2) {
            setState(() => paymentMethodError = false);
            OrderDetailStepperController.saveStepThreeDataToLocalStorage(
                context, userId, paymentMethodSelected);
          }

          canGoToTappedStep = true;
        }
      }
    } else {
      //Go back is always allowed since steps are validated
      canGoToTappedStep = true;
    }

    if (canGoToTappedStep) {
      setState(() => _currentStep = index);
    } else {
      setState(() => _currentStep = i);
      return;
    }
  }

  //On Android devices, handle Back button pressed event
  Future<bool> goBackStepByStep() {
    if (checkoutSuccessful) {
      //Redirect option when checkout is successful in case confirmation dialog fails to be displayed
      goHome();
    } else {
      if (_currentStep >= 1) {
        setState(() => _currentStep--);
      } else {
        Navigator.pop(context);
      }
    }

    return Future.value(false);
  }

  // ----------------------------  STEP ONE METHODS ---------------------------

  onSelectedNeighborhood(String neighborhood) {
    setState(() => selectedNeighborhood.text = neighborhood);
  }

  onStreetSelected(String street) {
    setState(() => selectedStreet.text = street);
  }

  ontextCtrlPlatePart1(String textCtrlPlatePartUI) {
    setState(() => textCtrlPlatePart1.text = textCtrlPlatePartUI);
  }

  ontextCtrlPlatePart2(String textCtrlPlatePart2UI) {
    setState(() => textCtrlPlatePart2.text = textCtrlPlatePart2UI);
  }

  ontextCtrlPlatePart3(String textCtrlPlatePart3UI) {
    setState(() => textCtrlPlatePart3.text = textCtrlPlatePart3UI);
  }

  onTextCtrlAdditionalInfo(String textCtrlAdditionalInfoUI) {
    setState(() => textCtrlAdditionalInfo.text = textCtrlAdditionalInfoUI);
  }

  // ----------------------------  STEP TWO METHODS ---------------------------
  void getDeliveryDay(String daySelected) {
    setState(() {
      deliveryDateHourError = false;
      dayIdSelected = daySelected;
    });
  }

  void getDeliveryHour(String hourSelected) {
    setState(() {
      deliveryDateHourError = false;
      hourIdSelected = hourSelected;
    });
  }

  // ----------------------------  STEP THREE METHODS ---------------------------
  void getStepThreeData(String paymentMethod) {
    setState(() {
      paymentMethodError = false;
      paymentMethodSelected = paymentMethod;
    });
  }

  // ----------------------------  STEP THREE METHODS ---------------------------
  void getStepFourData(String customerTypeSelected) {
    setState(() {
      customerTypeError = false;
      customerType = customerTypeSelected;
    });
  }

  // ----------------------------  STEP FOUR METHODS ---------------------------
  onSaveData(Map dataToSave) {
    setState(() => userBilledData = dataToSave);
  }

  // ----------------------------  STEP FIVE METHODS ---------------------------
  verifyCheckoutInfo() async {
    LoaderService.showLoader(
      context: context,
      text: 'Finalizando pedido...',
    );

    //Check inventory
    bool validInventory =
        await OrderDetailStepperController.verifyCartProductsInventory(
            context, getCartData);
    // DESARROLLO
    // bool validInventory = true;
    if (validInventory) {
      //Check minimum payment amount according to Payment method
      bool enoughPurchaseAmount =
          await OrderDetailStepperController.minimumPaymentValue(
                  context, paymentMethodSelected, totalResume)
              .then((enoughAmount) => enoughAmount);

      if (!enoughPurchaseAmount) return;

      //Ask for amount of money the User is goign to pay mith
      if (paymentMethodSelected == 'cash' && amountCashToPayWith.text == '') {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: _payWithCashDialog);
      } else {
        proceedToCheckout();
      }
    } else {
      getCartData();
    }
  }

  proceedToCheckout() {
    OrderDetailStepperController.checkout(
        context,
        userIsLogged,
        couponData,
        total,
        paymentMethodSelected,
        total,
        double.tryParse(amountCashToPayWith.text),
        totalResume,
        couponDiscountTotal,
        userBilledData, () {
      setState(() {
        checkoutSuccessful = true;
      });
    });
  }

  goHome() {
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  Widget build(BuildContext context) {
    if (loading || error) {
      return PageLoaderWidget(
        error: error,
        onError: () async {
          await _init();
        },
      );
    }
    return WillPopScope(
      onWillPop: goBackStepByStep,
      child: Scaffold(
        appBar: _getAppBarWidget(context),
        body: _getBodyWidget(context),
      ),
    );
  }

  Widget _payWithCashDialog(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        LoaderService.dismissLoader(context: context);
        LoaderService.dismissLoader(context: context);
        return Future.value(true);
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: Text(
          'A pagar con',
          style: TextStyle(
            color: kCustomPrimaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Indique con cuánto va a pagar para calcular su cambio:'),
            SizedBox(height: 10.0),
            Form(
              key: _cashAmountForm,
              child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: amountCashToPayWith != null
                      ? amountCashToPayWith.text
                      : '',
                  keyboardType: TextInputType.number,
                  cursorColor: kCustomPrimaryColor,
                  decoration: InputDecoration(
                    hintText: 'Ingrese cantidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    fillColor: kCustomWhiteColor,
                    focusColor: kCustomWhiteColor,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Por favor, ingrese una cantidad';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    setState(() => amountCashToPayWith.text = value);
                  }),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_cashAmountForm.currentState.validate()) {
                _cashAmountForm.currentState.save();
                AlertService.dismissAlert(context: context);
                proceedToCheckout();
              } else
                return;
            },
            child: Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kCustomWhiteColor,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (checkoutSuccessful) {
                      //Redirect option when checkout is successful in case confirmation dialog fails to be displayed
                      goHome();
                    } else if (_currentStep >= 1) {
                      setState(() => _currentStep--);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    'assets/icons/back_arrow.png',
                    width: 25.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    _currentStep == 0
                        ? 'Datos de envío'
                        : _currentStep == 1
                            ? 'Fecha de entrega'
                            : _currentStep == 4
                                ? 'Confirmar Pedido'
                                : 'Forma de pago',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF8D2789, kCutomkColor);
    //Calculate stepper content height
    double bodyheight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    heightStepContent =
        bodyheight - (76 + 24 + 45 + 24); //Steps + padding + button + padding
    return Material(
        child: Container(
      height: double.infinity,
      child: Theme(
        data: ThemeData(
            accentColor: colorCustom,
            primarySwatch: colorCustom,
            colorScheme: ColorScheme.light(primary: colorCustom)),
        child: Stepper(
          type: StepperType.horizontal,
          physics: ClampingScrollPhysics(),
          currentStep: _currentStep,
          onStepContinue: next,
          onStepTapped: onStepTapped,
          /* 
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width - 50,
              child: Stack(overflow: Overflow.visible, children: <Widget>[
                Positioned(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  top: 5,
                  left: 2,
                  child: ElevatedButton(
                      onPressed: checkoutSuccessful ? goHome : onStepContinue,
                      child: Text(
                        checkoutSuccessful
                            ? 'Exitoso - Salir'
                            : _currentStep == 4
                                ? 'Finalizar compra'
                                : 'Siguiente',
                        style: TextStyle(fontSize: 17),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 13.0),
                        primary: kCustomPrimaryColor,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      )),
                )
              ]),
              // Visibility(
              //   child: ElevatedButton(
              //       onPressed: onStepContinue,
              //       child: Text(
              //         _currentStep == 4 ? 'Finalizar compra' : 'Siguiente',
              //         style: TextStyle(fontSize: 17),
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         padding: EdgeInsets.symmetric(vertical: 13.0),
              //         primary: kCustomPrimaryColor,
              //         onPrimary: Colors.white,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(32.0),
              //         ),
              //       )),
              // ),
            );
          }, */
          steps: [
            Step(
                title: Text(""),
                content: Container(
                  height: heightStepContent,
                  alignment: Alignment.centerLeft,
                  child: StepOne(
                    neighborhoods: neighborhoods,
                    formKey: _stepOneForm,
                    onSelectedNeighborhood: onSelectedNeighborhood,
                    onStreetSelected: onStreetSelected,
                    ontextCtrlPlatePart1: ontextCtrlPlatePart1,
                    ontextCtrlPlatePart2: ontextCtrlPlatePart2,
                    ontextCtrlPlatePart3: ontextCtrlPlatePart3,
                    onTextCtrlAdditionalInfo: onTextCtrlAdditionalInfo,
                    selectedNeighborhood: selectedNeighborhood,
                    selectedStreet: selectedStreet,
                    textCtrlPlatePart1: textCtrlPlatePart1,
                    textCtrlPlatePart2: textCtrlPlatePart2,
                    textCtrlPlatePart3: textCtrlPlatePart3,
                    textCtrlAdditionalInfo: textCtrlAdditionalInfo,
                  ),
                ),
                isActive: _currentStep >= 0 && !checkoutSuccessful),
            Step(
                title: Text(""),
                content: Container(
                  height: heightStepContent,
                  child: StepTwo(
                    dayIdSelected: dayIdSelected,
                    hourIdSelected: hourIdSelected,
                    deliveryDateHourError: deliveryDateHourError,
                    getDeliveryDay: getDeliveryDay,
                    getDeliveryHour: getDeliveryHour,
                    deliveryDays: deliveryDays,
                  ),
                ),
                isActive: _currentStep >= 1 && !checkoutSuccessful),
            Step(
                title: Text(""),
                content: Container(
                  height: heightStepContent,
                  alignment: Alignment.centerLeft,
                  child: StepThree(
                      getData: getStepThreeData,
                      paymentMethod: paymentMethodSelected,
                      paymentMethodError: paymentMethodError),
                ),
                isActive: _currentStep >= 2 && !checkoutSuccessful),
            Step(
                title: Text(""),
                content: Container(
                  height: heightStepContent,
                  alignment: Alignment.centerLeft,
                  child: StepFour(
                      customerType: customerType,
                      customerTypeError: customerTypeError,
                      getData: getStepFourData,
                      formKey: _stepFourForm,
                      userBilledData: userBilledData,
                      saveData: onSaveData),
                ),
                isActive: _currentStep >= 3 && !checkoutSuccessful),
            Step(
                title: Text(""),
                content: Container(
                  height: heightStepContent,
                  alignment: Alignment.topLeft,
                  child: StepFive(
                      total: total,
                      couponData: couponData,
                      updateCartWithCoupon: updateCartWithCoupon,
                      totalResume: totalResume,
                      couponError: couponError,
                      couponSubtitle: couponSubtitle,
                      couponDiscountTotal: couponDiscountTotal,
                      savedResume: savedResume,
                      deliveryDays: deliveryDays,
                      selectedStreet: selectedStreet.text,
                      textCtrlPlatePart1: textCtrlPlatePart1.text,
                      textCtrlPlatePart2: textCtrlPlatePart2.text,
                      textCtrlPlatePart3: textCtrlPlatePart3.text,
                      neighborhoodSelected: selectedNeighborhood.text,
                      paymentMethodSelected: paymentMethodSelected,
                      shippingDaySelected: dayIdSelected,
                      shippingHourSelected: hourIdSelected,
                      billingName: userBilledData['full_name'],
                      billingIdentificationType:
                          userBilledData['identification_type'],
                      billingIdentificationNumber:
                          userBilledData['identification_number']),
                ),
                isActive: _currentStep >= 4 && !checkoutSuccessful),
          ],
        ),
      ),
    ));
  }
}
