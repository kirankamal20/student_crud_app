import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:student_crud_app/data/model/student_model.dart';
import 'package:student_crud_app/data/service/student_db_service.dart';
import 'package:student_crud_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:student_crud_app/shared/exception/baseexception.dart';

class StudentRepository {
  final dio = Dio();
  final StudentDbService studentDbService = StudentDbService();
  final String apiUrl =
      'https://studentcrudfastapi-production.up.railway.app/'; // Replace with your API URL

  Future<Result<bool, BaseException>> register(
      {required String username, required String password}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    try {
      var response = await http.post(
        headers: headers,
        body: json.encode({"email": username, "password": password}),
        Uri.parse('${apiUrl}signup'),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return const Success(true);
      } else {
        return Error(BaseException(message: "Something wrong"));
      }
    } catch (error) {
      return Error(BaseException(message: error.toString()));
    }
  }

  Future<Result<bool, BaseException>> login(
      {required String username, required String password}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    try {
      var response = await http.post(
        headers: headers,
        body: json.encode({"email": username, "password": password}),
        Uri.parse('${apiUrl}login'),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await studentDbService.saveUserDetails(studentId: data["detail"]["id"]);
        return const Success(true);
      } else {
        return Error(BaseException(message: data["detail"]));
      }
    } catch (error) {
      return Error(BaseException(message: error.toString()));
    }
  }

  Future<Result<List<Studentmodel>, Exception>> fetchStudents() async {
    try {
      final id = await studentDbService.getuserData();
      final response =
          await http.get(Uri.parse("${apiUrl}getAllstudents?user_id=$id"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final studentList = data.map((e) => Studentmodel.fromMap(e)).toList();

        return Success(studentList);
      } else {
        return Error(Exception('Failed to load students'));
      }
    } catch (e) {
      return Error(Exception(e.toString()));
    }
  }

  Future<Result<bool, Exception>> addStudent(
      {required String studenName,
      required String studentAge,
      required String studentDob,
      required String studentGender,
      required String studentCountry,
      required String studentImage,
      required String fileName,
      Function(int, int)? onSendProgress}) async {
    try {
      final id = await studentDbService.getuserData();
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      };
      var data = FormData.fromMap({
        'image': await MultipartFile.fromFile(studentImage, filename: fileName),
        'student_name': studenName,
        'student_age': studentAge,
        'date_of_birth': studentDob,
        'gender': studentGender,
        'country': studentCountry
      });

      var response = await dio.request(
        'https://studentcrudfastapi-production.up.railway.app/addstudent?user_id=$id',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        onSendProgress: onSendProgress,
        data: data,
      );

      if (response.statusCode == 200) {
        return const Success(true);
      } else {
        return Error(Exception('Unable to upload'));
      }
    } catch (e) {
      return Error(Exception(e.toString()));
    }
  }

  // Future<Result<List<Studentmodel>, Exception>> fetchStudents() async {
  //   try {
  //     final response = await dio.get("${apiUrl}getAllstudents/");
  //     print(response.data);
  //     if (response.statusCode == 200) {
  //       var data = response.data as List;
  //       var bookList = data.map((e) => Studentmodel.fromMap(e)).toList();

  //       return Success(bookList);
  //     } else {
  //       return Error(Exception(Exception('Failed to load books')));
  //     }
  //   } catch (e) {
  //     return Error(Exception(e));
  //   }
  // }

  // Future<Result<bool, Exception>> createBook(Book book) async {
  //   try {
  //     final response = await dio.post('${apiUrl}books/',
  //         data: {"id": book.id, "title": book.title, "author": book.author},
  //         options: Options(headers: {'Content-type': 'application/json'}));

  //     if (response.statusCode == 200) {
  //       return const Success(true);
  //     } else {
  //       return Error(Exception('Failed to create a book'));
  //     }
  //   } catch (e) {
  //     return Error(Exception(e));
  //   }
  // }

  // Future<Result<bool, Exception>> updateBook(Book book) async {
  //   try {
  //     var headers = {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json'
  //     };
  //     var data = json
  //         .encode({"id": book.id, "title": book.title, "author": book.author});
  //     final response = await dio.request(
  //       '${apiUrl}books/${book.id}',
  //       data: data,
  //       options: Options(
  //         method: 'PUT',
  //         headers: headers,
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return const Success(true);
  //     } else {
  //       return Error(Exception('Failed to update the book'));
  //     }
  //   } catch (e) {
  //     return Error(Exception(e));
  //   }
  // }

  Future<Result<bool, Exception>> deleteStudent(
      {required int userId, required int studentId}) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      var data = json.encode({"user_id": userId, "student_id": studentId});
      var dio = Dio();
      var response = await dio.request(
        'https://studentcrudfastapi-production.up.railway.app/delete',
        options: Options(
          method: 'DELETE',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        return const Success(true);
      } else {
        return Error(Exception('Failed to delete the student'));
      }
    } catch (e) {
      return Error(Exception(e));
    }
  }
}
