import 'package:flutter/material.dart';

void main() {
  runApp(StepCounterApp());
}

class StepCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Step Counter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    StepsPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: Column(
        children: [
          // Gradient AppBar replacement
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const Text(
                  "Step Tracker",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Icon(Icons.favorite, color: Colors.white),
              ],
            ),
          ),

          // Main page content
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 245, 237, 255),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: "Steps",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF7F00FF),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}

// ---------------- Drawer Navigation ----------------

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Step Tracker Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_walk, color: Colors.deepPurple),
            title: const Text("Steps"),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart, color: Colors.deepPurple),
            title: const Text("History"),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepPurple),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.deepPurple),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.deepPurple),
            title: const Text("About"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------- Page Widgets ----------------

class StepsPage extends StatelessWidget {
  const StepsPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.directions_walk, size: 90, color: Color(0xFF7F00FF)),
          SizedBox(height: 20),
          Text(
            "Today’s Steps",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            "5,432",
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF7F00FF)),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage();

  @override
  Widget build(BuildContext context) {
    final history = {
      "Mon": "6,120",
      "Tue": "7,850",
      "Wed": "4,300",
      "Thu": "9,010",
      "Fri": "5,432"
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: history.entries
          .map((entry) => Card(
                color: const Color.fromARGB(255, 236, 222, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Color(0xFF7F00FF)),
                  title: Text("${entry.key}: ${entry.value} steps"),
                ),
              ))
          .toList(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage("assets/profile.jpg"), // add an image
          ),
          SizedBox(height: 20),
          Text(
            "John Doe",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Fitness Enthusiast",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// ---------------- Drawer-only Pages ----------------

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF7F00FF),
      ),
      body: const Center(child: Text("⚙️ Settings go here")),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: const Color(0xFF7F00FF),
      ),
      body: const Center(child: Text("📱 Step Counter Demo v2.0")),
    );
  }
}
