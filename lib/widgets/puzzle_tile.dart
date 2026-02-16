import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';

class PuzzleTile extends StatelessWidget {
  final PuzzlePiece piece;
  final String imagePath;
  final int gridSize;

  const PuzzleTile({
    super.key,
    required this.piece,
    required this.imagePath,
    required this.gridSize,
  });

  @override
  Widget build(BuildContext context) {
    final dx = piece.correctCol / (gridSize - 1.0);
    final dy = piece.correctRow / (gridSize - 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double tileSize = constraints.maxWidth;

            return FittedBox(
              fit: BoxFit.none,
              alignment: FractionalOffset(dx, dy),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: tileSize * gridSize,
                height: tileSize * gridSize,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
