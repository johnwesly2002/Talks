import 'package:json_annotation/json_annotation.dart';

part 'imagesModal.g.dart';

@JsonSerializable()
class imageModal {
  String id;
  String? title;
  String description;

  @JsonKey(name: 'url_full_size')
  String urlFullSize;
  @JsonKey(name: 'url_small_size')
  String urlSmallSize;
  imageModal(
      {this.title,
      required this.id,
      required this.description,
      required this.urlFullSize,
      required this.urlSmallSize});
  factory imageModal.fromJson(Map<String, dynamic> json) =>
      _$imageModalFromJson(json);
  imageModal toJson() => _$imageModalFromJson(this as Map<String, dynamic>);
}
