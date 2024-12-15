import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of items in a row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              title: "Profile",
              icon: Icons.person,
              onTap: () => Navigator.pushNamed(context, '/profileUpdate'),
            ),
            _buildDashboardCard(
              context,
              title: "Settings",
              icon: Icons.settings,
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _buildDashboardCard(
              context,
              title: "AppInbox",
              icon: Icons.notifications,
              onTap: () => Navigator.pushNamed(context, '/appInbox'),
            ),
            _buildDashboardCard(
              context,
              title: "Reports",
              icon: Icons.bar_chart,
              onTap: () => Navigator.pushNamed(context, '/reports'),
            ),
            _buildDashboardCard(
              context,
              title: "Help",
              icon: Icons.help,
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            _buildDashboardCard(
              context,
              title: "Logout",
              icon: Icons.logout,
              onTap: () {
                // Add your logout logic here
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
