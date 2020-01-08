class Food {
  const Food({
    this.barcode,
    this.expiry,
    this.name,
    this.description,
    this.image,
    this.quantity,
  });

  final String barcode;
  final DateTime expiry;
  final String name;
  final String description;
  final String image;
  final double quantity;

}