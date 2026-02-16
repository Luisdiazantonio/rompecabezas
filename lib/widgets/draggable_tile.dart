import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';
import 'puzzle_tile.dart';

class DraggableTile extends StatelessWidget {
  final PuzzlePiece piece;
  final int gridSize;
  final String imagePath;
  final Function(int, int) onSwap;

  const DraggableTile({
    super.key,
    required this.piece,
    required this.gridSize,
    required this.imagePath,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        onSwap(details.data, piece.currentIndex);
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<int>(
          data: piece.currentIndex,
          feedback: SizedBox(
            width: 100,
            height: 100,
            child: PuzzleTile(
              piece: piece,
              imagePath: imagePath,
              gridSize: gridSize,
            ),
          ),
          childWhenDragging: Container(color: Colors.grey),
          child: PuzzleTile(
            piece: piece,
            imagePath: imagePath,
            gridSize: gridSize,
          ),
        );
      },
    );
  }
}
