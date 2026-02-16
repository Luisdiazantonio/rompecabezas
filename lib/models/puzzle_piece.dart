class PuzzlePiece {
  final int correctIndex;
  int currentIndex;
  PuzzlePiece({required this.correctIndex, required this.currentIndex});
  int get correctRow => correctIndex ~/ gridSize;
  int get correctCol => correctIndex % gridSize;
  static int gridSize = 4;
}
