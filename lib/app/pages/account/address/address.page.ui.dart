import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/core/services/wordpress/wodpress.service.dart';
import 'package:mercave/app/pages/search/search.page.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class AddressPageUI {
  final TextEditingController textCtrlPlatePart1;
  final TextEditingController textCtrlPlatePart2;
  final TextEditingController textCtrlPlatePart3;
  final TextEditingController textCtrlAdditionalInfo;

  final BuildContext context;
  final List neighborhoods;
  final List streets;
  final String selectedNeighborhood;
  final String selectedStreet;
  final Function onSelectedNeighborhood;
  final Function onSelectedStreet;
  final int userId;
  final bool loading;
  final bool error;
  final Function onError;

  AddressPageUI({
    @required this.context,
    @required this.neighborhoods,
    @required this.streets,
    @required this.selectedNeighborhood,
    @required this.selectedStreet,
    @required this.onSelectedNeighborhood,
    @required this.onSelectedStreet,
    @required this.textCtrlPlatePart1,
    @required this.textCtrlPlatePart2,
    @required this.textCtrlPlatePart3,
    @required this.textCtrlAdditionalInfo,
    @required this.userId,
    @required this.loading,
    @required this.error,
    @required this.onError,
  });

  Widget build() {
    if (loading || error) {
      return PageLoaderWidget(
        error: error,
        onError: onError,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomWhiteColor),
      home: Scaffold(
        appBar: _getAppBarWidget(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Barrio',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: kCustomPrimaryColor,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        title: selectedNeighborhood == null ||
                                selectedNeighborhood == ''
                            ? Text('Seleccione el barrio')
                            : Text(selectedNeighborhood),
                        trailing: GestureDetector(
                          child: Icon(Icons.arrow_forward),
                        ),
                        onTap: () async {
                          final itemSelected = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(
                                items: neighborhoods,
                                hintText: 'Seleccione el barrio',
                                noItemsFoundText:
                                    'No se han encontrado resultados',
                              ),
                            ),
                          );

                          if (itemSelected != null) {
                            onSelectedNeighborhood(itemSelected);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Ingrese la dirección',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: kCustomPrimaryColor,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 55.0,
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            title:
                                selectedStreet == null || selectedStreet == ''
                                    ? Text('Seleccion el tipo de vía')
                                    : Text(selectedStreet),
                            trailing: GestureDetector(
                              child: Icon(Icons.arrow_forward),
                            ),
                            onTap: () async {
                              final itemSelected = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                    items: streets,
                                    hintText: 'Seleccione el tipo de vía',
                                    noItemsFoundText:
                                        'No se han encontrado resultados',
                                  ),
                                ),
                              );

                              if (itemSelected != null) {
                                onSelectedStreet(itemSelected);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: textCtrlPlatePart1,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                hintText: '12 Sur',
                                hintStyle: TextStyle(color: kCustomHintColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kCustomPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '#',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: textCtrlPlatePart2,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                hintText: '34',
                                hintStyle: TextStyle(color: kCustomHintColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kCustomPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '-',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: textCtrlPlatePart3,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                hintText: '26',
                                hintStyle: TextStyle(color: kCustomHintColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kCustomPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: textCtrlAdditionalInfo,
                              textAlign: TextAlign.left,
                              maxLines: null,
                              decoration: new InputDecoration(
                                hintText: 'Información adicional',
                                hintStyle: TextStyle(color: kCustomHintColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kCustomPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ButtonTheme(
                        height: 50.0,
                        minWidth: MediaQuery.of(context).size.width,
                        child: RoundButtonWidget(
                          text: 'Guardar',
                          onPressed: () async {
                            LoaderService.showLoader(
                              context: context,
                              text: 'Actualizando dirección...',
                            );

                            try {
                              Map userData = {
                                'id': userId,
                                'neighborhood': selectedNeighborhood,
                                'type_of_road': selectedStreet,
                                'plate_part_1': textCtrlPlatePart1.text,
                                'plate_part_2': textCtrlPlatePart2.text,
                                'plate_part_3': textCtrlPlatePart3.text,
                                'address_info': textCtrlAdditionalInfo.text
                              };

                              /// ==================================================================
                              /// Update wordPress meta user info
                              /// ==================================================================
                              if (userId > 0) {
                                dynamic metadata = {
                                  "barrio": selectedNeighborhood,
                                  "via": selectedStreet,
                                  "placa_no_1": textCtrlPlatePart1.text,
                                  "placa_no_2": textCtrlPlatePart2.text,
                                  "placa_no_3": textCtrlPlatePart3.text,
                                  "informacion_direccion":
                                      textCtrlAdditionalInfo.text,
                                };

                                await WordPressService
                                    .updateWordPressUserMetadata(
                                  userId: userId,
                                  metadata: metadata,
                                );
                              }

                              /// ==================================================================
                              /// Update local user info
                              /// ==================================================================
                              await UserDBService.createUpdateUser(
                                userData: userData,
                              );

                              LoaderService.dismissLoader(context: context);
                              Navigator.pop(context);
                            } catch (e) {
                              LoaderService.dismissLoader(context: context);

                              AlertService.showErrorAlert(
                                context: context,
                                title: 'Error',
                                description: e.message,
                                onClose: () {},
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAppBarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Image.asset(
                    'assets/icons/back_arrow.png',
                    width: 25.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Verífique los datos de envío',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
