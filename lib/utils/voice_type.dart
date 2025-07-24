enum Sex { male, female }

enum Quality {
  standard,
  premium,
  largeModel;

  String get name {
    return switch (this) {
      standard => "标准音色",
      premium => "精品音色",
      largeModel => "大模型音色",
    };
  }
}

class VoiceType {
  final int id;
  final String name;
  final Sex sex;
  final Quality quality;

  const VoiceType({
    required this.id,
    required this.name,
    required this.sex,
    required this.quality,
  });
}
