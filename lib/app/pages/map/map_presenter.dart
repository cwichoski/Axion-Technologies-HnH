import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:hnh/domain/usecases/location_track_usecase.dart';

class MapPresenter extends Presenter {
  late Function locationOnNext;
  late Function locationOnComplete;
  late Function locationOnError;

  late LocationTrackUseCase _locationTrackUseCase;

  MapPresenter(locationRepository, weatherRepository) {
    _locationTrackUseCase = LocationTrackUseCase(locationRepository, weatherRepository);
  }

  void startTrackingLocation() => _locationTrackUseCase.execute(_LocationTrackObserver(this));

  void dispose() => _locationTrackUseCase.dispose();
}

class _LocationTrackObserver implements Observer<LocationTrackResponse> {
  MapPresenter _mapPresenter;
  _LocationTrackObserver(this._mapPresenter);

  void onNext(response) {
    assert(_mapPresenter.locationOnNext != null);
    _mapPresenter.locationOnNext(response.location, response.weather);
  }

  void onComplete() {
    assert(_mapPresenter.locationOnComplete != null);
    _mapPresenter.locationOnComplete();
  }

  void onError(e) {
    assert(_mapPresenter.locationOnError != null);
    print(e);
    _mapPresenter.locationOnError(e);
  }
}
