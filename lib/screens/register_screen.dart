import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repeatPassword = TextEditingController();
  bool obscure = true;
  bool loading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _repeatPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    await AppState.instance.register(
      ProfileData(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        favoriteCities: '',
        preferredPrice: '',
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration(String label, IconData icon) => InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Создать аккаунт', style: TextStyle(fontWeight: FontWeight.w900))),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 34),
            children: [
              const Text(
                'Регистрация в Ugur',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 7),
              const Text(
                'Создайте профиль, чтобы сохранять гостиницы и управлять запросами.',
                style: TextStyle(color: AppColors.muted, height: 1.45),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: decoration('Имя и фамилия', Icons.person_outline_rounded),
                validator: (value) => value == null || value.trim().length < 2 ? 'Введите имя' : null,
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: decoration('Номер телефона', Icons.phone_outlined),
                validator: (value) => value == null || value.trim().isEmpty ? 'Введите номер телефона' : null,
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: decoration('Email', Icons.email_outlined),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Введите email';
                  if (!text.contains('@')) return 'Проверьте email';
                  return null;
                },
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: _password,
                obscureText: obscure,
                decoration: decoration('Пароль', Icons.lock_outline_rounded).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                ),
                validator: (value) => value == null || value.length < 6 ? 'Минимум 6 символов' : null,
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: _repeatPassword,
                obscureText: obscure,
                decoration: decoration('Повторите пароль', Icons.lock_outline),
                validator: (value) => value != _password.text ? 'Пароли не совпадают' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: loading ? null : _submit,
                child: loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Создать аккаунт'),
              ),
              const SizedBox(height: 13),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text('Уже есть аккаунт? Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
