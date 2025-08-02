import 'package:app/data/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// 1. Convert to a ConsumerStatefulWidget to access Riverpod providers
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

// 2. Change the State to a ConsumerState
class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              delay: const Duration(milliseconds: 100),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                const SizedBox(height: 10),
                // User Profile Section
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Charan Gutti", style: TextStyle(fontSize: 14)),
                          Text(
                            "charan.gutti@gmail.com",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          context.push('/settings/edit-profile');
                        },
                      ),
                      // 3. Fix: Use the Riverpod provider to call signOut
                      IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () async {
                          try {
                            // Use ref.read to access the service via its provider
                            await ref.read(authServiceProvider).signOut();
                            // Your GoRouter redirect logic will automatically
                            // handle navigation to the login screen.
                          } catch (e) {
                            // Show an error if sign-out fails
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error signing out: ${e.toString()}',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // The rest of your widgets...
                for (int i = 0; i < 3; i++) someList(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Health Overview"),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text("You are all good"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text("ACCOUNT"),
                for (int i = 0; i < 3; i++) someList2(),
                const SizedBox(height: 10),
                const Text("SETTINGS"),
                for (int i = 0; i < 3; i++) someList2(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget someList() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.calendar_today_outlined),
            SizedBox(width: 10),
            Text("Appointments"),
            Spacer(),
            Icon(Icons.arrow_right_alt_outlined),
          ],
        ),
      ),
    );
  }

  Widget someList2() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      height: 50,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            Text("Appointments"),
            Spacer(),
            Icon(Icons.arrow_right_sharp),
          ],
        ),
      ),
    );
  }
}
