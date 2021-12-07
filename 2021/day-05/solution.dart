import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main() async {
  var coordinates = await loadCoordinates();
  var value = radarCounter(buildRadar(coordinates));
  print("The result is: $value");
  value = radarCounter(buildRadar(coordinates, true));
  print("The result is: $value");

}

Future loadCoordinates() async {
  var coordinates = [];
  Stream<String> lines = File('input.txt').openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());
    await for (var line in lines) {
      var data = line.split(" -> ");
      coordinates.add([data[0].split(",").map((v) => int.parse(v)).toList(), data[1].split(",").map((v) => int.parse(v)).toList()]);
    }
  return coordinates;
}


List buildRadar(coordinates, [vertical = false]) {
  var list = List.generate(1000, (i) => List.generate(1000, (j) => 0), growable: false);
  for(var c in coordinates) {
    if(c[0][0] == c[1][0]) {
      var extremes = [c[0][1], c[1][1]]..sort();
      for (var y = extremes[0]; y <= extremes[1]; y++) {
        list[y][c[0][0]] += 1;
      }
    } else if (c[0][1] == c[1][1]) {
      var extremes = [c[0][0], c[1][0]]..sort();
      for (var x = extremes[0]; x <= extremes[1]; x++) {
        list[c[0][1]][x] += 1;
      }
    } else if (vertical) {
      var lineLength = (c[0][0] - c[1][0]).abs() + 1;
      var xShift = (c[0][0] <= c[1][0]) ? 1 : -1;
      var yShift = (c[0][1] <= c[1][1]) ? 1 : -1;
      var x = c[0][0];
      var y = c[0][1];
      for (var l = 0; l < lineLength; l++) {
        list[y][x] += 1;
        x += xShift;
        y += yShift;
      }
    }
  }
  return list;
}

int radarCounter(radar) {
  var counter = 0;
  for(var y in radar) {
    for(var x in y) {
      if(x > 1){
        counter++;
      }
    }
  }
  return counter;
}
