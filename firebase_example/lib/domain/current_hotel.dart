import 'package:riverpod/riverpod.dart';

final currentHotelProvider =
    StateNotifierProvider<CurrentHotel, String>((_) => CurrentHotel());

class CurrentHotel extends StateNotifier<String> {
  CurrentHotel() : super('');

  void setCurrentHotel(String value) => state = value;
}
