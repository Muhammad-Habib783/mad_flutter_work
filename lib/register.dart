import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

// Same teal scheme as the login, profile and landing pages
const Color _primary = Color(0xFF00A8A8);
const Color _primaryLight = Color(0xFFE6F6F6);
const Color _textDark = Color(0xFF2C3E50);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // GlobalKey so all fields are validated together (same as the login page)
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  // Controllers: the password ones are needed for the live strength meter
  // and for the "confirm password" match check
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // Saved data
  String _name = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  DateTime? _dob;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // ==========================================
  // STRONG VALIDATION METHODS
  // ==========================================

  // Name: letters and spaces only, at least 3 characters
  String? _validateName(String value) {
    final String name = value.trim();
    if (name.isEmpty) {
      return 'Full name is Required';
    }
    if (name.length<3) {
      return 'Name must be at least 3 characters long';
    }
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  // Email: same rule as the login page, so a new user can log in later
  String? _validateEmail(String value) {
    final String email = value.trim();
    if (email.isEmpty) {
      return 'Email is Required';
    }
    if (!email.contains('@')) {
      return 'Email must contain @ symbol';
    }
    if (!email.endsWith('.com')) {
      return 'Email must end with .com';
    }
    if (!RegExp(r'^[\w.\-]+@[\w\-]+(\.[\w\-]+)*\.com$').hasMatch(email)) {
      return 'Enter a valid email like name@example.com';
    }
    return null;
  }

  // Phone: digits only, 10 to 15 digits
  String? _validatePhone(String value) {
    if (value.isEmpty) {
      return 'Phone number is Required';
    }
    if (value.length<10) {
      return 'Phone number must be at least 10 digits';
    }
    if (value.length>15) {
      return 'Phone number can have at most 15 digits';
    }
    return null;
  }

  // Date of birth: required and the user must be at least 13 years old
  String? _validateDob() {
    if (_dob==null) {
      return 'Date of birth is Required';
    }
    final DateTime now = DateTime.now();
    int age = now.year-_dob!.year;
    final bool birthdayPassed =
        now.month>_dob!.month||(now.month==_dob!.month&&now.day>=_dob!.day);
    if (!birthdayPassed) {
      age = age-1;
    }
    if (age<13) {
      return 'You must be at least 13 years old';
    }
    return null;
  }

  // Password rules (also used by the live checklist below the field)
  bool _hasLength(String v) => v.length>=8;
  bool _hasUpper(String v) => RegExp(r'[A-Z]').hasMatch(v);
  bool _hasLower(String v) => RegExp(r'[a-z]').hasMatch(v);
  bool _hasDigit(String v) => RegExp(r'[0-9]').hasMatch(v);
  bool _hasSymbol(String v) =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v);

  // How many of the 5 rules pass (0 to 5)
  int _passedRules(String v) {
    int count = 0;
    if (_hasLength(v)) count++;
    if (_hasUpper(v)) count++;
    if (_hasLower(v)) count++;
    if (_hasDigit(v)) count++;
    if (_hasSymbol(v)) count++;
    return count;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is Required';
    }
    if (_passedRules(value)<5) {
      return 'Password needs: 8+ chars, Uppercase, Lowercase, Number, Symbol';
    }
    return null;
  }

  String? _validateConfirm(String value) {
    if (value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value!=_passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ==========================================
  // ACTIONS
  // ==========================================

  // Opens the calendar and writes the chosen date in the field
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2004, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Select your date of birth',
    );
    if (picked!=null&&mounted) {
      setState(() {
        _dob = picked;
        _dobController.text =
        '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  void _submitRegister() {
    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      print('Register Validation Passed!');
      print('Name: $_name');
      print('Email: $_email');
      print('Phone: $_phone');
      print('Date of birth: $_dob');
      print('Password: $_password');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created for $_name. Please login.'),
          backgroundColor: _primary,
        ),
      );

      // Replace the register page with the login page, so the back arrow
      // on the login page goes straight to the landing page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors shown in red'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // ==========================================
  // SMALL UI HELPERS
  // ==========================================

  // Eye icon to show / hide a password
  Widget _eyeButton(bool obscure, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: _primary,
      ),
      onPressed: onPressed,
    );
  }

  // Strength bar: the colored part grows with AnimatedContainer
  Widget _buildStrengthBar(String password) {
    final int passed = _passedRules(password);
    final double strength = passed/5.0;

    String label = 'Too short';
    Color color = Colors.red;
    if (passed==5) {
      label = 'Strong';
      color = _primary;
    } else if (passed==4) {
      label = 'Good';
      color = Colors.lightGreen;
    } else if (passed==3) {
      label = 'Fair';
      color = Colors.orange;
    } else if (passed>0) {
      label = 'Weak';
      color = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Text(
              'Password strength',
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            const Spacer(),
            Text(
              password.isEmpty ? '' : label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 8.0,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  height: 8.0,
                  width: constraints.maxWidth*strength,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // One line of the checklist: the icon cross-fades when the rule passes
  Widget _rule(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: <Widget>[
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState:
            ok ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Icon(Icons.radio_button_unchecked,
                size: 18.0, color: Colors.grey.shade400),
            secondChild:
            const Icon(Icons.check_circle, size: 18.0, color: _primary),
          ),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.0,
              color: ok ? _textDark : Colors.black45,
              fontWeight: ok ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist(String v) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: _primaryLight,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildStrengthBar(v),
          const SizedBox(height: 4.0),
          _rule('At least 8 characters', _hasLength(v)),
          _rule('One uppercase letter (A-Z)', _hasUpper(v)),
          _rule('One lowercase letter (a-z)', _hasLower(v)),
          _rule('One number (0-9)', _hasDigit(v)),
          _rule('One symbol (!@#\$%^&*)', _hasSymbol(v)),
        ],
      ),
    );
  }

  // Terms checkbox as a FormField, so it can show an error like the others
  Widget _buildTerms() {
    return FormField<bool>(
      initialValue: false,
      validator: (value) =>
      value==true ? null : 'You must accept the terms to continue',
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: state.value,
                  activeColor: _primary,
                  onChanged: (v) => state.didChange(v),
                ),
                const Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy',
                    style: TextStyle(fontSize: 13.0, color: Colors.black54),
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(fontSize: 12.0, color: Colors.red),
                ),
              ),
          ],
        );
      },
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
    // Same width logic as the other pages
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth =
    screenWidth<700 ? screenWidth : (screenWidth*0.4).clamp(460.0, 800.0);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              child: ScrollConfiguration(
                behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: cardWidth),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 28.0),
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
                          children: <Widget>[
                            // --- BACK ARROW (inside the card corner) ---
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _buildBackButton(_primary),
                            ),
                            const SizedBox(height: 8.0),

                            // --- HEADER ---
                            const Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 80.0,
                              color: _primary,
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            const Text(
                              'Fill in your details to get started',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
                            ),
                            const SizedBox(height: 28.0),

                            // --- FORM ---
                            Form(
                              key: _formStateKey,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: <Widget>[
                                  // FULL NAME
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Full Name',
                                      hintText: 'Enter your full name',
                                      prefixIcon: Icon(Icons.person_outline,
                                          color: _primary),
                                    ),
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    validator: (value) =>
                                        _validateName(value??''),
                                    onSaved: (value) =>
                                    _name = value!.trim(),
                                  ),
                                  const SizedBox(height: 18.0),

                                  // EMAIL
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'name@example.com',
                                      prefixIcon: Icon(Icons.email_outlined,
                                          color: _primary),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        _validateEmail(value??''),
                                    onSaved: (value) =>
                                    _email = value!.trim(),
                                  ),
                                  const SizedBox(height: 18.0),

                                  // PHONE (digits only)
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                      hintText: 'Enter your phone number',
                                      prefixIcon: Icon(Icons.phone_outlined,
                                          color: _primary),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    validator: (value) =>
                                        _validatePhone(value??''),
                                    onSaved: (value) => _phone = value!,
                                  ),
                                  const SizedBox(height: 18.0),

                                  // DATE OF BIRTH (calendar picker)
                                  TextFormField(
                                    controller: _dobController,
                                    readOnly: true,
                                    onTap: _pickDate,
                                    decoration: const InputDecoration(
                                      labelText: 'Date of Birth',
                                      hintText: 'Tap to choose a date',
                                      prefixIcon: Icon(
                                          Icons.calendar_today_outlined,
                                          color: _primary),
                                    ),
                                    validator: (value) => _validateDob(),
                                  ),
                                  const SizedBox(height: 18.0),

                                  // PASSWORD (updates the strength meter live)
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    onChanged: (value) => setState(() {}),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      hintText: 'Create a strong password',
                                      prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: _primary),
                                      suffixIcon: _eyeButton(
                                        _obscurePassword,
                                            () => setState(() =>
                                        _obscurePassword =
                                        !_obscurePassword),
                                      ),
                                    ),
                                    validator: (value) =>
                                        _validatePassword(value??''),
                                    onSaved: (value) => _password = value!,
                                  ),
                                  const SizedBox(height: 12.0),
                                  _buildChecklist(_passwordController.text),
                                  const SizedBox(height: 18.0),

                                  // CONFIRM PASSWORD
                                  TextFormField(
                                    controller: _confirmController,
                                    obscureText: _obscureConfirm,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      hintText: 'Re-enter your password',
                                      prefixIcon: const Icon(
                                          Icons.lock_reset_outlined,
                                          color: _primary),
                                      suffixIcon: _eyeButton(
                                        _obscureConfirm,
                                            () => setState(() =>
                                        _obscureConfirm = !_obscureConfirm),
                                      ),
                                    ),
                                    validator: (value) =>
                                        _validateConfirm(value??''),
                                  ),
                                  const SizedBox(height: 10.0),

                                  // TERMS
                                  _buildTerms(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // --- SIGN UP BUTTON ---
                            SizedBox(
                              width: double.infinity,
                              height: 55.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primary,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                onPressed: _submitRegister,
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),

                            // --- LOGIN LINK ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Already have an account?',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  onPressed: _goToLogin,
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: _primary,
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