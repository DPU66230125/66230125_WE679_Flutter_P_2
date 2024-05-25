class APIResponse{
  bool? success;
  dynamic data;

  APIResponse({required this.success, required this.data});

  APIResponse.fromResponse(Map<String, dynamic> response){
    success = response["success"] ?? false;
    data = response['data'];
  }
}