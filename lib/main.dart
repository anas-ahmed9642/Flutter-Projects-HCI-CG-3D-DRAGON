import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'rendering/engine.dart';
import 'models/mesh.dart';
import 'models/skull_data.dart';

void main() {
  runApp(const BalerionApp());
}

class BalerionApp extends StatelessWidget {
  const BalerionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const DungeonScene(),
    );
  }
}

class DungeonScene extends StatefulWidget {
  const DungeonScene({super.key});

  @override
  State<DungeonScene> createState() => _DungeonSceneState();
}
class _DungeonSceneState extends State<DungeonScene> {
  double _rotation = 0.0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMusicPlaying = false; 
  Mesh? _dragonMesh; 

  @override
  void initState() {
    super.initState();
    _loadRealDragon(); 
  }

  Future<void> _loadRealDragon() async {
    Mesh loadedMesh = await SkullData.loadObjFile('assets/models/balerion.obj');
    setState(() {
      _dragonMesh = loadedMesh;
    });
  }

  void _playMusic() async {
    _audioPlayer.setReleaseMode(ReleaseMode.loop); 
    await _audioPlayer.play(AssetSource('audio/vermithor.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // THE HCI UPGRADE: InteractiveViewer allows pinch, scroll, and drag to zoom/pan
          InteractiveViewer(
            minScale: 1.0,  // Standard view
            maxScale: 5.0,  // Let the user zoom way into the teeth
            boundaryMargin: EdgeInsets.zero,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/red_keep_dungeon.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: _dragonMesh == null
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.orange),
                        )
                      : CustomPaint(
                          painter: DragonPainter(
                            rotation: _rotation,
                            mesh: _dragonMesh!, 
                          ),
                        ),
                ),
              ],
            ),
          ),
          
          // THE FIXED UI CONTROLS
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                const Text(
                  "AWAKEN THE DREAD",
                  style: TextStyle(
                    color: Colors.orange, 
                    letterSpacing: 4, 
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 10)]
                  ),
                ),
                Slider(
                  value: _rotation,
                  min: 0,
                  max: 2 * pi,
                  activeColor: Colors.deepOrange,
                  inactiveColor: Colors.black87,
                  onChanged: (val) {
                    if (!_isMusicPlaying) {
                      _playMusic();
                      _isMusicPlaying = true;
                    }
                    setState(() { _rotation = val; });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}