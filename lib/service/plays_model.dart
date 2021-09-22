class PlaysModel{
  final String id;
  final String email;
  final int length;
  final String name;
  final String price;
  PlaysModel({required this.name, required this.price, required this.length, required this.id,required this.email});
}

class PlaysContentModel {
  final String name;
  final int length;

  PlaysContentModel( {required this.length,required this.name});
}

class PlaysTestModel{
  final String name;
  final String price;
  final int length;

  PlaysTestModel({required this.name, required this.price, required this.length});
}