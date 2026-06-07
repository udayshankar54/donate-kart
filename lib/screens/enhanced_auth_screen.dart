import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../services/analytics_service.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class EnhancedAuthScreen extends StatefulWidget {
  final Function(dynamic)? onSuccess; // <-- Add this right under line 7

  const EnhancedAuthScreen({super.key, this.onSuccess}); // <-- Update line 8

  @override
  State<EnhancedAuthScreen> createState() => _EnhancedAuthScreenState();
}

class _EnhancedAuthScreenState extends State<EnhancedAuthScreen> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool isLoading = false;
  String selectedUserType = 'donor';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  late FirebaseAuthService authService;
  late FirestoreService firestoreService;
  late AnalyticsService analyticsService;

  @override
  void initState() {
    super.initState();
    authService = FirebaseAuthService();
    firestoreService = FirestoreService();
    analyticsService = AnalyticsService();
  }

  Future<void> handleSignUp() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true);
    try {
      final user = await authService.signUpWithEmail(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        userType: selectedUserType,
      );

      if (user != null) {
        // Create user profile in Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: emailController.text,
          phone: phoneController.text.isNotEmpty ? phoneController.text : null,
          name: nameController.text,
          userType: selectedUserType,
          isVerified: false,
        );

        await firestoreService.createUser(userModel);
        await analyticsService.logSignUp(method: 'email');

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign up successful!')));
          // Navigate to home screen
          if (widget.onSuccess != null) {
            widget.onSuccess!({
              'uid': user.uid,
              'email': user.email,
              'name': user.displayName ?? nameController.text,
              'role': selectedUserType,
            });
          } else {
            Navigator.of(context).pop({'success': true, 'user': user});
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final user = await authService.loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        await analyticsService.logLogin(method: 'email');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));
          // Navigate to home screen
          if (widget.onSuccess != null) {
            widget.onSuccess!({
              'uid': user.uid,
              'email': user.email,
              'name': user.displayName ?? 'User',
              'role': 'donor', // Default role
            });
          } else {
            Navigator.of(context).pop({'success': true, 'user': user});
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleGoogleSignIn() async {
    setState(() => isLoading = true);
    try {
      final user = await authService.signInWithGoogle();
      if (user != null) {
        await analyticsService.logLogin(method: 'google');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google sign in successful!')),
          );
          // Navigate to home screen
          if (widget.onSuccess != null) {
            widget.onSuccess!({
              'uid': user.uid,
              'email': user.email,
              'name': user.displayName ?? 'User',
              'role': 'donor', // Default role
            });
          } else {
            Navigator.of(context).pop({'success': true, 'user': user});
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleDemoLogin() async {
    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo login successful! 🎉')),
        );
        // Navigate to home screen with demo user
        if (widget.onSuccess != null) {
          widget.onSuccess!({
            'uid': 'demo_user_12345',
            'email': 'demo@donatekart.app',
            'name': 'Demo User',
            'role': 'donor',
          });
        } else {
          Navigator.of(context).pop({
            'success': true,
            'user': {
              'uid': 'demo_user_12345',
              'email': 'demo@donatekart.app',
              'displayName': 'Demo User',
            },
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF047857).withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DonateKart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLogin ? 'Welcome back!' : 'Join our giving community',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormToggle(context, true, 'Login'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFormToggle(context, false, 'Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (!isLogin) ...[
                      _buildTextField(
                        nameController,
                        'Full Name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildUserTypeDropdown(),
                      const SizedBox(height: 16),
                    ],
                    _buildTextField(
                      emailController,
                      'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      passwordController,
                      'Password',
                      obscureText: obscurePassword,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF64748B),
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                    ),
                    if (!isLogin) ...[
                      const SizedBox(height: 16),
                      _buildTextField(
                        phoneController,
                        'Phone (Optional)',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : (isLogin ? handleLogin : handleSignUp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isLoading
                              ? 'Please wait...'
                              : (isLogin ? 'Login securely' : 'Create account'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text(
                            'or continue with',
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : handleGoogleSignIn,
                        icon: const Icon(
                          Icons.g_mobiledata,
                          color: Color(0xFF334155),
                        ),
                        label: const Text('Continue with Google'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF64748B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          foregroundColor: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          phoneController.clear();
                        });
                      },
                      child: Text(
                        isLogin
                            ? 'Need an account? Sign Up'
                            : 'Already have an account? Log In',
                        style: const TextStyle(
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormToggle(BuildContext context, bool loginMode, String title) {
    final isActive = isLogin == loginMode;
    return GestureDetector(
      onTap: () => setState(() => isLogin = loginMode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? Colors.white : Colors.white54),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFF047857) : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildUserTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedUserType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: const [
            DropdownMenuItem(value: 'donor', child: Text('Donor')),
            DropdownMenuItem(value: 'volunteer', child: Text('Volunteer')),
            DropdownMenuItem(value: 'ngo', child: Text('NGO')),
          ],
          onChanged: (value) {
            setState(() => selectedUserType = value ?? 'donor');
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
