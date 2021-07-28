import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:hnh/domain/usecases/auth/get_authentication_status_usecase.dart';

class SplashPresenter extends Presenter {
  late Function getAuthStatusOnNext;
  late Function getAuthStatusOnComplete;

  late GetAuthStatusUseCase _getAuthStatusUseCase;

  SplashPresenter(authRepo) {
    _getAuthStatusUseCase = GetAuthStatusUseCase(authRepo);
  }

  void getAuthStatus() => _getAuthStatusUseCase.execute(_SplashObserver(this));
  void dispose() => _getAuthStatusUseCase.dispose();
}

class _SplashObserver implements Observer<bool> {
  SplashPresenter _splashPresenter;
  _SplashObserver(this._splashPresenter);

  void onNext(isAuth) {
    assert (_splashPresenter.getAuthStatusOnNext != null);
    _splashPresenter.getAuthStatusOnNext(isAuth);
  }

  void onComplete() {
    assert (_splashPresenter.getAuthStatusOnComplete != null);
    _splashPresenter.getAuthStatusOnComplete();
  }

  void onError(e) {
    // if any errors occured, proceed as if the user is not logged in
    assert (_splashPresenter.getAuthStatusOnNext != null);
    _splashPresenter.getAuthStatusOnNext(false);
    onComplete();
  }
}
