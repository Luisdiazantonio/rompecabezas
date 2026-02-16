import 'package:flutter/material.dart';
import 'dart:math';
import '../models/puzzle_piece.dart';
import '../widgets/puzzle_tile.dart';
import '../data/image_data.dart';

class PuzzleScreen extends StatefulWidget {
  final int imageIndex;
  const PuzzleScreen({super.key, required this.imageIndex});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  static const int gridSize = 3;
  late List<PuzzlePiece> pieces;

  String get imagePath => ImageData.images[widget.imageIndex];
  bool get isLastImage => widget.imageIndex == ImageData.images.length - 1;

  @override
  void initState() {
    super.initState();
    PuzzlePiece.gridSize = gridSize;
    resetPuzzle();
  }

  void resetPuzzle() {
    pieces = List.generate(
      gridSize * gridSize,
      (i) => PuzzlePiece(correctIndex: i, currentIndex: i),
    );
    pieces.shuffle(Random());
    setState(() {});
  }

  void swapPieces(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    setState(() {
      final temp = pieces[fromIndex];
      pieces[fromIndex] = pieces[toIndex];
      pieces[toIndex] = temp;
    });
    checkCompletion();
  }

  void checkCompletion() {
    final completed = pieces.asMap().entries.every(
      (entry) => entry.value.correctIndex == entry.key,
    );

    if (completed) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              isLastImage
                  ? "¡Has completado todos los puzzles! 🎉"
                  : "¡Completado! 🎉",
            ),
            content: Text(
              isLastImage
                  ? "¡Felicidades! Volvemos al menú."
                  : "¡Has armado el rompecabezas!",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  if (isLastImage) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PuzzleScreen(imageIndex: widget.imageIndex + 1),
                      ),
                    );
                  }
                },
                child: Text(
                  isLastImage ? "Volver al menú" : "Siguiente imagen →",
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileSize = (screenWidth - 24.0 - 1.5 * (gridSize - 1)) / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Puzzle ${widget.imageIndex + 1} / ${ImageData.images.length}",
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: resetPuzzle),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.12,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gridSize * gridSize,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 1.5,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final piece = pieces[index];
                return DragTarget<int>(
                  onAcceptWithDetails: (details) =>
                      swapPieces(details.data, index),
                  builder: (context, _, __) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 0.8,
                        ),
                      ),
                      child: Draggable<int>(
                        data: index,
                        feedback: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: tileSize,
                            height: tileSize,
                            child: PuzzleTile(
                              piece: piece,
                              imagePath: imagePath,
                              gridSize: gridSize,
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.35,
                          child: PuzzleTile(
                            piece: piece,
                            imagePath: imagePath,
                            gridSize: gridSize,
                          ),
                        ),
                        child: PuzzleTile(
                          piece: piece,
                          imagePath: imagePath,
                          gridSize: gridSize,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
