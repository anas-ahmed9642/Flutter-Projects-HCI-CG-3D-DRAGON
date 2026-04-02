import '../math/vector3.dart';

class Triangle {
  List<int> indices; 
  Triangle(this.indices);
}

// Making this public like you smartly suggested!
class ProjectedTriangle {
  final Vector3 p1, p2, p3; 
  final double brightness;  
  final double depth;       

  ProjectedTriangle(this.p1, this.p2, this.p3, this.brightness, this.depth);
}

class Mesh {
  List<Vector3> vertices;
  List<Triangle> triangles;
  Mesh({required this.vertices, required this.triangles});
}