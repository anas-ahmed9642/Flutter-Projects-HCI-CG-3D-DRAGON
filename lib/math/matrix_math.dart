import 'dart:math';
import 'vector3.dart';

class MatrixMath {
  static Vector3 project(Vector3 point, double fov, double viewerDistance) {
    double z = point.z + viewerDistance;
    if (z <= 0.1) z = 0.1; // Strict division-by-zero protection
    return Vector3((point.x * fov) / z, (point.y * fov) / z, point.z);
  }

  static Vector3 rotateY(Vector3 point, double angle) {
    double cosA = cos(angle);
    double sinA = sin(angle);
    return Vector3(
      point.x * cosA + point.z * sinA, 
      point.y, 
      -point.x * sinA + point.z * cosA
    );
  }

  static double calculateLighting(Vector3 v1, Vector3 v2, Vector3 v3, Vector3 lightSource) {
    Vector3 side1 = Vector3(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
    Vector3 side2 = Vector3(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z);
    
    double nx = side1.y * side2.z - side1.z * side2.y;
    double ny = side1.z * side2.x - side1.x * side2.z;
    double nz = side1.x * side2.y - side1.y * side2.x;
    
    double length = sqrt(nx * nx + ny * ny + nz * nz);
    if (length == 0) return 0;
    
    nx /= length; ny /= length; nz /= length;

    // Dot product for diffuse lighting
    double dot = nx * lightSource.x + ny * lightSource.y + nz * lightSource.z;
    return max(0.0, dot); 
  }
}