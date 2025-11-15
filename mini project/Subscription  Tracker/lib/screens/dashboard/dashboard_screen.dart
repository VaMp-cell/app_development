import 'package:flutter/material.dart';
import '../../services/subscription_service.dart' as subs;
import '../subscriptions/subscriptions_screen.dart';
import '../subscriptions/add_subscription_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userEmail = "";
  bool isPremium = false;
  int _selectedIndex = 0;

  final service = subs.SubscriptionService();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final data = await AuthService().getUserData();
    if (data != null) {
      setState(() {
        userEmail = data["email"] ?? "";
        isPremium = data["isPremium"] ?? false;
      });
    }
  }

  Future<void> _upgradeToPremium() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({"isPremium": true});

    setState(() => isPremium = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🎉 You are now a Premium Member!")),
    );
  }

  final List<Widget> pages = const [
    SubscriptionsScreen(),
    AnalyticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),

      // 🔥 Drawer
      drawer: _buildDrawer(),

      // 🔥 Switch tabs
      body: pages[_selectedIndex],

      // 🔥 Floating add button available on all pages
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSubscriptionScreen()),
          );
        },
      ),

      // 🔥 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: "Subscriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // 🔥 Drawer widget
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.red),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  isPremium ? "💎 Premium Member" : "Free Member",
                  style: TextStyle(
                    color: isPremium ? Colors.amber : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: Text(isPremium ? "You're Premium" : "Upgrade to Premium"),
            onTap: () {
              if (!isPremium) _upgradeToPremium();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
