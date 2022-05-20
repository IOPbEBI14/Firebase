import 'package:json_annotation/json_annotation.dart';

part 'hotel.g.dart';

@JsonSerializable(explicitToJson: true)
class HotelPreview {
  @JsonKey(ignore: true)
  late String docId;
  final String uuid;
  final String name;
  final String poster;
  @JsonKey(defaultValue: false)
  final bool booked;
  @JsonKey(defaultValue: 5)
  final int rating;

  HotelPreview(
      {required this.uuid,
      required this.name,
      required this.poster,
      required this.booked,
      required this.rating});

  factory HotelPreview.fromJson(String documentId, Map<String, dynamic> json) {
    HotelPreview hotel = _$HotelPreviewFromJson(json);
    hotel.docId = documentId;
    return hotel;
  }

  Map<String, dynamic> toJson() => _$HotelPreviewToJson(this);

  HotelPreview copyWith({bool? booked, int? rating}) {
    return HotelPreview.init(
      docId: docId,
      uuid: uuid,
      name: name,
      poster: poster,
      booked: booked ?? this.booked,
      rating: rating ?? this.rating,
    );
  }

  HotelPreview.init(
      {required this.docId,
      required this.uuid,
      required this.name,
      required this.poster,
      required this.booked,
      required this.rating});
}
