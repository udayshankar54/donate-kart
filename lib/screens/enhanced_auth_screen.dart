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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF059669), const Color(0xFF10B981)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'DonateKart',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isLogin ? 'Welcome Back' : 'Join Our Community',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (!isLogin) ...[
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Full Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedUserType,
                          items: const [
                            DropdownMenuItem(
                              value: 'donor',
                              child: Text('Donor'),
                            ),
                            DropdownMenuItem(
                              value: 'volunteer',
                              child: Text('Volunteer'),
                            ),
                            DropdownMenuItem(value: 'ngo', child: Text('NGO')),
                          ],
                          onChanged: (value) {
                            setState(() => selectedUserType = value ?? 'donor');
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(
                                () => obscurePassword = !obscurePassword,
                              );
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (!isLogin) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone (Optional)',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : (isLogin ? handleLogin : handleSignUp),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                            : Text(isLogin ? 'Login' : 'Sign Up'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : handleGoogleSignIn,
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text('Sign in with Google'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() => isLogin = !isLogin);
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          phoneController.clear();
                        },
                        child: Text(
                          isLogin
                              ? 'Don\'t have an account? Sign up'
                              : 'Already have an account? Login',
                        ),
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
