import 'dart:math';
import 'package:flutter/material.dart';
import '../math/vector3.dart';
import '../math/matrix_math.dart';
import '../models/mesh.dart';

class DragonPainter extends CustomPainter {
  final double rotation;
  final Mesh mesh;
  
  DragonPainter({required this.rotation, required this.mesh});

  @override
  void paint(Canvas canvas, Size size) {
    Vector3 lightSource = Vector3(0, -1, -0.5); 
    List<ProjectedTriangle> trianglesToDraw = [];

    for (var tri in mesh.triangles) {
      Vector3 v1 = mesh.vertices[tri.indices[0]];
      Vector3 v2 = mesh.vertices[tri.indices[1]];
      Vector3 v3 = mesh.vertices[tri.indices[2]];

      double finalRotation = rotation + pi; 

      Vector3 r1 = MatrixMath.rotateY(v1, finalRotation);
      Vector3 r2 = MatrixMath.rotateY(v2, finalRotation);
      Vector3 r3 = MatrixMath.rotateY(v3, finalRotation);

      if (r1.x * (r2.y - r3.y) + r2.x * (r3.y - r1.y) + r3.x * (r1.y - r2.y) < 0) continue;

      double brightness = MatrixMath.calculateLighting(r1, r2, r3, lightSource);

      double z1 = r1.z + 15.0; if (z1 <= 0.1) z1 = 0.1;
      double z2 = r2.z + 15.0; if (z2 <= 0.1) z2 = 0.1;
      double z3 = r3.z + 15.0; if (z3 <= 0.1) z3 = 0.1;

      // Locked the scale at 700 (the perfect size from your screenshot)
      double fixedScale = 700.0;
      Vector3 p1 = Vector3((r1.x * fixedScale) / z1, -(r1.y * fixedScale) / z1, r1.z);
      Vector3 p2 = Vector3((r2.x * fixedScale) / z2, -(r2.y * fixedScale) / z2, r2.z);
      Vector3 p3 = Vector3((r3.x * fixedScale) / z3, -(r3.y * fixedScale) / z3, r3.z);

      double depth = (r1.z + r2.z + r3.z) / 3.0;
      trianglesToDraw.add(ProjectedTriangle(p1, p2, p3, brightness, depth));
    }

    trianglesToDraw.sort((a, b) => b.depth.compareTo(a.depth));

    // Anchored at 0.65 to drop it right onto the candles
    canvas.translate(size.width / 2, size.height * 0.65);

    for (var tri in trianglesToDraw) {
      Path path = Path();
      path.moveTo(tri.p1.x, tri.p1.y);
      path.lineTo(tri.p2.x, tri.p2.y);
      path.lineTo(tri.p3.x, tri.p3.y);
      path.close();
      double contrastEffect = pow(tri.brightness, 1.3).toDouble();
    int baseR = 60;
    int baseG = 58;
    int baseB = 65;

// Highlight: warm ivory bone (real skull tone)
int highlightR = 230;
int highlightG = 220;
int highlightB = 190;

// Interpolate between shadow and highlight
int r = (baseR + (highlightR - baseR) * contrastEffect).toInt().clamp(0, 255);
int g = (baseG + (highlightG - baseG) * contrastEffect).toInt().clamp(0, 255);
int b = (baseB + (highlightB - baseB) * contrastEffect).toInt().clamp(0, 255);

// Slight boost for visibility on dark background
r = (r * 1.05).toInt().clamp(0, 255);
g = (g * 1.05).toInt().clamp(0, 255);
b = (b * 1.08).toInt().clamp(0, 255);

Paint fillPaint = Paint()
  ..color = Color.fromARGB(255, r, g, b)
  ..style = PaintingStyle.fill;

      canvas.drawPath(path, fillPaint);    }
  }

  @override
  bool shouldRepaint(covariant DragonPainter oldDelegate) => oldDelegate.rotation != rotation;
}