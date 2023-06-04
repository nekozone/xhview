import 'package:flutter/material.dart';
import '../tool/status.dart';
import '../tool/profile.dart';
import '../tool/bbslogin.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("登录"),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: const SingleChildScrollView(child: LoginPage()));
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (XhStatus.xhstatus.isLogin) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('已登录'),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              },
              child: const Text('退出登录'))
        ],
      );
    } else {
      return const LoginCont();
    }
  }
}

class LoginCont extends StatefulWidget {
  const LoginCont({super.key});

  @override
  State<LoginCont> createState() => _LoginContState();
}

class _LoginContState extends State<LoginCont> {
  String lgname = '';
  String lgpass = '';
  bool isLogining = false;
  TextEditingController lgnameController = TextEditingController();
  TextEditingController lgpassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    lgname = UserProfiles.username;
    lgpass = UserProfiles.password;
    isLogining = false;
    lgnameController.text = lgname;
    lgpassController.text =
        lgpass.length >= 8 ? lgpass.substring(0, 8) : lgpass;
  }

  @override
  void dispose() {
    lgnameController.dispose();
    lgpassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userNameInput(),
        userPassInput(),
        loginButton(),
      ],
    );
  }

  Widget userNameInput() {
    return Container(
        padding: const EdgeInsets.all(5),
        child: TextField(
            controller: lgnameController,
            decoration: const InputDecoration(
              labelText: '用户名',
              hintText: '请输入用户名',
              prefixIcon: Icon(Icons.person),
            )));
  }

  Widget userPassInput() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        child: TextField(
            obscureText: true,
            // obscuringCharacter: '*',
            controller: lgpassController,
            decoration: const InputDecoration(
              labelText: '密码',
              hintText: '请输入密码',
              prefixIcon: Icon(Icons.lock),
            )));
  }

  Widget loginButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 55),
          child: ElevatedButton.icon(
              onPressed: isLogining
                  ? null
                  : () {
                      setState(() {
                        isLogining = true;
                      });
                      bbslogin(lgnameController.text, lgpassController.text)
                          .then((value) {
                        if (value) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('登录失败')));
                        }
                        setState(() {
                          isLogining = false;
                        });
                      });
                    },
              icon: const Icon(Icons.send),
              label: Text(isLogining ? '登录中...' : '登录')),
        ));
  }
}
