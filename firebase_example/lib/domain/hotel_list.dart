import 'package:dio/dio.dart';
import '../data/hotel.dart';

String _hotelsURL =
    'https://run.mocky.io/v3/ac888dc5-d193-4700-b12c-abb43e289301';

class HotelList {
  final Dio _dio = Dio();

  Future<List<HotelPreview>> getData() async {
    late Future<List<HotelPreview>> hotels;
    try {
      final responce = await _dio.get(_hotelsURL);
      hotels = Future.value(responce.data
          .map<HotelPreview>((hotel) => HotelPreview.fromJson(hotel))
          .toList());
    } on DioError catch (e) {
      hotels = Future.error(e.message);
    }
    return hotels;
  }
}
