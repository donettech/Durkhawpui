import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);

  // final _paymentItems = [
  //   PaymentItem(
  //     label: 'Total',
  //     amount: '99.99',
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Durkhawpui app chungchang',
                style: GoogleFonts.quintessential(
                  fontSize: 30,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(text: "He app "),
                      TextSpan(
                        text: "'Durkhawpui'",
                        style: GoogleFonts.playfairDisplay(
                          color: Constants.primary,
                        ),
                      ),
                      TextSpan(text: " hi "),
                      TextSpan(
                        text: "DoNET Technology",
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.blue[800],
                        ),
                      ),
                      TextSpan(
                        text:
                            ' in a free in a siam ani a, Durtlang mipui ten khawchhung thu pawimawh awlsam leh chiangkuang zawk a an dawn theih na tur a duan ani.',
                      ),
                    ],
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      wordSpacing: 1.5,
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "He app source code hi MIT License hnuai ah Open source ani a, duh leh mamawh ten inlo hman ve phal ani,",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  wordSpacing: 1.5,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Project link"),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Chhawl hal min hnangfak sak duh tan a hnuai ami hi hmeh tur ani e",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  wordSpacing: 1.5,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Constants.primary,
                ),
                child: Text(
                  "Donate",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    wordSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
              //TODO gpay integrate
              // GooglePayButton(
              //   paymentConfigurationAsset:
              //       'default_payment_profile_google_pay.json',
              //   paymentItems: _paymentItems,
              //   style: GooglePayButtonStyle.black,
              //   type: GooglePayButtonType.pay,
              //   margin: const EdgeInsets.only(top: 15.0),
              //   onPaymentResult: onGooglePayResult,
              //   loadingIndicator: const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
  }
}
