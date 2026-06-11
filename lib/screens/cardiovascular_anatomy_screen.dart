import 'package:flutter/material.dart';
import '../services/fake_ai_service.dart';

enum AnatomyTab {
  overview,
  chambers,
  valves,
  vessels,
  circulation,
  quiz,
}

class AnatomySection {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> bullets;
  final String imagePath;
  final String clinicalNote;

  const AnatomySection({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.bullets,
    required this.imagePath,
    required this.clinicalNote,
  });
}

class AnatomyQuizQuestion {
  final String question;
  final List<String> answers;
  final int correctIndex;

  const AnatomyQuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}

class SmartRecommendation {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const SmartRecommendation({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class CardiovascularAnatomyScreen extends StatefulWidget {
  const CardiovascularAnatomyScreen({super.key});

  @override
  State<CardiovascularAnatomyScreen> createState() =>
      _CardiovascularAnatomyScreenState();
}

class _CardiovascularAnatomyScreenState
    extends State<CardiovascularAnatomyScreen> {
  AnatomyTab selectedTab = AnatomyTab.overview;
  bool isFavorite = false;
  bool showClinicalCard = true;
  bool showImageLabels = true;

  int currentQuizIndex = 0;
  bool quizSubmitted = false;
  List<int?> selectedAnswers = List<int?>.filled(anatomyQuiz.length, null);

  bool isAiLoading = false;
  String aiResultTitle = "AI Study Assistant";
  String aiResult =
      "Choose one of the AI tools below to simplify the topic, generate a study summary, create practice questions, or show clinical insight.";
  Color aiAccentColor = const Color(0xFF8B5CF6);

  final List<AnatomySection> sections = const [
    AnatomySection(
      title: "Heart Overview",
      subtitle: "General structure and function",
      description:
          "The heart is a hollow muscular organ located in the mediastinum. It functions as a dual pump, driving pulmonary and systemic circulation through coordinated chamber contraction.",
      icon: Icons.favorite_rounded,
      color: Color(0xFFE35D6A),
      bullets: [
        "Located in the thoracic cavity",
        "Consists of four chambers",
        "Supports pulmonary and systemic circulation",
        "Connected to major vessels",
      ],
      imagePath: "assets/images/anatomy/heart_overview.jpg",
      clinicalNote:
          "Understanding global heart orientation is essential for interpreting cardiac imaging, auscultation sites, and anatomical relations in surgery.",
    ),
    AnatomySection(
      title: "Heart Chambers",
      subtitle: "Atria and ventricles",
      description:
          "The four chambers are arranged to receive and pump blood in a coordinated sequence. The right side manages pulmonary flow, while the left side drives systemic circulation.",
      icon: Icons.dashboard_customize_rounded,
      color: Color(0xFF4A90E2),
      bullets: [
        "Right atrium receives systemic venous blood",
        "Right ventricle sends blood to lungs",
        "Left atrium receives oxygenated blood",
        "Left ventricle pumps blood to the body",
      ],
      imagePath: "assets/images/anatomy/heart_chambers.jpg",
      clinicalNote:
          "Chamber enlargement, ventricular hypertrophy, and wall motion abnormalities are key concepts in echocardiography and cardiology.",
    ),
    AnatomySection(
      title: "Heart Valves",
      subtitle: "One-way flow regulators",
      description:
          "Heart valves maintain unidirectional blood flow and open or close in response to pressure differences between chambers and vessels.",
      icon: Icons.tune_rounded,
      color: Color(0xFF8B78E6),
      bullets: [
        "Tricuspid valve: RA → RV",
        "Pulmonary valve: RV → pulmonary trunk",
        "Mitral valve: LA → LV",
        "Aortic valve: LV → aorta",
      ],
      imagePath: "assets/images/anatomy/heart_valves.jpg",
      clinicalNote:
          "Valve disease such as stenosis or regurgitation significantly changes hemodynamics and is fundamental in clinical cardiology.",
    ),
    AnatomySection(
      title: "Major Vessels",
      subtitle: "Great vessels connected to the heart",
      description:
          "The heart is anatomically and functionally connected to the aorta, pulmonary trunk, superior vena cava, inferior vena cava, and pulmonary veins.",
      icon: Icons.hub_rounded,
      color: Color(0xFF26A69A),
      bullets: [
        "Aorta distributes oxygenated blood",
        "Pulmonary trunk carries blood to lungs",
        "Venae cavae return deoxygenated blood",
        "Pulmonary veins return oxygenated blood",
      ],
      imagePath: "assets/images/anatomy/major_vessels.jpg",
      clinicalNote:
          "Recognition of vessel origin and blood direction is essential in CT angiography, catheterization, and congenital heart disease interpretation.",
    ),
    AnatomySection(
      title: "Blood Circulation",
      subtitle: "Pulmonary and systemic pathways",
      description:
          "Blood circulates from the body to the right heart, to the lungs, back to the left heart, and then to the body through systemic arteries.",
      icon: Icons.sync_alt_rounded,
      color: Color(0xFFF4A641),
      bullets: [
        "Body → right atrium",
        "Right ventricle → lungs",
        "Lungs → left atrium",
        "Left ventricle → systemic circulation",
      ],
      imagePath: "assets/images/anatomy/circulation_pathway.jpg",
      clinicalNote:
          "Mastering circulation pathways is crucial for understanding oxygenation, pressure changes, shunts, and cardiovascular physiology.",
    ),
  ];

  AnatomySection get currentSection {
    switch (selectedTab) {
      case AnatomyTab.overview:
        return sections[0];
      case AnatomyTab.chambers:
        return sections[1];
      case AnatomyTab.valves:
        return sections[2];
      case AnatomyTab.vessels:
        return sections[3];
      case AnatomyTab.circulation:
        return sections[4];
      case AnatomyTab.quiz:
        return sections[0];
    }
  }

  SmartRecommendation get currentRecommendation {
    if (quizSubmitted) {
      final score = _quizScore();
      if (score <= 1) {
        return const SmartRecommendation(
          title: "Recommended Review: Heart Chambers",
          subtitle:
              "Your score suggests revisiting the basic heart structure first.",
          icon: Icons.refresh_rounded,
          color: Color(0xFFE35D6A),
        );
      }
      return const SmartRecommendation(
        title: "Recommended Next: Clinical Review",
        subtitle:
            "Good progress. Continue by connecting anatomy with clinical meaning.",
        icon: Icons.auto_awesome_rounded,
        color: Color(0xFF14B8A6),
      );
    }

    switch (selectedTab) {
      case AnatomyTab.overview:
        return const SmartRecommendation(
          title: "Recommended Next: Heart Chambers",
          subtitle: "Start with chambers to understand blood flow direction.",
          icon: Icons.recommend_rounded,
          color: Color(0xFF4A90E2),
        );
      case AnatomyTab.chambers:
        return const SmartRecommendation(
          title: "Recommended Next: Heart Valves",
          subtitle: "Valves are easier to understand after chamber anatomy.",
          icon: Icons.recommend_rounded,
          color: Color(0xFF8B78E6),
        );
      case AnatomyTab.valves:
        return const SmartRecommendation(
          title: "Recommended Next: Blood Circulation",
          subtitle: "Now connect valve function to blood flow sequence.",
          icon: Icons.sync_alt_rounded,
          color: Color(0xFFF4A641),
        );
      case AnatomyTab.vessels:
        return const SmartRecommendation(
          title: "Recommended Next: Blood Circulation",
          subtitle: "Relate great vessels to the complete circulation pathway.",
          icon: Icons.alt_route_rounded,
          color: Color(0xFF26A69A),
        );
      case AnatomyTab.circulation:
        return const SmartRecommendation(
          title: "Recommended Next: Quiz Assessment",
          subtitle: "Test your understanding of cardiovascular anatomy.",
          icon: Icons.quiz_rounded,
          color: Color(0xFF8B5CF6),
        );
      case AnatomyTab.quiz:
        return const SmartRecommendation(
          title: "Recommended Next: Review Weak Areas",
          subtitle: "Use the quiz result to strengthen weak topics.",
          icon: Icons.analytics_rounded,
          color: Color(0xFF14B8A6),
        );
    }
  }

  void _goToRecommendedSection() {
    setState(() {
      switch (selectedTab) {
        case AnatomyTab.overview:
          selectedTab = AnatomyTab.chambers;
          break;
        case AnatomyTab.chambers:
          selectedTab = AnatomyTab.valves;
          break;
        case AnatomyTab.valves:
          selectedTab = AnatomyTab.circulation;
          break;
        case AnatomyTab.vessels:
          selectedTab = AnatomyTab.circulation;
          break;
        case AnatomyTab.circulation:
          selectedTab = AnatomyTab.quiz;
          break;
        case AnatomyTab.quiz:
          selectedTab = AnatomyTab.chambers;
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Moved to recommended section: ${selectedTab.name}"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleAIAction(String action, AnatomySection section) async {
    setState(() {
      isAiLoading = true;
      aiResultTitle = "Analyzing ${section.title}...";
    });

    try {
      String result = "";
      String title = "";
      Color accent = section.color;

      if (action == "simplify") {
        title = "Simplified Explanation";
        accent = const Color(0xFF8B5CF6);
        result = await FakeAIService.simplifyTopic(
          topic: section.title,
          content: section.description,
        );
      } else if (action == "summary") {
        title = "Smart Summary";
        accent = const Color(0xFF26A69A);
        result = await FakeAIService.generateSummary(
          topic: section.title,
          content: section.description,
          bullets: section.bullets,
        );
      } else if (action == "questions") {
        title = "Practice Questions";
        accent = const Color(0xFFF4A641);
        result = await FakeAIService.generateQuestions(
          topic: section.title,
        );
      } else if (action == "clinical") {
        title = "Clinical Insight";
        accent = const Color(0xFFE35D6A);
        result = await FakeAIService.generateClinicalInsight(
          topic: section.title,
          clinicalNote: section.clinicalNote,
        );
      }

      if (!mounted) return;

      setState(() {
        isAiLoading = false;
        aiResultTitle = title;
        aiResult = result;
        aiAccentColor = accent;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isAiLoading = false;
        aiResultTitle = "AI Request Failed";
        aiResult = "$e";
        aiAccentColor = Colors.redAccent;
      });
    }
  }

  void _openImageViewer(String imagePath, String title, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: isDark ? const Color(0xFF0B1220) : Colors.white,
        insetPadding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF102033),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF111827)
                      : const Color(0xFFF8FBFF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: 280,
                          child: Center(
                            child: Text(
                              "Image not found:\n$imagePath",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _quizScore() {
    int score = 0;
    for (int i = 0; i < anatomyQuiz.length; i++) {
      if (selectedAnswers[i] == anatomyQuiz[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  double _progressValue() {
    switch (selectedTab) {
      case AnatomyTab.overview:
        return 0.20;
      case AnatomyTab.chambers:
        return 0.40;
      case AnatomyTab.valves:
        return 0.60;
      case AnatomyTab.vessels:
        return 0.70;
      case AnatomyTab.circulation:
        return 0.85;
      case AnatomyTab.quiz:
        return quizSubmitted ? 1.0 : 0.90;
    }
  }

  String _progressLabel() {
    return "${(_progressValue() * 100).toInt()}% completed";
  }

  void _resetQuiz() {
    setState(() {
      currentQuizIndex = 0;
      quizSubmitted = false;
      selectedAnswers = List<int?>.filled(anatomyQuiz.length, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final section = currentSection;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF09111F) : const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF09111F) : const Color(0xFFF4F8FC),
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF14314B),
        ),
        title: Text(
          "Cardiovascular Anatomy",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF14314B),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => isFavorite = !isFavorite),
            icon: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isFavorite
                  ? const Color(0xFFF59E0B)
                  : (isDark ? Colors.white70 : const Color(0xFF14314B)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHero(isDark),
            const SizedBox(height: 18),
            _buildSectionTabs(isDark),
            const SizedBox(height: 18),
            _buildRecommendationPanel(isDark),
            const SizedBox(height: 18),
            if (selectedTab != AnatomyTab.quiz) ...[
              _buildMainStudyCard(isDark, section),
              const SizedBox(height: 18),
              _buildAiWorkspace(isDark, section),
              const SizedBox(height: 18),
              _buildClinicalPanel(isDark, section),
            ] else ...[
              _buildAiWorkspace(isDark, currentSection),
              const SizedBox(height: 18),
              _buildQuizPanel(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopHero(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF123B63),
            Color(0xFF1D5D91),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.monitor_heart_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Cardiac Anatomy Explorer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Explore the heart through structured anatomy, interactive visuals, clinical notes, quiz assessment, and integrated AI learning support.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.55,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _heroChip(Icons.layers_rounded, "5 Topics"),
              _heroChip(Icons.zoom_in_rounded, "High Detail"),
              _heroChip(Icons.quiz_rounded, "Assessment"),
              _heroChip(Icons.auto_graph_rounded, _progressLabel()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTabs(bool isDark) {
    final items = {
      AnatomyTab.overview: "Overview",
      AnatomyTab.chambers: "Chambers",
      AnatomyTab.valves: "Valves",
      AnatomyTab.vessels: "Vessels",
      AnatomyTab.circulation: "Circulation",
      AnatomyTab.quiz: "Quiz",
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.entries.map((entry) {
          final active = selectedTab == entry.key;
          return GestureDetector(
            onTap: () => setState(() => selectedTab = entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF14314B)
                    : (isDark ? const Color(0xFF111827) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active
                      ? const Color(0xFF14314B)
                      : (isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFDDE6EF)),
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: const Color(0xFF14314B).withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF334155)),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendationPanel(bool isDark) {
    final rec = currentRecommendation;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            rec.color.withOpacity(isDark ? 0.18 : 0.10),
            rec.color.withOpacity(isDark ? 0.10 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: rec.color.withOpacity(0.28),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: rec.color.withOpacity(0.14),
            ),
            child: Icon(rec.icon, color: rec.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rec.subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: rec.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _goToRecommendedSection,
            child: const Text("Open"),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStudyCard(bool isDark, AnatomySection section) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFDDE6EF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.12 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPremiumImageViewer(isDark, section),
          const SizedBox(height: 16),
          Text(
            section.title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            section.subtitle,
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            section.description,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              fontSize: 14.2,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: section.bullets
                .map(
                  (point) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: section.color.withOpacity(isDark ? 0.14 : 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      point,
                      style: TextStyle(
                        color: section.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAiWorkspace(bool isDark, AnatomySection section) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFDDE6EF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.12 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: aiAccentColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.psychology_alt_rounded,
                  color: aiAccentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "MediLearn AI Assistant",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Use AI tools to simplify the lesson, produce a concise study summary, create practice questions, or show clinical insight.",
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildClickableAIChip(
                isDark,
                label: "Simplify Topic",
                icon: Icons.auto_fix_high_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () => _handleAIAction("simplify", section),
              ),
              _buildClickableAIChip(
                isDark,
                label: "Generate Summary",
                icon: Icons.summarize_rounded,
                color: const Color(0xFF26A69A),
                onTap: () => _handleAIAction("summary", section),
              ),
              _buildClickableAIChip(
                isDark,
                label: "Practice Questions",
                icon: Icons.quiz_rounded,
                color: const Color(0xFFF4A641),
                onTap: () => _handleAIAction("questions", section),
              ),
              _buildClickableAIChip(
                isDark,
                label: "Clinical Insight",
                icon: Icons.local_hospital_rounded,
                color: const Color(0xFFE35D6A),
                onTap: () => _handleAIAction("clinical", section),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: aiAccentColor.withOpacity(0.24),
              ),
            ),
            child: isAiLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aiResultTitle,
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF102033),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(aiAccentColor),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Generating AI response...",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF475569),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aiResultTitle,
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF102033),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        aiResult,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF334155),
                          fontSize: 14.2,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableAIChip(
    bool isDark, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumImageViewer(bool isDark, AnatomySection section) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 260, maxHeight: 360),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2EAF2),
        ),
      ),
      child: GestureDetector(
        onTap: () => _openImageViewer(section.imagePath, section.title, isDark),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  section.imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        "Image not found:\n${section.imagePath}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.zoom_in_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            if (showImageLabels)
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: section.color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: section.color.withOpacity(0.30),
                    ),
                  ),
                  child: Text(
                    section.title,
                    style: TextStyle(
                      color: section.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicalPanel(bool isDark, AnatomySection section) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF2A1515), Color(0xFF1A1010)],
              )
            : const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFFFBF5)],
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(0.28),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => showClinicalCard = !showClinicalCard),
            child: Row(
              children: [
                const Icon(
                  Icons.health_and_safety_rounded,
                  color: Color(0xFFF59E0B),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Clinical Relevance",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF102033),
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                ),
                Icon(
                  showClinicalCard
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
          ),
          if (showClinicalCard) ...[
            const SizedBox(height: 14),
            Text(
              section.clinicalNote,
              style: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF7C2D12),
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuizPanel(bool isDark) {
    final q = anatomyQuiz[currentQuizIndex];
    final selected = selectedAnswers[currentQuizIndex];
    final score = _quizScore();

    return Column(
      children: [
        _baseCard(
          isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardTitle(
                isDark,
                "Anatomy Assessment",
                Icons.quiz_rounded,
                const Color(0xFF8B5CF6),
              ),
              const SizedBox(height: 16),
              Text(
                "Question ${currentQuizIndex + 1} of ${anatomyQuiz.length}",
                style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (currentQuizIndex + 1) / anatomyQuiz.length,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF8B5CF6),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                q.question,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF102033),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(q.answers.length, (index) {
                final isSelected = selected == index;
                final showCorrectState = quizSubmitted;
                final isCorrect = q.correctIndex == index;
                final isWrongSelected =
                    showCorrectState && isSelected && !isCorrect;

                Color borderColor;
                Color fillColor;

                if (showCorrectState && isCorrect) {
                  borderColor = Colors.green;
                  fillColor = Colors.green.withOpacity(0.10);
                } else if (isWrongSelected) {
                  borderColor = Colors.red;
                  fillColor = Colors.red.withOpacity(0.10);
                } else if (isSelected) {
                  borderColor = const Color(0xFF8B5CF6);
                  fillColor = const Color(0xFF8B5CF6).withOpacity(0.10);
                } else {
                  borderColor = isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE2E8F0);
                  fillColor =
                      isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: quizSubmitted
                        ? null
                        : () {
                            setState(() {
                              selectedAnswers[currentQuizIndex] = index;
                            });
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              q.answers[index],
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF102033),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (showCorrectState && isCorrect)
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.green),
                          if (isWrongSelected)
                            const Icon(Icons.cancel_rounded, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: currentQuizIndex > 0
                          ? () => setState(() => currentQuizIndex--)
                          : null,
                      child: const Text("Previous"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: currentQuizIndex < anatomyQuiz.length - 1
                          ? () => setState(() => currentQuizIndex++)
                          : null,
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetQuiz,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Reset"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14314B),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => setState(() => quizSubmitted = true),
                      icon: const Icon(Icons.task_alt_rounded),
                      label: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (quizSubmitted) ...[
          const SizedBox(height: 14),
          _baseCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardTitle(
                  isDark,
                  "Result Summary",
                  Icons.emoji_events_rounded,
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 14),
                Text(
                  "Your score: $score / ${anatomyQuiz.length}",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  score == anatomyQuiz.length
                      ? "Excellent. You mastered the core anatomy concepts."
                      : score >= 2
                          ? "Good work. Review some details to strengthen retention."
                          : "Keep studying the anatomical structures and their relations.",
                  style: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _baseCard(bool isDark, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFDDE6EF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.12 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _cardTitle(bool isDark, String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontSize: 14.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

const List<AnatomyQuizQuestion> anatomyQuiz = [
  AnatomyQuizQuestion(
    question:
        "Which chamber pumps oxygenated blood into the systemic circulation?",
    answers: [
      "Right atrium",
      "Right ventricle",
      "Left atrium",
      "Left ventricle",
    ],
    correctIndex: 3,
  ),
  AnatomyQuizQuestion(
    question: "Which valve lies between the left atrium and left ventricle?",
    answers: [
      "Tricuspid valve",
      "Pulmonary valve",
      "Mitral valve",
      "Aortic valve",
    ],
    correctIndex: 2,
  ),
  AnatomyQuizQuestion(
    question: "Which vessel returns oxygenated blood to the heart?",
    answers: [
      "Pulmonary artery",
      "Pulmonary vein",
      "Superior vena cava",
      "Inferior vena cava",
    ],
    correctIndex: 1,
  ),
  AnatomyQuizQuestion(
    question: "The right ventricle pumps blood toward the:",
    answers: [
      "Aorta",
      "Left atrium",
      "Pulmonary trunk",
      "Coronary sinus",
    ],
    correctIndex: 2,
  ),
];