import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:graphql/client.dart';
import 'success_login.dart';
import 'unsuccessful_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Login http request
  /*
  Future login() async {
    final url = Uri.parse('https://c8e6-181-235-179-127.ngrok-free.app/login');
    final body = {
      "user": {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      }
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
    } else {
      print('No pudiste entrar jkejexd');
    }
  }
  */
  // Login GraphQL
  Future login() async {
    final HttpLink httpLink = HttpLink(
      'http://172.26.64.1:5000/graphql', // Your GraphQL endpoint
    );

    final Link link = httpLink;
    // ignore: prefer_const_declarations
    final String loginMutation = """
      mutation Login(\$email: String!, \$password: String!) {
        loginUser(user: { email: \$email, password: \$password }) {
          status {
            code
            message
            data {
              user {
                id
                email
              }
              token
            }
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
                'Login',
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
              // LOGIN BUTTON
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: login,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(
                      'Iniciar Sesión',
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
                  Text('¿No tienes cuenta?'),
                  Text(
                    'Crea una',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
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
