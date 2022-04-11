import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../domain/hotel_list.dart';
import 'grid_view_builder.dart';

class HotelListBuilder extends StatefulWidget {
  const HotelListBuilder({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HotelListBuilderState();
}

class _HotelListBuilderState extends State<HotelListBuilder> {
  final HotelList hotelList = HotelList();

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return FutureBuilder(
      future: hotelList.getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return GridViewBuilder(snapshot: snapshot);
            } else {
              return const CircularProgressIndicator();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
