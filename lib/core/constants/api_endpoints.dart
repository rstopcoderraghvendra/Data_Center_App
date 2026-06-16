class ApiEndpoints {
  static const baseUrl = 'http://192.168.1.9:8000';
 // static const baseUrl = 'http://datamaster.tech';
  static const login = '/api/v1/login';
  static const me = '/api/v1/me';
  static const logout = '/api/v1/logout';
  static const colonies = '/api/v1/colonies';
  static const setDefaultColony = '/api/v1/set-default-colony';
  static const profile = '/api/v1/profile';
  static const changePassword = '/api/v1/change-password';
  static const customers = '/api/v1/customers';
  static const sync = '/api/v1/sync';
  static const projects = '/api/v1/projects';
  static const authBillDetails = '/api/v1/auth-bill-details';
  static String projectById(int id) => '/api/v1/projects/$id';
  static String fetchCustomersByProjectId(int id) => '/api/v1/fetch-customers-for-mapping/$id';
  static String billDistributionCustomersByProjectId(int id) => '/api/v1/bill-distribution-customers/$id';
  static String billDistributionCustomersViewByCustomerId(int id) => '/api/v1/bill-distribution-customers/view/$id';
  static String billDistributionNextCustomerViewByCustomerId(int id) => '/api/v1/bill-distribution-customers/next-customer-view/$id';
  static String billDistributionPreviousCustomerViewByCustomerId(int id) => '/api/v1/bill-distribution-customers/previous-customer-view/$id';
  
  static String uploadCustomerSideViewImageByCustomerId(int id) => '/api/v1/bill-distribution-customers/upload-side-view-image/$id';

}
