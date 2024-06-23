import 'package:http/http.dart' as http;
import 'dart:convert';

class Location {
  String currentLocation = '';

  Future<void> fetchData() async {
    const url =
        'https://vanitysoft-boundaries-io-v1.p.rapidapi.com/rest/v1/public/boundary/censustract/within?latitude=37.5053796&longitude=-77.5550683';
    const apiKey = '4d10c89cbcmshe2fd1c1667c77ffp1e3733jsnedabffda54c0';
    const apiHost = 'vanitysoft-boundaries-io-v1.p.rapidapi.com';

    final headers = {
      'x-rapidapi-key': apiKey,
      'x-rapidapi-host': apiHost,
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Map map1 = jsonDecode(response.body);
        currentLocation = map1['features'][0]['properties']['county'];
        print(map1);
        print(currentLocation);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
