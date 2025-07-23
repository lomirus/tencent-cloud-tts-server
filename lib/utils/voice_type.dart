enum Sex { male, female }

enum Quality { standard, premium, largeModel }

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
