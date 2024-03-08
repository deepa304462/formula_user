import 'package:dartz/dartz.dart';
import 'package:formula_user/core/error/exception.dart';
import 'package:formula_user/core/usecase/usecase.dart';
import 'package:formula_user/data/repositories/subscription_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class GetPastPurchases extends UseCase<List<PurchasedItem>?, NoParam> {
  final SubscriptionRepository repository;
  GetPastPurchases(this.repository);
  @override
  Future<Either<Failure, List<PurchasedItem>?>> call(NoParam params) async {
    return await repository.getPastPurchases();
  }
}
