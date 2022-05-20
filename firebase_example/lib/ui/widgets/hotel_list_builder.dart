import 'package:firebase_example/domain/app_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantity_input/quantity_input.dart';
import '../../data/hotel.dart';
import '../../domain/hotel_list.dart';

class HotelListBuilder extends ConsumerWidget {
  const HotelListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Stream<List<HotelPreview>> _hotels;
    final hotelsList = ref.watch(hotelsListProvider);
    final provider = ref.watch(hotelsListProvider.notifier);
    final iconsState = ref.watch(appStateProvider);
    final iconProvider = ref.watch(appStateProvider.notifier);
    final storage = FirebaseStorage.instance;
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
              List<HotelPreview> _hotelList = snapshot.data!;
              return //GridViewBuilder(hotelList: snapshot.data!);
                  ListView.builder(
                      shrinkWrap: true,
                      controller: ScrollController(keepScrollOffset: false),
                      itemCount: _hotelList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(45)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: FutureBuilder(
                                          future: storage
                                              .ref(
                                                  'images/${_hotelList[index].poster}')
                                              .getDownloadURL(),
                                          builder: (context, assetSnapshot) {
                                            return assetSnapshot.hasData
                                                ? Image.network(
                                                    assetSnapshot.data
                                                        .toString(),
                                                    fit: BoxFit.scaleDown,
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                          })),
                                  Expanded(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            _hotelList[index].name,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                          QuantityInput(
                                            inputWidth: 30,
                                            value: _hotelList[index].rating,
                                            onChanged: (hotelRating) =>
                                                provider.editHotel(
                                                    _hotelList[index].copyWith(
                                                        rating: int.parse(
                                                            hotelRating
                                                                .replaceAll(
                                                                    ',', '')))),
                                            maxValue: 10,
                                          ),
                                          Expanded(
                                            child: TextButton(
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    _hotelList[index].booked
                                                        ? Colors.red
                                                        : Colors.lightBlue,
                                                // background
                                                onPrimary:
                                                    Colors.white, // foreground
                                              ),
                                              onPressed: () => provider
                                                  .editHotel(_hotelList[index]
                                                      .copyWith(
                                                          booked:
                                                              !_hotelList[index]
                                                                  .booked)),
                                              child: const Text(
                                                'Я здесь был',
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          )
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
