import 'dart:developer';
import 'dart:html';

class Editor {
  final DivElement textArea;
  final BodyElement body;
  final Map<String, ImageElement> alphabets = {};

  int loadCounter = 0;
  int elements = 0;

  int top = 10;
  Editor(this.textArea, this.body) {
    window.onKeyPress.listen(KeyEventListener);
    loadImages();
  }

  void clearDocument(MouseEvent event) {
    textArea.setInnerHtml('');
    elements = 0;
    top = 10;
  }

  void KeyEventListener(KeyboardEvent event) {
    final chr = String.fromCharCodes([event.charCode]);
    log('character got is $chr');
    if (alphabets.containsKey(chr.toUpperCase())) {
      final imageElement = alphabets[chr.toUpperCase()].clone(true) as ImageElement;
      imageElement.style.position = 'absolute';
      final left = 50 * elements++;
      imageElement.style.left = '${left}px';
      imageElement.style.top = '${top}px';
      textArea.append(imageElement);
    }
    if(event.charCode == 13){
      top += 50;
      elements = 0;
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
      src: 'assets/$alphabet.gif',
      height: 100,
      width: 100,
    );

    imageElement.onLoad.listen(loadCount);
    alphabets[alphabet] = imageElement;
  }

  void loadCount(Event event) {
    loadCounter++;
    if (loadCounter > 25) {
      log('all loaded loadCounter = $loadCounter');
    }
  }
}
