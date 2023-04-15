import 'package:intl/intl.dart'; 
enum AlertAction {
  cancel,
  discard,
  disagree,
  agree,
}

const String apiUserURL = "https://reqres.in/api/users/2";
const String apiURL = "https://app.aiapos.vn/api-v2";
const String apiURLV2 = "https://app.aiapos.vn/api-v2";
const String apiHomeURL = "https://app.aiapos.vn/";

const String apiTable = "https://app.aiapos.vn/api-v2/table/";
const bool devMode = false;
const double textScaleFactor = 1.0;

const String currency = ' VNĐ';
var formatter = NumberFormat('#,###');
String showPriceText (total) {
  return ('${formatter.format(total.toInt())}'.replaceAll(',', '.').toString());
}