import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi/register.dart';
import 'package:pi/home.dart';

class Login extends StatefulWidget {
  final String backgroundImage;

  const Login({super.key, required this.backgroundImage});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _performLogin() async {
    // Criar o objeto FormData
    final formData = {
      'email': _emailController.text,
      'senha': _passwordController.text,
      'grupo': 'cliente', // ou 'funcionario', dependendo do seu caso
    };

    // Enviar dados para o servidor Flask
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:5000/login'), // replace with your actual endpoint
      body: formData,
    );

    // Tratar a resposta do servidor
    if (response.statusCode == 200) {
      // Login bem-sucedido
      print('Login bem-sucedido: ${response.body}');
    } else {
      // Algo deu errado
      print('Falha no login. Status code: ${response.statusCode}');
    }
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _emailController.text = value;
                        });
                      },
                      validator: (value) {
                        return value!.isEmpty ? "Email is empty" : null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _passwordController.text = value;
                        });
                      },
                      validator: (value) {
                        return value!.isEmpty ? "Password is empty" : null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // _performLogin();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Home()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("Login"),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(
                                  backgroundImage: widget.backgroundImage,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
        ],
      ),
    );
  }
}
