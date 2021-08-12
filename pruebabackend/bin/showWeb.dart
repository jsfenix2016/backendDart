import 'dart:io';

//final UListElement wordList = querySelector('#img') as UListElement;

//UListElement toDoList;

class ShowWebImage {
  void showImageInWeb(List<FileSystemEntity> list) {
    // toDoList = querySelector('#list');
    list.forEach((elements) {
      elements.path.toString();
      print(elements.path.toString());
      //  my_div.children.add(elements.);
    });
    // querySelector('#img'). = 'Wake up, sleepy head!';

    // toDoList.children.add(list);
  }

  // Future<void> makeRequest(Event _) async {
  //   const path = 'https://dart.dev/f/portmanteaux.json';
  //   final httpRequest = HttpRequest();
  //   httpRequest
  //     ..open('GET', path)
  //     ..onLoadEnd.listen((e) => requestComplete(httpRequest))
  //     ..send('');
  // }

  // void requestComplete(HttpRequest request) {
  //   if (request.status == 200) {
  //     final response = request.responseText;
  //     if (response != null) {
  //       processResponse(response);
  //       return;
  //     }
  //   }

  //   // The GET request failed. Handle the error.
  //   final li = LIElement()..text = 'Request failed, status=${request.status}';
  //   wordList.children.add(li);
  // }

  // void processResponse(String jsonString) {
  //   for (final portmanteau in json.decode(jsonString)) {
  //     wordList.children.add(LIElement()..text = portmanteau as String);
  //   }
  // }
}
