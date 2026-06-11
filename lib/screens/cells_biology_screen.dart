import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class CellHotspot {
  final String id;
  final String title;
  final String short;
  final String function;
  final String location;
  final String clinical;
  final String keyFact;
  final String histology;
  final String studyTip;
  final String commonConfusion;
  final IconData icon;
  final IconData imageIcon;
  final Color color;
  final String tag;
  final String position;
  final String normal;
  final String imagePath;
  final String videoTitle;
  final String videoDuration;
  final String videoDescription;
  final String diagnosticHint;

  const CellHotspot({
    required this.id,
    required this.title,
    required this.short,
    required this.function,
    required this.location,
    required this.clinical,
    required this.keyFact,
    required this.histology,
    required this.studyTip,
    required this.commonConfusion,
    required this.icon,
    required this.imageIcon,
    required this.color,
    required this.tag,
    required this.position,
    required this.normal,
    required this.imagePath,
    required this.videoTitle,
    required this.videoDuration,
    required this.videoDescription,
    required this.diagnosticHint,
  });
}

class CellsBiologyScreen extends StatefulWidget {
  const CellsBiologyScreen({super.key});

  @override
  State<CellsBiologyScreen> createState() => _CellsBiologyScreenState();
}

class _CellsBiologyScreenState extends State<CellsBiologyScreen>
    with TickerProviderStateMixin {
  static const Color medicalNavy = Color(0xFF0E4A6B);
  static const Color medicalBlue = Color(0xFF1E6F8C);
  static const Color medicalTeal = Color(0xFF1FA7A0);
  static const Color medicalBg = Color(0xFFF3F8FB);
  static const Color softCard = Color(0xFFFFFFFF);
  static const Color stroke = Color(0xFFDCE8F0);
  static const Color textDark = Color(0xFF17384D);
  static const Color textSoft = Color(0xFF5D7284);
  static const Color alertRed = Color(0xFFD62828);

  int selectedIndex = 0;
  int? activeHotspotIndex;
  bool autoRotateHeart = false;
  bool showHotspots = true;
  bool showDetails = true;
  bool showClinicalPanel = true;
  int viewerRefreshKey = 0;
  int sectionIndex = 0;

  late final AnimationController _panelController;
  late final Animation<double> _panelFade;

  final List<CellHotspot> cells = const [
    CellHotspot(
      id: 'sa_node',
      title: 'SA Node',
      short: 'Natural pacemaker',
      function: 'Initiates the electrical impulse that starts each heartbeat.',
      location: 'Upper right atrium near the superior vena cava.',
      clinical:
          'Dysfunction may lead to sinus bradycardia or abnormal heart rhythm.',
      keyFact: 'The SA node usually determines the dominant heart rhythm.',
      histology:
          'Specialized nodal cells are smaller and less contractile than ordinary cardiomyocytes.',
      studyTip:
          'Think of the SA node as the first electrical trigger of the normal heartbeat.',
      commonConfusion:
          'It is not mainly responsible for ventricular contraction; it starts the impulse.',
      icon: Icons.bolt_rounded,
      imageIcon: Icons.electrical_services_rounded,
      color: Color(0xFFD62828),
      tag: 'Electrical',
      position: '-0.06m 0.11m 0.03m',
      normal: '0m 1m 0m',
      imagePath: 'assets/cells/sa_node.png',
      videoTitle: 'SA Node Micro-Lesson',
      videoDuration: '2:10',
      videoDescription:
          'Short explanation of impulse initiation and pacemaker hierarchy.',
      diagnosticHint:
          'Correlate SA node dysfunction with sinus bradycardia and rate abnormalities.',
    ),
    CellHotspot(
      id: 'av_node',
      title: 'AV Node',
      short: 'Electrical relay center',
      function:
          'Receives the atrial impulse and delays it briefly before passing it to the ventricles.',
      location: 'Lower interatrial septum near the tricuspid valve region.',
      clinical: 'Conduction delay or block here can produce AV block.',
      keyFact:
          'Its delay allows ventricular filling before ventricular contraction.',
      histology:
          'AV nodal tissue is composed of specialized conduction cells that transmit more slowly.',
      studyTip:
          'Always connect AV node with delay and controlled transmission.',
      commonConfusion:
          'The AV node does not normally act as the main pacemaker when the SA node is intact.',
      icon: Icons.sync_alt_rounded,
      imageIcon: Icons.alt_route_rounded,
      color: Color(0xFFF77F00),
      tag: 'Conduction',
      position: '0.02m 0.02m 0.05m',
      normal: '0m 0m 1m',
      imagePath: 'assets/cells/av_node.png',
      videoTitle: 'AV Node Delay Concept',
      videoDuration: '1:48',
      videoDescription:
          'Why AV nodal delay is essential before ventricular contraction.',
      diagnosticHint:
          'Think AV block when conduction through the AV node becomes impaired.',
    ),
    CellHotspot(
      id: 'purkinje',
      title: 'Purkinje Fibers',
      short: 'Fast conduction fibers',
      function:
          'Rapidly conduct impulses through the ventricles for synchronized contraction.',
      location: 'Subendocardial ventricular conduction network.',
      clinical:
          'Abnormal conduction may contribute to ventricular arrhythmias.',
      keyFact:
          'Purkinje fibers are specialized for rapid electrical propagation.',
      histology:
          'They are larger and paler than ordinary cardiac muscle cells and contain fewer myofibrils.',
      studyTip:
          'Remember them as the fast distribution network for the ventricular impulse.',
      commonConfusion:
          'Purkinje fibers conduct electrical activity; they are not the main contractile pumping cells.',
      icon: Icons.timeline_rounded,
      imageIcon: Icons.multiline_chart_rounded,
      color: Color(0xFF00897B),
      tag: 'Fibers',
      position: '-0.02m -0.12m 0.06m',
      normal: '0m 0m 1m',
      imagePath: 'assets/cells/purkinje.png',
      videoTitle: 'Purkinje Network Review',
      videoDuration: '2:04',
      videoDescription:
          'Fast overview of synchronized ventricular activation.',
      diagnosticHint:
          'Relate delayed ventricular conduction to dysrhythmia and desynchrony.',
    ),
    CellHotspot(
      id: 'cardiac_muscle',
      title: 'Cardiac Muscle Cells',
      short: 'Contractile cells',
      function:
          'Responsible for rhythmic myocardial contraction and effective blood pumping.',
      location: 'Main ventricular myocardium wall.',
      clinical:
          'Damage to these cells reduces pumping efficiency and may contribute to heart failure.',
      keyFact:
          'These cells combine excitability, conductivity, and contractility.',
      histology:
          'Cardiomyocytes are branched, striated cells with central nuclei and abundant mitochondria.',
      studyTip:
          'These are the principal cells generating the force of cardiac pumping.',
      commonConfusion:
          'Cardiac muscle cells are not the same as conduction fibers, although both participate in cardiac function.',
      icon: Icons.favorite_rounded,
      imageIcon: Icons.monitor_heart_outlined,
      color: Color(0xFF7B2CBF),
      tag: 'Contractile',
      position: '0.10m -0.03m 0.03m',
      normal: '1m 0m 0m',
      imagePath: 'assets/cells/cardiac_muscle.png',
      videoTitle: 'Cardiomyocyte Function',
      videoDuration: '2:32',
      videoDescription:
          'Clinical link between contractility, myocardium, and pump performance.',
      diagnosticHint:
          'When cardiomyocytes fail, ejection and tissue perfusion decline.',
    ),
    CellHotspot(
      id: 'intercalated_discs',
      title: 'Intercalated Discs',
      short: 'Microscopic junctions',
      function:
          'Connect adjacent cardiac muscle cells mechanically and electrically.',
      location: 'Between cardiomyocytes inside the myocardium.',
      clinical:
          'Disruption affects coordinated contraction and electrical spread.',
      keyFact:
          'They help neighboring cardiomyocytes work as a coordinated functional unit.',
      histology:
          'They contain junctional complexes that support adhesion and intercellular communication.',
      studyTip:
          'Think of them as bridges that help cardiac cells stay connected and synchronized.',
      commonConfusion:
          'They are not a separate cell type; they are specialized junctional regions between cells.',
      icon: Icons.hub_outlined,
      imageIcon: Icons.device_hub_rounded,
      color: Color(0xFF1976D2),
      tag: 'Junctions',
      position: '0.08m -0.18m -0.01m',
      normal: '1m 0m 0m',
      imagePath: 'assets/cells/intercalated_discs.png',
      videoTitle: 'Intercalated Discs Basics',
      videoDuration: '1:42',
      videoDescription:
          'See how cardiac cells stay mechanically and electrically linked.',
      diagnosticHint:
          'Loss of coordinated cellular linkage impairs synchronous contraction.',
    ),
  ];

  CellHotspot get current => cells[selectedIndex];

  @override
  void initState() {
    super.initState();
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();

    _panelFade = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  void selectCell(int index, {bool fromHotspot = false}) {
    if (index < 0 || index >= cells.length) return;

    setState(() {
      selectedIndex = index;
      if (fromHotspot) {
        activeHotspotIndex = activeHotspotIndex == index ? null : index;
      }
    });

    _panelController.forward(from: 0);
  }

  void nextCell() {
    final next = (selectedIndex + 1) % cells.length;
    setState(() {
      selectedIndex = next;
      activeHotspotIndex = next;
    });
    _panelController.forward(from: 0);
  }

  void previousCell() {
    final prev = (selectedIndex - 1 + cells.length) % cells.length;
    setState(() {
      selectedIndex = prev;
      activeHotspotIndex = prev;
    });
    _panelController.forward(from: 0);
  }

  void resetViewer() {
    setState(() {
      viewerRefreshKey++;
      activeHotspotIndex = null;
    });
  }

  JavascriptChannel _hotspotChannel() {
    return JavascriptChannel(
      'HotspotChannel',
      onMessageReceived: (message) {
        final value = int.tryParse(message.message);
        if (value != null) {
          selectCell(value, fromHotspot: true);
        }
      },
    );
  }

  String _colorHex(Color c) =>
      '#${c.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  String _buildInnerHotspotsHtml() {
    if (!showHotspots) return '';

    final buffer = StringBuffer();

    for (int i = 0; i < cells.length; i++) {
      final item = cells[i];
      final color = _colorHex(item.color);
      final isActive = i == activeHotspotIndex;

      buffer.write('''
<button
  class="mv-hotspot ${isActive ? "selected-hotspot" : ""}"
  slot="hotspot-${item.id}"
  data-position="${item.position}"
  data-normal="${item.normal}"
  onclick="HotspotChannel.postMessage('$i')"
>
  <span class="pulse-ring" style="border-color: $color;"></span>
  <span class="core-dot" style="background: $color;">
    <span class="mini-icon">${isActive ? "•" : "+"}</span>
  </span>
</button>
''');
    }

    return buffer.toString();
  }

  String _buildRelatedCss() {
    return '''
model-viewer {
  --poster-color: transparent;
  width: 100%;
  height: 100%;
  background: transparent;
}

.mv-hotspot {
  position: relative;
  border: none;
  background: transparent;
  transform: translate(-50%, -50%);
  cursor: pointer;
  padding: 0;
  outline: none;
  transition: transform .2s ease, filter .2s ease;
}

.mv-hotspot:hover {
  transform: translate(-50%, -50%) scale(1.08);
  filter: drop-shadow(0 0 12px rgba(14,74,107,0.20));
}

.mv-hotspot .pulse-ring {
  position: absolute;
  width: 64px;
  height: 64px;
  left: -32px;
  top: -32px;
  border-radius: 999px;
  border: 2px solid;
  background: rgba(255,255,255,0.08);
  animation: pulse 1.8s infinite;
  pointer-events: none;
}

.mv-hotspot .core-dot {
  position: absolute;
  width: 28px;
  height: 28px;
  left: -14px;
  top: -14px;
  border-radius: 999px;
  border: 3px solid rgba(255,255,255,.95);
  box-shadow: 0 10px 24px rgba(0,0,0,.18);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform .22s ease, box-shadow .22s ease;
}

.selected-hotspot .core-dot {
  transform: scale(1.16);
  box-shadow: 0 0 0 6px rgba(255,255,255,.24), 0 16px 32px rgba(0,0,0,.22);
}

.selected-hotspot .pulse-ring {
  width: 74px;
  height: 74px;
  left: -37px;
  top: -37px;
}

.mv-hotspot .mini-icon {
  color: white;
  font-weight: 900;
  font-size: 14px;
  line-height: 1;
}

@keyframes pulse {
  0% { transform: scale(.82); opacity: .95; }
  70% { transform: scale(1.20); opacity: .10; }
  100% { transform: scale(1.28); opacity: 0; }
}
''';
  }

  Alignment _bubbleAlignment(int index) {
    switch (index) {
      case 0:
        return const Alignment(0.36, 0.03);
      case 1:
        return const Alignment(0.03, -0.20);
      case 2:
        return const Alignment(-0.16, 0.48);
      case 3:
        return const Alignment(0.28, -0.58);
      case 4:
        return const Alignment(0.58, 0.34);
      default:
        return Alignment.center;
    }
  }

  Alignment _bubbleCardAlignment(int index) {
    switch (index) {
      case 0:
        return const Alignment(0.14, -0.02);
      case 1:
        return const Alignment(-0.24, -0.30);
      case 2:
        return const Alignment(-0.34, 0.18);
      case 3:
        return const Alignment(0.10, -0.78);
      case 4:
        return const Alignment(0.26, 0.02);
      default:
        return Alignment.center;
    }
  }

  Widget _floatingBubbleCard() {
    if (activeHotspotIndex == null) return const SizedBox.shrink();

    final item = cells[activeHotspotIndex!];

    return IgnorePointer(
      child: Align(
        alignment: _bubbleCardAlignment(activeHotspotIndex!),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: 1,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: 1,
            child: Container(
              width: 205,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.98),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: stroke),
                boxShadow: [
                  BoxShadow(
                    color: medicalNavy.withOpacity(0.15),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: item.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 12.8,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.tag,
                    style: TextStyle(
                      fontSize: 10.8,
                      fontWeight: FontWeight.w800,
                      color: item.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.short,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                      color: textSoft,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bubblePointer() {
    if (activeHotspotIndex == null) return const SizedBox.shrink();

    final item = cells[activeHotspotIndex!];

    return IgnorePointer(
      child: Align(
        alignment: _bubbleAlignment(activeHotspotIndex!),
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.98),
            border: Border.all(color: stroke),
            boxShadow: [
              BoxShadow(
                color: medicalNavy.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          transform: Matrix4.rotationZ(0.78),
          child: Center(
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showVideoDialog(CellHotspot item) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [
                        medicalNavy,
                        medicalBlue,
                        item.color.withOpacity(0.90),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            item.videoDuration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const Center(
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 38,
                            color: medicalNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.videoTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.videoDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: textSoft,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: medicalBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: stroke),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: medicalBlue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'يمكنك لاحقًا ربط هذا الزر بفيديو حقيقي من asset أو network video.',
                          style: TextStyle(
                            fontSize: 12.4,
                            color: textSoft,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: medicalNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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

  void _showImagePreview(CellHotspot item) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: const Color(0xFFF1F7FB),
                    border: Border.all(color: stroke),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                item.color.withOpacity(0.16),
                                medicalBg,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.imageIcon,
                                  size: 44,
                                  color: item.color,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: item.color,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Add medical image asset here',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: textSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.histology,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: textSoft,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Close Preview'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: medicalNavy,
                      side: const BorderSide(color: stroke),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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

  void _showClinicalBottomSheet(CellHotspot item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SafeArea(
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4DEE6),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: item.color.withOpacity(0.14),
                      child: Icon(item.imageIcon, color: item.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${item.title} · Clinical Interpretation',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _clinicalBottomItem(
                  Icons.medical_information_outlined,
                  'Clinical significance',
                  item.clinical,
                  item.color,
                ),
                const SizedBox(height: 10),
                _clinicalBottomItem(
                  Icons.search_rounded,
                  'Diagnostic hint',
                  item.diagnosticHint,
                  item.color,
                ),
                const SizedBox(height: 10),
                _clinicalBottomItem(
                  Icons.lightbulb_outline_rounded,
                  'Common confusion',
                  item.commonConfusion,
                  item.color,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _clinicalBottomItem(
    IconData icon,
    String title,
    String content,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: medicalBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.6,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 12.6,
                    color: textSoft,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroSection() {
    final progress = ((selectedIndex + 1) / cells.length * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0C3F5B),
            Color(0xFF0E5A77),
            Color(0xFF1B7E8D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: medicalNavy.withOpacity(0.22),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.16),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.monitor_heart_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cardiac Cells Biology',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Interactive Cardiovascular Learning Module',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Explore conduction structures, contractile elements, histology, and clinical meaning in a more medical and presentation-ready format suitable for graduation project demos.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.7,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _heroChip(Icons.view_in_ar_rounded, '3D Anatomy'),
              _heroChip(Icons.science_outlined, 'Histology'),
              _heroChip(Icons.video_collection_outlined, 'Media Learning'),
              _heroChip(Icons.local_hospital_outlined, 'Clinical Links'),
              _heroChip(Icons.auto_graph_rounded, '$progress% explored'),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                _summaryMetric('Focus', current.title),
                _verticalDivider(),
                _summaryMetric('Category', current.tag),
                _verticalDivider(),
                _summaryMetric('Clinical note', 'High relevance'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryMetric(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11.3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white24,
    );
  }

  Widget _heroChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topControls() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: softCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: stroke),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _softPill(
            Icons.my_location_rounded,
            '${selectedIndex + 1} / ${cells.length}',
          ),
          _softPill(Icons.circle, current.tag, color: current.color),
          _softPill(Icons.timelapse_rounded, '8–12 min module'),
          _actionPill(
            showHotspots ? 'Hide hotspots' : 'Show hotspots',
            showHotspots
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            medicalNavy,
            () => setState(() {
              showHotspots = !showHotspots;
              if (!showHotspots) activeHotspotIndex = null;
            }),
          ),
          _actionPill(
            autoRotateHeart ? 'Auto rotate on' : 'Auto rotate off',
            autoRotateHeart
                ? Icons.motion_photos_on_rounded
                : Icons.pause_circle_filled_rounded,
            autoRotateHeart ? alertRed : const Color(0xFF607D8B),
            () => setState(() => autoRotateHeart = !autoRotateHeart),
          ),
          _actionPill(
            'Reset view',
            Icons.refresh_rounded,
            medicalBlue,
            resetViewer,
          ),
          _actionPill(
            showDetails ? 'Hide details' : 'Show details',
            showDetails ? Icons.close_rounded : Icons.open_in_new_rounded,
            medicalTeal,
            () => setState(() => showDetails = !showDetails),
          ),
          _actionPill(
            showClinicalPanel ? 'Clinical panel on' : 'Clinical panel off',
            Icons.local_hospital_rounded,
            alertRed,
            () => setState(() => showClinicalPanel = !showClinicalPanel),
          ),
        ],
      ),
    );
  }

  Widget _softPill(IconData icon, String text, {Color? color}) {
    final accent = color ?? medicalNavy;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accent),
          const SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w700,
              fontSize: 12.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionPill(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guidedStepper() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: softCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: stroke),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(cells.length, (index) {
            final item = cells[index];
            final selected = index == selectedIndex;

            return Padding(
              padding: EdgeInsets.only(
                right: index == cells.length - 1 ? 0 : 10,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    activeHotspotIndex = null;
                  });
                  _panelController.forward(from: 0);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? item.color.withOpacity(0.10)
                        : const Color(0xFFF7FBFD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? item.color.withOpacity(0.36)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: selected
                            ? item.color.withOpacity(0.14)
                            : Colors.white,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: item.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 12.4,
                              fontWeight: FontWeight.w800,
                              color: selected ? item.color : textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.short,
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: textSoft,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _sectionSelector() {
    final sections = const [
      'Overview',
      'Media',
      'Clinical',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: softCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: stroke),
      ),
      child: Row(
        children: List.generate(sections.length, (index) {
          final selected = sectionIndex == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => sectionIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? medicalNavy : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  sections[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : textDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _viewerCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(color: stroke),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: current.color.withOpacity(0.12),
                  ),
                  child: Icon(
                    current.imageIcon,
                    color: current.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '3D Cardiac Viewer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Selected structure: ${current.title}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: current.color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showClinicalPanel)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: alertRed.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monitor_heart_rounded,
                          color: alertRed,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Clinical mode',
                          style: TextStyle(
                            color: alertRed,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.8,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              height: 540,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFCFEFF),
                    Color(0xFFF0F7FB),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(color: const Color(0xFFE6EEF6)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ModelViewer(
                        key: ValueKey(
                          '$viewerRefreshKey-$activeHotspotIndex-$selectedIndex',
                        ),
                        src: '/models/beating-heart.glb',
                        alt: 'Interactive 3D beating heart model',
                        ar: false,
                        autoRotate: autoRotateHeart,
                        autoPlay: true,
                        cameraControls: true,
                        disableZoom: false,
                        backgroundColor: Colors.transparent,
                        loading: Loading.eager,
                        interactionPromptThreshold: 1800,
                        cameraOrbit: '0deg 78deg 1.35m',
                        minCameraOrbit: 'auto auto 0.95m',
                        maxCameraOrbit: 'auto auto 2.8m',
                        fieldOfView: '24deg',
                        minHotspotOpacity: 0,
                        maxHotspotOpacity: 1,
                        id: 'heart-viewer',
                        javascriptChannels: {_hotspotChannel()},
                        innerModelViewerHtml: _buildInnerHotspotsHtml(),
                        relatedCss: _buildRelatedCss(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: _instructionCard(),
                  ),
                  if (showClinicalPanel)
                    Positioned(
                      right: 16,
                      top: 16,
                      child: _clinicalQuickCard(),
                    ),
                  Positioned.fill(child: _floatingBubbleCard()),
                  Positioned.fill(child: _bubblePointer()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructionCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.touch_app_rounded,
            color: alertRed,
            size: 18,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Tap any hotspot on the heart model to show a quick medical bubble.',
              style: TextStyle(
                fontSize: 12.1,
                height: 1.45,
                color: textSoft,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clinicalQuickCard() {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: stroke),
        boxShadow: [
          BoxShadow(
            color: medicalNavy.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_hospital_rounded,
                color: current.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Clinical Summary',
                  style: TextStyle(
                    fontSize: 12.8,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            current.diagnosticHint,
            style: const TextStyle(
              fontSize: 11.8,
              color: textSoft,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard() {
    final item = current;
    final color = item.color;

    return FadeTransition(
      opacity: _panelFade,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white,
          border: Border.all(color: color.withOpacity(0.18), width: 1.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.12),
                  ),
                  child: Icon(
                    item.imageIcon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.short,
                        style: TextStyle(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _tagBadge('Selected', color),
                _tagBadge(item.tag, color.withOpacity(0.88)),
                _tagBadge('Medical Module', medicalBlue),
              ],
            ),
            const SizedBox(height: 16),
            _detailCard(
              Icons.psychology_alt_outlined,
              'Function',
              item.function,
              color,
            ),
            const SizedBox(height: 10),
            _detailCard(
              Icons.place_outlined,
              'Location',
              item.location,
              color,
            ),
            const SizedBox(height: 10),
            _detailCard(
              Icons.local_hospital_outlined,
              'Clinical significance',
              item.clinical,
              color,
            ),
            const SizedBox(height: 10),
            _detailCard(
              Icons.lightbulb_outline_rounded,
              'Key fact',
              item.keyFact,
              color,
            ),
            const SizedBox(height: 10),
            _detailCard(
              Icons.science_outlined,
              'Histology note',
              item.histology,
              color,
            ),
            const SizedBox(height: 10),
            _detailCard(
              Icons.school_outlined,
              'Study tip',
              item.studyTip,
              color,
            ),
            const SizedBox(height: 10),
            _detailCard(
              Icons.help_outline_rounded,
              'Common confusion',
              item.commonConfusion,
              color,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: previousCell,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: medicalNavy,
                      side: BorderSide(color: color.withOpacity(0.25)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: nextCell,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: () => _showClinicalBottomSheet(item),
                  icon: const Icon(Icons.local_hospital_rounded),
                  label: const Text('Clinical interpretation'),
                  style: FilledButton.styleFrom(
                    backgroundColor: medicalNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _showVideoDialog(item),
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  label: const Text('Open lesson video'),
                  style: FilledButton.styleFrom(
                    backgroundColor: medicalTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _detailCard(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EEF6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.4,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.9,
                    color: textSoft,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _learningObjectivesCard() {
    final objectives = [
      'Identify the main cardiac conduction structures.',
      'Differentiate conducting elements from contractile elements.',
      'Recognize how structure supports physiological role.',
      'Relate cellular abnormalities to clinical outcomes.',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag_outlined, color: medicalBlue),
              SizedBox(width: 8),
              Text(
                'Learning Objectives',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...objectives.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: current.color,
                    size: 18,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 12.8,
                        color: textSoft,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewSummaryCard() {
    final cards = [
      {
        'title': 'Function',
        'value': current.function,
        'icon': Icons.psychology_alt_outlined,
      },
      {
        'title': 'Histology',
        'value': current.histology,
        'icon': Icons.science_outlined,
      },
      {
        'title': 'Study Tip',
        'value': current.studyTip,
        'icon': Icons.school_outlined,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.dashboard_customize_outlined, color: medicalBlue),
              SizedBox(width: 8),
              Text(
                'Medical Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...cards.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: medicalBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: stroke),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: current.color.withOpacity(0.12),
                      child: Icon(
                        item['icon'] as IconData,
                        color: current.color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 12.6,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['value'] as String,
                            style: const TextStyle(
                              fontSize: 12.7,
                              color: textSoft,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _studyCardsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.image_search_rounded, color: medicalBlue),
              SizedBox(width: 8),
              Text(
                'Visual Study Cards',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Each card reinforces the visual and conceptual meaning of the selected structure.',
            style: TextStyle(
              fontSize: 12.5,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cells.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = cells[index];
                final selected = selectedIndex == index;

                return InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      activeHotspotIndex = null;
                    });
                    _panelController.forward(from: 0);
                  },
                  onDoubleTap: () => _showImagePreview(item),
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? item.color.withOpacity(0.08)
                          : const Color(0xFFF8FBFF),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected
                            ? item.color.withOpacity(0.35)
                            : const Color(0xFFE6EEF6),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: _cellImage(item),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: InkWell(
                                  onTap: () => _showImagePreview(item),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.94),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.open_in_full_rounded,
                                      size: 18,
                                      color: item.color,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: selected ? item.color : textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.histology,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.8,
                            color: textSoft,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaSection() {
    final item = current;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.video_collection_outlined, color: medicalBlue),
                  SizedBox(width: 8),
                  Text(
                    'Clinical Video Lesson',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      medicalNavy,
                      medicalBlue,
                      item.color.withOpacity(0.86),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          item.videoDuration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Text(
                            item.videoTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.videoDescription,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: () => _showVideoDialog(item),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Play lesson'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: medicalNavy,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _studyCardsSection(),
      ],
    );
  }

  Widget _clinicalSection() {
    final item = current;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.local_hospital_outlined, color: alertRed),
                  SizedBox(width: 8),
                  Text(
                    'Clinical Relevance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _clinicalInfoTile(
                Icons.warning_amber_rounded,
                'Clinical significance',
                item.clinical,
                alertRed,
              ),
              const SizedBox(height: 10),
              _clinicalInfoTile(
                Icons.search_rounded,
                'Diagnostic hint',
                item.diagnosticHint,
                medicalBlue,
              ),
              const SizedBox(height: 10),
              _clinicalInfoTile(
                Icons.check_circle_outline_rounded,
                'Normal concept',
                item.keyFact,
                medicalTeal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _caseSimulationCard(),
      ],
    );
  }

  Widget _clinicalInfoTile(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.6,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.7,
                    color: textSoft,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseSimulationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.quiz_outlined, color: medicalBlue),
              SizedBox(width: 8),
              Text(
                'Mini Clinical Case',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: medicalBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patient scenario',
                  style: TextStyle(
                    fontSize: 12.6,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A patient presents with an abnormal rhythm pattern. Which structure should be reviewed first if the timing of cardiac impulse generation itself appears altered?',
                  style: TextStyle(
                    fontSize: 12.8,
                    color: textSoft,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _caseChoiceButton('SA Node'),
                    _caseChoiceButton('AV Node'),
                    _caseChoiceButton('Purkinje Fibers'),
                    _caseChoiceButton('Intercalated Discs'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseChoiceButton(String label) {
    final isCorrect = label == 'SA Node';

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: isCorrect ? medicalTeal : alertRed,
            content: Text(
              isCorrect
                  ? 'Correct: the SA node is the natural pacemaker.'
                  : 'Not the best answer for impulse initiation. Try again.',
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: stroke),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
      ),
    );
  }

  Widget _cellImage(CellHotspot item) {
    return Container(
      color: const Color(0xFFF2F7FC),
      child: Image.asset(
        item.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  item.color.withOpacity(0.12),
                  item.color.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.imageIcon, size: 42, color: item.color),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: item.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add image asset here',
                    style: TextStyle(
                      color: textSoft,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionBody(bool wide) {
    if (sectionIndex == 0) {
      if (wide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _learningObjectivesCard()),
            const SizedBox(width: 14),
            Expanded(child: _overviewSummaryCard()),
          ],
        );
      }

      return Column(
        children: [
          _learningObjectivesCard(),
          const SizedBox(height: 14),
          _overviewSummaryCard(),
        ],
      );
    }

    if (sectionIndex == 1) {
      return _mediaSection();
    }

    return _clinicalSection();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width >= 1100;

    return Scaffold(
      backgroundColor: medicalBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: medicalBg,
        foregroundColor: textDark,
        centerTitle: false,
        title: const Text(
          'Cardiac Cells Biology',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
        child: Column(
          children: [
            _heroSection(),
            const SizedBox(height: 12),
            _topControls(),
            const SizedBox(height: 12),
            _guidedStepper(),
            const SizedBox(height: 12),
            _sectionSelector(),
            const SizedBox(height: 14),
            _viewerCard(),
            const SizedBox(height: 14),
            if (showDetails) ...[
              _detailsCard(),
              const SizedBox(height: 14),
            ],
            _buildSectionBody(wide),
          ],
        ),
      ),
    );
  }
}