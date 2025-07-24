import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_tts_server/data/voice_types.dart';
import 'package:tencent_cloud_tts_server/utils/store.dart';
import 'package:tencent_cloud_tts_server/utils/voice_type.dart';

class VoiceTypeSelector extends StatefulWidget {
  const VoiceTypeSelector({super.key});

  @override
  State<VoiceTypeSelector> createState() => _VoiceTypeSelectorState();
}

class _VoiceTypeSelectorState extends State<VoiceTypeSelector> {
  final Set<Sex> _sexes = {Sex.male, Sex.female};
  final Set<Quality> _qualities = {
    Quality.standard,
    Quality.premium,
    Quality.largeModel,
  };

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const Text('性别'),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      children: Sex.values
                          .map(
                            (sex) => FilterChip(
                              label: Text(sex.name),
                              selected: _sexes.contains(sex),
                              onSelected: (enabled) {
                                setState(() {
                                  if (enabled) {
                                    _sexes.add(sex);
                                  } else {
                                    _sexes.remove(sex);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('品质'),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      children: Quality.values
                          .map(
                            (quality) => FilterChip(
                              label: Text(quality.name),
                              selected: _qualities.contains(quality),
                              onSelected: (enabled) {
                                setState(() {
                                  if (enabled) {
                                    _qualities.add(quality);
                                  } else {
                                    _qualities.remove(quality);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                children: voiceTypes
                    .where(
                      (voiceType) =>
                          _sexes.contains(voiceType.sex) &&
                          _qualities.contains(voiceType.quality),
                    )
                    .map(
                      (voiceType) => ChoiceChip(
                        label: Text(voiceType.name),
                        selected: settings.voiceType == voiceType.id,
                        onSelected: (newSelected) {
                          if (newSelected) {
                            setState(() {
                              settings.voiceType = voiceType.id;
                            });
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
