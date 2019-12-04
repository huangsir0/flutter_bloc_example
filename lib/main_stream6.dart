import 'dart:async';

void main() {
  print("Hello  Stream");
}

void onListen(event) {
  print("==>${event}");
}

void onError(error) {
  print(error);
}


void onDone() {
  print('The stream is done !');
}
