enum Difficulty {
  easy(size: 4),
  medium(size: 6),
  hard(size: 8)
  ;

  const Difficulty({required this.size});
  
  final int size;
}
