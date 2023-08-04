import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_crud_app/data/service/student_db_service.dart';
import 'package:student_crud_app/features/home/presentation/home_page.dart';
import 'package:student_crud_app/features/login/presentation/login_page.dart';
import 'package:talker/talker.dart';
import 'package:hive_flutter/hive_flutter.dart';

final talker = Talker();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  await SystemChannels.textInput.invokeMethod('TextInput.hide');
  final StudentDbService studentDbService = StudentDbService();
  var isUserAvailable = await studentDbService.isUserIsAvailable();
  runApp(MyApp(
    isUserAvailable: isUserAvailable,
  ));
}

class MyApp extends StatelessWidget {
  final bool isUserAvailable;
  const MyApp({super.key, required this.isUserAvailable});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 3, 3, 77),
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                const MaterialStatePropertyAll(Color.fromARGB(255, 3, 3, 77)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ),
      home: isUserAvailable ? const HomePage() : const LoginPage(),
    );
  }
}
