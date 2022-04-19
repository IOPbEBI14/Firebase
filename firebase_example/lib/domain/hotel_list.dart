import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hotel.dart';

enum SortOrder { asc, desc, none }

// String _hotelsURL =
//     'https://run.mocky.io/v3/ac888dc5-d193-4700-b12c-abb43e289301';

final hotelsListProvider =
    StateNotifierProvider<HotelList, Stream<List<HotelPreview>>>(
        (state) => HotelList());

class HotelList extends StateNotifier<Stream<List<HotelPreview>>> {
  HotelList() : super(Stream.value([]));
  SortOrder sortOrder = SortOrder.none;
  late CollectionReference<HotelPreview> _hotels;

  Stream<List<HotelPreview>> getDataFromDatabase() {
    _hotels = FirebaseFirestore.instance
        .collection('hotels')
        .withConverter<HotelPreview>(
            fromFirestore: (snapshot, _) =>
                HotelPreview.fromJson(snapshot.data()!),
            toFirestore: (hotel, _) => hotel.toJson());
    if (sortOrder == SortOrder.none) {
      return _hotels
          .snapshots()
          .map((e) => e.docs.map((e) => e.data()).toList());
    } else {
      return _hotels
          .orderBy('name', descending: sortOrder == SortOrder.desc)
          .snapshots()
          .map((e) => e.docs.map((e) => e.data()).toList());
    }
  }

  void sortHotelsByName() {
    if (sortOrder == SortOrder.asc) {
      sortOrder = SortOrder.desc;
    } else {
      sortOrder = SortOrder.asc;
    }
    state = getDataFromDatabase();
  }
}
