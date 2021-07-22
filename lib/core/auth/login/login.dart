part of core.auth;

class LoginPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  jumpToPage(int page) {
    controller.animateToPage(
      page,
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  static Page page() => MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bucket Map'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(6.0),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.loading) {
                  return LinearProgressIndicator();
                }

                return Container();
              },
            ),
          ),
        ),
        body: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            EmailView(
              onNextView: () => jumpToPage(1),
              onRegister: () => Navigator.push(context, RegisterPage.page()),
            ),
            PasswordView(
              onPreviouseView: () => jumpToPage(0),
            ),
          ],
        ),
      ),
    );
  }
}