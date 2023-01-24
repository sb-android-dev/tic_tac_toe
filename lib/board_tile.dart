import 'package:flutter/material.dart';
import 'package:tic_tac_toe/tile_state.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({Key? key, required this.tileState, required this.dimension, required this.onPressed}) : super(key: key);

  final TileState tileState;
  final double dimension;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dimension,
      height: dimension,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: onPressed,
          child: _widgetForTileState(),
        ),
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;

    switch(tileState) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;

      case TileState.CROSS:
        {
          widget = Image.asset('images/cross.png');
        }
        break;

      case TileState.CIRCLE:
        {
          widget = Image.asset('images/circle.png');
        }
        break;
    }

    return widget;
  }
}
