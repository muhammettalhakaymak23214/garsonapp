class Menu {
  final int id;
  final String name;
  final double price;
  final double expense;
  final List<String>? ingredients;
  final String categoryName;

  Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.expense,
    this.ingredients,
    required this.categoryName,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      expense: json['expense'].toDouble(),
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      categoryName: json['categoryName'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final List<Menu> menus;

  Category({
    required this.id,
    required this.name,
    required this.menus,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var menuList = json['menus'] as List;
    List<Menu> menus = menuList.map((menu) => Menu.fromJson(menu)).toList();

    return Category(
      id: json['id'],
      name: json['name'],
      menus: menus,
    );
  }
}
