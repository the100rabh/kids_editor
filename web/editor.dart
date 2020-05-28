import 'dart:developer';
import 'dart:html';

final _width_for_padding = 60;
final _text_element_padding = 60;

class Editor {
  static const _EDIT_AREA_TOP = 140;

  final DivElement _textArea;
  final Map<String, ImageElement> _alphabets = {};
  var lastImageElement;

  int _loadCounter = 0;
  int _elements = 0;
  int _top = _EDIT_AREA_TOP;

  final _default_text_width = 50;

  Editor(DivElement textArea) : _textArea = textArea {
    window.onKeyPress.listen(KeyEventListener);
    loadImages();
  }

  void clearDocument(MouseEvent event) {
    log(r'clear document called');
    _textArea.children.clear();
    _elements = 0;
    _top = _EDIT_AREA_TOP;
    _textArea.focus();
  }

  void KeyEventListener(KeyboardEvent event) {
    final chr = String.fromCharCodes([event.charCode]);
    log('character got is $chr');
    var needsNewline = false;
    var handled = false;
    if (_alphabets.containsKey(chr.toUpperCase())) {
      final imageElement =
          _alphabets[chr.toUpperCase()].clone(true) as ImageElement;
      imageElement.style.position = 'absolute';
      if (imageElement.getBoundingClientRect().width +
              50 * _elements +
              _text_element_padding >
          window.innerWidth) {
        _top += 50;
        _elements = 0;
        log('moved to new line');
      }
      final left = 50 * _elements++;
      imageElement.style.left = '${left}px';
      imageElement.style.top = '${_top}px';
      imageElement.className = 'bounce';
      imageElement.addEventListener(
        'animationend',
        (event) => window.scrollTo(left, _top, {'ScrollBehavior': 'smooth'}),
      );
      imageElement.addEventListener(
        'webkitAnimationEnd',
        (event) => window.scrollTo(left, _top, {'ScrollBehavior': 'smooth'}),
      );
      _textArea.append(imageElement);
      needsNewline = checkIfNeedsNewline(imageElement);
      handled = true;
      event.preventDefault();
    }
    if (event.charCode == ' '.codeUnitAt(0)) {
      _elements++;
    } else if (!handled) {
      var regExp = RegExp(r'^[^\p{Cc}\p{Cf}\p{Zl}\p{Zp}]');
      if (regExp.hasMatch(chr)) {
        final span = SpanElement();
        span.appendText(chr);
        span.className = 'spanText textAnimation';
        log('width is ${span.getBoundingClientRect().width}');
        if (_default_text_width + 50 * _elements + _text_element_padding > window.innerWidth) {
          _top += 50;
          _elements = 0;
          log('moved to new line');
        }
        final left = 50 * _elements++;
        span.style.left = '${left}px';
        span.style.top = '${_top}px';
        span.addEventListener(
          'animationstart',
          (event) => window.scrollTo(left, _top, {'ScrollBehavior': 'smooth'}),
        );
        span.addEventListener(
          'webkitAnimationStart',
          (event) => window.scrollTo(left, _top, {'ScrollBehavior': 'smooth'}),
        );
        _textArea.append(span);
        needsNewline = checkIfNeedsNewline(span);
        event.preventDefault();
      }
    }
    if (event.charCode == 13 || needsNewline) {
      _top += 50;
      _elements = 0;
      event.preventDefault();
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

  bool checkIfNeedsNewline(Element imageElement) {
    final boundingRect = imageElement.getBoundingClientRect();
    return boundingRect.right + _width_for_padding >= window.innerWidth;
  }
}
