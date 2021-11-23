import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/neighborhood.api.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/pages/account/address/address.page.ui.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool error = false;
  bool loading = false;

  TextEditingController selectedNeighborhood = TextEditingController();
  TextEditingController selectedStreet= TextEditingController();
  int userId;

  TextEditingController textCtrlPlatePart1 = TextEditingController();
  TextEditingController textCtrlPlatePart2 = TextEditingController();
  TextEditingController textCtrlPlatePart3 = TextEditingController();
  TextEditingController textCtrlAdditionalInfo = TextEditingController();

  List<String> neighborhoods = [];

  List streets = [
    'Calle',
    'Carrera',
    'Avenida',
    'Avenida Carrera',
    'Circular',
    'Circunvalar',
    'Diagonal',
    'Manzana',
    'Transversal',
    'Via',
  ];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getNeighborhoods();
  }

  void _getUserData() async {
    userId = await AuthService.getUserIdLogged();
    Map userData = await UserDBService.getUserById(id: userId);

    if (userData != null) {
      setState(() {
        selectedNeighborhood.text = userData['neighborhood'];
        selectedStreet.text = userData['type_of_road'];
        textCtrlPlatePart1.text = userData['plate_part_1'];
        textCtrlPlatePart2.text = userData['plate_part_2'];
        textCtrlPlatePart3.text = userData['plate_part_3'];
        textCtrlAdditionalInfo.text = userData['address_info'];
      });
    } else {
      setState(() {
        selectedNeighborhood.text = '';
        selectedStreet.text = '';
        textCtrlPlatePart1.text = '';
        textCtrlPlatePart2.text = '';
        textCtrlPlatePart3.text = '';
        textCtrlAdditionalInfo.text = '';
      });
    }
  }

  void _getNeighborhoods() async {
    setState(() {
      loading = true;
      error = false;
    });

    try {
      var neighborhoodsData = await NeighborhoodAPIService.getNeighborhoods();

      for (var i = 0; i < neighborhoodsData.length; i++) {
        if (neighborhoodsData[i]['active']) {
          this.neighborhoods.add(neighborhoodsData[i]['neighborhood']);
        }
      }

      this.neighborhoods.sort((a, b) => a.compareTo(b));
      setState(() {
        loading = false;
        error = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddressPageUI(
        context: context,
        neighborhoods: neighborhoods,
        userId: userId,
        // streets: streets,
        selectedNeighborhood: selectedNeighborhood,
        selectedStreet: selectedStreet,
        // onSelectedNeighborhood: (neighborhood) {
        //   if (neighborhood is String) {
        //     setState(() {
        //       selectedNeighborhood = neighborhood;
        //     });
        //   }
        // },
        // onSelectedStreet: (street) {
        //   if (street is String) {
        //     setState(() {
        //       selectedStreet = street;
        //     });
        //   }
        // },
        textCtrlPlatePart1: textCtrlPlatePart1,
        textCtrlPlatePart2: textCtrlPlatePart2,
        textCtrlPlatePart3: textCtrlPlatePart3,
        textCtrlAdditionalInfo: textCtrlAdditionalInfo,
        loading: loading,
        error: error,
        onError: () {
          _getNeighborhoods();
        }
        ).build();
  }
}
