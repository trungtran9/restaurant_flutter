import 'package:json_annotation/json_annotation.dart';
part 'option.g.dart';
@JsonSerializable()
class OptionSelect {
  OptionSelect({
    required this.value,
    required this.display,
  });
  final String value;
  @JsonKey(name: "display")
  String display;
  factory OptionSelect.fromJson(Map<String, dynamic> json) => _$OptionSelectFromJson(json);

  Map<String, dynamic> toJson() => _$OptionSelectToJson(this);
}
