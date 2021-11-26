class Products {
  String? products;

  Products(this.products);

  Products.fromJson(dynamic json) {
    products = json["products"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["products"] = products;
    return data;
  }
}

class Product {
  String? name;
  String? id;
  String? productId;
  String? sku;
  String? image;
  String? thumb;
  String? zoomThumb;
  List<dynamic>? options;
  String? description;
  String? href;
  int? quantity;
  List<dynamic>? images;
  String? price;
  String? special;

  Product(
      this.name,
      this.id,
      this.productId,
      this.sku,
      this.image,
      this.thumb,
      this.zoomThumb,
      this.options,
      this.description,
      this.href,
      this.quantity,
      this.images,
      this.price,
      this.special);

  Product.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    productId = json["product_id"];
    sku = json["sku"];
    image = json["image"];
    thumb = json["thumb"];
    zoomThumb = json["zoom_thumb"];
    options = json["options"];
    description = json["description"];
    href = json["href"];
    quantity = json["quantity"];
    images = json["images"];
    price = json["price"];
    special = json["special"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["id"] = id;
    data["product_id"] = productId;
    data["sku"] = sku;
    data["image"] = image;
    data["thumb"] = thumb;
    data["zoom_thumb"] = zoomThumb;
    data["options"] = options;
    data["description"] = description;
    data["href"] = href;
    data["quantity"] = quantity;
    data["images"] = images;
    data["price"] = price;
    data["special"] = special;
    return data;
  }
}
