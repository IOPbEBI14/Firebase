import 'package:firebase_example/domain/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/hotel.dart';
import '../../domain/hotel_list.dart';
import 'grid_view_builder.dart';

class HotelListBuilder extends ConsumerWidget {
  const HotelListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Stream<List<HotelPreview>> _hotels;
    final hotelsList = ref.watch(hotelsListProvider);
    final provider = ref.watch(hotelsListProvider.notifier);
    final iconsState = ref.watch(appStateProvider);
    final iconProvider = ref.watch(appStateProvider.notifier);
    _hotels = provider.getDataFromDatabase();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
                icon: Icon(iconsState.sortIcon),
                onPressed: () {
                  provider.sortHotelsByName();
                  if (iconsState.sortIcon == Icons.north) {
                    iconProvider.setSortIcon(Icons.south);
                  } else {
                    iconProvider.setSortIcon(Icons.north);
                  }
                }),
          ),
          Builder(
              builder: (context) => IconButton(
                    icon: Icon(iconsState.loginIcon),
                    onPressed: () {
                      if (iconsState.loginIcon == Icons.logout) {
                        iconProvider.logout();
                      } else {
                        iconProvider.login();
                      }
                    },
                  )),
        ],
      ),
      body: StreamBuilder<List<HotelPreview>>(
          stream: _hotels,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return GridViewBuilder(hotelList: snapshot.data!);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
