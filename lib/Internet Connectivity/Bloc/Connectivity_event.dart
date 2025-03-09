// ConnectivityEvent.dart
abstract class ConnectivityEvent {}

class ConnectivityLostEvent extends ConnectivityEvent {}

class ConnectivityGainEvent extends ConnectivityEvent {}


class ConnectivityCheckEvent extends ConnectivityEvent {}
