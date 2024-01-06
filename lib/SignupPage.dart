import 'dart:convert';  // Add this import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Add this import
import 'HomeScreen.dart';
import 'LoginPage.dart';
// import 'LoginPage.dart';
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  GlobalKey<FormState> _frmkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body:
        SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: Container(
                      padding: EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            // Set the shadow color
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // Offset of the shadow
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                          maxWidth: 350.0, maxHeight: 667.0),
                      child: Form(
                        key: _frmkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("SignUp", style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                            SizedBox(height: 30,),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'enter your email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              // Set the keyboard type to email
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'enter your password',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'enter your Full Name',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your First Name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                hintText: 'enter your Phone Number',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Phone number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                hintText: 'enter your Address',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            Row(children: [
                              SizedBox(width: 170,),
                              ElevatedButton(
                                onPressed: () {
                                  if (_frmkey.currentState?.validate() ??
                                      false) {
                                    signUpUser(
                                      _emailController.text,
                                      _passwordController.text,
                                      _fullNameController.text,
                                      _addressController.text,
                                      _phoneNumberController.text,

                                    );
                                  } else {
                                    // Show Snackbar if fields are empty
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please fill in all fields'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Sign Up'),
                              ),
                            ]),
                            SizedBox(height: 5),
                            Row(
                                children: [
                                  Text("Already have an account? ",
                                      style: TextStyle(fontSize: 12)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                      );
                                    },
                                    child: Text('Login',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ],
                        ),
                      ),
                    )
                )
            )
        )

    );
  }

  void signUpUser(String email, String password, String fullName,
      String address, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('http://10.0.0.15/food/signup.php'),
      body:{
        'email': email,  // Update to match your server parameter name
        'password': password,
        'full_name': fullName,
        'address': address,
        'phone_number': phoneNumber,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('success')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
          ),
        );

        // If signup is successful, navigate to the home screen or any other page.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (data.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['error']),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to connect to the server. Please try again later.'),
        ),
      );
    }
  }
}
