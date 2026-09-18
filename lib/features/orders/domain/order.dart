class OrderSummary {
  final String id;
  final String status;
  final num total;
  final String currency;
  final int itemCount;
  final DateTime createdAt;

  const OrderSummary({
    required this.id,
    required this.status,
    required this.total,
    required this.currency,
    required this.itemCount,
    required this.createdAt,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) => OrderSummary(
        id: json['id'] as String,
        status: json['status'] as String,
        total: json['total'] as num,
        currency: json['currency'] as String,
        itemCount: json['itemCount'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class OrderLineItem {
  final String nameAr;
  final String nameEn;
  final String? colorNameAr;
  final String? colorNameEn;
  final num unitPrice;
  final int quantity;
  final num lineTotal;

  const OrderLineItem({
    required this.nameAr,
    required this.nameEn,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    this.colorNameAr,
    this.colorNameEn,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
        nameAr: json['nameAr'] as String,
        nameEn: json['nameEn'] as String,
        colorNameAr: json['colorNameAr'] as String?,
        colorNameEn: json['colorNameEn'] as String?,
        unitPrice: json['unitPrice'] as num,
        quantity: json['quantity'] as int,
        lineTotal: json['lineTotal'] as num,
      );
}

class OrderTimelineStage {
  final String stage;
  final String label;
  final DateTime at;
  final bool done;

  const OrderTimelineStage({required this.stage, required this.label, required this.at, required this.done});

  factory OrderTimelineStage.fromJson(Map<String, dynamic> json) => OrderTimelineStage(
        stage: json['stage'] as String,
        label: json['label'] as String,
        at: DateTime.parse(json['at'] as String),
        done: json['done'] as bool,
      );
}

class OrderDetail {
  final String id;
  final String status;
  final String currency;
  final num subtotal;
  final num deliveryFee;
  final num total;
  final String addressLabel;
  final String deliveryMethod;
  final String paymentMethod;
  final DateTime createdAt;
  final List<OrderLineItem> items;
  final List<OrderTimelineStage> timeline;

  const OrderDetail({
    required this.id,
    required this.status,
    required this.currency,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.addressLabel,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
    required this.timeline,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json['id'] as String,
        status: json['status'] as String,
        currency: json['currency'] as String,
        subtotal: json['subtotal'] as num,
        deliveryFee: json['deliveryFee'] as num,
        total: json['total'] as num,
        addressLabel: (json['address'] as Map<String, dynamic>)['label'] as String,
        deliveryMethod: json['deliveryMethod'] as String,
        paymentMethod: json['paymentMethod'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        items: (json['items'] as List).map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>)).toList(),
        timeline: (json['timeline'] as List).map((e) => OrderTimelineStage.fromJson(e as Map<String, dynamic>)).toList(),
      );
}
