import 'package:dartz/dartz.dart';
import 'package:formula_user/core/error/exception.dart';
import 'package:formula_user/core/usecase/usecase.dart';
import 'package:formula_user/data/repositories/subscription_repository.dart';

class CheckSubscriptionReadyStatus extends UseCase<int, NoParam> {
  SubscriptionRepository repository;
  CheckSubscriptionReadyStatus(this.repository);
  @override
  Future<Either<Failure, int>> call(NoParam params) {
    return repository.checkSubscriptionReadyStatus();
  }
}
