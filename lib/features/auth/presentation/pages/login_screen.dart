import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/core/utils/snackbar_utils.dart';
import 'package:ilike/core/utils/validation_utils.dart';
import 'package:ilike/features/auth/presentation/bloc/auth.dart';
import 'package:ilike/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:ilike/features/auth/presentation/widgets/password_field.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';
import 'package:ilike/core/network/hive_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onDemoModePressed() {
    // Cache demo user and token locally first
    final demoUser = UserEntity(
      id: 'demo-user-123',
      email: 'demo@ilike.com',
      username: 'Demo User',
      token: 'demo-token-123',
      password: 'demo-password-123',
      hasCompletedProfile: true,
    );

    // Store demo user in Hive for authentication checks
    HiveService.cacheUser(UserHiveModel.fromEntity(demoUser));
    HiveService.cacheAuthToken('demo-token-123');

    // Trigger AuthBloc to update state to Authenticated
    context.read<AuthBloc>().add(
      UpdateUserEvent(demoUser),
    );

    // Auto-fill demo credentials
    _emailController.text = 'demo@ilike.com';
    _passwordController.text = 'demo-password-123';

    // Navigate will be handled by AuthBloc listener
  }

  void _navigateToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading && !_isLoading) {
            setState(() => _isLoading = true);
          } else if (state is Authenticated) {
            setState(() => _isLoading = false);
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthInitial) {
            if (_isLoading) setState(() => _isLoading = false);
          } else if (state is AuthError) {
            setState(() => _isLoading = false);
            showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48.0),
                    Text(
                      'Welcome Back',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48.0),

                    // Email Field
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Validator.validateEmail(value),
                    ),

                    const SizedBox(height: 16.0),

                    // Password Field
                    PasswordField(
                      controller: _passwordController,
                      label: 'Password',
                      validator: (value) => Validator.validatePassword(value),
                    ),

                    const SizedBox(height: 8.0),

                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Demo Mode Button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _onDemoModePressed,
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Try Demo Mode'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(fontSize: 16.0),
                          side: BorderSide(color: Colors.purple.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),

                    // Login Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text('Login'),
                    ),

                    const SizedBox(height: 24.0),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: _navigateToRegister,
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
