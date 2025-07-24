import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_tts_server/data/voice_types.dart';
import 'package:tencent_cloud_tts_server/utils/store.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:tencent_cloud_tts_server/utils/voice_type.dart';
import 'package:tencent_cloud_tts_server/widgets/voice_type_selector.dart';

import 'widgets/list_group_title.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialSettings = await SettingsProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => initialSettings,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '腾讯云 TTS 服务',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: '设置'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListGroupTitle("密钥"),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text("Secret ID"),
              subtitle: settings.secretId == ""
                  ? null
                  : Text(
                      settings.secretId,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
              trailing: IconButton(
                onPressed: () async {
                  final newSecretId = await prompt(
                    context,
                    title: Text("新 Secret ID"),
                    initialValue: settings.secretId,
                  );
                  settings.secretId = newSecretId ?? "";
                },
                icon: Icon(Icons.edit),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text("Secret Key"),
              subtitle: settings.secretKey == ""
                  ? null
                  : Text(
                      settings.secretKey,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
              trailing: IconButton(
                onPressed: () async {
                  final newSecretKey = await prompt(
                    context,
                    title: Text("新 Secret Key"),
                    initialValue: settings.secretKey,
                  );
                  settings.secretKey = newSecretKey ?? "";
                },
                icon: Icon(Icons.edit),
              ),
            ),
            const ListGroupTitle("语音"),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("音色"),
              subtitle: Text(
                (() {
                  final vt = voiceTypes.firstWhere(
                    (voiceType) => voiceType.id == settings.voiceType,
                  );
                  final sex = switch (vt.sex) {
                    Sex.male => "男",
                    Sex.female => "女",
                  };
                  final quality = vt.quality.name;
                  return "${vt.name} ($sex, $quality, ${vt.id})";
                })(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (BuildContext context) {
                      return VoiceTypeSelector();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
