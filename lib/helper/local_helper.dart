import 'package:shared_preferences/shared_preferences.dart';

class LocalHelper {
  static const String _userNameKey = 'userName';
  static const String _avatarKey = 'avatar';
  static const String _favouritesKey = 'favourites';

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? 'Chef';
  }

  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  static Future<String> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatar = prefs.getString(_avatarKey) ?? '1';
    // Sanitize: if they have a full path stored, extract only the number/filename
    if (avatar.contains('/')) {
      final parts = avatar.split('/');
      final fileName = parts.last; // e.g. "1.png"
      return fileName.split('.').first; // e.g. "1"
    }
    return avatar.split('.').first;
  }

  static Future<void> setAvatar(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, path);
  }

  // Favourites logic
  static Future<List<String>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favouritesKey) ?? [];
  }

  static Future<void> addFavourite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_favouritesKey) ?? [];
    if (!items.contains(id)) {
      items.add(id);
      await prefs.setStringList(_favouritesKey, items);
    }
  }

  static Future<void> removeFavourite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_favouritesKey) ?? [];
    items.remove(id);
    await prefs.setStringList(_favouritesKey, items);
  }

  static Future<bool> isFavourite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_favouritesKey) ?? [];
    return items.contains(id);
  }
}
