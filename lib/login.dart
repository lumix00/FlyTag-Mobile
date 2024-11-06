import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi/register.dart';
import 'package:pi/home.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
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
    double buttonWidth = MediaQuery.of(context).size.width * 0.7;
    double buttonWidth2 = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(192, 134, 206, 240),
            ),
          ),
          Positioned(
            child: SvgPicture.asset(
              'assets/nuvemBranca.svg',
              height: MediaQuery.of(context).size.height * 1,
              fit: BoxFit.contain,
              color: Color.fromARGB(192, 157, 218, 228),
            ),
          ),
          Positioned(
            child: SvgPicture.asset(
              'assets/nuvemSuperior.svg',
              height: MediaQuery.of(context).size.height * 0.2,
              // fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      'assets/nuvemBranca.svg',
                      fit: BoxFit.cover,
                      color: Color.fromARGB(255, 240, 240, 240),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(), // Adiciona um espaçamento flexível no topo
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Olá!",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              "Como deseja acessar?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 100, 100, 100),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Column(
                          children: [
                            // Botão de Entrar com Google
                            SizedBox(
                              width: buttonWidth,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Implementar login com Google
                                },
                                icon: const Icon(Icons.account_circle,
                                    color: Colors.lightBlue),
                                label: const Text("Entrar com Google"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  textStyle:
                                      const TextStyle(color: Colors.black87),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Botão de Entrar com Apple
                            SizedBox(
                              width: buttonWidth,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Implementar login com Apple
                                },
                                icon: const Icon(Icons.apple,
                                    color: Colors.lightBlue),
                                label: const Text("Entrar com Apple"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  textStyle:
                                      const TextStyle(color: Colors.black87),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Botão de Entrar com Microsoft
                            SizedBox(
                              width: buttonWidth,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Implementar login com Microsoft
                                },
                                icon: const Icon(Icons.account_circle,
                                    color: Colors.lightBlue),
                                label: const Text("Entrar com Microsoft"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  textStyle:
                                      const TextStyle(color: Colors.black87),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Botão de Entrar com E-mail
                            SizedBox(
                              width: buttonWidth,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                  );
                                },
                                icon: const Icon(Icons.email,
                                    color: Colors.lightBlue),
                                label: const Text("Entrar com E-mail"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  textStyle:
                                      const TextStyle(color: Colors.black87),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 16.0,bottom: 16.0), child: SizedBox(
                              width: buttonWidth2,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Register(
                                              backgroundImage: '',
                                            )),
                                  );
                                },
                                icon: const Icon(Icons.email,
                                    color: Colors.white),
                                label: const Text("Registrar-se"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  elevation: 5,
                                  shadowColor: Colors.black.withOpacity(0.9),
                                ),
                              ),
                            ),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
