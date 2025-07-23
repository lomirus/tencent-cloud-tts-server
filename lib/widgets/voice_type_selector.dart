import 'package:flutter/material.dart';
import 'package:tencent_cloud_tts_server/data/voice_types.dart';

class VoiceTypeSelector extends StatelessWidget {
  const VoiceTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
                      children: const [
                        Chip(label: Text('男')),
                        Chip(label: Text('女')),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('品质'),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      children: [
                        Chip(label: Text('标准音色')),
                        Chip(label: Text('精品音色')),
                        Chip(label: Text('大模型音色')),
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
                children: [
                  for (final voiceType in voiceTypes)
                    ChoiceChip(label: Text(voiceType.name), selected: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
