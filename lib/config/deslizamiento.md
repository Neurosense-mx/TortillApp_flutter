Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return RegisterPassword(registerModel: registerModel); // La página a la que vas
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Aquí definimos cómo se realiza la animación de la transición
      const begin = Offset(1.0, 0.0); // Deslizar desde la derecha
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      // Aquí puedes modificar la animación a tu gusto
      return SlideTransition(position: offsetAnimation, child: child);
    },
  ),
);