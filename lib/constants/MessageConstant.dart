import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class MessageConstant {
  //ERROR MESSAGE
  static const String CONNECTION_NOT_AVAILABLE_ERROR =
      "Please check your internet connection."; //

  static const String FEED_IS_DELETED = "Author has deleted the shared post.";
  static const String IMAGE_SOURCE_IS_INCORRECT_ERROR =
      "Image source is incorrect, please select from other location."; //
  static const String CONNECTION_INACTIVE_ERROR =
      "Your connection is inactive"; //
  static const String ACCESS_PROFILE_REVOKED_ERROR =
      "Your access on this profile has revoked.";
  static const String SORRY_OVER_18_BECOME_PARENT_ERROR =
      "Sorry, you need to be over 18 to become a Parent.";
  static const String SORRY_OVER_13_BECOME_PARTNER_ERROR =
      "Sorry, you need to be over 13 to become a partner.";
  static const String
      PARTNER_NOT_ALLOWED_CONNECTON_REQUEST_SPIKEVIEW_USERS_ERROR =
      "Partners are not allowed to send connection requests to spikeview users.";
  static const String PENDING_PROFILE_ACTIVATION_BY_PARENT_ERROR =
      "Your profile is pending activation by your parent. Please follow up with them.";
  static const String SOMETHING_WENT_WRONG_ERROR = 'Something went wrong!!';
  static const String AUTHORIZED_ACCESS_RECOMMENDATON_ERROR =
      "Sorry, you are not authorized to access this recommendation.";
  static const String NOT_AUTHORIZED_ACCESS_OUTSIDE_ACCOMPLISHMENT =
      "Sorry, you are not authorized to access this feature.";
  static const String WRITE_SOMETHING_ERROR = "Please write something.";
  static const String VIDEO_SOURCE_INCORRECT_ERROR =
      "Video source is incorrect, please select from other location.";
  static const String SELECT_PROBLEM_CONTINUE_ERROR =
      "Please select a problem to continue.";
  static const String NEED_OVER_18_BECOME_PARENT_ERROR =
      "Sorry, you need to be over 18 to become a parent.";

  //SUCCESS MESSAGE
  static const String SUCCESSFULLY_SEND_RECOMMENDATION_REQUEST_SUCCESS =
      "Nice work! You have successfully done something that makes you great and your recommendation request has been sent.";

  static const String SUCCESSFULLY_DONE_SOMETHING_SUCCESS =
      "Nice Work! You’ve successfully done something that makes you great.";

  static const String SUCCESSFULLY_UPDATE_MANAGE_OFFERING_SUCCESS =
      "Manage offering updated successfully.";

  //VALIDATION MESSAGE
  static const String SELECT_COMPETENCY_VAL = "Please select a competency.";
  static const String SELECT_SKILLS_VAL = "Please select applicable skills.";
  static const String SELECT_ACHIEVEMENT_LEVEL_VAL =
      "Please select achievement level.";
  static const String SELECT_FROM_DATE_VAL = "Please select \"from date\".";
  static const String SELECT_TO_DATE_VAL = "Please select \"to date\".";

  static const String ENTER_TITLE_VAL = 'Please enter title.';
  static const String ENTER_RECOMMENDATION_TITLE_VAL =
      "Please enter recommendation title";
  static const String ENTER_FIRST_NAME_VAL = "Please enter first name.";
  static const String FIRST_NAME_CONTAINS_ALPHABET_VAL =
      'First name can only contain alphabets.';
  static const String ENTER_LAST_NAME_VAL = "Please enter last name.";
  static const String LAST_NAME_CONTAINS_ALPHABET_VAL =
      'Last name can only contain alphabets.';
  static const String ENTER_EMAIL_VAL = "Please enter email.";
  static const String VALID_EMAIL_VAL = 'Please enter valid email.';
  static const String ENTER_DESCRIPTION_VAL = 'Please enter description.';
  static const String ENTER_PHONE_NUMBER_VAL = "Please Enter phone number";

  static const String ENTER_CORRECT_DATE_RANGE_VAL =
      "Please enter the correct date range.";
  static const String MAXIMUM_10_IMAGE_UPLOADED_VAL =
      "Maximum 10 images can be uploaded.";
  static const String MAXIMUM_8_IMAGE_UPLOADED_VAL =
      "Maximum 8 images can be uploaded.";
  static const String ENTER_VALUE_ACCOMPLISHMENT_FIELD_VAL =
      "A field(s) value has been left blank. Enter the value in Accomplishment field(s) before proceeding.";

  static const String REQUIRED_FIRST_NAME_VAL = 'First Name required';
  static const String REQUIRED_LAST_NAME_VAL = 'Last Name required';
  static const String ENTER_VALID_PHONE_NUMBER_VAL =
      'Please enter a valid phone number';
  static const String ENTER_VALID_EMAIL_VAL = 'Enter Valid Email';
  static const String ENTER_COMPANY_NAMEL_VAL = 'Please enter the company name';
  static const String ENTER_COMPANY_ADDRESS_VAL =
      'Please enter the company address';
  static const String ENTER_VALID_WEBSITE_URL_VAL =
      "Please enter a valid website url";
  static const String ENTER_WEB_URL_VAL = "Please Enter WebUrl";
  static const String ENTER_VALID_DOC_URL_VAL = 'Please enter a valid Doc url';
  static const String ENTER_SOMETHING_ABOUT_COMPANY_VAL =
      'Please enter something about your company';
  static const String ENTER__ABOUT_COMPANY_VAL =
      "Please Enter About Your Compnay";
  static const String ENTER_JOB_TITLE_VAL = 'Please enter job title';
  static const String ENTER_SERVICE_TITLE_VAL = 'Please enter service title';
  static const String ENTER_JOB_TYPE_VAL = 'Please enter job type';
  static const String REQUIRED_SERVICE_DESCRIPTION_VAL =
      'Service description required';
  static const String ENTER_JOB_LOCATION_VAL = 'Please enter job location';
  static const String DESCRIBE_ROLE_VAL = 'Please describe the role';
  static const String REQUIRED_DURATION_VAL = 'Duration required';
  static const String REQUIRED_STATUS_VAL = 'Status required';
  static const String REQUIRED_TITLE_VAL = 'Title required';
  static const String REQUIRED_DISPLAY_VAL = 'Text To Display Required';
  static const String REQUIRED_FROM_AGE_VAL = 'Age From required';
  static const String REQUIRED_TO_AGE_VAL = 'Age To required';
  static const String REQUIRED_INTEREST_VAL = 'Interest required';
  static const String REQUIRED_GROUP_NAME_VAL = 'Group Name required';
  static const String REQUIRED_GROUP_ABOUT_VAL = 'About Group required';
  static const String REQUIRED_OTHER_INFORMATION_VAL =
      'Other Information required';
  static const String ENTER_EXPIRATION_DATE_VAL =
      'Please enter expiration Date';
  static const String ENTER_EXPIRATION_DATE_BETWEEN_VAL =
      'Please select date between the scheduled date.';
  static const String SELECT_ATLEAST_ONE_SECTON_VAL =
      'Select atleast one action';

  static const String ENTER_INSTITUTE_NAME_VAL = 'Please enter institute name.';
  static const String SELECT_GRADE_FROM_VAL = "Please select from grade";
  static const String TO_GRADE_LESS_THAN_FROM_GRADE_VAL =
      "To grade should not be less than from grade";
  static const String FROM_GRADE_LESS_THAN_TO_GRADE_VAL =
      "From grade should  be smaller than to grade";
  static const String SELECT_GRADE_TO_VAL = "Please select grade (to)";
  static const String ENTER_CITY_VAL = 'Please enter city.';
  static const String SELECT_GRAD_VAL = 'Please select grade.';
  static const String SELECT_YEAR_VAL = "Please select year.";
  static const String REVIEW_CONFIRM_DATE_VAL =
      "Please review and confirm the dates below.";
  static const String DONT_THINK_YOU_MAKE_TENURE_VAL =
      "Don't think, you can make it in this tenure.";
  static const String ALREADY_ADDED_ALL_GRADE_VAL =
      "You have already added all grades";
  static const String VIDEO_UPLOAD_NOT_SUPPORT_VAL =
      "Video uploads are not yet supported. Please upload an image instead.";
  static const String REQUIRED_MIN_1_STUDENT_VAL =
      "Minimum 1 student required.";

  static const String ENTER_PASSWORD_VAL = "Please enter password";
  static const String ENTER_CURRENT_PASSWORD_VAL =
      "Please enter current password";
  static const String ENTER_TEMPORARY_PASSWORD_VAL =
      "Please enter temporary password";
  static const String ENTER_CORRECT_CURRENT_PASSWORD_VAL =
      "Please enter current password";
  static const String ENTER_NEW_PASSWORD_VAL = "Please enter new password";
  static const String ENTER_CONFIRM_PASSWORD_VAL =
      "Please enter confirm password";
  static const String PASSWORD_SHOULD_8_CHARACTER_VAL =
      'Your new password should be at least 8 characters, contain one capital letter, one small letter, one special character and one number.';

  static const String INVALID_FILE_FORMAT_VAL =
      "Invalid file format, please select .pdf files";
  static const String MAX_5_DOC_UPLOADED_VAL =
      "Maximum 5 documents can be uploaded.";
  static const String MAX_10_IMAGE_VIDEO_UPLOADED_VAL =
      "Maximum 10 images or video can be uploaded.";
  static const String MAX_5_LINK_UPLOADED_VAL =
      "Maximum 5 link can be uploaded.";
  static const String MIN_1_OFFERING_SELECTED_VAL =
      "Minimum 1 offering selected";
  static const String SELECT_1_PHOTO_VIDEO_VAL = 'Select one photo or video.';
  static const String REQUIRED_FILL_ALL_FIELD_VAL =
      "Please fill all required field.";

  static const String ENTER_CORRECRT_EMAIL_VAL =
      'Please enter the correct email.';
  static const String SELECT_DOB_VAL = 'Please select date of birth.';
  static const String SELECT_DATE_TAKEN_VAL = 'Please select date of taken.';
  static const String SELECT_GENDER_VAL = "Please select gender.";
  static const String ENTER_STUDENT_FIRST_NAME_VAL =
      "Please enter student first name.";
  static const String ENTER_STUDENT_LAST_NAME_VAL =
      "Please enter student last name.";
  static const String STUDENT_FIRST_NAME_CONTAIN_ALPHABET_VAL =
      'Student First name can only contain alphabets.';
  static const String STUDENT_LAST_NAME_CONTAIN_ALPHABET_VAL =
      'Student Last name can only contain alphabets.';
  static const String ENTER_VALID_ZIP_CODE_VAL = "Please enter valid zipcode.";
  static const String STUDENT_PARENT_EMAIL_CANNOT_SAME_VAL =
      "Student and parent email cannot be the same.";

  static const String ENTER_PARENT_EMAIL_VAL = "Please enter parent email.";
  static const String ENTER_PARENT_FIRST_NAME_VAL =
      "Please enter parent first name.";
  static const String ENTER_PARENT_LAST_NAME_VAL =
      "Please enter parent last name.";
  static const String PARENT_FIRST_NAME_CONTAIN_ALPHABET_VAL =
      'Parent First name can only contain alphabets.';
  static const String PARENT_LAST_NAME_CONTAIN_ALPHABET_VAL =
      'Parent Last name can only contain alphabets.';

  static const String ENTER_GROUP_NAME_VAL = 'Please enter group name.';
  static const String ENTER_MIN_3_CHAR_VAL =
      "Please insert minimum 3 character";
  static const String ENTER_GROUP_MOTIVE_VAL = 'Please enter group motive';
  static const String SELECT_STUDENT_VAL = "Please select student.";
  static const String ENTER_NAME_VAL = "Please enter name.";
  static const String NAME_CONTAIN_ALPHABT_VAL =
      'Name can only have alphabets.';
  static const String ENTER_CORRECT_INPUT_VAL =
      "Please Enter Correct Input here";
  static const String ENTER_MESSAGE_VAL = "Please Enter message";
  static const String INSERT_LINK_VAL = "Please insert link";
  static const String SELECT_TYPE_OF_CALL_TO_ACTION_VAL =
      'Please select the type of call to action: This shows up as a button next to your opportunity posting.';

  static const String CREATE_GROUP_VAL = "Please create a group";
  static const String SELECT_GROUP_VAL = "Please select a group";
  static const String ENTER_NUMBER_VAL = "Please enter number";
  static const String ADD_MEMBERS_VAL = "Please add members.";

  static const String REMOVE_LEARN_MORE_LINK_VAL =
      'Are you sure you want to remove learn more link?';
  static const String REMOVE_GET_OFFER_LINK_VAL =
      'Are you sure you want to remove get offer link?';
  static const String REMOVE_APPLY_NOW_LINK_VAL =
      'Are you sure you want to remove apply now link?';
  static const String REMOVE_NEW_GROUP_AND_ADD_EXISTING_GROUP_VAL =
      'Are you sure you want to remove new group and add existing group?';
  static const String REMOVE__EXISTING_GROUP_AND_CREATE_NEW_GROUP_VAL =
      'Are you sure you want to remove existing group and create new group?';

  static const String ENTER_DURATION_VAL = 'Please enter duration.';
  static const String ENTER_STATUS_VAL = 'Please enter status.';
  static const String ENTER_REASON_VAL = 'Please enter reason';
  static const String SELECT_ATLEAST_1_GROUP_TO_SHARE_VAL =
      "Please select atleast one group to share.";
  static const String CREATE_1_GROUP_TO_SHARE_VAL =
      "Please create one group to share.";
  static const String SELECT_PARENT_GENDER_VAL = "Please select parent gender.";
  static const String STUDENT_MUST_HAVE_1_PARENT_ATTACHED_VAL =
      "Being a minor, student must need at least one parent attached with.";
  static const String SELF_SHARE_NOT_GOOD_IDEA =
      "Self share is not a good idea.";
  static const String SELF_RECOMMENDATION_NOT_GOOD_IDEA =
      "Self recommendation is not a good idea.";
  static const String ENTER_REQUEST_VAL = 'Please enter request.';

  static const String ENTER_RECOMMENDER_TITLE_VAL =
      'Please enter recommender title.';

  static const String RATE_OUR_SERVICE = 'Please rate our service.';

  static const String BADGE_VALIDATION =
      'Provide details about your qualification for the badge being requested.';
  static const String EMAIL_VALIDATION = 'Your own email is not allowed.';
}
