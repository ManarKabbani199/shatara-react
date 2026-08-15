import 'dart:math' as math;

import 'ChessBoard.dart' show ChessPiece, PieceType, PlayerColor;

bool whiteKingMoved = false;
bool whiteKingsideRookMoved = false;
bool whiteQueensideRookMoved = false;
bool blackKingMoved = false;
bool blackKingsideRookMoved = false;
bool blackQueensideRookMoved = false;

typedef BoardState = List<List<ChessPiece?>>;

void resetCastlingFlags() {
  whiteKingMoved = false;
  whiteKingsideRookMoved = false;
  whiteQueensideRookMoved = false;
  blackKingMoved = false;
  blackKingsideRookMoved = false;
  blackQueensideRookMoved = false;
}

void updateCastlingRights(int fromRow, int fromCol, ChessPiece movingPiece) {
  if (movingPiece.color == PlayerColor.white) {
    if (movingPiece.type == PieceType.king) whiteKingMoved = true;
    if (movingPiece.type == PieceType.rook && fromRow == 7 && fromCol == 7) {
      whiteKingsideRookMoved = true;
    }
    if (movingPiece.type == PieceType.rook && fromRow == 7 && fromCol == 0) {
      whiteQueensideRookMoved = true;
    }
  } else {
    if (movingPiece.type == PieceType.king) blackKingMoved = true;
    if (movingPiece.type == PieceType.rook && fromRow == 0 && fromCol == 7) {
      blackKingsideRookMoved = true;
    }
    if (movingPiece.type == PieceType.rook && fromRow == 0 && fromCol == 0) {
      blackQueensideRookMoved = true;
    }
  }
}

bool _inside(int row, int col) => row >= 0 && row < 8 && col >= 0 && col < 8;

bool _pathClear(
    BoardState board, int fromRow, int fromCol, int toRow, int toCol) {
  final rowStep = (toRow - fromRow).sign;
  final colStep = (toCol - fromCol).sign;
  var r = fromRow + rowStep;
  var c = fromCol + colStep;
  while (r != toRow || c != toCol) {
    if (board[r][c] != null) return false;
    r += rowStep;
    c += colStep;
  }
  return true;
}

bool isValidMove(
  int fromRow,
  int fromCol,
  int toRow,
  int toCol,
  BoardState board, {
  dynamic enPassantTarget,
}) {
  if (!_inside(fromRow, fromCol) || !_inside(toRow, toCol)) return false;
  if (fromRow == toRow && fromCol == toCol) return false;

  final piece = board[fromRow][fromCol];
  if (piece == null) return false;

  final target = board[toRow][toCol];
  if (target != null && target.color == piece.color) return false;

  switch (piece.type) {
    case PieceType.pawn:
      final dir = piece.color == PlayerColor.white ? -1 : 1;
      final startRow = piece.color == PlayerColor.white ? 6 : 1;

      if (fromCol == toCol) {
        if (toRow == fromRow + dir && target == null) return true;
        if (fromRow == startRow &&
            toRow == fromRow + 2 * dir &&
            target == null &&
            board[fromRow + dir][fromCol] == null) {
          return true;
        }
      }

      if ((toCol - fromCol).abs() == 1 && toRow == fromRow + dir) {
        if (target != null && target.color != piece.color) return true;
        if (enPassantTarget != null) {
          try {
            final epRow = (enPassantTarget.dy as num).toInt();
            final epCol = (enPassantTarget.dx as num).toInt();
            if (epRow == toRow && epCol == toCol) return true;
          } catch (_) {}
        }
      }
      return false;

    case PieceType.knight:
      final dr = (toRow - fromRow).abs();
      final dc = (toCol - fromCol).abs();
      return (dr == 2 && dc == 1) || (dr == 1 && dc == 2);

    case PieceType.bishop:
      if ((toRow - fromRow).abs() != (toCol - fromCol).abs()) return false;
      return _pathClear(board, fromRow, fromCol, toRow, toCol);

    case PieceType.rook:
      if (fromRow != toRow && fromCol != toCol) return false;
      return _pathClear(board, fromRow, fromCol, toRow, toCol);

    case PieceType.queen:
      final straight = fromRow == toRow || fromCol == toCol;
      final diagonal = (toRow - fromRow).abs() == (toCol - fromCol).abs();
      if (!straight && !diagonal) return false;
      return _pathClear(board, fromRow, fromCol, toRow, toCol);

    case PieceType.king:
      final dr = (toRow - fromRow).abs();
      final dc = (toCol - fromCol).abs();
      if (dr <= 1 && dc <= 1) return true;
      // castling pattern check only; final legality via canCastle* helpers elsewhere
      if (dr == 0 && dc == 2) return true;
      return false;
  }
}

List<List<ChessPiece?>> _cloneBoard(BoardState board) {
  return List.generate(8, (r) {
    return List.generate(8, (c) {
      final p = board[r][c];
      return p == null
          ? null
          : ChessPiece(p.type, p.color, hasMoved: p.hasMoved);
    });
  });
}

(bool, int, int) _findKing(PlayerColor color, BoardState board) {
  for (var r = 0; r < 8; r++) {
    for (var c = 0; c < 8; c++) {
      final p = board[r][c];
      if (p != null && p.color == color && p.type == PieceType.king) {
        return (true, r, c);
      }
    }
  }
  return (false, -1, -1);
}

bool isKingInCheck(PlayerColor color, BoardState board) {
  final (found, kingRow, kingCol) = _findKing(color, board);
  if (!found) return true; // if king missing, treat as check / lost

  for (var r = 0; r < 8; r++) {
    for (var c = 0; c < 8; c++) {
      final p = board[r][c];
      if (p == null || p.color == color) continue;
      if (isValidMove(r, c, kingRow, kingCol, board)) return true;
    }
  }
  return false;
}

bool canCastleKingside(PlayerColor color, BoardState board) {
  final row = color == PlayerColor.white ? 7 : 0;
  if (color == PlayerColor.white) {
    if (whiteKingMoved || whiteKingsideRookMoved) return false;
  } else {
    if (blackKingMoved || blackKingsideRookMoved) return false;
  }

  final king = board[row][4];
  final rook = board[row][7];
  if (king == null || rook == null) return false;
  if (king.type != PieceType.king || rook.type != PieceType.rook) return false;
  if (king.color != color || rook.color != color) return false;
  if (board[row][5] != null || board[row][6] != null) return false;
  if (isKingInCheck(color, board)) return false;

  final tmp1 = _cloneBoard(board);
  tmp1[row][5] = tmp1[row][4];
  tmp1[row][4] = null;
  if (isKingInCheck(color, tmp1)) return false;

  final tmp2 = _cloneBoard(board);
  tmp2[row][6] = tmp2[row][4];
  tmp2[row][4] = null;
  if (isKingInCheck(color, tmp2)) return false;

  return true;
}

bool canCastleQueenside(PlayerColor color, BoardState board) {
  final row = color == PlayerColor.white ? 7 : 0;
  if (color == PlayerColor.white) {
    if (whiteKingMoved || whiteQueensideRookMoved) return false;
  } else {
    if (blackKingMoved || blackQueensideRookMoved) return false;
  }

  final king = board[row][4];
  final rook = board[row][0];
  if (king == null || rook == null) return false;
  if (king.type != PieceType.king || rook.type != PieceType.rook) return false;
  if (king.color != color || rook.color != color) return false;
  if (board[row][1] != null || board[row][2] != null || board[row][3] != null)
    return false;
  if (isKingInCheck(color, board)) return false;

  final tmp1 = _cloneBoard(board);
  tmp1[row][3] = tmp1[row][4];
  tmp1[row][4] = null;
  if (isKingInCheck(color, tmp1)) return false;

  final tmp2 = _cloneBoard(board);
  tmp2[row][2] = tmp2[row][4];
  tmp2[row][4] = null;
  if (isKingInCheck(color, tmp2)) return false;

  return true;
}

int evaluateBoard(BoardState board) {
  const values = {
    PieceType.pawn: 100,
    PieceType.knight: 320,
    PieceType.bishop: 330,
    PieceType.rook: 500,
    PieceType.queen: 900,
    PieceType.king: 20000,
  };

  var score = 0;
  for (var r = 0; r < 8; r++) {
    for (var c = 0; c < 8; c++) {
      final p = board[r][c];
      if (p == null) continue;
      final value = values[p.type] ?? 0;
      score += p.color == PlayerColor.black ? value : -value;
    }
  }
  return score;
}
