class ApiResponse<T> {
  bool working;
  String message;
  T result;

  ApiResponse.working(this.result) {
    working = true;
  }

  ApiResponse.error(this.message) {
    working = false;
  }
}
