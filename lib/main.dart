import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _body;//сюда записывается информация с www.metaweather.com
_sendRequestGet() async{
  var url = Uri.parse('https://www.metaweather.com/api/location/924938/');
  var response = await http.get(url);
  String for_resp = (response.body);
  _body = for_resp;
}//получение информации по городу Киеву и её запись
class WeatherFilling extends StatelessWidget {

  giveDayInfo(int dayNumber){   //выделить из блока информации данные о погоде и вернуть их строкой; dayNumber - номер дня, по которому ищем (от 1 до 6)
    if (_body == null){ //если данные ещё не получены, не пытаться ничего выделить
      return '------------';
    }
    int lastFind = 0, indOfStart = 0, indOfEnding = 0;
    double forTransfer = 0.0;
    String cdMinTemp, cdMaxTemp, cdWindSpeed, cdWindDir, cdAirPressure, cdHumidity,
        cdPredictability, forReturn;
    for (int i = 0; i < dayNumber; i++) { //находим нужный день и потом выбираем всё, что нужно
      lastFind = _body.indexOf('weather_state_abbr', lastFind) + 1;
    }
    lastFind = _body.indexOf('min_temp', lastFind);
    indOfStart = lastFind + 10;
    indOfEnding = _body.indexOf(',', indOfStart);
    cdMinTemp = _body.substring(indOfStart, indOfEnding); //
    lastFind = _body.indexOf('max_temp', lastFind);
    indOfStart = lastFind + 10;
    indOfEnding = _body.indexOf(',', indOfStart);
    cdMaxTemp = _body.substring(indOfStart, indOfEnding); //
    lastFind = _body.indexOf('wind_speed', lastFind);
    indOfStart = lastFind + 12;
    indOfEnding = _body.indexOf(',', indOfStart);
    cdWindSpeed = _body.substring(indOfStart, indOfEnding); //
    lastFind = _body.indexOf('wind_direction', lastFind);
    indOfStart = lastFind + 16;
    indOfEnding = _body.indexOf(',', indOfStart);
    cdWindDir = _body.substring(indOfStart, indOfEnding); //
    forTransfer = (double.parse(cdWindSpeed))*1.61;
    cdWindSpeed = forTransfer.toString();
    lastFind = _body.indexOf('air_pressure', lastFind);
    indOfStart = lastFind + 14;
    indOfEnding = _body.indexOf(',', indOfStart);
    cdAirPressure = _body.substring(indOfStart, indOfEnding); //
    lastFind = _body.indexOf('humidity', lastFind);
    indOfStart = lastFind + 10;
    indOfEnding = _body.indexOf(',', indOfStart);
    cdHumidity = _body.substring(indOfStart, indOfEnding); //
    lastFind = _body.indexOf('predictability', lastFind);
    indOfStart = lastFind + 16;
    indOfEnding = _body.indexOf('}', indOfStart);
    cdPredictability = _body.substring(indOfStart, indOfEnding); //
    forReturn = 'Температура: ' + cdMinTemp + '°C/' + cdMaxTemp +
        '°C; Швидкість вітру: ' + cdWindSpeed + ' км/год; напрям: ' + cdWindDir + '°; Атмосферний тиск: '+
        cdAirPressure + ' мбар; Вологість: ' + cdHumidity + '%; Ймовірність: ' + cdPredictability + '%'; //составляем строку для вывода
    return forReturn;
  }
  giveDayNumber(int dayNumber){
    if (_body == null){
      return '0     0';
    }
    int lastFind = 0, indOfStart = 0, indOfEnding = 0;
    String forReturn;
    for (int i = 0; i < dayNumber; i++) {
      lastFind = _body.indexOf('applicable_date', lastFind) + 1;
    }
    indOfStart = lastFind + 17;
    indOfEnding = _body.indexOf('"', indOfStart);
    forReturn = _body.substring(indOfStart, indOfEnding); //
    return forReturn;
  }//аналогично, только тут выводим дату

  giveDayAbr(int dayNumber){
    if (_body == null){
      return 'c';
    }
    int lastFind = 0, indOfStart = 0, indOfEnding = 0;
    String forReturn;
    for (int i = 0; i < dayNumber; i++) {
      lastFind = _body.indexOf('weather_state_abbr', lastFind) + 1;
    }
    indOfStart = lastFind + 20;
    indOfEnding = _body.indexOf('"', indOfStart);
    forReturn = _body.substring(indOfStart, indOfEnding); //
    return forReturn;
  }//аналогично, только тут ищем обозначение погоды для того, чтобы потом вывести картинку

  Widget build(BuildContext context) {
    return Container(
        color: Colors.black12,
        child: ListView( //помещаем всё в список, чтобы можно было его прокручивать, если на экране не поместиться
            children: [ //создаем 6 блоков, по одному на день
              WeatherBox(giveDayNumber(1), giveDayInfo(1),
                  imageurl: 'https://www.metaweather.com/static/img/weather/png/' + giveDayAbr(1) + '.png'),
              WeatherBox(giveDayNumber(2), giveDayInfo(2),
                  imageurl: 'https://www.metaweather.com/static/img/weather/png/' + giveDayAbr(2) + '.png'),
              WeatherBox(giveDayNumber(3), giveDayInfo(3),
                  imageurl: 'https://www.metaweather.com/static/img/weather/png/' + giveDayAbr(3) + '.png'),
              WeatherBox(giveDayNumber(4), giveDayInfo(4),
                  imageurl: 'https://www.metaweather.com/static/img/weather/png/' + giveDayAbr(4) + '.png'),
              WeatherBox(giveDayNumber(5), giveDayInfo(5),
                  imageurl: 'https://www.metaweather.com/static/img/weather/png/' + giveDayAbr(5) + '.png'),
              WeatherBox(giveDayNumber(6), giveDayInfo(6),
                  imageurl: 'https://www.metaweather.com/static/img/weather/png/' + giveDayAbr(6) + '.png'),
            ]
        )
    );
  }
}//

class WeatherBox extends StatelessWidget { //отдельный блок, в котором показана информация за один день (дата, картинка, текст)
  final String _title;
  final String _text;
  String _imageurl;

  WeatherBox(this._title, this._text, {String imageurl}) {
    _imageurl = imageurl;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.blue[100],
        height: 150.0,
        child: new Row(children: [
          new Image.network(_imageurl, width: 100.0, height: 100.0, fit: BoxFit.cover,),
          new Expanded(child: new Container(padding: new EdgeInsets.all(5.0), child: new Column(children: [
            new Text(_title,  style: new TextStyle(fontSize: 20.0), overflow: TextOverflow.ellipsis),
            new Expanded(child:new Text(_text, softWrap: true, textAlign: TextAlign.justify,))
          ]
          ))
          )
        ])
    );
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WeatherApi'),
        ),
        body: WeatherFilling()
    );
  }
}
void main() async{
  await _sendRequestGet();
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp()
      )
  );
}