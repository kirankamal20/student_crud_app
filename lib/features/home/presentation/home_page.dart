import 'package:flutter/material.dart';
import 'package:student_crud_app/data/model/student_model.dart';
import 'package:student_crud_app/data/repository/student_repository.dart';
import 'package:student_crud_app/data/service/student_db_service.dart';
import 'package:student_crud_app/features/add_student/presentation/add_student.dart';
import 'package:student_crud_app/features/login/presentation/login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:student_crud_app/shared/helpers/on_back_pressed.dart';

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
  List<Studentmodel> studentsList = [];
  bool isLoading = true;
  bool isAddstudentLoading = false;
  bool isDeletingstudentLoading = false;
  bool isupdatestudentLoading = false;
  bool isUpdateButtonEnable = false;
  int tapIndex = 0;
  final int itemsPerPage = 4;
  int currentPage = 1;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchstudents();
  }

  void searchStudent(String searchString) {
    setState(
      () {
        if (searchString.isNotEmpty) {
          studentsList = studentsList
              .where((item) =>
                  item.student_name
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  item.gender
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  item.country
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  item.date_of_birth
                      .toLowerCase()
                      .contains(searchString.toLowerCase()))
              .toList();
        } else {
          fetchstudents();
        }
      },
    );
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
      setState(() {
        studentsList = data;
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

  List<Studentmodel> studentListPagination() {
    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex = startIndex + itemsPerPage;
    if (studentsList.length < endIndex) {
      return studentsList.sublist(startIndex, studentsList.length);
    } else {
      return studentsList.sublist(startIndex, endIndex);
    }
  }

  Widget buildPagination() {
    final int totalPages = (studentsList.length / itemsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Previous button
          if (totalPages > 2)
            GestureDetector(
              onTap: () {
                if (currentPage > 1) {
                  setState(() {
                    currentPage--;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),

          ...List.generate(
            totalPages > 2 ? 2 : totalPages,
            (index) {
              final pageNumber = index + 1;
              currentIndex = pageNumber + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentPage = pageNumber;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: pageNumber == currentPage || pageNumber > 3
                        ? const Color.fromARGB(255, 3, 3, 77)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '$pageNumber',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          if (totalPages > 2)
            GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = currentIndex;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: currentIndex == currentPage || currentPage > 2
                      ? currentPage < 2
                          ? Colors.grey
                          : const Color.fromARGB(255, 3, 3, 77)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "${currentPage < 3 ? 3 : currentPage}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (totalPages > 2)
            GestureDetector(
              onTap: () {
                if (currentPage < totalPages) {
                  setState(() {
                    currentPage++;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
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
  void dispose() {
    formkey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showExitPopup(context);
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: EasySearchBar(
          actions: [
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Do you want to Logout?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await studentDbService.deleteUserData().then(
                            (value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.exit_to_app,
              ),
            )
          ],
          elevation: 0.5,
          title: const Text(
            "Students Details",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          onSearch: (value) {
            searchStudent(value);
          },
        ),
        body: Center(
          child: SingleChildScrollView(
            child: isLoading
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
                : studentsList.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: () async {
                          await fetchstudents();
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.79,
                              child: GridView.builder(
                                itemCount: studentListPagination().length,
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.62),
                                itemBuilder: (context, index) {
                                  final student =
                                      studentListPagination()[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          height: 130,
                                          width: double.infinity,
                                          imageUrl:
                                              "https://studentcrudfastapi-production.up.railway.app/download-image/${student.image}",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fadeInDuration:
                                              const Duration(milliseconds: 300),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(
                                                () {
                                                  isDeletingstudentLoading =
                                                      true;
                                                  tapIndex = index;
                                                },
                                              );
                                              deletestudent(
                                                  studentId: student.id,
                                                  userid: student.owner_id);
                                            },
                                            icon: isDeletingstudentLoading &&
                                                    tapIndex == index
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator())
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
                                              var result =
                                                  await Navigator.push<bool>(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddStudentView(
                                                    studentId: student.id,
                                                    countryCode: "+91",
                                                    index: index,
                                                    isVisibleAddButton: false,
                                                    appBarTittleName:
                                                        "Update Student",
                                                    studentName:
                                                        student.student_name,
                                                    studentAge:
                                                        student.student_age,
                                                    studentDob:
                                                        student.date_of_birth,
                                                    studentCountry:
                                                        student.country,
                                                    studentGender:
                                                        student.gender,
                                                    studentImage: null,
                                                  ),
                                                ),
                                              );
                                              if (result != null &&
                                                  result == true) {
                                                showSnackBar(
                                                    message:
                                                        "Successfully Updated",
                                                    color: Colors.blue);
                                                fetchstudents();
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    student.student_name,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Age: ${student.student_age}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'DOB:  ${student.date_of_birth}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Gender:   ${student.gender}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Country:   ${student.country}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            buildPagination(),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.2),
                          child: const Text("Student Not found"),
                        ),
                      ),
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
                  studentId: 0,
                ),
              ),
            );
            if (result != null && result == true) {
              showSnackBar(message: "Successfully Added", color: Colors.green);
              await fetchstudents();
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
