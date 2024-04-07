
class SubscriptionModel {
  final String? id;
  final String subscriptionsIdAndroid;
  final String subscriptionsIdIos;


  SubscriptionModel(
      {required this.id,
        required this.subscriptionsIdAndroid,
        required this.subscriptionsIdIos
      });

  SubscriptionModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        subscriptionsIdAndroid = res["subscriptions_id_android"],
        subscriptionsIdIos = res["subscriptions_id_ios"];



  Map<String, Object?> toMap(){

    return {
      'id':id,
      "subscriptions_id_android":subscriptionsIdAndroid,
      "subscriptions_id_ios":subscriptionsIdIos
    };
  }
}
