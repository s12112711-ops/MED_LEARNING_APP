import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class HeartScreen extends StatelessWidget {
  const HeartScreen({super.key});

  void showCellInfo(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3D Heart Model"),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: [

          /// 3D HEART MODEL
          ModelViewer(
            src: 'https://modelviewer.dev/shared-assets/models/Heart.glb',
            alt: "3D Heart",
            autoRotate: true,
            cameraControls: true,
            ar: false,
          ),

          /// ARROW BUTTON 1
          Positioned(
            top: 200,
            left: 60,
            child: GestureDetector(
              onTap: () {
                showCellInfo(
                  context,
                  "Cardiac Muscle Cells",
                  "These cells are responsible for heart contraction and pumping blood.",
                );
              },
              child: const Icon(
                Icons.arrow_forward,
                size: 40,
                color: Colors.red,
              ),
            ),
          ),

          /// ARROW BUTTON 2
          Positioned(
            bottom: 180,
            right: 80,
            child: GestureDetector(
              onTap: () {
                showCellInfo(
                  context,
                  "Pacemaker Cells",
                  "These cells control the heartbeat rhythm and electrical signals.",
                );
              },
              child: const Icon(
                Icons.arrow_upward,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ),

          /// INFO CARD
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Tap the arrows to explore heart cells and learn how the cardiovascular system works.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}