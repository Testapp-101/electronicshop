class ProductItems {
  String? status;
  int? results;
  Item? item;
  String? message;

  ProductItems({this.status, this.results, this.item, this.message});

  ProductItems.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    results = json['results'];
    item = json['data'] != null ? Item.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['results'] = results;
    if (this.item != null) {
      data['data'] = this.item!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Item {
  List<Product>? product;

  Item({this.product});

  Item.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? image;
  String? price;
  int? stock;
  int? createDate;
  List<String>? category;

  Product(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.stock,
      this.createDate,
      this.category});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    stock = json['stock'];
    createDate = json['createDate'];
    category = json['category'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['stock'] = stock;
    data['createDate'] = createDate;
    data['category'] = category;
    return data;
  }
}
