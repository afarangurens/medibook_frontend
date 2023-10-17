import 'package:flutter/material.dart';
// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:graphql/client.dart';
import 'success_login.dart';
import 'unsuccessful_login.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future register() async {
    final HttpLink httpLink = HttpLink(
      'http://172.26.64.1:5000/graphql', // Your GraphQL endpoint
    );

    final Link link = httpLink;
    // ignore: prefer_const_declarations
    final String loginMutation = """
     mutation CreateUser(\$email: String!, \$password: String!) {
        createUser(user: { email: \$email, password: \$password }) {
          status {
            code
            message
          }
        }
      }
    """;
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );

    final MutationOptions options = MutationOptions(
      document: gql(loginMutation),
      variables: {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotSuccessfulLoginView()),
      );
    } else {
      final responseData = result.data;

      if (responseData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessView(),
          ),
        );
      } else {
        print("IIIIIIIIIISSSSSSSSSS THIIIIIS WORKIIIIING");
      }

      // Redirect to the successful login view or perform other actions.
    }
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // TITLE
            children: [
              Text(
                'Medibook',
                style: GoogleFonts.bebasNeue(fontSize: 52),
              ),
              SizedBox(height: 10),
              // SUB TITLE
              Text(
                'Crea una cuenta',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              // EMAIL
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Correo',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // PASSWORD
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true, // To hide the password
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // PASSWORD CONFIRMATION
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: true, // To hide the password
                  decoration: InputDecoration(
                    hintText: 'Confirmar Contraseña',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // LOGIN BUTTON
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: register,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // REGISTER BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Ya tienes cuenta?'),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Inicia sesión',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
