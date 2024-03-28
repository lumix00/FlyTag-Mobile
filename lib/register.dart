import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final String backgroundImage;

  const Register({required this.backgroundImage});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  // Variables to store user input
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _zipcodeController;
  DateTime? _selectedDate; // Variable to store selected date

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _zipcodeController = TextEditingController();
    _selectedDate = DateTime.now(); // Initialize with the current date
  }

  // Common method for login and registration logic
  void _performAuthLogic() {
    // Your authentication logic here
    // Access user input using _nameController.text, _emailController.text, etc.
    // Access selected date using _selectedDate
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height, // Full height of the screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // New TextFormFields for registration details
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                          : "Select your date of birth",
                    ),
                    decoration: const InputDecoration(
                      labelText: "Date of Birth",
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // TextFormField for CEP
                  TextFormField(
                    controller: _zipcodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: "CEP",
                      hintText: "Enter your ZIP code",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate back to login
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Cancel"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _performAuthLogic(); // Perform registration logic
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Register"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _zipcodeController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
