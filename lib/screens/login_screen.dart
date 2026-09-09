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

  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

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
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // Ensures the layout resizes (and the card's own scroll view
        // kicks in) only when the keyboard actually needs the space.
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;

              // Smaller image footprint so the card has enough room
              // to show all fields without needing a scroll first.
              final imageHeight = screenHeight * 0.34;
              final cardTop = screenHeight * 0.26;

              return Stack(
                children: [
                  // ==========================================
                  // TOP BACKGROUND IMAGE ONLY
                  // ==========================================
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: imageHeight,
                    child: Image.asset(
                      'assets/images/hi_class_login_background.jfif',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),

                  // ==========================================
                  // FLOATING LOGIN CARD
                  // ==========================================
                  Positioned(
                    top: cardTop,
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(38),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(38),
                        child: LayoutBuilder(
                          builder: (context, cardConstraints) {
                            return SingleChildScrollView(
                              // Only scrolls if content genuinely can't
                              // fit (very small screens / keyboard open).
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                24,
                                24,
                                20,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: cardConstraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      // TITLE
                                      const Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          color: AppColors.maroon,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // SUBTITLE
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: AppColors.gold
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              'نظام إدارة المشاريع',
                                              style: TextStyle(
                                                color: AppColors.gold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: AppColors.gold
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),

                                      // USERNAME
                                      _buildTextField(
                                        controller: _userCtrl,
                                        hint: 'اسم المستخدم',
                                        icon: Icons.person,
                                        obscureText: false,
                                      ),

                                      const SizedBox(height: 14),

                                      // PASSWORD
                                      _buildTextField(
                                        controller: _passCtrl,
                                        hint: 'رمز الدخول',
                                        icon: Icons.lock,
                                        obscureText: true,
                                      ),

                                      const SizedBox(height: 18),

                                      // LOGIN BUTTON
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: _login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.gold,
                                            foregroundColor:
                                                AppColors.maroon,
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'دخول',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      // INTERNAL USE
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.lock_outline,
                                            size: 17,
                                            color: AppColors.gold,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'للاستخدام الداخلي فقط',
                                            style: TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // ROLE SELECTION
                                      Row(
                                        children:
                                            UserRole.values.map((role) {
                                          final selected =
                                              role == _selectedRole;

                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                horizontal: 4,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedRole = role;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  height: 85,
                                                  decoration: BoxDecoration(
                                                    color: selected
                                                        ? AppColors.gold
                                                            .withValues(
                                                            alpha: 0.12,
                                                          )
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(18),
                                                    border: Border.all(
                                                      color: selected
                                                          ? AppColors.gold
                                                          : Colors
                                                              .grey.shade300,
                                                      width:
                                                          selected ? 2 : 1,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        role.icon,
                                                        color:
                                                            AppColors.gold,
                                                        size: 26,
                                                      ),
                                                      const SizedBox(
                                                          height: 6),
                                                      Text(
                                                        role.label,
                                                        style:
                                                            const TextStyle(
                                                          color: AppColors
                                                              .maroon,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool obscureText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.maroon,
            fontSize: 16,
          ),
          suffixIcon: Icon(
            icon,
            color: AppColors.maroon,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}