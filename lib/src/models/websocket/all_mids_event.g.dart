// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_mids_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllMidsEvent _$AllMidsEventFromJson(Map<String, dynamic> json) => AllMidsEvent(
      data: (json['data'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$AllMidsEventToJson(AllMidsEvent instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
