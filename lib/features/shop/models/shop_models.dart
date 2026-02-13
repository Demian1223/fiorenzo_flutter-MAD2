class Product {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

final List<Product> demoProducts = [
  const Product(
    id: '1',
    name: 'LUXURY HANDBAG',
    price: '\$ 2,450.00',
    imageUrl: 'assets/images/bag_1.jpg',
    category: 'women',
  ),
  const Product(
    id: '2',
    name: 'LEATHER BOOTS',
    price: '\$ 1,200.00',
    imageUrl: 'assets/images/boot_1.jpg',
    category: 'men',
  ),
  const Product(
    id: '3',
    name: 'SILK SCARF',
    price: '\$ 450.00',
    imageUrl: 'assets/images/scarf_1.jpg',
    category: 'women',
  ),
  const Product(
    id: '4',
    name: 'CLASSIC WATCH',
    price: '\$ 5,000.00',
    imageUrl: 'assets/images/watch_1.jpg',
    category: 'men',
  ),
  const Product(
    id: '5',
    name: 'ELEGANT PERFUME',
    price: '\$ 350.00',
    imageUrl: 'assets/images/perfume_1.jpg',
    category: 'women',
  ),
  const Product(
    id: '6',
    name: 'DESIGNER BELT',
    price: '\$ 650.00',
    imageUrl: 'assets/images/belt_1.jpg',
    category: 'men',
  ),
];
