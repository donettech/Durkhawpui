import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DinhmunCard extends StatelessWidget {
  const DinhmunCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'Durkhawpui Covid-19 Dinhmun',
              style: GoogleFonts.ebGaramond(fontSize: 20),
            ),
            SizedBox(
              height: 2,
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Dam tawh',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Vei mek",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Boral tawh",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '50',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "4",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "2",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
