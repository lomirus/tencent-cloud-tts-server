import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _keySecretId = 'secretId';
  static const String _keySecretKey = 'secretKey';
  static const String _keyVoiceType = 'voiceType';

  String _secretId;
  String _secretKey;
  int _voiceType;

  String get secretId => _secretId;
  String get secretKey => _secretKey;
  int get voiceType => _voiceType;

  set secretId(String newSecretId) {
    _secretId = newSecretId;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_keySecretId, newSecretId);
    });
  }

  set secretKey(String newSecretKey) {
    _secretKey = newSecretKey;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_keySecretKey, newSecretKey);
    });
  }

  set voiceType(int newVoiceType) {
    _voiceType = newVoiceType;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_keyVoiceType, newVoiceType);
    });
  }

  SettingsProvider({
    required String secretId,
    required String secretKey,
    required int voiceType,
  }) : _secretId = secretId,
       _secretKey = secretKey,
       _voiceType = voiceType;

  static Future<SettingsProvider> init() async {
    final prefs = await SharedPreferences.getInstance();
    final secretId = prefs.getString(_keySecretId) ?? "";
    final secretKey = prefs.getString(_keySecretKey) ?? "";
    final voiceType = prefs.getInt(_keyVoiceType) ?? 0;
    return SettingsProvider(
      secretId: secretId,
      secretKey: secretKey,
      voiceType: voiceType,
    );
  }
}
