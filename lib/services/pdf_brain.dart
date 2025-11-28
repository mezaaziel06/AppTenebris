import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfBrain {
  static String? _fullText;

  // Cargar y convertir el PDF a texto
  static Future<void> init() async {
    if (_fullText != null) return;

    // Cargar PDF desde assets
    final data = await rootBundle.load('assets/data/DocumentoGuíaFuente.pdf');
    final bytes = data.buffer.asUint8List();

    // Abrir documento PDF
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    // Extraer texto de cada página
    final buffer = StringBuffer();
    for (int i = 0; i < document.pages.count; i++) {
      final pageText = PdfTextExtractor(document).extractText(startPageIndex: i);
      buffer.writeln(pageText);
    }

    document.dispose();

    _fullText = buffer.toString().toLowerCase();
  }

  // Buscar respuesta basada en coincidencias simples
  static Future<String> answer(String question) async {
    await init();

    final q = question.toLowerCase();
    final words = q.split(" ").where((w) => w.length > 3).toList();

    final lines = _fullText!.split("\n");

    final List<String> matches = [];

    for (final line in lines) {
      for (final w in words) {
        if (line.contains(w)) {
          matches.add(line.trim());
        }
      }
    }

    if (matches.isEmpty) {
      return "No encontré información en la Guía sobre eso.";
    }

    // Recortar a las mejores coincidencias
    return "Según la Guía:\n${matches.take(6).join("\n")}";
  }
}
