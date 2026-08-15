// جندي=1و حصان=2 و فيل =3 و قلعة=4 ووزير=5 و لاشيئ=0typePiece
class  Setting {
     static  int x=0;
     static int  xr=-1;
     static int xc=-1;
     static int typePiece=0;
     static int turn=0;
  static int pcx=-1;
   static int pcy=-1;
   static int blackwins=0;
    static List<List<int>> boardData1 = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
  ];

// جندي=1و حصان=2 و فيل =3 و قلعة=4 ووزير=5 و لاشيئ=0typePiece
      static List<List<int>> boardType = [
      [-900, -900, -500, -500],
      [-320, -320, -330, -330],
      [-100, -100, -100, -100],
      [ 0, 0, 0, 0],
      [ 0, 0, 0, 0],
      [ 100, 100, 100, 100],
      [ 320, 320, 330, 330],
      [ 900, 900, 500, 500]
  ];



}