import 'package:battery_plus/battery_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DeviceProvider with ChangeNotifier {
  final Battery _battery = Battery();
  final ImagePicker _picker = ImagePicker();

  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  String? _profileImagePath;

  int get batteryLevel => _batteryLevel;
  BatteryState get batteryState => _batteryState;
  String? get profileImagePath => _profileImagePath;

  DeviceProvider() {
    _init();
  }

  void _init() {
    refreshBattery();
    _loadProfileImage();

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _batteryState = state;
      refreshBattery();
    });
  }

  Future<void> refreshBattery() async {
    try {
      final level = await _battery.batteryLevel;
      _batteryLevel = level;
      notifyListeners();
    } catch (e) {
      debugPrint('Battery Error: $e');
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    _profileImagePath = prefs.getString('profile_image_path');
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        _profileImagePath = image.path;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', _profileImagePath!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Image Picker Error: $e');
    }
  }
}
