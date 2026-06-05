class Pizza {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> availableOptions;

  Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.availableOptions,
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    var optionsVal = json['availableOptions'] ?? '';
    List<String> options = [];
    if (optionsVal is String && optionsVal.isNotEmpty) {
      options = optionsVal.split(',').map((e) => e.trim()).toList();
    } else if (optionsVal is List) {
      options = optionsVal.map((e) => e.toString()).toList();
    }
    
    return Pizza(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      availableOptions: options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'availableOptions': availableOptions.join(','),
    };
  }
}
