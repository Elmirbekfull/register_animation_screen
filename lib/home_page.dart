import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var animationLink = "assets/images/gif.riv";
  late SMITrigger fileTrigger, successTrigger;
  late SMIBool isChecking, isHandsUp;
  late SMINumber lookNum;
  Artboard? artboard;
  late StateMachineController? stateMachineController;

  @override
  void initState() {
    super.initState();
    initArtboard(); // начало процесс анимаций
  }

  initArtboard() {
    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, "Login Machine")!;
      if (stateMachineController != null) {
        art.addController(stateMachineController!);
        for (var element in stateMachineController!.inputs) {
          if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "trigSucces") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            fileTrigger = element as SMITrigger;
          } else if (element.name == "numLook") {
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() {
        artboard = art;
      });
    });
  }

  // проверка данных

  checking() {
    isHandsUp.change(false);
    isChecking.change(true);
    lookNum.change(0);
  }

  moveEyes(value) {
    lookNum.change(value.length.toDouble());
  }

  handsup() {
    isHandsUp.change(true);
    isChecking.change(false);
  }

  login() {
    isHandsUp.change(false);
    isHandsUp.change(false);
    if (emailController.text == "elmirbekabdymanapov@gmail.com" &&
        passwordController.text == "elmirbek") {
      successTrigger.fire();
    } else {
      fileTrigger.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffd6e2ea),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (artboard != null)
            SizedBox(
              width: 500,
              height: 350,
              child: Rive(artboard: artboard!),
            ),
          Container(
            width: 500,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 15, top: 20),
            margin: const EdgeInsets.only(bottom: 15 * 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.green,
                    blurRadius: 1,
                  )
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      TextField(
                        onTap: checking,
                        onChanged: (value) => moveEyes(value),
                        controller: emailController,
                        decoration: const InputDecoration(
                            hintText: "Почта или номер телефона",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        onTap: handsup,
                        controller: passwordController,
                        decoration: const InputDecoration(
                            hintText: "Пароль", border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "Запомнить",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          // GestureDetector(
                          //   onTap: login,
                          //   child: Container(
                          //     height: 40,
                          //     width: 200,
                          //     decoration: BoxDecoration(
                          //         color: Colors.red,
                          //         borderRadius: BorderRadius.circular(12)),
                          //     child: const Center(
                          //       child: Text(
                          //         "Авторизоваться",
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //     ),
                          //   ),
                          // )
                          ElevatedButton(
                              onPressed: login, child: const Text("Войти"))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
