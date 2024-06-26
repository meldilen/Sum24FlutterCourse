import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'provider.dart';
import 'start_session_page.dart';
import 'package:provider/provider.dart';
import 'session_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class CustomEvent extends Event {
  Color color = const Color.fromARGB(115, 244, 54, 54);
  Duration duration = const Duration(seconds: 0);
  TemperaturePhase phase = ColdTemperaturePhase();

  CustomEvent({required super.date}) {
    if (phase.runtimeType == ColdTemperaturePhase) {
      color = Colors.blue;
    }
  }

  CustomEvent setPhase(TemperaturePhase newPhase) {
    phase = newPhase;
    return this;
  }

  CustomEvent updateDuration(int seconds) {
    int originalDuration = duration.inSeconds;
    duration = Duration(seconds: originalDuration + seconds);
    return this;
  }

  CustomEvent updateColor() {
    if (duration.inSeconds > 300 && phase.runtimeType == ColdTemperaturePhase) {
      color = const Color.fromARGB(194, 38, 105, 199);
    } else if (duration.inSeconds > 150 &&
        phase.runtimeType == ColdTemperaturePhase) {
      color = const Color.fromARGB(118, 152, 175, 206);
    } else if (duration.inSeconds < 150 &&
        duration.inSeconds > 0 &&
        phase.runtimeType == ColdTemperaturePhase) {
      color = const Color.fromARGB(194, 159, 199, 255);
    }
    if (duration.inSeconds > 300 && phase.runtimeType == HotTemperaturePhase) {
      color = const Color.fromARGB(118, 199, 38, 38);
    } else if (duration.inSeconds > 150 &&
        phase.runtimeType == HotTemperaturePhase) {
      color = const Color.fromARGB(118, 202, 91, 91);
    } else if (duration.inSeconds < 150 &&
        duration.inSeconds > 0 &&
        phase.runtimeType == HotTemperaturePhase) {
      color = const Color.fromARGB(194, 255, 159, 159);
    }
    if (duration.inSeconds <= 0) {
      color = Colors.transparent;
    }
    return this;
  }
}

class _HomePageState extends State<HomePage> {
  final DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
        backgroundColor: Colors.lightGreen[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0),
                child: Column(children: [
                  const Text('Contrast Shower Companion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 163, 151, 151),
                          ),
                        ],
                      )),
                  const SizedBox(width: 8),
                  const Text('Click on any day and see your activity!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(118, 199, 38, 38),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Hot Day',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(194, 38, 105, 199),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Cold Day',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                    ],
                  )
                ]),

                //progress bar next
              ),
              Expanded(
                child: Center(
                  child: CalendarCarousel<Event>(
                      onDayPressed: (date, list) {
                        List<CustomEvent> eventsOnSelectedDay = dataProvider
                            .contrastShowerDays
                            .where((event) =>
                                event.date.year == date.year &&
                                event.date.month == date.month &&
                                event.date.day == date.day)
                            .toList();

                        if (eventsOnSelectedDay.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SessionInfoPage(events: eventsOnSelectedDay),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Attention!'),
                                content: const Text(
                                    'There are no sessions on this day.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      height: 550,
                      width: 450,
                      prevDaysTextStyle: const TextStyle(
                          color: Color.fromARGB(255, 190, 190, 190)),
                      selectedDayBorderColor:
                          const Color.fromARGB(255, 0, 0, 0),
                      selectedDayButtonColor:
                          const Color.fromARGB(255, 138, 189, 177),
                      minSelectedDate: DateTime(_currentDate.year - 10),
                      maxSelectedDate: DateTime(_currentDate.year + 10),
                      selectedDateTime: _currentDate,
                      iconColor: Colors.black,
                      headerTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 20.0),
                      weekdayTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 15.0),
                      customDayBuilder: (bool isSelectable,
                          int index,
                          bool isSelectedDay,
                          bool isToday,
                          bool isPrevMonthDay,
                          TextStyle textStyle,
                          bool isNextMonthDay,
                          bool isThisMonthDay,
                          DateTime day) {
                        if (dataProvider.contrastShowerDays
                            .any((event) => event.date == day)) {
                          return Container(
                            decoration: BoxDecoration(
                              color: dataProvider.contrastShowerDays
                                  .firstWhere((event) => event.date == day)
                                  .color,
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: Center(
                                child: Text(
                                    '${dataProvider.contrastShowerDays.firstWhere((event) => event.date == day).date.day}',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)))),
                          );
                        }
                        return null;
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 65.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      backgroundColor: const Color.fromARGB(255, 146, 146, 146),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/startSessionPage');
                    },
                    child: const Text('New Session',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)))),
              )
            ],
          ),
        ));
  }
}
