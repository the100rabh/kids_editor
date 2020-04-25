import 'dart:html';
import 'package:pwa/client.dart' as pwa;

import 'editor.dart';

Editor editor;

void main() {
  pwa.Client();
  editor = Editor(querySelector('#editor'), querySelector('#body'));
  ButtonInputElement btnClear = querySelector('#btnClearText');
  btnClear.onClick.listen(editor.clearDocument);
}
