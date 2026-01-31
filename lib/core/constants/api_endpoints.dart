class ApiEndpoints {
  static const baseUrl = 'http://192.168.1.5:8000';
  //static const baseUrl = 'http://datacore.expensi.in';
  static const login = '/api/v1/login';
  static const me = '/api/v1/me';
  static const logout = '/api/v1/logout';
  static const profile = '/api/v1/profile';
  static const changePassword = '/api/v1/change-password';
  static const customers = '/api/v1/customers';
  static const sync = '/api/v1/sync';
  static const projects = '/api/v1/projects';
  static String projectById(int id) => '/api/v1/projects/$id';
}
