import "dart:convert";
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:Talks/modals/imagesModal.dart';

class ImageRepository {
  Future<List<imageModal>> getNetworkImages() async {
    try {
      var endpointUrl = Uri.parse(
          'https://66498d494032b1331bee350c.mockapi.io/api/v1/Images');

      final response = await http.get(endpointUrl);
      if (response.statusCode == 200) {
        final List<dynamic> decodedList = jsonDecode(response.body) as List;
        final List<imageModal> _imageList = decodedList.map((listItem) {
          return imageModal.fromJson(listItem);
        }).toList();
        print(_imageList[0].urlFullSize);
        return _imageList;
      } else {
        // Handle unexpected status codes
        print('Failed to load images: ${response.statusCode}');
        throw Exception('API not Successful');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Couldnt retrive Images');
    } on FormatException {
      throw Exception("Bad Response format");
    } catch (e) {
      print(e);
      throw Exception('Unknown Exception');
    }
  }
}
