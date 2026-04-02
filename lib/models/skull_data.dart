import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import '../math/vector3.dart';
import 'mesh.dart';

class SkullData {
  static Future<Mesh> loadObjFile(String path) async {
    String fileText = await rootBundle.loadString(path);
    List<String> lines = fileText.split('\n');

    List<Vector3> vertices = [];
    List<Triangle> triangles = [];

    for (String line in lines) {
      if (line.startsWith('v ')) {
        List<String> parts = line.split(RegExp(r'\s+'));
        // We scale it down slightly (* 0.5) just in case the Blender export is huge
        vertices.add(Vector3(
          double.parse(parts[1]) * 3.0,
          double.parse(parts[2]) * 3.0,
          double.parse(parts[3]) * 3.0,
        ));
      } else if (line.startsWith('f ')) {
        List<String> parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          int v1 = int.parse(parts[1].split('/')[0]) - 1;
          int v2 = int.parse(parts[2].split('/')[0]) - 1;
          int v3 = int.parse(parts[3].split('/')[0]) - 1;
          triangles.add(Triangle([v1, v2, v3]));
        }
      }
    }
    return Mesh(vertices: vertices, triangles: triangles);
  }
}