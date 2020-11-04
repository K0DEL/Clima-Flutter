import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get (url);
      var data;
    if(response.statusCode == 200){
      data = response.body;

    }else{
      print(response.statusCode);
      data = null;
    }
    return data;
  }
}