import 'package:flutter/material.dart';
import 'package:tic_tac_toe/board_tile.dart';
import 'package:tic_tac_toe/tile_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  var _boardState = List.filled(9, TileState.EMPTY);

  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final containerWidth = constraints.maxWidth;
              return Column(
                children: [
                  Flexible(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _currentTurn == TileState.CROSS
                            ? Text(
                          "X's turn",
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary),
                        )
                            : Text(
                          "O's turn",
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary),
                        ),
                      )),
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Stack(
                          children: [
                            Image.asset('images/board.png'),
                            _boardTiles(containerWidth),
                          ]),
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: OutlinedButton(
                        onPressed: _resetGame, child: const Text('Reset Game')),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _boardTiles(double containerWidth) {
    return Builder(builder: (context) {
      final boardDimension = containerWidth;
      final tileDimension = boardDimension / 3;

      return SizedBox(
        width: boardDimension,
        height: boardDimension,
        child: Column(
          children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;

            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return BoardTile(
                    tileState: tileState,
                    dimension: tileDimension,
                    onPressed: () => _updateTileStateForIndex(tileIndex));
              }).toList(),
            );
          }).toList(),
        ),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
        print('Winner is $winner');
        _showWinnerDialog(winner);
      }

      if(_isMatchDraw()) {
        _showMatchDrawDialog();
      }
    }
  }

  bool _isMatchDraw() {
    for(int i=0; i<_boardState.length; i++) {
      if(_boardState[i] == TileState.EMPTY) {
        return false;
      }
    }

    return true;
  }

  TileState? _findWinner() {
    winnerForMatch(a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if (_boardState[a] == _boardState[b] &&
            _boardState[b] == _boardState[c]) {
          return _boardState[a];
        }
      }

      return null;
    }

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i];
        break;
      }
    }

    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    final context = navigatorKey.currentState?.overlay?.context;

    if (context != null) {
      showDialog(
        context: context,
        builder: (_) {
          final titleColor = Theme.of(context).primaryColor;

          return AlertDialog(
            title: const Text(
              'Winner is',
              textAlign: TextAlign.center,
            ),
            content: Image.asset(
              tileState == TileState.CROSS
                  ? 'images/cross.png'
                  : 'images/circle.png',
              width: 50,
              height: 50,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Play New Game'))
            ],
            actionsAlignment: MainAxisAlignment.center,
            icon: const Icon(Icons.celebration_outlined, size: 40),
            iconColor: titleColor,
          );
        },
        barrierDismissible: false,
      );
    }
  }

  void _showMatchDrawDialog() {
    final context = navigatorKey.currentState?.overlay?.context;

    if (context != null) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              'Match is Draw',
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Play New Game'))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        },
        barrierDismissible: false,
      );
    }
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
