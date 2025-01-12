/// A utility file to map avatar titles to their corresponding asset paths.

class AvatarUtils {
  // Map of avatar titles to asset paths
  static const Map<String, String> avatarMap = {
    "grey": "assets/avatars/grey_default.jpeg",
    "blue": "assets/avatars/blue.jpg",
    "pink": "assets/avatars/pink.jpg",
    "ducky": "assets/avatars/ducky.jpg",
    "sunglasses": "assets/avatars/sunglasses.jpg",
  };

  /// Returns the asset path for a given avatar title.
  /// If the title is invalid, it defaults to "grey".
  static String getAvatarAsset(String avatarTitle) {
    return avatarMap[avatarTitle] ?? avatarMap["grey"]!;
  }

  /// Returns a list of all avatar titles.
  static List<String> getAllAvatarTitles() {
    return avatarMap.keys.toList();
  }

  /// Returns a list of all avatar asset paths.
  static List<String> getAllAvatarAssets() {
    return avatarMap.values.toList();
  }
}
