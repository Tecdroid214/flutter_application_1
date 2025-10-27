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
  bool _isLoading = false;
  bool _riveReady = false;

  StateMachineController? controller;
  SMIBool? isChecking;
  SMIBool? isHandsUp;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  SMINumber? numLook;

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Timer? _typingDebounce;
  String? emailError;
  String? passError;

  // ================= VALIDACIONES =================
  bool isValidEmail(String email) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);

  bool isValidPassword(String pass) =>
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$')
          .hasMatch(pass);

  void _validateFields() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    setState(() {
      emailError = email.isEmpty
          ? null
          : (isValidEmail(email) ? null : 'Email inválido');
      passError = pass.isEmpty
          ? null
          : (isValidPassword(pass)
              ? null
              : 'Contraseña inválida (usa mayúsculas, minúsculas, número y símbolo)');
    });
  }

  // ================= LOGIN PRINCIPAL (VERSIÓN FINAL) =================
  Future<void> _onLogin() async {
    if (_isLoading || !_riveReady) return;

    // 1. Inicia el estado de carga y valida
    setState(() => _isLoading = true);
    _validateFields();

    // 2. Quita el foco (esto ahora es seguro gracias al guard clause en _onFocusChange)
    FocusScope.of(context).unfocus();

    // 3. 🔥 Forzamos manualmente la animación de "bajar manos"
    isChecking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50.0;

    // 4. 🔥 ¡ESPERA A QUE TERMINE DE BAJAR LAS MANOS!
    // Esta duración debe ser IGUAL o MAYOR a tu animación
    // de "bajar manos" en Rive. Prueba con 300ms o 500ms.
    await Future.delayed(const Duration(milliseconds: 300));

    // 5. Ahora sí, dispara el resultado (bien o mal)
    if (emailError == null && passError == null) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }

    // 6. Esperamos a que termine la animación de éxito/fallo
    await Future.delayed(const Duration(seconds: 4));

    // 7. Terminamos el estado de carga
    if (mounted) setState(() => _isLoading = false);
  }

  // ================= FOCUS / MANOS (MODIFICADO) =================
  void _onFocusChange() {
    // ⚡ AÑADIDO: Si está cargando, no hagas nada para evitar
    // que compitan las animaciones.
    if (!_riveReady || _isLoading) return;

    if (!_emailFocus.hasFocus && !_passwordFocus.hasFocus) {
      isChecking?.change(false);
      isHandsUp?.change(false);
      numLook?.value = 50.0;
    } else if (_emailFocus.hasFocus) {
      isChecking?.change(true);
      isHandsUp?.change(false);
    } else if (_passwordFocus.hasFocus) {
      isHandsUp?.change(true);
      isChecking?.change(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
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

  // ================= UI PRINCIPAL =================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              // --- ANIMACIÓN RIVE ---
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ['Login Machine'],
                  onInit: (artboard) async {
                    controller = StateMachineController.fromArtboard(
                        artboard, 'Login Machine');
                    if (controller == null) return;

                    artboard.addController(controller!);
                    isChecking = controller!.findSMI('isChecking');
                    isHandsUp = controller!.findSMI('isHandsUp');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('trigFail');
                    numLook = controller!.findSMI('numLook');

                    await Future.delayed(const Duration(milliseconds: 100));
                    setState(() => _riveReady = true);
                  },
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              // --- EMAIL ---
              TextField(
                focusNode: _emailFocus,
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: emailError,
                  hintText: 'Introduce tu email',
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  if (!_riveReady) return;

                  isHandsUp?.change(false);
                  isChecking?.change(true);

                  final look = (value.length / 80.0 * 100.0)
                      .clamp(0.0, 100.0)
                      .toDouble();
                  numLook?.value = look;

                  _typingDebounce?.cancel();
                  _typingDebounce =
                      Timer(const Duration(milliseconds: 1000), () {
                    if (!mounted) return;
                    isChecking?.change(false);
                  });

                  _validateFields();
                },
              ),

              const SizedBox(height: 10),

              // --- CONTRASEÑA ---
              TextField(
                focusNode: _passwordFocus,
                controller: passCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  errorText: passError,
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
                      setState(() => _obscurePassword = !_obscurePassword);
                      if (_passwordFocus.hasFocus) {
                        isHandsUp?.change(true);
                        isChecking?.change(false);
                      }
                    },
                  ),
                ),
                onChanged: (_) => _validateFields(),
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

              // --- BOTÓN LOGIN ---
              SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading || !_riveReady ? null : _onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 33, 198),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
