class Strings{
  static bool testMode = true;
  static String testAddress = "http://192.168.1.13:8000";
  static String liveAddress = "https://medhasvinieducation.com";
  static String websiteAddress = testMode?testAddress:liveAddress;
  static String singInAPI = "$websiteAddress/api/user/login/";
  static String signUpAPI = "$websiteAddress/api/user/register/";
  static String profileAPI = "$websiteAddress/api/user/profile/";
  static String allCoursesAPI = "$websiteAddress/api/user/allCourse";
  static String allCoursesDeleteAPI = "$websiteAddress/api/user/allcourses";
  static String videosAPI = "$websiteAddress/api/user/video";
  static String validateReferralAPI = "$websiteAddress/api/payment/reffral_check/?referral_code=";
  static String stripeAPI = "https://api.stripe.com/v1/payment_intents";
  static String binaryTreeAPI = "$websiteAddress/api/payment/binarytree";
  static String paymentDoneAPI = "$websiteAddress/api/payment/";
  static String totalCommissionAPI = "$websiteAddress/api/payment/getcommission";
  // static String publishableTestKey = "pk_test_51LLkgrINeLgEu8OTfm8z1MSpZ9Ca7iOvplw1wt45vFLM3Yr4xxSTV5xJk5Jsk2nWBU5f686tk93lm6CayNs6s0Qp00ccoM1Lu9";
  // static String secretTestKey = "sk_test_51LLkgrINeLgEu8OTosPFfplXeIZL2TzBkO3AecEf6ys6iw0eWimKzNweJLXmtNAiD5CS9AumcrSf8ZCvtXrK0TQ700k9syQIbh";
  // static String publishableKey = "pk_live_51Ny7wfSDwhqjewtiPNdQ9L7JUcJZRs5A7tsk9ULNXDsOvPR1h0RYJvbr59WeGS3krHhY3z6QZolTos5pT11PRPTI00fp4TgJoh";
  // static String secretKey = "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";
  // static String publishableStripe = testMode?publishableTestKey:publishableKey;
  // static String secretStripe = testMode?secretTestKey:secretKey;
  static String forgotPasswordAPI = "$websiteAddress/api/user/send-reset-password-email/";
}