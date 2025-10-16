import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  StateMachineController? controller;
  SMIBool? isChecking;
  SMIBool? isHandsUp;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  SMINumber? numLook;

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  Timer? _typingDebounce;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String? emailError;
  String? passError;

  bool isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool isValidPassword(String pass) {
    final re = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(pass);
  }

  void _onLogin() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    final eError = isValidEmail(email) ? null : 'Email inválido';
    final pError = isValidPassword(pass)
        ? null
        : 'Contraseña inválida (usa mayúsculas, minúsculas, número y símbolo)';

    setState(() {
      emailError = eError;
      passError = pError;
    });

    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    isChecking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50.0;

    // Solo activar animaciones del oso, sin mostrar texto
    if (eError == null && pError == null) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (isHandsUp == null || isChecking == null) return;

    if (!_emailFocus.hasFocus && !_passwordFocus.hasFocus) {
      // Ningún campo enfocado
      isChecking!.change(false);
      isHandsUp!.change(false);
      numLook?.value = 50.0;
    } else if (_emailFocus.hasFocus) {
      // Campo de email enfocado
      isChecking!.change(true);
      isHandsUp!.change(false);
    } else if (_passwordFocus.hasFocus) {
      // Campo de contraseña enfocado
      if (_obscurePassword) {
        // Si está oculta, el oso sube las manos
        isHandsUp!.change(true);
        isChecking!.change(false);
      } else {
        // Si se está mostrando, baja las manos
        isHandsUp!.change(false);
        isChecking!.change(false);
      }
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(children: [
            // ANIMACIÓN RIVE DEL OSO
            SizedBox(
              width: size.width,
              height: 200,
              child: RiveAnimation.asset(
                'assets/animated_login_character.riv',
                stateMachines: ['Login Machine'],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                    artboard,
                    'Login Machine',
                  );
                  if (controller == null) return;
                  artboard.addController(controller!);

                  isChecking = controller!.findSMI('isChecking');
                  isHandsUp = controller!.findSMI('isHandsUp');
                  trigSuccess = controller!.findSMI('trigSuccess');
                  trigFail = controller!.findSMI('trigFail');
                  numLook = controller!.findSMI('numLook');
                },
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 10),

            // EMAIL
            TextField(
              focusNode: _emailFocus,
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorText: emailError,
                hintText: 'Introduce tu email',
                prefixIcon: const Icon(Icons.mail),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                if (isHandsUp != null) isHandsUp!.change(false);
                if (isChecking != null) isChecking!.change(true);

                final look =
                    (value.length / 80.0 * 100.0).clamp(0.0, 100.0).toDouble();
                numLook?.value = look;

                _typingDebounce?.cancel();
                _typingDebounce = Timer(const Duration(milliseconds: 3000), () {
                  if (!mounted) return;
                  isChecking?.change(false);
                });
              },
            ),

            const SizedBox(height: 10),

            // CONTRASEÑA
            TextField(
              focusNode: _passwordFocus,
              controller: passCtrl,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                errorText: passError,
                hintText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                    _onFocusChange(); // actualizar animación del oso
                  },
                ),
              ),
              onChanged: (_) => _onFocusChange(),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: size.width,
              child: const Text(
                '¿Olvidaste tu contraseña?',
                textAlign: TextAlign.right,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN LOGIN
            MaterialButton(
              onPressed: _onLogin,
              color: const Color.fromARGB(255, 243, 33, 198),
              minWidth: size.width,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            const SizedBox(height: 10),

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
            )
          ]),
        ),
      ),
    );
  }
}
