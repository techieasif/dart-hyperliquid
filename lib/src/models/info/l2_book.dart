import 'package:json_annotation/json_annotation.dart';

part 'l2_book.g.dart';

@JsonSerializable()
class L2Book {
  final String coin;
  final int time;
  final List<List<BookLevel>> levels;

  L2Book({required this.coin, required this.time, required this.levels});

  factory L2Book.fromJson(Map<String, dynamic> json) => _$L2BookFromJson(json);
  Map<String, dynamic> toJson() => _$L2BookToJson(this);
}

@JsonSerializable()
class BookLevel {
  final String px;
  final String sz;
  final int n;

  BookLevel({required this.px, required this.sz, required this.n});

  factory BookLevel.fromJson(Map<String, dynamic> json) =>
      _$BookLevelFromJson(json);
  Map<String, dynamic> toJson() => _$BookLevelToJson(this);
}
