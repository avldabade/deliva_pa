import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void call(String number) {
    print('inside call , number:: $number');
    launch("tel://$number");
  }

  void sendSms(String number) {
    print('inside sendSms, number:: $number');
    launch("sms:$number");
  }

  Future sendEmail(String email) {
    print('inside sendEmail , number:: $email');
    launch("mailto:$email");
  }
}