import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:student_crud_app/data/model/student_model.dart';
import 'package:student_crud_app/data/repository/student_repository.dart';
import 'package:student_crud_app/features/add_student/presentation/widgets/country_dropdown.dart';
import 'package:student_crud_app/features/add_student/presentation/widgets/date_of_birth_field.dart';
import 'package:student_crud_app/features/add_student/presentation/widgets/progress_indicator.dart';
import 'package:student_crud_app/shared/widgets/custom_textfiled.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class AddStudentView extends StatefulWidget {
  final String studentName;
  final String studentAge;
  final String studentDob;
  final String studentCountry;
  final String? studentGender;
  final String? studentImage;
  final String appBarTittleName;
  final bool isVisibleAddButton;
  final int index;
  final String countryCode;
  const AddStudentView({
    super.key,
    required this.studentName,
    required this.studentAge,
    required this.studentDob,
    required this.studentCountry,
    this.studentGender,
    required this.studentImage,
    required this.appBarTittleName,
    required this.isVisibleAddButton,
    required this.index,
    required this.countryCode,
  });

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final StudentRepository studentRepository = StudentRepository();
  final formKey = GlobalKey<FormState>();
  List<Studentmodel> studentdetailsList = [];
  final ImagePicker _picker = ImagePicker();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  DateTime? pickedDate = DateTime.now();
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  String? imageFilePath;
  String? imageFileName;
  String countryName = "";
  String dateOfBirth = "";
  String? selectedGender;
  String formattedDate = "";
  String countryCode = "";
  double percentage = 0.0;

  /// Get from image gallery
  void getImageFromGallery() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFilePath = File(pickedFile.path).path;
      });
    }
  }

  /// Get from image Camera
  void getImageFromCamara() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFilePath = File(pickedFile.path).path;
      });
    }
  }

  void addStudentDetails({required BuildContext context1}) async {
    if (formKey.currentState!.validate()) {
      if (imageFilePath != null) {
        final fileName = imageFilePath!.split('/').last;
        print(fileName);
        showDialog(
            barrierDismissible: false,
            context: context1,
            builder: (cocontext1ntext) => StatefulBuilder(
                  builder: (context, setState) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: Dialog(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularPercentIndicator(
                                  radius: 50,
                                  lineWidth: 5,
                                  reverse: false,
                                  percent: percentage / 100,
                                  center: Text(
                                      "${percentage.ceil().toString()}%",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0)),
                                  footer: const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      "Uploading...",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0),
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.square,
                                  progressColor: Colors.amber,
                                ),
                                const SizedBox(height: 8),
                              ],
                            )),
                      ),
                    );
                  },
                ));
        final result = await studentRepository.addStudent(
          studenName: nameController.text,
          studentAge: ageController.text,
          studentDob: dateOfBirthController.text,
          studentGender: selectedGender!,
          studentCountry: countryName,
          studentImage: imageFilePath!,
          fileName: fileName,
          onSendProgress: (count, total) {
            setState(() {
              percentage = ((count / total) * 100).ceilToDouble();

              print(percentage);
            });
          },
        );
        result.when((success) {
          Navigator.of(context).pop();
          Navigator.pop(context, true);
        }, (error) {
          Navigator.of(context).pop();

          showSnackBar(message: error.toString(), color: Colors.red);
        });
        // FocusScope.of(context).unfocus();
        // Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please add your image'),
        ));
      }
    }
  }

  void updateStudentDetails() {
    if (formKey.currentState!.validate()) {
      if (imageFilePath != null) {
        // hiveMethods.updateStudentDetails(
        //   index: widget.index,
        //   studentDetailsModel: StudentDetailsModel(
        //     name: nameController.text,
        //     age: ageController.text,
        //     date: formattedDate,
        //     country: countryName,
        //     gender: selectedGender ?? "",
        //     imagePath: imageFilePath!,
        //     countryCode: countryCode,
        //   ),
        // );
        FocusScope.of(context).unfocus();
        Navigator.pop(context, true);
      } else {
        const snackBar = SnackBar(
          content: Text('Please add your image'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
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

  void resetForm() {
    // formKey.currentState?.reset();
    // dateOfBirthController.clear();
    // nameController.clear();
    // ageController.clear();
    // setState(() {
    //   selectedGender = null;
    //   if (imageFilePath != null) {
    //     setState(() {
    //       imageFilePath = null;
    //     });
    //   }
    // });
  }
  void showSendingProgress(
      {String? message, required Widget child, required BuildContext context}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    dateOfBirthController.text = widget.studentDob;
    nameController.text = widget.studentName;
    ageController.text = widget.studentAge;
    countryName = widget.studentCountry;
    imageFilePath = widget.studentImage;
    selectedGender = widget.studentGender;
    countryCode = widget.countryCode;
    super.initState();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    dateOfBirthController.dispose();
    ageController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTittleName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          // TextButton(
          //   onPressed: () {
          //     resetForm();
          //   },
          //   child: const Text("Reset", style: TextStyle(color: Colors.white)),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(percentage.toString()),
                CustomTextField(
                  tittle: "Student Name",
                  hintText: "Enter the Name",
                  controller: nameController,
                  validator: (value) {
                    return value!.isEmpty ? "Enter the Student Name" : null;
                  },
                ),
                CustomTextField(
                  tittle: "Student Age",
                  hintText: "Enter the Age",
                  controller: ageController,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    return value!.isEmpty ? "Enter the Student Age" : null;
                  },
                ),
                DateOfBirthField(
                  dateInputcontroller: dateOfBirthController,
                  onChanged: (v) {},
                  onTap: () async {
                    pickedDate = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime(1994),
                      firstDate: DateTime(1960),
                      lastDate: DateTime(2012),
                      dateFormat: "dd-MMMM-yyyy",
                      locale: DateTimePickerLocale.en_us,
                      looping: true,
                    );
                    if (pickedDate != null) {
                      formattedDate = DateFormat('dd-MM-yyyy')
                          .format(pickedDate ?? DateTime.now());

                      setState(() {
                        dateOfBirthController.text = formattedDate;
                      });
                      print(formattedDate);
                    } else {}
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select your gender:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: "Male",
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                        ),
                        const Text('Male'),
                        Radio(
                          value: "Female",
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                        ),
                        const Text('Female'),
                        Radio(
                          value: "other",
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                        ),
                        const Text('Other'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Select Country:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                CountryPicker(
                  onCountrySelected: (country) {
                    countryName = country.name;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Student Image',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  child: DottedBorder(
                    dashPattern: const [5],
                    color: Colors.grey,
                    strokeWidth: 1,
                    child: imageFilePath == null
                        ? Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              ElevatedButton(
                                                onPressed: () {
                                                  getImageFromGallery();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    "PICK IMAGE FROM GALLERY"),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  getImageFromCamara();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    "PICK  IMAGE FROM CAMERA"),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.add_a_photo_outlined),
                                ),
                                const Text("Click To Add Photo")
                              ],
                            ),
                          )
                        : Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: const BoxDecoration(),
                                  child: Image.file(
                                    File(imageFilePath!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: IconButton(
                                    onPressed: () {
                                      if (imageFilePath != null) {
                                        setState(() {
                                          imageFilePath = null;
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.isVisibleAddButton
          ? FloatingActionButton(
              onPressed: () {
                addStudentDetails(context1: context);
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                updateStudentDetails();
              },
              child: const Icon(Icons.edit, color: Colors.white),
            ),
    );
  }
}
