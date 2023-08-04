import 'package:hive_flutter/hive_flutter.dart';

class StudentDbService {
  String hiveBox = 'student';
  Future<void> saveUserDetails({required int studentId}) async {
    var box = await Hive.openBox(hiveBox);
    box.put("studentId", studentId);
  }

  Future<int?> getuserData() async {
    var box = await Hive.openBox(hiveBox);
    var userId = box.get('studentId');
    if (userId != null) {
      return userId;
    } else {
      return null;
    }
  }

  Future<bool> isUserIsAvailable() async {
    var data = await getuserData();
    if (data != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteUserData() async {
    var box = await Hive.openBox(hiveBox);
    await box.delete("studentId");
  }
}
