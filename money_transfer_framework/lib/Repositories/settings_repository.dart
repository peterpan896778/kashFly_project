import 'package:keicy_firestore_0_14_data_provider/keicy_firestore_0_14_data_provider.dart';

class SettingsRepository {
  static String _collectionName = "/Settings";

  static Future<Map<String, dynamic>> getSettingData() async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.getDocumentData(
      path: _collectionName,
    );
    return result;
  }

  static Future<Map<String, dynamic>> updateSettingData(String id, Map<String, dynamic> data) async {
    return await KeicyFireStoreDataProvider.instance.updateDocument(path: _collectionName, id: id, data: data);
  }
}
