import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import the package

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ), // Overall animation duration
    );
    // Start the animation when the screen is initialized
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
          padding: EdgeInsets.all(20),
          child: ListView(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(
                milliseconds: 375,
              ), // Duration for each child animation
              delay: const Duration(
                milliseconds: 100,
              ), // Delay between each child's animation start
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0, // Slide from bottom
                child: FadeInAnimation(child: widget),
              ),
              children: [
                const SizedBox(height: 10),
                // User Profile Section
                AnimationConfiguration.staggeredList(
                  position:
                      0, // This is the first item in the list, so position 0
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            Icon(
                              Icons.supervised_user_circle_outlined,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Charan Gutti",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "charan.gutti@gmail.com",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(Icons.edit_outlined),
                              onPressed: () {
                                context.push('/settings/edit-profile');
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.exit_to_app),
                              onPressed: () {
                                context.push('/login');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // First set of list items (using someList())
                for (int i = 0; i < 3; i++)
                  AnimationConfiguration.staggeredList(
                    position: i + 1, // Stagger after the profile section
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: someList()),
                    ),
                  ),
                const SizedBox(height: 20),
                // Health Overview Section
                AnimationConfiguration.staggeredList(
                  position: 4, // Stagger after the first set of list items
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Health Overview"),
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
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text("You are all good"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Account Section Title
                AnimationConfiguration.staggeredList(
                  position: 5,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: Text("ACCOUNT")),
                  ),
                ),
                // Second set of list items (using someList2())
                for (int i = 0; i < 3; i++)
                  AnimationConfiguration.staggeredList(
                    position: i + 6, // Stagger after the account title
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: someList2()),
                    ),
                  ),
                const SizedBox(height: 10),
                // Settings Section Title
                AnimationConfiguration.staggeredList(
                  position: 9,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: Text("SETTINGS")),
                  ),
                ),
                // Third set of list items (using someList2())
                for (int i = 0; i < 3; i++)
                  AnimationConfiguration.staggeredList(
                    position: i + 10, // Stagger after the settings title
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: someList2()),
                    ),
                  ),
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
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 1, bottom: 1),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.calendar_today_outlined),
            const SizedBox(width: 10),
            Text("Appointments"),
            const Spacer(),
            Icon(Icons.arrow_right_alt_outlined),
          ],
        ),
      ),
    );
  }

  Widget someList2() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 5, bottom: 5),
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
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            Text("Appointments"),
            const Spacer(),
            Icon(Icons.arrow_right_sharp),
          ],
        ),
      ),
    );
  }
}
