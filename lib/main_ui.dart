import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'test_description_page.dart';
import 'login_page.dart';

// ==========================================================
// ------------------- PLACEHOLDER PAGES -------------------
// ==========================================================

enum UserRole { athlete, institute, admin }

class LiveEventPage extends StatelessWidget {
  const LiveEventPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Live Events Registration", style: TextStyle(fontSize: 18)));
  }
}

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Your Certificates", style: TextStyle(fontSize: 18)));
  }
}

// ==========================================================
// ------------------- TestResultPage (New) -------------------
// ==========================================================

class TestResultPage extends StatelessWidget {
  final String testName;
  final String score;
  final String date;
  final String rank;

  const TestResultPage({
    super.key,
    required this.testName,
    required this.score,
    required this.date,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$testName Results"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Summary Card ---
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Test: $testName", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    const Divider(height: 20),
                    _buildResultDetail(context, Icons.score, "Score", score, Colors.orange),
                    _buildResultDetail(context, Icons.calendar_today, "Date", date, Colors.indigo),
                    _buildResultDetail(context, Icons.leaderboard, "Ranking", rank, Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- Analysis Section ---
            const Text(
              "Performance Analysis",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            _buildAnalysisCard(
              title: "Technique Feedback",
              content: "Your form was excellent, but aim for consistency across all reps.",
              icon: Icons.lightbulb_outline,
              color: Colors.blue,
            ),
            _buildAnalysisCard(
              title: "Comparison",
              content: "You are currently ranked in the top 10% of users for this test!",
              icon: Icons.trending_up,
              color: Colors.red,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildResultDetail(BuildContext context, IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard({required String title, required String content, required IconData icon, required Color color}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle: Text(content, style: const TextStyle(color: Colors.grey)),
        isThreeLine: true,
      ),
    );
  }
}


// ==========================================================
// ------------------- MainPage (Unified) -------------------
// ==========================================================
class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String _userName = 'Athlete';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    pages = [
      _HomePage(cameras: widget.cameras, onNavigate: (index) => setState(() => _currentIndex = index)),
      _TestsPage(cameras: widget.cameras),
      const _DashboardPage(), 
      const _ProfilePage(), 
    ];
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists && mounted) {
      final data = doc.data();
      setState(() {
        _userName = data?['name'] ?? user.email?.split('@').first ?? 'Athlete';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildDynamicAppBar(),
      endDrawer: _buildSidebar(),
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildDynamicAppBar() {
    String titleText = '';
    List<Widget> actions = [
      IconButton(
        icon: const Icon(Icons.menu, color: Colors.indigo, size: 30),
        onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
    ];

    switch (_currentIndex) {
      case 0:
        return AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $_userName",
                style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                "Your excellence journey starts here.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: actions,
        );
      case 1:
        titleText = "Assessment Tests";
        break;
      case 2:
        titleText = "Performance Dashboard";
        break;
      case 3:
        titleText = "Profile";
        break;
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: false,
      title: Text(
        titleText,
        style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: actions,
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Colors.indigo)),
                const SizedBox(height: 10),
                Text(_userName, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildSidebarItem(context, Icons.person, 'Profile', () { Navigator.pop(context); setState(() => _currentIndex = 3); }),
          _buildSidebarItem(context, Icons.emoji_events, 'Achievements', () => _navigateToPage(const CertificatesPage())),
          _buildSidebarItem(context, Icons.assessment, 'Results', () => setState(() { Navigator.pop(context); _currentIndex = 2; })),
          _buildSidebarItem(context, Icons.support_agent, 'Expert Support', () => _navigateToPage(const LiveEventPage())),
          _buildSidebarItem(context, Icons.help, 'Help', () { Navigator.pop(context); }),
          _buildSidebarItem(context, Icons.logout, 'Logout', () async { 
             await FirebaseAuth.instance.signOut(); 
             if (mounted) Navigator.pushReplacementNamed(context, '/login');
           }),
        ],
      ),
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildSidebarItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.sports), label: "Tests"),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

// ==========================================================
// ------------------- _HomePage ------------------
// ==========================================================
class _HomePage extends StatelessWidget {
  final List<CameraDescription> cameras;
  final Function(int) onNavigate;
  const _HomePage({super.key, required this.cameras, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sliders
          CarouselSlider(
            items: [
              _buildCarouselImage("assets/running.jpg", "Join our live events and master your agility."),
              _buildCarouselImage("assets/jump.jpeg", "Boost your explosive power with our guided exercises."),
            ],
            options: CarouselOptions(height: 200, autoPlay: true, enlargeCenterPage: true, viewportFraction: 0.9),
          ),
          const SizedBox(height: 30),

          // Shortcuts for Tests and Dashboard
          _buildSectionTitle("Quick Shortcuts"),
          const SizedBox(height: 10),
          _buildShortcutRow(context),
          const SizedBox(height: 30),

          // Certificates Row
          _buildSectionTitle("Your Certificates"),
          const SizedBox(height: 10),
          _buildCertificatesRow(context),
          const SizedBox(height: 30),

          // Live Event Updates
          _buildSectionTitle("Live Event Updates"),
          const SizedBox(height: 10),
          _buildLiveEventsList(),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCarouselImage(String asset, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // Placeholder for assets, assumes you have these files
        image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(16),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo));
  }

  Widget _buildShortcutRow(BuildContext context) {
    return Column(
      children: [
        _buildShortcutCard(context,
          icon: Icons.sports_gymnastics,
          title: "Tests",
          subtitle: "Check your test list and start a new assessment.",
          onTap: () => onNavigate(1)
        ),
        const SizedBox(height: 12),
        _buildShortcutCard(context,
          icon: Icons.bar_chart,
          title: "Dashboard",
          subtitle: "Monitor your progress and review past performance.",
          onTap: () => onNavigate(2)
        ),
      ],
    );
  }

  Widget _buildShortcutCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.orange),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.indigo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificatesRow(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Placeholder for 3 certificates
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: const Center(
                child: Text(
                  "Certificate Placeholder",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveEventsList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildEventTile(
          icon: Icons.emoji_events,
          title: "National Vertical Jump Championship",
          subtitle: "Pune, Maharashtra | Sep 30, 2025",
          onTap: () {},
        ),
        _buildEventTile(
          icon: Icons.run_circle,
          title: "State Level 100m Dash",
          subtitle: "Mumbai, Maharashtra | Oct 15, 2025",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildEventTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo),
        onTap: onTap,
      ),
    );
  }
}

// ==========================================================
// ------------------- _TestsPage ------------------
// ==========================================================
class _TestsPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const _TestsPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    final tests = [
      {"name": "Vertical Jump", "icon": Icons.arrow_upward, "desc": "Test your explosive power.", "asset": "assets/animation/jump.mp4"},
      {"name": "Squats", "icon": Icons.accessibility_new, "desc": "Assess your stability and endurance.", "asset": "assets/animation/squats.mp4"},
      {"name": "Sit-Ups", "icon": Icons.timer, "desc": "Check your core strength.", "asset": "assets/animation/situps.mp4"},
      {"name": "Shuttle Run", "icon": Icons.directions_run, "desc": "Assess your agility and speed.", "asset": "assets/animation/shuttle.mp4"},
      {"name": "Endurance Run", "icon": Icons.run_circle, "desc": "Evaluate your cardiovascular fitness.", "asset": "assets/animation/run.mp4"},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(test["icon"] as IconData, size: 30, color: Colors.orange),
                  title: Text(test["name"] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(test["desc"] as String, style: const TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestDescriptionPage(
                          testName: test["name"] as String,
                          cameras: cameras,
                          animationAsset: test["asset"] as String,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ==========================================================
// ------------------- _DashboardPage (UPDATED) ------------------
// ==========================================================
class _DashboardPage extends StatelessWidget {
  const _DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Progress",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 20),

              // --- Performance Trend Bar Chart (No external package) ---
              Container(
                height: 250, 
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Performance Trend (Last 30 Days)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBar('Jump', 0.8, Colors.orange),
                          _buildBar('Squats', 0.6, Colors.blue),
                          _buildBar('Sit-Ups', 0.9, Colors.green),
                          _buildBar('Run', 0.4, Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- High Scores Section ---
              const Text(
                "High Scores",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 10),
              _buildHighScoresList(context), 
              const SizedBox(height: 30),

              // --- Recent Activities Section ---
              const Text(
                "Recent Activities",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 10),
              _buildRecentActivitiesList(context), 
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the bar chart visualization
  Widget _buildBar(String label, double heightRatio, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 30,
              height: 180 * heightRatio,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildHighScoresList(BuildContext context) {
    return Column(
      children: [
        _buildTestScoreTile(
          context: context,
          title: 'Vertical Jump', 
          score: '95 cm', 
          rank: 'National Rank: 12',
          date: '15/09/2025'
        ),
        _buildTestScoreTile(
          context: context,
          title: 'Squats', 
          score: '25 reps', 
          rank: 'State Rank: 3',
          date: '01/09/2025'
        ),
        _buildTestScoreTile(
          context: context,
          title: 'Sit-Ups', 
          score: '50 reps', 
          rank: 'District Rank: 1',
          date: '10/08/2025'
        ),
      ],
    );
  }

  Widget _buildTestScoreTile({required BuildContext context, required String title, required String score, required String rank, required String date}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.leaderboard, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle: Text(rank, style: const TextStyle(color: Colors.grey)),
        trailing: Text(score, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
        onTap: () {
          // Navigate to the hardcoded TestResultPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TestResultPage(
                testName: title,
                score: score,
                date: date,
                rank: rank,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentActivitiesList(BuildContext context) {
    return Column(
      children: [
        _buildActivityTile(
          context: context,
          title: "Squats", 
          subtitle: "Completed Today, 10:00 AM",
          onTap: () {
            // Hardcoded result for the recent activity
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TestResultPage(
                  testName: "Squats",
                  score: "5 reps",
                  date: "Today, 08:00 AM",
                  rank: "N/A (Training)",
                ),
              ),
            );
          },
        ),
        _buildActivityTile(
          context: context,
          title: "Vertical Jump", 
          subtitle: "Completed Today, 10:00 AM",
          onTap: () {
            // Hardcoded result for the recent activity
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TestResultPage(
                  testName: "Vertical Jump",
                  score: "92 cm",
                  date: "Today, 10:00 AM",
                  rank: "N/A (Training)",
                ),
              ),
            );
          },
        ),
        _buildActivityTile(
          context: context,
          title: "Sit-Ups Test", 
          subtitle: "Completed Yesterday, 5:00 PM",
          onTap: () {
            // Hardcoded result for the recent activity
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TestResultPage(
                  testName: "Sit-Ups Test",
                  score: "48 reps",
                  date: "Yesterday, 5:00 PM",
                  rank: "N/A (Training)",
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityTile({required BuildContext context, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.run_circle, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.indigo, size: 16),
        onTap: onTap,
      ),
    );
  }
}


// ==========================================================
// ------------------- _ProfilePage (UPDATED) ------------------
// ==========================================================
class _ProfilePage extends StatefulWidget {
  const _ProfilePage({super.key});

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController(); 
  final TextEditingController _weightController = TextEditingController();
  
  String _email = "";
  double _profileCompletion = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateCompletion() {
      // Name, Height, Weight are the tracked fields
      int fieldsTotal = 3;
      int fieldsCompleted = 0;

      if (_nameController.text.isNotEmpty && _nameController.text != "Athlete") fieldsCompleted++;
      if (_heightController.text.isNotEmpty && _heightController.text != "N/A") fieldsCompleted++;
      if (_weightController.text.isNotEmpty && _weightController.text != "N/A") fieldsCompleted++;

      setState(() {
          _profileCompletion = fieldsCompleted / fieldsTotal;
      });
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    
    if (doc.exists && mounted) {
      final data = doc.data();
      
      _nameController.text = data?['name'] ?? "Athlete";
      // Fetch Height and Weight
      _heightController.text = data?['height'] ?? "N/A";
      _weightController.text = data?['weight'] ?? "N/A";

      setState(() {
        _email = data?['email'] ?? user.email ?? "";
      });

      _calculateCompletion();
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    // Clean up 'N/A' placeholder before saving to keep Firestore clean
    String height = _heightController.text == 'N/A' ? '' : _heightController.text;
    String weight = _weightController.text == 'N/A' ? '' : _weightController.text;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': _nameController.text,
      'height': height, // Saving updated height
      'weight': weight, // Saving updated weight
    });
    
    // Reload to refresh the state, especially the completion metric
    _loadUserProfile(); 
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated successfully!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 30),
              
              // --- Profile Picture Section ---
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload profile picture!")));
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      style: IconButton.styleFrom(backgroundColor: Colors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // --- Profile Completion Metric (MOVED HERE) ---
              const Text(
                "Profile Completion",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: _profileCompletion, 
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              const SizedBox(height: 5),
              Text("${(_profileCompletion * 100).toInt()}% Complete", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 30), 
              
              // --- Editable Name ---
              _buildEditableProfileTile(
                icon: Icons.person,
                label: "Name",
                controller: _nameController,
                onSave: _updateProfile,
                keyboardType: TextInputType.text,
              ),
              
              // --- Editable Height ---
              _buildEditableProfileTile(
                icon: Icons.height, 
                label: "Height (cm)", 
                controller: _heightController, 
                onSave: _updateProfile,
                keyboardType: TextInputType.number,
              ),

              // --- Editable Weight ---
              _buildEditableProfileTile(
                icon: Icons.monitor_weight, 
                label: "Weight (kg)", 
                controller: _weightController, 
                onSave: _updateProfile,
                keyboardType: TextInputType.number,
              ),

              // --- Non-Editable Email ---
              _buildProfileInfoTile(icon: Icons.email, title: "Email", value: _email),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoTile({required IconData icon, required String title, required String value}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildEditableProfileTile({required IconData icon, required String label, required TextEditingController controller, required VoidCallback onSave, required TextInputType keyboardType}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle: TextField(
          controller: controller,
          keyboardType: keyboardType, 
          decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.save, color: Colors.indigo),
          onPressed: onSave,
        ),
      ),
    );
  }
}