class SaveResult {
  bool isSuccess;
  String? errorMessage;

  SaveResult(this.isSuccess, this.errorMessage);

  factory SaveResult.fromMap(Map<String, dynamic> json) {
    return SaveResult(json['isSuccess'], json['errorMessage']);
  }

  @override
  String toString() {
    return 'SaveResult{isSuccess: $isSuccess, errorMessage: $errorMessage}';
  }
}
