import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/token_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  // Register function
  Future<void> handleRegister() async {
    // Get values
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final nic = nicController.text.trim();
    final password = passwordController.text.trim();
    final repeatPassword = repeatPasswordController.text.trim();

    // Validation
    if (name.isEmpty || email.isEmpty || nic.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    // Show loading
    setState(() => isLoading = true);

    // Call API
    final result = await AuthService.register(
      name: name,
      email: email,
      nic: nic,
      password: password,
      repeatPassword: repeatPassword,
    );

    // Hide loading
    setState(() => isLoading = false);

   // Check result
if (result['success'] == true) {
  // Save token and user data
  TokenStorage.saveToken(result['token'], result['user']);
  
  // Success - Navigate to home
  if (mounted) {
    Navigator.pushReplacementNamed(context, '/home');
  }
} else {
      // Error - Show message
      _showError(result['message'] ?? 'Registration failed');
    }
  }

  // Show error dialog
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    nicController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF0074D9);
    const Color orange = Color(0xFFFF851B);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: blue, width: 2),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // header
                SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: CustomPaint(
                          size: const Size(150, 150),
                          painter: _CornerPainter(color: blue),
                        ),
                      ),
                      Positioned(
                        top: 28,
                        left: 8,
                        child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: blue,
                          ),
                          label: const Text(
                            'Back',
                            style: TextStyle(color: blue),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 26,
                        right: 40,
                        child: _SmallSquare(color: orange),
                      ),
                    ],
                  ),
                ),
                // body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Get started',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        _label('Name'),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'John Daniel',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: blue, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _label('Email Address'),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'example.com',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: blue, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _label('NIC'),
                        TextField(
                          controller: nicController,
                          decoration: const InputDecoration(
                            hintText: 'XXXXXXXXXXXX',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: blue, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _label('Password'),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: '..............',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: blue, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _label('Repeat password'),
                        TextField(
                          controller: repeatPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: '..............',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: blue, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: isLoading ? null : handleRegister,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Column(
                          children: [
                            const Text(
                              'If you have account ?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
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
                // bottom decoration
                SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Transform.rotate(
                          angle: 3.14159,
                          child: CustomPaint(
                            size: const Size(150, 150),
                            painter: _CornerPainter(color: orange),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 26,
                        right: 40,
                        child: _SmallSquare(color: blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmallSquare extends StatelessWidget {
  final Color color;
  const _SmallSquare({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 14, height: 14, color: color);
  }
}