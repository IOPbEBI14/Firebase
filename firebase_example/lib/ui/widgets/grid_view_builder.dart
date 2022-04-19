import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/hotel.dart';
import '../../domain/current_hotel.dart';

class GridViewBuilder extends ConsumerWidget {
  final List<HotelPreview> hotelList;

  const GridViewBuilder({required this.hotelList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentHotel = ref.watch(currentHotelProvider);
    final provider = ref.watch(currentHotelProvider.notifier);
    final storage = FirebaseStorage.instance;

    return GridView.builder(
        shrinkWrap: true,
        controller: ScrollController(keepScrollOffset: false),
        itemCount: hotelList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder(
                    future: storage
                        .ref('images/${hotelList[index].poster}')
                        .getDownloadURL(),
                    builder: (context, assetSnapshot) {
                      return Expanded(
                        child: assetSnapshot.hasData
                            ? Image.network(
                                assetSnapshot.data.toString(),
                                fit: BoxFit.fill,
                              )
                            : const Center(child: CircularProgressIndicator()),
                      );
                    }),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        hotelList[index].name,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              (hotelList[index].uuid == currentHotel.toString())
                                  ? Colors.red
                                  : Colors.lightBlue,
                          // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          provider.setCurrentHotel(hotelList[index].uuid);
                        },
                        child: Text(
                          (hotelList[index].uuid == currentHotel.toString())
                              ? 'Забронировано'
                              : 'Забронировать',
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ])
              ]);
        });
  }
}
