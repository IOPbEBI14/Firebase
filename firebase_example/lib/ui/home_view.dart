import 'package:flutter/material.dart';
import './widgets/hotel_list_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Center(child: HotelListBuilder()));
  }
}
