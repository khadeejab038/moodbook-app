import 'dart:io';

class NetworkHelper {
  /// Fast check if there is an active internet connection using domain lookup
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
