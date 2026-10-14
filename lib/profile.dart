import 'package:flutter/material.dart';

// Colors used across the app (same teal scheme as the login page)
const Color kPrimary = Color(0xFF00A8A8);
const Color kPrimaryLight = Color(0xFFE6F6F6); // very light teal tint
const Color kTextDark = Color(0xFF2C3E50);
const Color kTextSoft = Colors.black54;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Gives the user feedback when a button is pressed (HCI: visibility of status)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Same width logic as the login page: about 40% on wide screens
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth =
    screenWidth < 700 ? screenWidth : (screenWidth * 0.4).clamp(460.0, 800.0);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 20.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        // ==============================
                        // 1. HEADER + PROFILE PICTURE
                        // ==============================
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            // Gradient cover
                            Container(
                              height: 150.0,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00A8A8),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/cover.png"),
                                  fit: BoxFit.cover,
                                  // Keeps the phones in view when cropped
                                  alignment: Alignment(0.0, -0.2),
                                  // Light teal tint to match the app colors
                                  colorFilter: ColorFilter.mode(
                                    Color(0x5500A8A8),
                                    BlendMode.srcATop,
                                  ),
                                ),
                              ),
                            ),
                            // Back button (HCI: user control and freedom)
                            Positioned(
                              top: 6.0,
                              left: 6.0,
                              // Round translucent button so the arrow is
                              // always visible on top of the photo
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.35),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  tooltip: 'Back to login',
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                            // Round profile picture overlapping the cover
                            Positioned(
                              top: 85.0,
                              child: Semantics(
                                label: 'Profile photo of Muhammad Habib',
                                child: Container(
                                  width: 130.0,
                                  height: 130.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 5.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10.0,
                                        offset: const Offset(0.0, 4.0),
                                      ),
                                    ],
                                    image: const DecorationImage(
                                      image:
                                      AssetImage("assets/images/habib3.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Space for the part of the picture below the cover
                        const SizedBox(height: 75.0),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 8.0),
                          child: Column(
                            children: <Widget>[
                              // ==============================
                              // 2. NAME + TITLE + LOCATION
                              // ==============================
                              const Text(
                                'Muhammad Habib',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  color: kTextDark,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              const Text(
                                'Software Engineering Student | Flutter Developer',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: kPrimary,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.location_on_outlined,
                                      size: 18.0, color: kTextSoft),
                                  SizedBox(width: 4.0),
                                  Flexible(
                                    child: Text(
                                      'Riphah International University, Islamabad',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: kTextSoft,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),

                              // ==============================
                              // 3. ACTION BUTTONS
                              // ==============================
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      height: 48.0,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimary,
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () => _showMessage(
                                            context, 'Edit Profile coming soon'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: SizedBox(
                                      height: 48.0,
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: kPrimary,
                                          side: const BorderSide(
                                              color: kPrimary, width: 1.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        icon: const Icon(Icons.share_outlined),
                                        label: const Text(
                                          'Share',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () => _showMessage(
                                            context, 'Profile link copied'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24.0),

                              // ==============================
                              // 4. QUICK STATS
                              // ==============================
                              Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                  color: kPrimaryLight,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: const Row(
                                  children: <Widget>[
                                    StatItem(value: '8', label: 'Projects'),
                                    StatDivider(),
                                    StatItem(value: '4', label: 'Certificates'),
                                    StatDivider(),
                                    StatItem(value: '500+', label: 'Connections'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28.0),

                              // ==============================
                              // 5. ABOUT
                              // ==============================
                              const SectionTitle(title: 'About'),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Passionate Software Engineering student and '
                                      'Flutter developer who loves turning ideas into '
                                      'clean, fast and user-friendly mobile apps. '
                                      'I focus on good UI/UX, responsive layouts and '
                                      'writing maintainable code. Always learning, '
                                      'always building, and open to internships and '
                                      'collaboration opportunities.',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.5,
                                    color: kTextSoft,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28.0),

                              // ==============================
                              // 6. EXPERIENCE
                              // ==============================
                              const SectionTitle(title: 'Experience'),
                              const InfoTile(
                                icon: Icons.work_outline,
                                title: 'Flutter Developer Intern',
                                subtitle: 'TechNova Solutions, Islamabad',
                                detail: 'Jun 2025 - Aug 2025',
                              ),
                              const InfoTile(
                                icon: Icons.groups_outlined,
                                title: 'Mobile App Team Member',
                                subtitle: 'University Software Society',
                                detail: '2024 - Present',
                              ),
                              const SizedBox(height: 20.0),

                              // ==============================
                              // 7. EDUCATION
                              // ==============================
                              const SectionTitle(title: 'Education'),
                              const InfoTile(
                                icon: Icons.school_outlined,
                                title: 'BS Software Engineering',
                                subtitle:
                                'Riphah International University, Islamabad',
                                detail: '2023 - 2027',
                              ),
                              const InfoTile(
                                icon: Icons.menu_book_outlined,
                                title: 'Intermediate (Pre-Engineering)',
                                subtitle: 'Islamabad College',
                                detail: '2021 - 2023',
                              ),
                              const SizedBox(height: 20.0),

                              // ==============================
                              // 8. SKILLS
                              // ==============================
                              const SectionTitle(title: 'Skills'),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: <Widget>[
                                    SkillChip(label: 'Flutter'),
                                    SkillChip(label: 'Dart'),
                                    SkillChip(label: 'Firebase'),
                                    SkillChip(label: 'REST APIs'),
                                    SkillChip(label: 'Git & GitHub'),
                                    SkillChip(label: 'Material Design'),
                                    SkillChip(label: 'Responsive UI'),
                                    SkillChip(label: 'UI/UX Basics'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28.0),

                              // ==============================
                              // 9. PROJECTS
                              // ==============================
                              const SectionTitle(title: 'Projects'),
                              const InfoTile(
                                icon: Icons.checklist_outlined,
                                title: 'Task Manager App',
                                subtitle:
                                'Create, edit and track daily tasks with '
                                    'reminders and local storage',
                                detail: 'Flutter  |  Dart',
                              ),
                              const InfoTile(
                                icon: Icons.cloud_outlined,
                                title: 'Weather Forecast App',
                                subtitle:
                                'Live weather by city using a public REST '
                                    'API with a clean card layout',
                                detail: 'Flutter  |  REST API',
                              ),
                              const InfoTile(
                                icon: Icons.shopping_bag_outlined,
                                title: 'E-Commerce UI',
                                subtitle:
                                'Product list, details and cart screens '
                                    'with smooth navigation',
                                detail: 'Flutter  |  Firebase',
                              ),
                              const SizedBox(height: 20.0),

                              // ==============================
                              // 10. CONTACT (dummy details)
                              // ==============================
                              const SectionTitle(title: 'Contact'),
                              const InfoTile(
                                icon: Icons.email_outlined,
                                title: 'Email',
                                subtitle: 'habib.dev@example.com',
                              ),
                              const InfoTile(
                                icon: Icons.phone_outlined,
                                title: 'Phone',
                                subtitle: '+92 300 1234567',
                              ),
                              const InfoTile(
                                icon: Icons.link,
                                title: 'LinkedIn',
                                subtitle: 'linkedin.com/in/muhammad-habib',
                              ),
                              const InfoTile(
                                icon: Icons.code,
                                title: 'GitHub',
                                subtitle: 'github.com/muhammad-habib',
                              ),
                              const SizedBox(height: 24.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// REUSABLE WIDGET CLASSES (consistency)
// ==========================================

// Section heading with a teal accent bar
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 4.0,
            height: 22.0,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }
}

// One number + label in the stats row
class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: kPrimary,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: const TextStyle(fontSize: 13.0, color: kTextSoft),
          ),
        ],
      ),
    );
  }
}

// Thin vertical line between stats
class StatDivider extends StatelessWidget {
  const StatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.0,
      height: 36.0,
      color: Colors.grey.shade300,
    );
  }
}

// Rounded skill tag
class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: kPrimaryLight,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: kPrimary.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kPrimary,
        ),
      ),
    );
  }
}

// Card row with an icon, title, description and optional small detail
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? detail;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: kPrimary),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14.0, color: kTextSoft),
                ),
                if (detail != null) ...<Widget>[
                  const SizedBox(height: 4.0),
                  Text(
                    detail!,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: kPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}