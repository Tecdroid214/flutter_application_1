import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Estado para mostrar/ocultar contraseña
  bool _obscurePassword = true;

  // Controladores de animación Rive
  StateMachineController? controller;
  SMIBool? isChecking; // "Chismoso" (sigue el texto)
  SMIBool? isHandsUp; // Se tapa los ojos
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  SMINumber? numLook; // Controla la dirección de la mirada

  // FocusNodes para detectar foco de los campos
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  // Timer para detectar cuando se deja de escribir
  Timer? _typingDebounce;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
  }

  // Actualiza la animación cuando se enfoca o desenfoca un campo
  void _onFocusChange() {
    if (isChecking == null || isHandsUp == null) return;

    if (_emailFocus.hasFocus) {
      // Enfocando email → mirar atento
      isChecking!.change(true);
      isHandsUp!.change(false);
      numLook?.value = 50.0;
    } else if (_passwordFocus.hasFocus) {
      // Enfocando contraseña → taparse los ojos
      isChecking!.change(false);
      isHandsUp!.change(true);
    } else {
      // Ningún campo enfocado → neutral
      isChecking!.change(false);
      isHandsUp!.change(false);
      numLook?.value = 50.0;
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              // 🐻 Animación Rive
              SizedBox(
                width: size.width,
                height: 220,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ['Login Machine'],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                        artboard, 'Login Machine');
                    if (controller == null) return;
                    artboard.addController(controller!);

                    // Conectar inputs del State Machine
                    isChecking = controller!.findSMI('isChecking');
                    isHandsUp = controller!.findSMI('isHandsUp');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('trigFail');
                    numLook = controller!.findSMI('numLook');
                  },
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // 📨 Campo Email
              TextField(
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Introduce tu email',
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  // Cancela timer anterior si sigue escribiendo
                  _typingDebounce?.cancel();

                  if (isChecking != null) isChecking!.change(true);
                  if (isHandsUp != null) isHandsUp!.change(false);

                  // Calcular dirección de mirada (0 a 100)
                  final look = (value.length / 80.0 * 100.0).clamp(0.0, 100.0);
                  numLook?.value = look;

                  // Reinicia mirada neutral después de 3 segundos sin escribir
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    if (!mounted) return;
                    isChecking?.change(false);
                    numLook?.value = 50.0;
                  });
                },
              ),

              const SizedBox(height: 12),

              // 🔒 Campo Contraseña
              TextField(
                focusNode: _passwordFocus,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                      // Si muestra la contraseña → bajar las manos
                      isHandsUp?.change(!_obscurePassword);
                    },
                  ),
                ),
                onChanged: (value) {
                  // Mientras escribe contraseña se mantiene tapado
                  if (isHandsUp != null) {
                    isHandsUp!.change(true);
                  }
                  if (isChecking != null) {
                    isChecking!.change(false);
                  }
                },
              ),

              const SizedBox(height: 10),

              // 🔗 Olvidaste contraseña
              SizedBox(
                width: size.width,
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🚪 Botón Login
              MaterialButton(
                onPressed: () {
                  // Aquí podrías activar trigSuccess o trigFail
                },
                color: Colors.purple,
                minWidth: size.width,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              const SizedBox(height: 10),

              // 👤 Registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta? '),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¡Regístrate aquí!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
