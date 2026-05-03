sealed class ResultState {}

class Loading extends ResultState {}

class HasData<T> extends ResultState {
  final T data;
  HasData(this.data);
}

class Error extends ResultState {
  final String message;
  Error(this.message);
}