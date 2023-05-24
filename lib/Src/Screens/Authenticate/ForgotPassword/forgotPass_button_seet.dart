import 'package:alqgp/Src/Screens/Authenticate/ForgotPassword/forgotPass_button_widget.dart';
import 'package:alqgp/Src/Services/auth_repo.dart';
import 'package:alqgp/Src/Utils/Consts/consts.dart';
import 'package:alqgp/Src/Utils/Consts/text.dart';
import 'package:alqgp/Src/controllers/otp_controller.dart';
import 'package:alqgp/Src/controllers/otp_email_controller.dart';
import 'package:alqgp/Src/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgotPass_OTP.dart';
import 'forgotPass_email.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(
      BuildContext? context, String phoneNo, String email) {
    final controller = Get.put(SignUpController());
    OTPemailController oTPemailController = Get.put(OTPemailController());

    return showModalBottomSheet(
      context: context!,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tForgetPasswordTitle,
                style: Theme.of(context).textTheme.headline3),
            Text(tForgetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodyText2),
            const SizedBox(height: 30.0),
            ForgetPasswordBtnWidget(
              onTap: () {
                Navigator.pop(context);
                oTPemailController.sendOTP(email);
                // Get.to(() => OTPScreen(phone: email, isMail: true));
                // Get.to(() => const ForgetPasswordMailScreen());
              },
              title: tEmail,
              subTitle: tResetViaEMail,
              btnIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 20.0),
            ForgetPasswordBtnWidget(
              onTap: () {
                Navigator.pop(context);
                AuthenticationRepository.instance.phoneAuthentication(phoneNo);
                // Get.to(() => OTPScreen(phone: phoneNo, isMail: false));
              },
              title: tPhoneNo,
              subTitle: tResetViaPhone,
              btnIcon: Icons.mobile_friendly_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
