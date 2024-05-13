import "package:flutter/material.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

void loginUser(){
  print('Login Successful');
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView( // Wrap with SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Let\'s you sign in!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.deepPurple,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      'You\'ve been missed!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.deepPurple,
                      ),
                    )
                  ],
                ),
                Container(
                  child: Image.network('https://img.freepik.com/free-vector/my-password-concept-illustration_114360-4294.jpg?w=740&t=st=1715519845~exp=1715520445~hmac=15446596c1cd2c30f44e7244bded01965bd17b283488e0656e5be8384bcb5220',),
                  
                ),
                TextField(
                  onChanged: (value) {
                      print('value: $value');
                  },
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                      print('value: $value');
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
               ElevatedButton(
                  onPressed: loginUser,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),

                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),

                GestureDetector(
                  onDoubleTap: () {
                    print("DoubleTap");
                  },
                  onTap: () {
                    print('onTap');
                  },
                  onLongPress: () {
                    print('LongPress');
                  },
                  child: Column(
                    children: [
                      Text('LinkedIn'),
                      Text('https://google.com'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
