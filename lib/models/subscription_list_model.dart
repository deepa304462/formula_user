
class SubscriptionListModel {
  String subscriptionsId;
  String title;
  String description;
  String price;
  bool isPurchased;


  SubscriptionListModel(
      {
        required this.subscriptionsId,
        required this.title,
        required this.description,
        required this.isPurchased,
        required this.price,
      });
}
