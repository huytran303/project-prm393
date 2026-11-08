import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Timestamp ↔ DateTime. A pending serverTimestamp reads back as null.
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) => json is Timestamp ? json.toDate() : null;

  @override
  Object? toJson(DateTime? date) => date == null ? null : Timestamp.fromDate(date);
}
