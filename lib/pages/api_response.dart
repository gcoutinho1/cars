class ApiResponse<T> {
  bool working;
  String message;
  T result;

  ApiResponse.working({this.result, this.message}) {
    working = true;
  }

  ApiResponse.error({this.result, this.message}) {
    working = false;
  }
}
