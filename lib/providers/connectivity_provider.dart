import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOffline = false;
  bool get isOffline => _isOffline;

  ConnectivityProvider() {
    _initConnectivity();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    // connectivity_plus 6.0 returns a List<ConnectivityResult>
    // If ANY of them are not none, we are online (roughly)

    // Check if the list contains none, or if it's empty (which shouldn't happen usually but good to be safe)
    // Actually, if it contains mobile, wifi, ethernet, etc. it's online.
    // If it only contains none, it's offline.

    bool isNone = result.contains(ConnectivityResult.none);
    // Be careful, sometimes it might return [none]

    // Better logic:
    // If result contains .mobile or .wifi or .ethernet, we are online.
    // simpler:
    _isOffline = result.contains(ConnectivityResult.none) && result.length == 1;

    // Wait, let's verify connectivity_plus behavior.
    // Usually if we have connection it allows us to proceed.
    // Let's assume if it contains NONE it might be an issue, but standard check is:
    // if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) -> Online

    // Debug print to see what we are getting
    debugPrint('Connectivity changed: $result');

    bool hasConnection = result.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );

    // Explicitly set offline if hasConnection is false
    final newState = !hasConnection;
    if (_isOffline != newState) {
      _isOffline = newState;
      debugPrint('ConnectivityProvider: Offline state changed to $_isOffline');
      notifyListeners();
    }
  }
}
