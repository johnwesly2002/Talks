// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagesModal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

imageModal _$imageModalFromJson(Map<String, dynamic> json) => imageModal(
      title: json['title'] as String?,
      id: json['id'] as String,
      description: json['description'] as String,
      urlFullSize: json['url_full_size'] as String,
      urlSmallSize: json['url_small_size'] as String,
    );

Map<String, dynamic> _$imageModalToJson(imageModal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'url_full_size': instance.urlFullSize,
      'url_small_size': instance.urlSmallSize,
    };
