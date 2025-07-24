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
                      children: [
                        FilterChip(
                          label: Text('男'),
                          selected: _sexes.contains(Sex.male),
                          onSelected: (enabled) {
                            setState(() {
                              if (enabled) {
                                _sexes.add(Sex.male);
                              } else {
                                _sexes.remove(Sex.male);
                              }
                            });
                          },
                        ),
                        FilterChip(
                          label: Text('女'),
                          selected: _sexes.contains(Sex.female),
                          onSelected: (enabled) {
                            setState(() {
                              if (enabled) {
                                _sexes.add(Sex.female);
                              } else {
                                _sexes.remove(Sex.female);
                              }
                            });
                          },
                        ),
                      ],
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
                      children: [
                        FilterChip(
                          label: Text('标准音色'),
                          selected: _qualities.contains(Quality.standard),
                          onSelected: (enabled) {
                            setState(() {
                              if (enabled) {
                                _qualities.add(Quality.standard);
                              } else {
                                _qualities.remove(Quality.standard);
                              }
                            });
                          },
                        ),
                        FilterChip(
                          label: Text('精品音色'),
                          selected: _qualities.contains(Quality.premium),
                          onSelected: (enabled) {
                            setState(() {
                              if (enabled) {
                                _qualities.add(Quality.premium);
                              } else {
                                _qualities.remove(Quality.premium);
                              }
                            });
                          },
                        ),
                        FilterChip(
                          label: Text('大模型音色'),
                          selected: _qualities.contains(Quality.largeModel),
                          onSelected: (enabled) {
                            setState(() {
                              if (enabled) {
                                _qualities.add(Quality.largeModel);
                              } else {
                                _qualities.remove(Quality.largeModel);
                              }
                            });
                          },
                        ),
                      ],
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
