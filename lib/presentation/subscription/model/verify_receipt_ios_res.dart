import 'package:http/http.dart' as http;
import 'package:formula_user/presentation/subscription/model/purchase_receipt_ios.dart';

class VerifyReceiptIOSRes {
  final PurchaseReceiptIOS purchaseReceiptIOS;
  final http.Response response;
  VerifyReceiptIOSRes(
      {required this.purchaseReceiptIOS, required this.response});
}
