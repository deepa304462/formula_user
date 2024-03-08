import 'package:dartz/dartz.dart';
import 'package:formula_user/core/error/exception.dart';
import 'package:formula_user/core/usecase/usecase.dart';
import 'package:formula_user/data/repositories/subscription_repository.dart';

class InitializeSubscription extends UseCase<dynamic, NoParam> {
  final SubscriptionRepository repository;
  InitializeSubscription(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(NoParam params) {
    return repository.initializeSubscription();
  }
}
