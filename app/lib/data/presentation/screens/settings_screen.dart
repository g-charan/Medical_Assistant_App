import 'package:app/common/widgets/custom_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 60,

                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      Icon(Icons.supervised_user_circle_outlined, size: 30),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Charan Kumar", style: TextStyle(fontSize: 14)),
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
                const SizedBox(height: 20),
                someList(),
                someList(),
                someList(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: Offset(0, 2), // changes position of shadow
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
                              offset: Offset(
                                0,
                                2,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text("You are all good"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text("ACCOUNT"),
                someList2(),
                someList2(),
                someList2(),
                const SizedBox(height: 10),
                Text("SETTINGS"),
                someList2(),
                someList2(),
                someList2(),
              ],
            ),
          ],
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
