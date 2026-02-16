import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';
import 'draggable_tile.dart';

class PuzzleBoard extends StatelessWidget {
  final List<PuzzlePiece> pieces;
  final int gridSize;
  final Function(int, int) onSwap;
  final String imagePath;

  const PuzzleBoard({
    super.key,
    required this.pieces,
    required this.gridSize,
    required this.onSwap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        GridView.builder(
          itemCount: pieces.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: DraggableTile(
                piece: pieces[index],
                gridSize: gridSize,
                imagePath: imagePath,
                onSwap: onSwap,
              ),
            );
          },
        ),
      ],
    );
  }
}
