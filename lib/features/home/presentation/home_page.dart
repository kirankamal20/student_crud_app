import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:student_crud_app/data/model/student_model.dart';
import 'package:student_crud_app/data/repository/student_repository.dart';
import 'package:student_crud_app/data/service/student_db_service.dart';
import 'package:student_crud_app/features/add_student/presentation/add_student.dart';
import 'package:student_crud_app/features/login/presentation/login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StudentRepository studentRepository = StudentRepository();
  final StudentDbService studentDbService = StudentDbService();
  final studentIdController = TextEditingController();
  final studentTittleController = TextEditingController();
  final studentAuthorController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  List<Studentmodel> students = [];
  bool isLoading = true;
  bool isAddstudentLoading = false;
  bool isDeletingstudentLoading = false;
  bool isupdatestudentLoading = false;
  bool isUpdateButtonEnable = false;
  int tapIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchstudents();
  }

  Future<void> fetchstudents() async {
    setState(() {
      if (isDeletingstudentLoading ||
          isAddstudentLoading ||
          isupdatestudentLoading) {
        isLoading = false;
      } else {
        isLoading = true;
      }
    });

    final result = await studentRepository.fetchStudents();
    result.when((data) {
      log(data.length.toString());
      setState(() {
        students = data;
        print(students);
      });
      isLoading = false;
    }, (error) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(message: error.toString(), color: Colors.red);
    });
  }

  Future<void> deletestudent(
      {required int studentId, required int userid}) async {
    isDeletingstudentLoading = true;
    var result = await studentRepository.deleteStudent(
        userId: userid, studentId: studentId);

    result.when((success) async {
      await fetchstudents();

      setState(() {
        isDeletingstudentLoading = false;
      });
      showSnackBar(message: "student Successfully Deleted", color: Colors.red);
    }, (error) {
      setState(() {
        isDeletingstudentLoading = false;
      });
      showSnackBar(message: error.toString(), color: Colors.red);
    });
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: color,
        ))
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  void clearTextField() {
    // studentAuthorController.clear();
    // studentIdController.clear();

    // studentTittleController.clear();
    formkey.currentState?.reset();
  }

  void hidekeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: EasySearchBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Do you want to Logout",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await studentDbService
                                            .deleteUserData()
                                            .then(
                                          (value) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginPage()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "No",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.exit_to_app))
          ],
          elevation: 0.5,
          title: const Text(
            "Students Details",
            style: TextStyle(color: Colors.white),
          ),
          onSearch: (value) {}),
      body: isLoading
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("  Fetching students.....")
              ],
            ))
          : students.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    await fetchstudents();
                  },
                  child: GridView.builder(
                    itemCount: students.length,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.62),
                    itemBuilder: (context, index) {
                      var student = students[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              height: 130,
                              width: double.infinity,
                              imageUrl:
                                  "https://studentcrudfastapi-production.up.railway.app/download-image/${student.image}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fadeInDuration: const Duration(milliseconds: 300),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isDeletingstudentLoading = true;
                                    tapIndex = index;
                                  });
                                  deletestudent(
                                      studentId: student.id,
                                      userid: student.owner_id);
                                },
                                icon: isDeletingstudentLoading &&
                                        tapIndex == index
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator())
                                    : const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                              ),
                            ),
                            Positioned(
                              top: 127,
                              right: 0,
                              child: IconButton(
                                onPressed: () async {
                                  var result = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddStudentView(
                                        countryCode: "+91",
                                        index: index,
                                        isVisibleAddButton: false,
                                        appBarTittleName: "Update Student",
                                        studentName: student.student_name,
                                        studentAge: student.student_age,
                                        studentDob: student.date_of_birth,
                                        studentCountry: student.country,
                                        studentGender: student.gender,
                                        studentImage: "",
                                      ),
                                    ),
                                  );
                                  if (result != null && result == true) {
                                    showSnackBar(
                                        message: "Successfully Updated",
                                        color: Colors.blue);
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        student.student_name,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Age: ${student.student_age}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'DOB:  ${student.date_of_birth}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Gender:   ${student.gender}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Country:   ${student.country}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.2),
                    child: const Text("Student Not found"),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStudentView(
                index: 0,
                isVisibleAddButton: true,
                appBarTittleName: "Add student",
                studentName: "",
                studentAge: "",
                studentDob: "",
                studentCountry: "",
                studentImage: null,
                countryCode: "+91",
              ),
            ),
          );
          if (result != null && result == true) {
            showSnackBar(message: "Successfully Added", color: Colors.green);
            await fetchstudents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
