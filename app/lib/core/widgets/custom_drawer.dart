// lib/common/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerItem {
  final IconData icon;
  final String title;
  final String route;

  const DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}

// Create a list of your drawer items
const List<DrawerItem> drawerItems = [
  DrawerItem(icon: Icons.home, title: 'Home', route: '/'),
  DrawerItem(icon: Icons.next_plan, title: 'Vault', route: '/vault'),
  DrawerItem(icon: Icons.info, title: 'Family', route: '/family'),
  DrawerItem(icon: Icons.info, title: 'AI', route: '/ai'),
  DrawerItem(icon: Icons.info, title: 'Metrics', route: '/metrics'),
  DrawerItem(icon: Icons.info, title: 'Alerts', route: '/alerts'),

  DrawerItem(
    icon: Icons.settings,
    title: 'Settings',
    route: '/settings',
  ), // Example
  // Example
];

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: ListView(
        // Remove default padding from the ListView
        padding: EdgeInsets.zero,
        // Important to remove default padding
        children: <Widget>[
          SizedBox(
            height: 140.0,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'MediHelp',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'charan.gutti@example.com',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...drawerItems.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onTap: () {
                Navigator.pop(context);
                context.go(item.route);
              },
            );
          }),
          // Add more ListTile widgets for other menu items
        ],
      ),
    );
  }
}
