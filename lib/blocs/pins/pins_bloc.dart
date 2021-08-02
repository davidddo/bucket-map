part of blocs.locations;

class PinsBloc extends Bloc<PinEvent, PinsState> {
  PinsBloc({
    @required AuthenticationRepository authRepository,
    @required PinsRepository pinsRepository,
  })  : _authRepository = authRepository,
        _pinsRepository = pinsRepository,
        super(PinsUninitialized()) {
    _authSubscription = _authRepository.user.listen((user) {
      add(LoadPins(user.id));
    });
  }

  final AuthenticationRepository _authRepository;
  final PinsRepository _pinsRepository;

  StreamSubscription _authSubscription;
  StreamSubscription _pinsSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _pinsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<PinsState> mapEventToState(PinEvent event) async* {
    if (event is LoadPins) {
      yield* _mapLoadPinsToState(event);
    } else if (event is AddPin) {
      yield* _mapAddPinToState(event);
    } else if (event is UpdatePin) {
      yield* _mapUpdatePinToState(event);
    } else if (event is RemovePin) {
      yield* _mapRemovePinToState(event);
    } else if (event is PinsUpdated) {
      yield* _mapPinsUpdatedToState(event);
    }
  }

  Stream<PinsState> _mapLoadPinsToState(LoadPins event) async* {
    final userId = _authRepository.currentUser.id;
    _pinsSubscription = _pinsRepository.pins(userId).listen((pins) {
      add(PinsUpdated(pins));
    });
  }

  Stream<PinsState> _mapAddPinToState(AddPin event) async* {
    final userId = _authRepository.currentUser.id;
    _pinsRepository.addLocation(event.pin.copyWith(userId: userId));
  }

  Stream<PinsState> _mapUpdatePinToState(UpdatePin event) async* {
    _pinsRepository.updateLocation(event.pin);
  }

  Stream<PinsState> _mapRemovePinToState(RemovePin event) async* {
    _pinsRepository.deleteLocation(event.pin);
  }

  Stream<PinsState> _mapPinsUpdatedToState(PinsUpdated event) async* {
    yield PinsLoaded(event.pins);
  }
}