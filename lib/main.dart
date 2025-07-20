import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_tts_server/utils/store.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

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
                settings.voiceType.toString(),
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
                                    Expanded(
                                      child: Wrap(
                                        spacing: 8.0,
                                        children: const [
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
                            Wrap(
                              spacing: 8.0,
                              children: const [
                                Chip(label: Text('P1')),
                                Chip(label: Text('P2')),
                                Chip(label: Text('P3')),
                                Chip(label: Text('P4')),
                                Chip(label: Text('P5')),
                                Chip(label: Text('P6')),
                                Chip(label: Text('P7')),
                                Chip(label: Text('P8')),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            PopupMenuButton(
              initialValue: settings.voiceType,
              onSelected: (int id) => settings.voiceType = id,
              offset: const Offset(1, 0),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem(value: 1001, child: Text('1001')),
                const PopupMenuItem(value: 1004, child: Text('1004')),
              ],
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("音色"),
                subtitle: Text(
                  settings.voiceType.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
