import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

void main() {
  runApp(const MedicalApp());
}

class MedicalApp extends StatefulWidget {
  const MedicalApp({super.key});

  @override
  State<MedicalApp> createState() => _MedicalAppState();
}

class _MedicalAppState extends State<MedicalApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TissueStructureScreen(
        isDarkMode: isDarkMode,
        onThemeToggle: () {
          setState(() => isDarkMode = !isDarkMode);
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFFF3F8FB),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0F766E),
        secondary: Color(0xFF0284C7),
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFF08111F),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF14B8A6),
        secondary: Color(0xFF38BDF8),
        surface: Color(0xFF111827),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B1220),
        elevation: 0,
      ),
    );
  }
}

enum ViewMode { anatomy, histology, crossSection, clinical }

enum ContentTab { overview, compare, caseStudy, quiz }

class HeartLayerData {
  final String name;
  final String subtitle;
  final String description;
  final String clinical;
  final String pathology;
  final String function;
  final String histologyHint;
  final double thickness;
  final Color color;
  final List<String> quickFacts;
  final List<String> mistakes;
  final String anatomyImage;
  final String histologyImage;
  final String crossSectionImage;

  const HeartLayerData({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.clinical,
    required this.pathology,
    required this.function,
    required this.histologyHint,
    required this.thickness,
    required this.color,
    required this.quickFacts,
    required this.mistakes,
    required this.anatomyImage,
    required this.histologyImage,
    required this.crossSectionImage,
  });
}

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
    required this.explanation,
  });
}

const List<HeartLayerData> heartLayers = [
  HeartLayerData(
    name: "Epicardium",
    subtitle: "Outer protective layer",
    description:
        "The epicardium is the outermost layer of the heart wall. It contains connective tissue, fat, and coronary vessels, and is closely related to the visceral layer of the serous pericardium.",
    clinical:
        "Inflammation around this region may be associated with pericardial irritation and pain related to the outer cardiac surface.",
    pathology: "Pericardial irritation / superficial inflammation",
    function: "Outer protection and vessel support",
    histologyHint:
        "Look for outer connective tissue, adipose tissue, and coronary vessels near the external surface.",
    thickness: 0.5,
    color: Color(0xFF2563EB),
    quickFacts: [
      "Most external layer",
      "Contains fat and coronary vessels",
      "Helps reduce friction",
    ],
    mistakes: [
      "Often confused with pericardium",
      "Students may ignore its vascular importance",
    ],
    anatomyImage: "assets/images/heart/epicardium_real.jpg",
    histologyImage: "assets/images/histology/epicardium_histo.jpg",
    crossSectionImage: "assets/images/cross_sections/epicardium_cross.jpg",
  ),
  HeartLayerData(
    name: "Myocardium",
    subtitle: "Main contractile muscle",
    description:
        "The myocardium is the thick muscular middle layer of the heart wall. It generates the contractile force required to pump blood through the body.",
    clinical:
        "Damage to this layer directly reduces pumping efficiency and may lead to myocardial infarction, heart failure, or major contractility problems.",
    pathology: "Myocardial infarction / ischemia",
    function: "Main pumping force of the heart",
    histologyHint:
        "Look for organized cardiac muscle fibers forming the thickest functional wall layer.",
    thickness: 1.5,
    color: Color(0xFFDC2626),
    quickFacts: [
      "Thickest heart wall layer",
      "Responsible for contraction",
      "Highly dependent on coronary blood flow",
    ],
    mistakes: [
      "Sometimes confused with the whole heart wall",
      "Students forget it is the main clinical target in infarction",
    ],
    anatomyImage: "assets/images/heart/myocardium_real.jpg",
    histologyImage: "assets/images/histology/myocardium_histo.jpg",
    crossSectionImage: "assets/images/cross_sections/myocardium_cross.jpg",
  ),
  HeartLayerData(
    name: "Endocardium",
    subtitle: "Smooth inner lining",
    description:
        "The endocardium is the smooth internal endothelial lining of the heart chambers and valves. It supports laminar blood flow and reduces surface turbulence.",
    clinical:
        "Infection or damage here can affect valves and may be associated with infective endocarditis and altered blood-surface interaction.",
    pathology: "Endocarditis / valvular involvement",
    function: "Smooth blood-contact lining",
    histologyHint:
        "Look for a thin endothelial inner surface adjacent to the chamber lumen.",
    thickness: 0.3,
    color: Color(0xFF16A34A),
    quickFacts: [
      "Lines chambers and valves",
      "Smooth endothelial surface",
      "Important in blood flow interface",
    ],
    mistakes: [
      "Often underestimated because it is thin",
      "Students forget its valvular relevance",
    ],
    anatomyImage: "assets/images/heart/endocardium_real.jpg",
    histologyImage: "assets/images/histology/endocardium_histo.jpg",
    crossSectionImage: "assets/images/cross_sections/endocardium_cross.jpg",
  ),
];

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: "Which layer generates the main contractile force of the heart?",
    answers: ["Epicardium", "Myocardium", "Endocardium", "Pericardium"],
    correctIndex: 1,
    explanation:
        "The myocardium is the muscular layer that produces contraction and pumping force.",
  ),
  QuizQuestion(
    question: "Which layer directly lines the chambers and valves?",
    answers: ["Epicardium", "Endocardium", "Myocardium", "Pleura"],
    correctIndex: 1,
    explanation:
        "The endocardium is the inner endothelial lining of chambers and valves.",
  ),
  QuizQuestion(
    question: "Which layer commonly contains coronary vessels and fat?",
    answers: ["Epicardium", "Myocardium", "Endocardium", "Septum"],
    correctIndex: 0,
    explanation:
        "The epicardium contains connective tissue, fat, and coronary vessels externally.",
  ),
  QuizQuestion(
    question: "Myocardial infarction most directly affects which layer?",
    answers: ["Epicardium", "Endocardium", "Myocardium", "Fibrous sac"],
    correctIndex: 2,
    explanation:
        "Myocardial infarction damages the myocardium, the main muscular pumping layer.",
  ),
];

class TissueStructureScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;

  const TissueStructureScreen({
    super.key,
    this.onThemeToggle,
    this.isDarkMode = false,
  });

  @override
  State<TissueStructureScreen> createState() => _TissueStructureScreenState();
}

class _TissueStructureScreenState extends State<TissueStructureScreen>
    with TickerProviderStateMixin {
  int selectedIndex = 1;
  ViewMode currentView = ViewMode.anatomy;
  ContentTab selectedTab = ContentTab.overview;

  bool isBookmarked = false;
  bool showLabels = true;

  int currentQuestionIndex = 0;
  List<int?> selectedQuizAnswers = List<int?>.filled(quizQuestions.length, null);
  bool quizSubmitted = false;

  int? selectedCaseDiagnosis;
  int? selectedCaseLayer;
  int? selectedCaseImpact;
  bool caseSubmitted = false;

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _rotateController;

  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _slideController.forward();
    _loadBookmarkState();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarkState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isBookmarked = prefs.getBool('heart_wall_bookmarked') ?? false;
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !isBookmarked;

    await prefs.setBool('heart_wall_bookmarked', newValue);

    setState(() {
      isBookmarked = newValue;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newValue
              ? "Lesson saved to favorites"
              : "Lesson removed from favorites",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _selectLayer(int index) {
    setState(() {
      selectedIndex = index;
    });
    _slideController.forward(from: 0);
  }

  HeartLayerData get currentLayer => heartLayers[selectedIndex];

  String _currentImagePath(HeartLayerData layer) {
    switch (currentView) {
      case ViewMode.anatomy:
        return layer.anatomyImage;
      case ViewMode.histology:
        return layer.histologyImage;
      case ViewMode.crossSection:
        return layer.crossSectionImage;
      case ViewMode.clinical:
        return layer.crossSectionImage;
    }
  }

  String _viewTitle() {
    switch (currentView) {
      case ViewMode.anatomy:
        return "Gross Anatomy";
      case ViewMode.histology:
        return "Histology";
      case ViewMode.crossSection:
        return "Cross Section";
      case ViewMode.clinical:
        return "Clinical View";
    }
  }

  String _viewSubtitle(HeartLayerData layer) {
    switch (currentView) {
      case ViewMode.anatomy:
        return "Study the real structural appearance of ${layer.name}.";
      case ViewMode.histology:
        return "Focus on the microscopic appearance and tissue hint.";
      case ViewMode.crossSection:
        return "Understand relative position and spatial arrangement.";
      case ViewMode.clinical:
        return "Link anatomy with symptoms, diagnosis, and damage.";
    }
  }

  void _showHotspotSheet(HeartLayerData layer, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: layer.color.withOpacity(0.35)),
            boxShadow: [
              BoxShadow(
                color: layer.color.withOpacity(0.18),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: layer.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.favorite_rounded, color: layer.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        layer.name,
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  layer.function,
                  style: TextStyle(
                    color: layer.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  layer.clinical,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    height: 1.6,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: layer.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    "Common pathology: ${layer.pathology}",
                    style: TextStyle(
                      color: layer.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _quizScore() {
    int score = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (selectedQuizAnswers[i] == quizQuestions[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedQuizAnswers = List<int?>.filled(quizQuestions.length, null);
      quizSubmitted = false;
    });
  }

  void _resetCase() {
    setState(() {
      selectedCaseDiagnosis = null;
      selectedCaseLayer = null;
      selectedCaseImpact = null;
      caseSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final layer = currentLayer;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildMedicalHero(isDark, layer),
                    const SizedBox(height: 18),
                    _buildActionStrip(isDark),
                    const SizedBox(height: 18),
                    _buildLayerSelector(isDark),
                    const SizedBox(height: 18),
                    _buildViewSelector(isDark),
                    const SizedBox(height: 18),
                    _buildImagePanel(isDark, layer),
                    const SizedBox(height: 18),
                    _buildTabs(isDark),
                    const SizedBox(height: 18),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _slideController,
                        child: _buildSelectedContent(isDark, layer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF14B8A6), Color(0xFF0EA5E9)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0EA5E9).withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.monitor_heart_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Heart Wall Layers",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Professional medical learning experience",
                  style: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            isDark: isDark,
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            iconColor: isBookmarked ? const Color(0xFFF59E0B) : null,
            onTap: _toggleBookmark,
          ),
          const SizedBox(width: 10),
          _circleButton(
            isDark: isDark,
            icon: widget.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            iconColor: widget.isDarkMode
                ? const Color(0xFFFACC15)
                : const Color(0xFF0F766E),
            onTap: widget.onThemeToggle,
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required bool isDark,
    required IconData icon,
    required VoidCallback? onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.18 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? (isDark ? Colors.white70 : Colors.black54),
        ),
      ),
    );
  }

  Widget _buildMedicalHero(bool isDark, HeartLayerData layer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _rotateController]),
        builder: (_, __) {
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF0C1628), Color(0xFF111827)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Colors.white, Color(0xFFEFF8FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF1E293B) : const Color(0xFFDDEAF3),
              ),
              boxShadow: [
                BoxShadow(
                  color: layer.color.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _heroMetric(
                        isDark,
                        "Current Layer",
                        layer.name,
                        layer.color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _heroMetric(
                        isDark,
                        "Main Role",
                        layer.subtitle,
                        const Color(0xFF0EA5E9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0B1220).withOpacity(0.9)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 270,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: ECGGridPainter(isDark: isDark),
                              ),
                            ),
                            Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(_rotateAnimation.value * 0.07),
                                child: CustomPaint(
                                  size: const Size(280, 240),
                                  painter: HeartCrossSectionPainter(
                                    selectedIndex: selectedIndex,
                                    layers: heartLayers,
                                    isDark: isDark,
                                    showLabels: showLabels,
                                  ),
                                ),
                              ),
                            ),
                            _buildHotspots(isDark),
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: layer.color.withOpacity(0.14),
                                border: Border.all(
                                  color: layer.color.withOpacity(0.40),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: layer.color.withOpacity(0.25),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 46,
                                color: layer.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Tap any clinical hotspot to explore the layer directly from the heart model.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
                          height: 1.5,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildVitalsBar(isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _heroMetric(bool isDark, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotspots(bool isDark) {
    return Stack(
      children: [
        Positioned(
          left: 40,
          top: 60,
          child: _hotspot(
            heartLayers[0],
            onTap: () {
              _selectLayer(0);
              _showHotspotSheet(heartLayers[0], isDark);
            },
          ),
        ),
        Positioned(
          right: 38,
          top: 105,
          child: _hotspot(
            heartLayers[1],
            onTap: () {
              _selectLayer(1);
              _showHotspotSheet(heartLayers[1], isDark);
            },
          ),
        ),
        Positioned(
          left: 72,
          bottom: 38,
          child: _hotspot(
            heartLayers[2],
            onTap: () {
              _selectLayer(2);
              _showHotspotSheet(heartLayers[2], isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _hotspot(HeartLayerData layer, {required VoidCallback onTap}) {
    final active = currentLayer.name == layer.name;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: active ? 46 : 40,
        height: active ? 46 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: layer.color.withOpacity(active ? 0.26 : 0.16),
          border: Border.all(
            color: layer.color.withOpacity(active ? 0.9 : 0.5),
            width: active ? 2.2 : 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: layer.color.withOpacity(0.30),
              blurRadius: active ? 18 : 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.add_rounded,
          color: layer.color,
          size: active ? 24 : 20,
        ),
      ),
    );
  }

  Widget _buildVitalsBar(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF08111F) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _vitalChip("HR", "112", const Color(0xFFDC2626))),
          Expanded(child: _vitalChip("BP", "90/60", const Color(0xFFF97316))),
          Expanded(child: _vitalChip("Tn", "High", const Color(0xFF8B5CF6))),
          Expanded(child: _vitalChip("O2", "93%", const Color(0xFF0EA5E9))),
        ],
      ),
    );
  }

  Widget _vitalChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionStrip(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _actionCard(
              isDark,
              title: "Study",
              subtitle: "Core content",
              icon: Icons.menu_book_rounded,
              color: const Color(0xFF14B8A6),
              onTap: () => setState(() => selectedTab = ContentTab.overview),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _actionCard(
              isDark,
              title: "Compare",
              subtitle: "Layer vs layer",
              icon: Icons.compare_arrows_rounded,
              color: const Color(0xFF0284C7),
              onTap: () => setState(() => selectedTab = ContentTab.compare),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _actionCard(
              isDark,
              title: "Clinical",
              subtitle: "Patient case",
              icon: Icons.local_hospital_rounded,
              color: const Color(0xFFF97316),
              onTap: () => setState(() => selectedTab = ContentTab.caseStudy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(
    bool isDark, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerSelector(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(heartLayers.length, (i) {
          final layer = heartLayers[i];
          final active = selectedIndex == i;

          return Expanded(
            child: GestureDetector(
              onTap: () => _selectLayer(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                decoration: BoxDecoration(
                  color: active
                      ? layer.color.withOpacity(isDark ? 0.14 : 0.10)
                      : (isDark ? const Color(0xFF111827) : Colors.white),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: active
                        ? layer.color.withOpacity(0.55)
                        : (isDark
                            ? const Color(0xFF1F2937)
                            : const Color(0xFFE2E8F0)),
                    width: active ? 1.7 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor:
                          active ? layer.color : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      layer.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: active
                            ? layer.color
                            : (isDark
                                ? Colors.white70
                                : const Color(0xFF334155)),
                        fontWeight:
                            active ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      layer.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isDark ? Colors.white38 : const Color(0xFF94A3B8),
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildViewSelector(bool isDark) {
    final items = {
      ViewMode.anatomy: "Anatomy",
      ViewMode.histology: "Histology",
      ViewMode.crossSection: "Cross-Section",
      ViewMode.clinical: "Clinical",
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.entries.map((entry) {
            final selected = currentView == entry.key;
            return GestureDetector(
              onTap: () => setState(() => currentView = entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0F766E)
                      : (isDark ? const Color(0xFF111827) : Colors.white),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF0F766E)
                        : (isDark
                            ? const Color(0xFF1F2937)
                            : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : (isDark ? Colors.white70 : const Color(0xFF334155)),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildImagePanel(bool isDark, HeartLayerData layer) {
    final imagePath = _currentImagePath(layer);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.16 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                imagePath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    alignment: Alignment.center,
                    color: isDark
                        ? const Color(0xFF0B1220)
                        : const Color(0xFFF1F5F9),
                    child: Text(
                      "Image not found:\n$imagePath",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isDark ? Colors.white60 : const Color(0xFF64748B),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _viewTitle(),
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _viewSubtitle(layer),
              style: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                height: 1.5,
                fontSize: 12.5,
              ),
            ),
            if (currentView == ViewMode.histology) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  "Histology hint: ${layer.histologyHint}",
                  style: const TextStyle(
                    color: Color(0xFF0284C7),
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    final tabs = {
      ContentTab.overview: "Overview",
      ContentTab.compare: "Compare",
      ContentTab.caseStudy: "Clinical Case",
      ContentTab.quiz: "Quiz",
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: tabs.entries.map((entry) {
            final active = selectedTab == entry.key;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedTab = entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        active ? const Color(0xFF0F766E) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: active
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSelectedContent(bool isDark, HeartLayerData layer) {
    switch (selectedTab) {
      case ContentTab.overview:
        return _buildOverviewContent(isDark, layer);
      case ContentTab.compare:
        return _buildCompareContent(isDark);
      case ContentTab.caseStudy:
        return _buildClinicalCaseContent(isDark);
      case ContentTab.quiz:
        return _buildQuizContent(isDark);
    }
  }

  Widget _buildOverviewContent(bool isDark, HeartLayerData layer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _baseCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(
                  isDark,
                  title: layer.name,
                  subtitle: layer.function,
                  color: layer.color,
                  icon: Icons.favorite_rounded,
                ),
                const SizedBox(height: 16),
                Text(
                  layer.description,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    height: 1.7,
                    fontSize: 14.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _baseCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _miniHeader(
                  isDark,
                  "Quick Clinical Relevance",
                  Icons.local_hospital_rounded,
                  const Color(0xFFF97316),
                ),
                const SizedBox(height: 14),
                Text(
                  layer.clinical,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    "Pathology focus: ${layer.pathology}",
                    style: const TextStyle(
                      color: Color(0xFFC2410C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _baseCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _miniHeader(
                  isDark,
                  "Quick Facts",
                  Icons.bolt_rounded,
                  const Color(0xFF0284C7),
                ),
                const SizedBox(height: 14),
                ...layer.quickFacts.map(
                  (fact) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _bulletRow(isDark, fact, const Color(0xFF0EA5E9)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _baseCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _miniHeader(
                  isDark,
                  "Common Mistakes",
                  Icons.error_outline_rounded,
                  const Color(0xFFDC2626),
                ),
                const SizedBox(height: 14),
                ...layer.mistakes.map(
                  (mistake) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _bulletRow(isDark, mistake, const Color(0xFFDC2626)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _baseCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _miniHeader(
                  isDark,
                  "Relative Thickness",
                  Icons.straighten_rounded,
                  layer.color,
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: layer.thickness / 1.5,
                    minHeight: 10,
                    backgroundColor: isDark
                        ? const Color(0xFF1F2937)
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(layer.color),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${layer.thickness} mm relative layer thickness",
                  style: TextStyle(
                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareContent(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: heartLayers.map((layer) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: _baseCard(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    isDark,
                    title: layer.name,
                    subtitle: layer.subtitle,
                    color: layer.color,
                    icon: Icons.compare_arrows_rounded,
                  ),
                  const SizedBox(height: 14),
                  _factLine(isDark, "Function", layer.function),
                  _factLine(isDark, "Clinical", layer.pathology),
                  _factLine(isDark, "Thickness", "${layer.thickness} mm"),
                  _factLine(isDark, "Histology Hint", layer.histologyHint),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClinicalCaseContent(bool isDark) {
    final diagnosisOptions = [
      "Myocardial infarction",
      "Endocarditis",
      "Simple outer irritation only",
      "Pleural disease",
    ];

    final layerOptions = [
      "Epicardium",
      "Myocardium",
      "Endocardium",
      "Fibrous sac",
    ];

    final impactOptions = [
      "Reduced contractility",
      "Hair growth change",
      "Better oxygenation",
      "Increased skin secretion",
    ];

    final diagnosisCorrect = selectedCaseDiagnosis == 0;
    final layerCorrect = selectedCaseLayer == 1;
    final impactCorrect = selectedCaseImpact == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF2A1515), Color(0xFF15121A)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFFFF7ED), Color(0xFFFEF2F2)],
                    ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFF97316).withOpacity(0.24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF97316).withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(
                  isDark,
                  title: "Emergency Cardiac Scenario",
                  subtitle: "Applied anatomy + diagnosis + functional impact",
                  color: const Color(0xFFF97316),
                  icon: Icons.local_hospital_rounded,
                ),
                const SizedBox(height: 14),
                _patientHeaderCard(isDark),
                const SizedBox(height: 14),
                _caseStepCard(
                  isDark,
                  title: "Step 1 — Most likely diagnosis",
                  options: diagnosisOptions,
                  selectedValue: selectedCaseDiagnosis,
                  onSelect: (value) {
                    setState(() => selectedCaseDiagnosis = value);
                  },
                ),
                const SizedBox(height: 14),
                _caseStepCard(
                  isDark,
                  title: "Step 2 — Which layer is primarily affected?",
                  options: layerOptions,
                  selectedValue: selectedCaseLayer,
                  onSelect: (value) {
                    setState(() => selectedCaseLayer = value);
                  },
                ),
                const SizedBox(height: 14),
                _caseStepCard(
                  isDark,
                  title: "Step 3 — What is the main functional consequence?",
                  options: impactOptions,
                  selectedValue: selectedCaseImpact,
                  onSelect: (value) {
                    setState(() => selectedCaseImpact = value);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetCase,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text("Reset"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF97316),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => caseSubmitted = true);
                        },
                        icon: const Icon(Icons.task_alt_rounded),
                        label: const Text("Evaluate"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (caseSubmitted) ...[
            const SizedBox(height: 14),
            _baseCard(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _miniHeader(
                    isDark,
                    "Clinical Feedback",
                    Icons.analytics_rounded,
                    const Color(0xFF14B8A6),
                  ),
                  const SizedBox(height: 14),
                  _feedbackLine(
                    isDark,
                    "Diagnosis",
                    diagnosisCorrect,
                    "Chest pain + elevated troponin + reduced ventricular contractility strongly suggest myocardial infarction.",
                  ),
                  const SizedBox(height: 10),
                  _feedbackLine(
                    isDark,
                    "Affected Layer",
                    layerCorrect,
                    "The myocardium is the contractile muscle layer, so it is the primary layer damaged in infarction.",
                  ),
                  const SizedBox(height: 10),
                  _feedbackLine(
                    isDark,
                    "Functional Impact",
                    impactCorrect,
                    "When the myocardium is damaged, contractility decreases and pumping efficiency falls.",
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _patientHeaderCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDark ? 0.04 : 0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3342) : const Color(0xFFE8EDF3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _caseStat("Age", "58")),
              Expanded(child: _caseStat("Sex", "Male")),
              Expanded(child: _caseStat("Pain", "Severe")),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _caseStat("HR", "112 bpm")),
              Expanded(child: _caseStat("BP", "90/60")),
              Expanded(child: _caseStat("Troponin", "Elevated")),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Patient presents with severe chest pain, elevated troponin, and reduced left ventricular wall contractility.",
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _caseStepCard(
    bool isDark, {
    required String title,
    required List<String> options,
    required int? selectedValue,
    required ValueChanged<int> onSelect,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1220) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(options.length, (index) {
            final selected = selectedValue == index;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onSelect(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFF97316).withOpacity(0.10)
                        : (isDark
                            ? const Color(0xFF111827)
                            : const Color(0xFFF8FAFC)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFFF97316)
                          : (isDark
                              ? const Color(0xFF1F2937)
                              : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          options[index],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFFF97316),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _feedbackLine(
    bool isDark,
    String title,
    bool correct,
    String explanation,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (correct ? Colors.green : Colors.red).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (correct ? Colors.green : Colors.red).withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: correct ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent(bool isDark) {
    final q = quizQuestions[currentQuestionIndex];
    final selected = selectedQuizAnswers[currentQuestionIndex];
    final score = _quizScore();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _baseCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(
                  isDark,
                  title: "Interactive Quiz",
                  subtitle: "Check your understanding with feedback",
                  color: const Color(0xFF8B5CF6),
                  icon: Icons.quiz_rounded,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Question ${currentQuestionIndex + 1} of ${quizQuestions.length}",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      "${selectedQuizAnswers.where((e) => e != null).length}/${quizQuestions.length}",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / quizQuestions.length,
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
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(q.answers.length, (index) {
                  final isSelected = selected == index;
                  final isCorrect = q.correctIndex == index;
                  final wrongSelected =
                      quizSubmitted && isSelected && !isCorrect;

                  Color borderColor;
                  Color fillColor;

                  if (quizSubmitted && isCorrect) {
                    borderColor = Colors.green;
                    fillColor = Colors.green.withOpacity(0.10);
                  } else if (wrongSelected) {
                    borderColor = Colors.red;
                    fillColor = Colors.red.withOpacity(0.10);
                  } else if (isSelected) {
                    borderColor = const Color(0xFF8B5CF6);
                    fillColor = const Color(0xFF8B5CF6).withOpacity(0.10);
                  } else {
                    borderColor = isDark
                        ? const Color(0xFF1F2937)
                        : const Color(0xFFE2E8F0);
                    fillColor = isDark
                        ? const Color(0xFF0B1220)
                        : const Color(0xFFF8FAFC);
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: quizSubmitted
                          ? null
                          : () {
                              setState(() {
                                selectedQuizAnswers[currentQuestionIndex] =
                                    index;
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
                                      : const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (quizSubmitted && isCorrect)
                              const Icon(Icons.check_circle_rounded,
                                  color: Colors.green),
                            if (wrongSelected)
                              const Icon(Icons.cancel_rounded,
                                  color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                if (quizSubmitted) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      q.explanation,
                      style: const TextStyle(
                        color: Color(0xFF6D28D9),
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: currentQuestionIndex > 0
                            ? () {
                                setState(() => currentQuestionIndex--);
                              }
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
                        onPressed:
                            currentQuestionIndex < quizQuestions.length - 1
                                ? () {
                                    setState(() => currentQuestionIndex++);
                                  }
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
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => quizSubmitted = true);
                        },
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
                  _miniHeader(
                    isDark,
                    "Quiz Result",
                    Icons.emoji_events_rounded,
                    const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Your score: $score / ${quizQuestions.length}",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    score == quizQuestions.length
                        ? "Excellent. Strong retention and good layer differentiation."
                        : score >= 2
                            ? "Good work. Review the clinical case and histology hint once more."
                            : "You need more review, especially the relation between structure and function.",
                    style: TextStyle(
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
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
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.16 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(
    bool isDark, {
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _miniHeader(
    bool isDark,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bulletRow(bool isDark, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(Icons.circle, size: 8, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _factLine(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ECGGridPainter extends CustomPainter {
  final bool isDark;

  ECGGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.025)
          : Colors.black.withOpacity(0.025)
      ..strokeWidth = 0.7;

    const grid = 26.0;

    for (double x = 0; x < size.width; x += grid) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += grid) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final ecgPaint = Paint()
      ..color = const Color(0xFF14B8A6).withOpacity(0.16)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final midY = size.height * 0.72;

    path.moveTo(0, midY);
    for (double x = 0; x < size.width; x += 42) {
      path.lineTo(x + 8, midY);
      path.lineTo(x + 14, midY - 6);
      path.lineTo(x + 18, midY + 18);
      path.lineTo(x + 22, midY - 28);
      path.lineTo(x + 26, midY + 10);
      path.lineTo(x + 34, midY);
      path.lineTo(x + 42, midY);
    }

    canvas.drawPath(path, ecgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeartCrossSectionPainter extends CustomPainter {
  final int selectedIndex;
  final List<HeartLayerData> layers;
  final bool isDark;
  final bool showLabels;

  HeartCrossSectionPainter({
    required this.selectedIndex,
    required this.layers,
    required this.isDark,
    required this.showLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 6);
    final baseRadius = size.height * 0.34;

    final radii = [
      baseRadius,
      baseRadius * 0.68,
      baseRadius * 0.38,
    ];

    for (int i = 0; i < layers.length; i++) {
      final layer = layers[i];
      final active = i == selectedIndex;

      if (active) {
        final glowPaint = Paint()
          ..color = layer.color.withOpacity(0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
        canvas.drawCircle(center, radii[i] + 8, glowPaint);
      }

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = active
            ? layer.color.withOpacity(isDark ? 0.18 : 0.12)
            : layer.color.withOpacity(isDark ? 0.06 : 0.04);

      canvas.drawCircle(center, radii[i], fillPaint);

      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = active ? 2.6 : 1.4
        ..color =
            active ? layer.color.withOpacity(0.9) : layer.color.withOpacity(0.26);

      canvas.drawCircle(center, radii[i], borderPaint);

      if (active) {
        _drawDashedCircle(canvas, center, radii[i] + 14, layer.color);
      }
    }

    if (showLabels) {
      _drawLabel(
        canvas,
        "Epicardium",
        Offset(center.dx - 120, center.dy - 85),
        layers[0].color,
      );
      _drawLabel(
        canvas,
        "Myocardium",
        Offset(center.dx + 45, center.dy - 5),
        layers[1].color,
      );
      _drawLabel(
        canvas,
        "Endocardium",
        Offset(center.dx - 105, center.dy + 92),
        layers[2].color,
      );
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(offset.dx, offset.dy, painter.width + 20, 28),
      const Radius.circular(10),
    );

    final bg = Paint()..color = color.withOpacity(0.12);
    final border = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rect, bg);
    canvas.drawRRect(rect, border);
    painter.paint(canvas, Offset(offset.dx + 10, offset.dy + 6));
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final paint = Paint()
      ..color = color.withOpacity(0.45)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const gapWidth = 5.0;
    final circumference = 2 * math.pi * radius;
    final count = (circumference / (dashWidth + gapWidth)).floor();

    for (int i = 0; i < count; i++) {
      final start = (i * (dashWidth + gapWidth)) / radius;
      final sweep = dashWidth / radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HeartCrossSectionPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.isDark != isDark ||
        oldDelegate.showLabels != showLabels;
  }
}