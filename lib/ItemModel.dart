class ItemModel{
  final String name;
  final String price;
  final String id;
  final String email;
  final String image;
  ItemModel( {required this.name, required this.price,required this.id,required this.email,required this.image});
}

class raffleModel{
  final int number;
  final String id;

  raffleModel( this.id, this.number);
  }
