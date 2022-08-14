import 'package:random/model/item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//ProductItems item
Future<ProductItems> getItemList() async {
  String apiurl = 'https://electronic-ecommerce.herokuapp.com/api/v1/product';
  print('apicall');
  try {
    http.Response response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      print('apihit');
      var data = json.decode(response.body.toString());
      print('apireturn');
      return ProductItems.fromJson(data);
    } else {
      print('failed');
      return ProductItems.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}
