import 'package:hnh/domain/entities/event.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:hnh/domain/usecases/get_user_events_usecase.dart';
import 'package:meta/meta.dart';

class UserEventsPresenter extends Presenter {

  late Function getUserEventsOnNext;
  late Function getUserEventsOnComplete;
  late Function getUserEventsOnError;

  late GetUserEventsUseCase _getUserEventsUseCase;

  UserEventsPresenter(eventRepo) {
    _getUserEventsUseCase = GetUserEventsUseCase(eventRepo);
  }

  void dispose() {
    _getUserEventsUseCase.dispose();
  }

  void getUserEvents({@required String uid}) {
    _getUserEventsUseCase.execute(_GetUserEventsObserver(this), GetUserEventsUseCaseParams(uid));
  }
}


class _GetUserEventsObserver implements Observer<List<Event>> {
  UserEventsPresenter _eventPresenter;
  _GetUserEventsObserver(this._eventPresenter);
  
  void onNext(events) {
    assert(_eventPresenter.getUserEventsOnNext != null);
    _eventPresenter.getUserEventsOnNext(events);
  }

  void onComplete() {
    assert(_eventPresenter.getUserEventsOnComplete != null);
    _eventPresenter.getUserEventsOnComplete();
  }

  void onError(e) {
    assert(_eventPresenter.getUserEventsOnError != null);
    _eventPresenter.getUserEventsOnError(e);
  }
}
