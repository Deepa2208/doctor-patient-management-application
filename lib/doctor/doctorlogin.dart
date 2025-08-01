import 'package:dpm/doctor/doctorpatientdetails.dart';
import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';
import 'doctorregister.dart';

class Doctorloginscreen extends StatefulWidget {
  const Doctorloginscreen({super.key});

  @override
  State<Doctorloginscreen> createState() => _DoctorloginscreenState();
}

class _DoctorloginscreenState extends State<Doctorloginscreen> {
  final _appwrite = AppwriteService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberme = false;
  bool obscurepassword = true;
  bool _isLoading = false;

  Future<void> _loginDoctor() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _appwrite.loginUser(
        _emailController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Successful")));
      // Navigate to Doctor Dashboard (replace with actual dashboard screen)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DoctorDashboard()));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed: $e")));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/doctorlogin.png', width: sw * 0.6),
            SizedBox(height: sh * 0.02),
            Text(
              "Doctor Login",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: sh * 0.02),

            // Email Field
            SizedBox(
              height: 60,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(fontSize: 18),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  suffixIcon: Icon(Icons.person, size: 24),
                ),
              ),
            ),
            SizedBox(height: sh * 0.02),

            // Password Field
            SizedBox(
              height: 60,
              child: TextField(
                controller: _passwordController,
                obscureText: obscurepassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(fontSize: 18),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurepassword ? Icons.visibility : Icons.visibility_off,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurepassword = !obscurepassword;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Remember Me and Forgot Password
            Row(
              children: [
                Checkbox(
                  value: rememberme,
                  onChanged: (value) {
                    setState(() {
                      rememberme = value ?? false;
                    });
                  },
                ),
                Text("Remember me"),
                Spacer(),
                TextButton(
                  onPressed: () {
                    // Implement Forgot Password functionality
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: sh * 0.01),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorPatientDetails(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),

            // Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New user? ", style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorRegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
