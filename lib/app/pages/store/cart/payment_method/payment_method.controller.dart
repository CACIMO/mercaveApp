import 'package:flutter/cupertino.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';

class PaymentMethodController {
  void savePaymentMethodInfo(
      {@required BuildContext context,
      @required Map userBilledData,
      @required String paymentMethodSelected,
      @required String subPaymentMethodSelected,
      @required String typeClientSelected}) {
    AlertService.showConfirmAlert(
      context: context,
      title: 'Guardar',
      description: 'En realidad desea guardar la información de facturación?',
      onTapCancel: () {},
      onTapOk: () async {
        LoaderService.showLoader(
          context: context,
          text: 'Guardando...',
        );

        try {
          /// ==================================================================
          /// Update local user info
          /// ==================================================================
          Map userData = {
            'id': userBilledData['user_id'],
            'payment_method': paymentMethodSelected,
            'subpayment_method': subPaymentMethodSelected,
            'client_type': typeClientSelected,
            'billing_name': userBilledData['full_name'],
            'billing_identification_type':
                userBilledData['identification_type'],
            'billing_identification_number':
                userBilledData['identification_number'],
          };

          await UserDBService.createUpdateUser(
            userData: userData,
          );

          /// ==================================================================
          /// Redirect to checkout page
          /// ==================================================================
          LoaderService.dismissLoader(context: context);
          Navigator.pop(context);
        } catch (e) {
          LoaderService.dismissLoader(context: context);

          AlertService.showErrorAlert(
            context: context,
            title: 'Error al actualizar la información de facturación.',
            description: e.message,
          );
        }
      },
    );
  }
}
