import 'package:flutter/material.dart';

import 'package:country_code_picker/country_code_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String dialDigits = "";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: const Center(
                child: Text(
                  "Phone Authentication",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            CountryCodePicker(
              onChanged: (country) {
                setState(() {
                  dialDigits = country.dialCode!;
                });
              },
              initialSelection: "IN",
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              favorite: const ["IN", "US"],
            ),
            const SizedBox(height: 50.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    prefix: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(dialDigits),
                    ),
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: _controller,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            Container(
              margin: const EdgeInsets.all(25.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Verify",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
