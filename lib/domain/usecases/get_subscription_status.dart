import 'package:dartz/dartz.dart';
import 'package:formula_user/core/error/exception.dart';
import 'package:formula_user/core/usecase/usecase.dart';
import 'package:formula_user/data/repositories/subscription_repository.dart';
import 'package:formula_user/presentation/subscription/model/subscription_state_res.dart';

class GetSubscriptionStatus
    extends UseCase<SubscriptionStateResponse, GetSubscriptionStatusParam> {
  SubscriptionRepository repository;
  GetSubscriptionStatus(this.repository);
  @override
  Future<Either<Failure, SubscriptionStateResponse>> call(
      GetSubscriptionStatusParam params) {
    return repository.getSubscriptionStatus(params.productId);
  }
}

class GetSubscriptionStatusParam extends NoParam {
  final String productId;
  GetSubscriptionStatusParam(this.productId);

  @override
  List<Object?> get props => [productId];

  @override
  bool? get stringify => true;
}
