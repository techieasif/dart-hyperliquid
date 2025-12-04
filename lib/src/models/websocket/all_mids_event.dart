import 'package:json_annotation/json_annotation.dart';
import 'ws_message.dart';

part 'all_mids_event.g.dart';

@JsonSerializable()
class AllMidsEvent extends WsMessage {
  final Map<String, double> data;

  AllMidsEvent({
    required this.data,
  }) : super('allMids');

  factory AllMidsEvent.fromJson(Map<String, dynamic> json) {
    // Handle the fact that 'data' is a Map<String, String> (stringified doubles)
    // or Map<String, double> depending on API consistency.
    // The Info API returned strings. Let's assume WS might too.
    // Actually, json_serializable might struggle with custom parsing here if we just use default.
    // Let's do manual parsing for safety or custom converter.

    // For now, let's trust the generated code but we might need to adjust if data is stringified.
    // Based on Info API, it was stringified.

    final rawData = json['data'] as Map<String, dynamic>;
    final parsedData = rawData.map((key, value) {
      if (value is num) {
        return MapEntry(key, value.toDouble());
      } else if (value is String) {
        return MapEntry(key, double.parse(value));
      } else {
        // Fallback or throw
        return MapEntry(key, 0.0);
      }
    });

    return AllMidsEvent(data: parsedData);
  }

  // We can't use default generated fromJson easily if we want to do the parsing logic above
  // unless we use a custom converter.
  // Let's just stick to manual implementation for fromJson for this one to be safe.
}
