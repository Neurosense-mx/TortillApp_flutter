class CarritoDeCompras {
  final double precioTortillaPublico;
  final double precioTortillaTienda;

  final List<Map<String, dynamic>> _productos = [];

  CarritoDeCompras({
    required this.precioTortillaPublico,
    required this.precioTortillaTienda,
  });

  void getProductos() {
    
  }
  void addTortillas({
    required double cantidad, // puede ser en kg o gramos
    required String tipoPrecio, // 'publico' o 'tienda'
    bool enGramos = false,
  }) {
    double cantidadKg = enGramos ? cantidad / 1000 : cantidad;
    double precioUnitario = tipoPrecio == 'tienda'
        ? precioTortillaTienda
        : precioTortillaPublico;

    _productos.add({
      'tipo': 'tortillas',
      'cantidadKg': cantidadKg,
      'precioUnitario': precioUnitario,
      'subtotal': cantidadKg * precioUnitario,
    });
  }

  void addProducto({
    required String nombre,
    required int cantidad,
    required double precioUnitario,
  }) {
    _productos.add({
      'tipo': 'producto',
      'nombre': nombre,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': cantidad * precioUnitario,
    });
  }

  double getTotal() {
    return _productos.fold(0.0, (suma, item) => suma + item['subtotal']);
  }

  Map<String, dynamic> toJson() {
    return {
      'productos': _productos,
      'total': getTotal(),
    };
  }
}
