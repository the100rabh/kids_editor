import 'dart:developer';
import 'dart:html';

class Editor {
  static const _EDIT_AREA_TOP = 110;

  final DivElement _textArea;
  final Map<String, ImageElement> _alphabets = {};
  var lastImageElement;

  int _loadCounter = 0;
  int _elements = 0;
  int _top = _EDIT_AREA_TOP;

  Editor(DivElement textArea) : _textArea = textArea {
    window.onKeyPress.listen(KeyEventListener);
    loadImages();
  }

  void clearDocument(MouseEvent event) {
    log(r'clear document called');
    _textArea.children.clear();
    _elements = 0;
    _top = _EDIT_AREA_TOP;
  }

  void KeyEventListener(KeyboardEvent event) {
    final chr = String.fromCharCodes([event.charCode]);
    log('character got is $chr');
    var needsNewline = false;
    if (_alphabets.containsKey(chr.toUpperCase())) {
      final imageElement =
          _alphabets[chr.toUpperCase()].clone(true) as ImageElement;
      imageElement.style.position = 'absolute';
      final left = 50 * _elements++;
      imageElement.style.left = '${left}px';
      imageElement.style.top = '${_top}px';
      _textArea.append(imageElement);            
      needsNewline = checkIfNeedsNewline(imageElement);
    }
    if (event.charCode == 13 || needsNewline) {
      _top += 50;
      _elements = 0;
    }
  }

  void loadImages() {
    final alphabetsList = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
    ];

    alphabetsList.forEach((alphabet) => addImage(alphabet));
  }

  void addImage(String alphabet) {
    final imageElement = ImageElement(
      src: 'assets/${alphabet}.gif',
      height: 100,
      width: 100,
    );

    imageElement.onLoad.listen(loadCount);
    _alphabets[alphabet] = imageElement;
  }

  void loadCount(Event event) {
    _loadCounter++;
    if (_loadCounter > 25) {
      log('all loaded loadCounter = $_loadCounter');
    }
  }

  bool checkIfNeedsNewline(Element imageElement){
    final boundingRect = imageElement.getBoundingClientRect();
      return boundingRect.right + 50 >= window.innerWidth;
  }
}
