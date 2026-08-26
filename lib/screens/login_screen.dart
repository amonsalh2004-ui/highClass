import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'manager/manager_dashboard_screen.dart';
import 'designer/designer_dashboard_screen.dart';
import 'engineer/engineer_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.manager;
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _login() {
    Widget target;
    switch (_selectedRole) {
      case UserRole.manager:
        target = const ManagerDashboardScreen();
        break;
      case UserRole.designer:
        target = const DesignerDashboardScreen();
        break;
      case UserRole.engineer:
        target = const EngineerDashboardScreen();
        break;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.maroon,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(Icons.spa, color: AppColors.gold, size: 90),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'هاي كلاس',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'للمطابخ و الديكور',
                style: TextStyle(color: AppColors.gold, fontSize: 13),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                          color: AppColors.maroon,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'نظام إدارة المشاريع',
                      style: TextStyle(color: AppColors.gold),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _userCtrl,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'اسم المستخدم',
                        suffixIcon: Icon(Icons.person_outline,
                            color: AppColors.maroon),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'رمز الدخول',
                        suffixIcon:
                            Icon(Icons.lock_outline, color: AppColors.maroon),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('دخول'),
                    ),
                    const SizedBox(height: 14),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: 14, color: AppColors.textMuted),
                        SizedBox(width: 6),
                        Text('للاستخدام الداخلي فقط',
                            style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: UserRole.values.map((role) {
                        final selected = role == _selectedRole;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedRole = role),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.gold.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              border: Border.all(
                                color: selected
                                    ? AppColors.gold
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(role.icon,
                                    color: AppColors.gold, size: 26),
                                const SizedBox(height: 6),
                                Text(role.label,
                                    style: const TextStyle(
                                        color: AppColors.maroon,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
