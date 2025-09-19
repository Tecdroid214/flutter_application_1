import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Estado para mostrar/ocultar contraseña
  bool _obscurePassword = true;

  // Cerebro de las animaciones
  StateMachineController? controller;
  SMIBool? isChecking; // sigue con la mirada
  SMIBool? isHandsUp; // se tapa los ojos
  SMITrigger? trigSuccess; // cuando acierta
  SMITrigger? trigFail; // cuando falla

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"], //  asegúrate que coincide
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine", //  usa el mismo nombre exacto
                    );

                    if (controller == null) {
                      debugPrint("❌ No se encontró la máquina de estados");
                      return;
                    }
                    artboard.addController(controller!);

                    // Buscar inputs (los nombres deben coincidir con tu .riv)
                    isChecking = controller!.findSMI("isChecking");
                    isHandsUp = controller!.findSMI("isHandsUp");
                    trigSuccess = controller!.findSMI("trigSuccess");
                    trigFail = controller!.findSMI("trigFail");

                    debugPrint("✅ isChecking: $isChecking");
                    debugPrint("✅ isHandsUp: $isHandsUp");
                    debugPrint("✅ trigSuccess: $trigSuccess");
                    debugPrint("✅ trigFail: $trigFail");
                  },
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),

              // Campo de texto Email
              TextField(
                onChanged: (value) {
                  // Al escribir → seguir con la mirada
                  if (isHandsUp != null) {
                    isHandsUp!.change(false);
                  }
                  if (isChecking != null) {
                    isChecking!.change(value.isNotEmpty);
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Introduce tu Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Campo de texto Contraseña con ojito invertido
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility // 👁 oculta → se ve el icono normal
                          : Icons.visibility_off, // 🚫 visible → tachado
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;

                        // 👁 Si muestro la contraseña → personaje se tapa los ojos
                        if (isHandsUp != null) {
                          isHandsUp!.change(!_obscurePassword);
                        }
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: size.width,
                child: const Text(
                  "forgot your password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 20),

              MaterialButton(
                onPressed: () {
                  // Aquí ejemplo de disparar animaciones de éxito/fallo
                  if (trigSuccess != null) {
                    trigSuccess!.fire();
                  }
                },
                color: const Color.fromARGB(255, 243, 33, 198),
                minWidth: size.width,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "register",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
