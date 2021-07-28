import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:hnh/domain/entities/user.dart';
import 'package:hnh/domain/usecases/get_current_user_usecase.dart';
import 'package:hnh/domain/usecases/get_all_events_usecase.dart';
import 'package:hnh/domain/entities/event.dart';

class EventsPresenter extends Presenter {
  late Function getUserOnNext;
  late Function getUserOnComplete;
  late Function getUserOnError;

  late Function getEventsOnNext;
  late Function getEventsOnComplete;
  late Function getEventsOnError;

  late GetCurrentUserUseCase _getCurrentUserUseCase;
  late GetAllEventsUseCase _getAllEventsUseCase;

  EventsPresenter(authenticationRepository, eventRepository) {
    _getCurrentUserUseCase = GetCurrentUserUseCase(authenticationRepository);
    _getAllEventsUseCase = GetAllEventsUseCase(eventRepository);
  }

  void dispose() {
    _getCurrentUserUseCase.dispose();
    _getAllEventsUseCase.dispose();
  }

  void getUser() => _getCurrentUserUseCase.execute(_GetUserUseCaseObserver(this));
  void getAllEvents()  => _getAllEventsUseCase.execute(_GetAllEventsObserver(this));
}


class _GetUserUseCaseObserver implements Observer<User> {
  EventsPresenter _eventPresenter;

  _GetUserUseCaseObserver(this._eventPresenter);

  void onNext(user) {
    // any cleaning or preparation goes here before invoking callback
    assert(user is User);
    _eventPresenter.getUserOnNext(user);
  }

  void onComplete() {
    // any cleaning or preparation goes here
    assert(_eventPresenter.getUserOnComplete != null);
    _eventPresenter.getUserOnComplete();
    
  }

  void onError(e) {
    // any cleaning or preparation goes here
    assert(_eventPresenter.getUserOnError != null);
    _eventPresenter.getUserOnError(e);
    
  }
}

class _GetAllEventsObserver implements Observer<List<Event>> {
  EventsPresenter _eventPresenter;

  _GetAllEventsObserver(this._eventPresenter);

  void onNext(events) {
    // any cleaning or preparation goes here before invoking callback
    assert(events is List<Event>);
    assert(_eventPresenter.getEventsOnNext != null);
    List<Event> featured = events.where((event) => event.isFeatured).toList();
    featured.sort((event1, event2) => event1.isRace ? 0 : 1);
    List<Event> upcoming = events.where((event) => !event.isFeatured).toList();
    upcoming.sort((event1, event2) => event1.route.length.compareTo(event2.route.length));
    _eventPresenter.getEventsOnNext(featured, upcoming);
  }

  void onComplete() {
    // any cleaning or preparation goes here
    assert(_eventPresenter.getEventsOnComplete != null);
    _eventPresenter.getEventsOnComplete();
    
  }

  void onError(e) {
    // any cleaning or preparation goes here
    assert(_eventPresenter.getEventsOnError != null);
    _eventPresenter.getEventsOnError(e);
    
  }
}