import 'package:flutter/material.dart';
import 'profile.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Create the GlobalKey for the Form (As per book Step 3)
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  // 2. Create variables to hold the saved data
  String _email = '';
  String _password = '';

  // Controls whether the password is hidden or visible
  bool _obscurePassword = true;

  // ==========================================
  // 3. STRONG VALIDATION METHODS
  // ==========================================

  // Email Validation: Must contain '@' and '.com'
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is Required';
    }
    if (!value.contains('@')) {
      return 'Email must contain @ symbol';
    }
    if (!value.endsWith('.com')) {
      return 'Email must end with .com';
    }
    return null; // Returns null if validation passes
  }

  // Password Validation: 8+ chars, Upper, Lower, Digit, Symbol
  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is Required';
    }
    if (value.length<8) {
      return 'Password must be at least 8 characters long';
    }

    // RegEx checks for at least one uppercase, one lowercase, one digit, and one special symbol
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasUppercase||!hasLowercase||!hasDigit||!hasSpecialChar) {
      return 'Password needs: 8+ chars, Uppercase, Lowercase, Number, Symbol';
    }
    return null; // Returns null if validation passes
  }

  // ==========================================
  // 4. SUBMIT METHOD
  // ==========================================
  void _submitLogin() {
    // Check if the form is valid (As per book Step 6)
    if (_formStateKey.currentState!.validate()) {
      // Save the form data
      _formStateKey.currentState!.save();

      // Print to console
      print('Login Validation Passed!');
      print('Email: $_email');
      print('Password: $_password');

      // Show a success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logging in as $_email...'),
          backgroundColor: const Color(0xFF00A8A8),
        ),
      );

      // Open the Profile page after a successful (validated) login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  }

  // Sign Up link: replaces the login page with the register page,
  // so the back arrow still goes straight to the landing page
  void _goToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  // Round back arrow, placed inside the card (not in the screen corner)
  Widget _buildBackButton(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6.0,
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: IconButton(
        tooltip: 'Back to landing page',
        icon: Icon(Icons.arrow_back, color: color),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Card width: about 40% of the page on wide screens (web/tablet),
    // and almost full width on small phones
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth =
    screenWidth<700 ? screenWidth : (screenWidth*0.4).clamp(460.0, 800.0);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              // Center the content vertically and horizontally
              // Scrollbar is hidden so no scroll line shows on the page
              child: ScrollConfiguration(
                behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    // Limits the width so the page stays centered and
                    // compact on wide web/landscape screens
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: cardWidth),
                      child: Container(
                        // Card that shows the area of the login page
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 28.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 20.0,
                              offset: const Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // --- BACK ARROW (inside the card corner) ---
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _buildBackButton(const Color(0xFF00A8A8)),
                            ),
                            const SizedBox(height: 8.0),

                            // --- LOGO SECTION ---
                            const Icon(
                              Icons.flutter_dash,
                              size: 100,
                              color: Color(0xFF00A8A8), // Aesthetic Teal
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50), // Dark blue/grey
                              ),
                            ),
                            const SizedBox(height: 40),

                            // --- FORM SECTION ---
                            Form(
                              key: _formStateKey,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: <Widget>[
                                  // --- EMAIL FIELD ---
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'Enter your email',
                                      prefixIcon: Icon(Icons.email_outlined,
                                          color: Color(0xFF00A8A8)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        _validateEmail(value!),
                                    onSaved: (value) => _email = value!,
                                  ),
                                  const SizedBox(height: 20),

                                  // --- PASSWORD FIELD ---
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      hintText: 'Enter your password',
                                      prefixIcon: const Icon(Icons.lock_outline,
                                          color: Color(0xFF00A8A8)),
                                      // Eye icon to show / hide the password
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: const Color(0xFF00A8A8),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                            !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: _obscurePassword,
                                    validator: (value) =>
                                        _validatePassword(value!),
                                    onSaved: (value) => _password = value!,
                                  ),
                                  const SizedBox(height: 10),

                                  // --- FORGOT PASSWORD ---
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        print('Forgot Password Pressed');
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            color: Color(0xFF00A8A8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // --- LOGIN BUTTON ---
                            SizedBox(
                              width: double.infinity,
                              height: 55, // Slightly taller for a modern feel
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFF00A8A8), // Teal
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Rounded corners
                                  ),
                                ),
                                onPressed: _submitLogin,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // --- SIGN UP LINK (opens the register page) ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  onPressed: _goToRegister,
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFF00A8A8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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