import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'cardiovascular_screen.dart';

class MedicalKnowledgeScreen extends StatelessWidget {
  const MedicalKnowledgeScreen({super.key});

  /// ===============================
  /// Systems Data
  /// ===============================
  List<Map<String, dynamic>> get systems => [
        {
          "title": "Cardiovascular System",
          "subtitle": "Heart & vascular circulation",
          "image": "assets/images/cardiovascular.png",
          "gradient": [const Color(0xFFE53935), const Color(0xFFB71C1C)],
          "route":  CardiovascularScreen(),
        },
        {
          "title": "Respiratory System",
          "subtitle": "Pulmonary structures",
          "image": "assets/images/respiratory.png",
          "gradient": [const Color(0xFF0288D1), const Color(0xFF01579B)],
        },
        {
          "title": "Nervous System",
          "subtitle": "Brain & neural pathways",
          "image": "assets/images/nervous.png",
          "gradient": [const Color(0xFF6A1B9A), const Color(0xFF4A148C)],
        },
        {
          "title": "Digestive System",
          "subtitle": "GI tract & metabolism",
          "image": "assets/images/digestive.png",
          "gradient": [const Color(0xFFFF8F00), const Color(0xFFE65100)],
        },
        {
          "title": "Endocrine System",
          "subtitle": "Hormonal regulation",
          "image": "assets/images/endocrine.png",
          "gradient": [const Color(0xFF00897B), const Color(0xFF004D40)],
        },
        {
          "title": "Immune System",
          "subtitle": "Defense mechanisms",
          "image": "assets/images/immune.png",
          "gradient": [const Color(0xFF546E7A), const Color(0xFF263238)],
        },
      ];

  bool isMobile(double width) => width < 700;
  bool isTablet(double width) => width >= 700 && width < 1100;
  bool isDesktop(double width) => width >= 1100;

  int getColumns(double width) {
    if (width >= 1300) return 3;
    if (width >= 750) return 2;
    return 1;
  }

  double horizontalPadding(double width) {
    if (width >= 1400) return 110;
    if (width >= 1100) return 70;
    if (width >= 750) return 28;
    return 16;
  }

  double titleSize(double width) {
    if (isDesktop(width)) return 30;
    if (isTablet(width)) return 26;
    return 22;
  }

  double subtitleSize(double width) {
    if (isDesktop(width)) return 15;
    if (isTablet(width)) return 14;
    return 13;
  }

  double cardAspectRatio(double width) {
    if (width >= 1300) return 1.55;
    if (width >= 900) return 1.45;
    if (width >= 700) return 1.28;
    return 1.55;
  }

  Widget buildCard(
    BuildContext context,
    Map<String, dynamic> item,
    double width,
  ) {
    final bool mobile = isMobile(width);

    return _MedicalCardAnimation(
      onTap: item["route"] != null
          ? () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                  child: item["route"],
                ),
              );
            }
          : () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(mobile ? 22 : 28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: mobile ? 12 : 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(mobile ? 22 : 28),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  item["image"],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.12),
                        item["gradient"][1].withOpacity(0.90),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(mobile ? 18 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: mobile ? 18 : 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item["subtitle"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: mobile ? 12.5 : 13,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: const [
                        Text(
                          "Explore",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = getColumns(width);
        final mobile = isMobile(width);

        return Scaffold(
          backgroundColor: const Color(0xFFF4F7FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0B2E4F),
            automaticallyImplyLeading: true,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Medical Knowledge",
                  style: TextStyle(
                    fontSize: mobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0B2E4F),
                  ),
                ),
                Text(
                  "Clinical body systems",
                  style: TextStyle(
                    fontSize: mobile ? 11.5 : 12.5,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding(width),
                vertical: mobile ? 18 : 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(mobile ? 18 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(mobile ? 20 : 26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Clinical Body Systems",
                          style: TextStyle(
                            fontSize: titleSize(width),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0B2E4F),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Medical learning platform for human body systems. Choose a system to start exploring the content in a structured and visually clear way.",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: subtitleSize(width),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mobile ? 18 : 28),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: systems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: mobile ? 14 : 22,
                      mainAxisSpacing: mobile ? 14 : 22,
                      childAspectRatio: cardAspectRatio(width),
                    ),
                    itemBuilder: (context, index) {
                      return buildCard(context, systems[index], width);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MedicalCardAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _MedicalCardAnimation({
    required this.child,
    required this.onTap,
  });

  @override
  State<_MedicalCardAnimation> createState() => _MedicalCardAnimationState();
}

class _MedicalCardAnimationState extends State<_MedicalCardAnimation> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.97),
      onTapUp: (_) {
        setState(() => scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => scale = 1.0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: scale,
        child: widget.child,
      ),
    );
  }
}