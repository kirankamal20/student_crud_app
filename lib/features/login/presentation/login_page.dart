import 'package:flutter/material.dart';
import 'package:student_crud_app/data/repository/student_repository.dart';
import 'package:student_crud_app/features/home/presentation/home_page.dart';
import 'package:student_crud_app/features/register/presentation/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final StudentRepository studentRepository = StudentRepository();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  void login() async {
    setState(() {
      isLoading = true;
    });

    final result = await studentRepository.login(
        username: usernameController.text, password: passwordController.text);

    result.when((success) {
      if (success) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);

        showSnackBar(message: "Successfully Logged", color: Colors.green);
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
            message: "Incorrect Username or password",
            color: Colors.yellowAccent);
      }
    }, (error) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(message: error.message, color: Colors.red);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.55,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 3, 3, 77),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(color: Colors.grey.shade300),
              ),
            ],
          ),
          Align(
            alignment: const Alignment(0, 0.4),
            child: SizedBox(
              width: size.width * 0.9,
              height: size.height * 0.45,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Circular border radius
                ),
                elevation: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 45, right: 10, left: 10),
                          child: TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              labelText: "Enter the email",
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 17, right: 10, left: 10),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              label: Text("Enter the Password"),
                              prefixIcon: Icon(Icons.password),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 10, left: 10),
                          child: SizedBox(
                            width: screenWidth,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                login();
                              },
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Dont't have an account ? ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 3, 3, 77),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
