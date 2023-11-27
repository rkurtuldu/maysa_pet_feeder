import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IntervalFeed extends StatefulWidget {
  const IntervalFeed({Key? key,}) : super(key: key);

  @override
  State<IntervalFeed> createState() => _IntervalFeedState();
}

class _IntervalFeedState extends State<IntervalFeed> {
  late List<bool> isSelected;
  late List<bool> numOfFeed;
  late List<bool> feedAmount;
  bool isValuesLoaded = false;
  late bool mode;
  late int interval;
  late int feedTime;
  late int newInterval;
  late int amount;
  late int time1;
  late int time2;
  late int time3;
  late int time4;
  late int numberOfFeed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otomatik Besleme Ayarları"),
      ),
      body: Center(
        child: isValuesLoaded
            ? SingleChildScrollView(
            child: mode
                ? SizedBox(height: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 35,),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text("Besleme Modu", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ToggleButtons(
                            constraints: const BoxConstraints(
                                maxWidth: 200, minWidth: 150, minHeight: 40),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                if (isSelected[0] == true) {
                                  mode = true;
                                } else {
                                  mode = false;
                                }
                              });
                            },
                            borderColor: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            selectedColor: Colors.white,
                            borderWidth: 2,
                            fillColor: Colors.blue,
                            selectedBorderColor: Colors.blue,
                            isSelected: isSelected,
                            children: const [
                              Text("Zaman Aralığı"),
                              Text("Beseleme Saati"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 5),
                            child: Text("Besleme Miktarı", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ToggleButtons(
                            constraints: const BoxConstraints(
                                maxWidth: 133, minWidth: 100, minHeight: 40),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < feedAmount.length; i++) {
                                  feedAmount[i] = i == index;
                                }
                              });
                            },
                            borderColor: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            selectedColor: Colors.white,
                            borderWidth: 2,
                            fillColor: Colors.blue,
                            selectedBorderColor: Colors.blue,
                            isSelected: feedAmount,
                            children: const [
                              Text("50 ml"),
                              Text("100 ml"),
                              Text("150 ml"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 5),
                            child: Text("Zaman Aralığı", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 45, width: 200,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.blue, width: 2),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                              onPressed: () {
                                showDialog(
                                  context: context, builder: (context) {
                                  return SimpleDialog(
                                    title: const Text("Zaman Aralığı Seçin"),
                                    elevation: 10,
                                    children: [
                                      SizedBox(height: 150, width: 350,
                                        child: CupertinoTimerPicker(
                                          backgroundColor: Colors.white,
                                          minuteInterval: 5,
                                          alignment: Alignment.bottomCenter,
                                          mode: CupertinoTimerPickerMode.hms,
                                          onTimerDurationChanged: (value) {
                                            setState(() {
                                              newInterval = value.inSeconds;
                                            });
                                          },),
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                        children: [
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                          }, child: const Text("Vazgeç",
                                            style: TextStyle(fontSize: 16,
                                                color: Colors.black),)),
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              interval = newInterval;
                                            });
                                          }, child: const Text("Seç",
                                            style: TextStyle(fontSize: 16,
                                                color: Colors.black),))
                                        ],)
                                    ],);
                                },);
                              },
                              child: Text(
                                  formatTime(interval),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black)),),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 5),
                            child: Text("Son Besleme Zamanı", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 45, width: 200,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.blue, width: 2),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                              onPressed: () {
                                null;
                              },
                              child: Text(
                                  DateFormat("dd.MM.yyyy  HH:mm").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          feedTime)),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black)),),
                          ),
                        ],),
                    ],),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(140, 40))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, icon: const Icon(Icons.cancel_sharp),
                                label: const Text("Vazgeç")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(140, 40))),
                                onPressed: () {
                                  saveValues();
                                  writeValues();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Kaydedildi")));
                                  Navigator.of(context).pop();
                                }, icon: const Icon(Icons.check_circle),
                                label: const Text("Kaydet")),
                          ),
                        ],),
                        const SizedBox(height: 35,)
                      ]
                      ),
                    ],
                  ),
                ],
              ),
            )
                : SizedBox(height: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 35,),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text("Besleme Modu", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ToggleButtons(
                            constraints: const BoxConstraints(
                                maxWidth: 200, minWidth: 150, minHeight: 40),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                if (isSelected[0] == true) {
                                  mode = true;
                                } else {
                                  mode = false;
                                }
                              });
                            },
                            borderColor: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            selectedColor: Colors.white,
                            borderWidth: 2,
                            fillColor: Colors.blue,
                            selectedBorderColor: Colors.blue,
                            isSelected: isSelected,
                            children: const [
                              Text("Zaman Aralığı"),
                              Text("Beseleme Saati"),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 5),
                            child: Text("Besleme Miktarı", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ToggleButtons(
                            constraints: const BoxConstraints(
                                maxWidth: 133, minWidth: 100, minHeight: 40),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < feedAmount.length; i++) {
                                  feedAmount[i] = i == index;
                                }
                              });
                            },
                            borderColor: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            selectedColor: Colors.white,
                            borderWidth: 2,
                            fillColor: Colors.blue,
                            selectedBorderColor: Colors.blue,
                            isSelected: feedAmount,
                            children: const [
                              Text("50 ml"),
                              Text("100 ml"),
                              Text("150 ml"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 5),
                            child: Text("Besleme Sayısı", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ToggleButtons(
                            constraints: const BoxConstraints(
                                maxWidth: 100, minWidth: 75, minHeight: 40),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < numOfFeed.length; i++) {
                                  numOfFeed[i] = i == index;
                                }
                                if (numOfFeed[0] == true) {
                                  numberOfFeed = 1;
                                }
                                else if (numOfFeed[1] == true) {
                                  numberOfFeed = 2;
                                }
                                else if (numOfFeed[2] == true) {
                                  numberOfFeed = 3;
                                }
                                else if (numOfFeed[3] == true) {
                                  numberOfFeed = 4;
                                }
                              });
                            },
                            borderColor: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            selectedColor: Colors.white,
                            borderWidth: 2,
                            fillColor: Colors.blue,
                            selectedBorderColor: Colors.blue,
                            isSelected: numOfFeed,
                            children: const [
                              Text("1"),
                              Text("2"),
                              Text("3"),
                              Text("4"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: numberOfFeed >= 1 ? const Text(
                                "1. Besleme Saati", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                                : const Text(
                                "1. Besleme Saati", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                          ),
                          SizedBox(width: 140, height: 45,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: numberOfFeed >= 1
                                        ? const BorderSide(
                                        color: Colors.blue, width: 2)
                                        : const BorderSide(
                                        color: Colors.grey, width: 1),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)))),
                                onPressed: () {
                                  numberOfFeed >= 1
                                      ? showDialog(
                                      context: context, builder: (context) {
                                    return SimpleDialog(
                                      title: const Text("Besleme Saati Seçin"),
                                      elevation: 10,
                                      children: [
                                        SizedBox(width: 250, height: 150,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.time,
                                            use24hFormat: true,
                                            onDateTimeChanged: (
                                                DateTime value) {
                                              setState(() {
                                                time1 =
                                                (value.millisecondsSinceEpoch);
                                              });
                                            },),),
                                        Row(mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                          children: [
                                            TextButton(onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                null;
                                              });
                                            }, child: const Text("Tamam",
                                              style: TextStyle(fontSize: 16,
                                                  color: Colors.black),))
                                          ],)
                                      ],
                                    );
                                  })
                                      : { null};
                                }, child: numberOfFeed >= 1
                                ? Text(DateFormat("HH:mm").format(
                                DateTime.fromMillisecondsSinceEpoch(time1)),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black))
                                : Text(DateFormat("HH:mm").format(
                                DateTime.fromMillisecondsSinceEpoch(time1)),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.grey))),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: numberOfFeed >= 3 ? const Text(
                                "3. Besleme Saati", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                                : const Text(
                                "3. Besleme Saati", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                          ),
                          SizedBox(width: 140, height: 45,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: numberOfFeed >= 3
                                        ? const BorderSide(
                                        color: Colors.blue, width: 2)
                                        : const BorderSide(
                                        color: Colors.grey, width: 1),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)))),
                                onPressed: () {
                                  numberOfFeed >= 3
                                      ? showDialog(
                                      context: context, builder: (context) {
                                    return SimpleDialog(
                                      title: const Text("Besleme Saati Seçin"),
                                      elevation: 10,
                                      children: [
                                        SizedBox(width: 250, height: 150,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.time,
                                            use24hFormat: true,
                                            onDateTimeChanged: (
                                                DateTime value) {
                                              setState(() {
                                                time3 =
                                                (value.millisecondsSinceEpoch);
                                              });
                                            },),),
                                        Row(mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                          children: [
                                            TextButton(onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                null;
                                              });
                                            }, child: const Text("Tamam",
                                              style: TextStyle(fontSize: 16,
                                                  color: Colors.black),))
                                          ],)
                                      ],
                                    );
                                  })
                                      : { null};
                                }, child: numberOfFeed >= 3
                                ? Text(DateFormat("HH:mm").format(
                                DateTime.fromMillisecondsSinceEpoch(time3)),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black))
                                : Text(DateFormat("HH:mm").format(
                                DateTime.fromMillisecondsSinceEpoch(time3)),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.grey))),
                          ),

                        ],
                      ),
                      const SizedBox(width: 30,),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: numberOfFeed >= 2 ? const Text(
                              "2. Besleme Saati", style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))
                              : const Text("2. Besleme Saati", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                        ),
                        SizedBox(width: 140, height: 45,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: numberOfFeed >= 2
                                      ? const BorderSide(
                                      color: Colors.blue, width: 2)
                                      : const BorderSide(
                                      color: Colors.grey, width: 1),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                              onPressed: () {
                                numberOfFeed >= 2
                                    ? showDialog(
                                    context: context, builder: (context) {
                                  return SimpleDialog(
                                    title: const Text("Besleme Saati Seçin"),
                                    elevation: 10,
                                    children: [
                                      SizedBox(width: 250, height: 150,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              time2 =
                                              (value.millisecondsSinceEpoch);
                                            });
                                          },),),
                                      Row(mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                        children: [
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              null;
                                            });
                                          }, child: const Text("Tamam",
                                            style: TextStyle(fontSize: 16,
                                                color: Colors.black),))
                                        ],)
                                    ],
                                  );
                                })
                                    : { null};
                              }, child: numberOfFeed >= 2
                              ? Text(DateFormat("HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(time2)),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black))
                              : Text(DateFormat("HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(time2)),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey))),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: numberOfFeed >= 4 ? const Text(
                              "4. Besleme Saati", style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))
                              : const Text("4. Besleme Saati", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                        ),
                        SizedBox(width: 140, height: 45,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: numberOfFeed >= 4
                                      ? const BorderSide(
                                      color: Colors.blue, width: 2)
                                      : const BorderSide(
                                      color: Colors.grey, width: 1),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                              onPressed: () {
                                numberOfFeed >= 4
                                    ? showDialog(
                                    context: context, builder: (context) {
                                  return SimpleDialog(
                                    title: const Text("Besleme Saati Seçin"),
                                    elevation: 10,
                                    children: [
                                      SizedBox(width: 250, height: 150,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              time4 =
                                              (value.millisecondsSinceEpoch);
                                            });
                                          },),),
                                      Row(mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                        children: [
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              null;
                                            });
                                          }, child: const Text("Tamam",
                                            style: TextStyle(fontSize: 16,
                                                color: Colors.black),))
                                        ],)
                                    ],
                                  );
                                })
                                    : { null};
                              }, child: numberOfFeed >= 4
                              ? Text(DateFormat("HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(time4)),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black))
                              : Text(DateFormat("HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(time4)),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey))),
                        ),
                      ],)
                    ],
                  ),
                  Text("Son Besleme Zamanı: ${DateFormat("dd.MM.yyyy  HH:mm")
                      .format(DateTime.fromMillisecondsSinceEpoch(feedTime))}"),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(140, 40))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, icon: const Icon(Icons.cancel_sharp),
                                label: const Text("Vazgeç")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(140, 40))),
                                onPressed: () {
                                  saveValues();
                                  writeValues();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Kaydedildi")));
                                  Navigator.of(context).pop();
                                }, icon: const Icon(Icons.check_circle),
                                label: const Text("Kaydet")),
                          ),
                        ],),
                        const SizedBox(height: 35,)
                      ],),
                    ],
                  ),
                ],
              ),
            )
        )
            : const CircularProgressIndicator(),
      ),
    );
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    loadValues();
    super.initState();
  }

  void loadValues() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot1 = await ref.child("main").get();
    if (snapshot1.exists) {
      Map values = snapshot1.value as Map;
      mode = values["mode"];
      feedTime = values['feedTime']*1000;
      amount = values["amount"];
    }
    final snapshot2 = await ref.child("interval").get();
    if (snapshot2.exists) {
      Map values = snapshot2.value as Map;
      interval = values['interval'];
    }
    final snapshot3 = await ref.child("scheduled").get();
    if (snapshot3.exists) {
      Map values = snapshot3.value as Map;
      numberOfFeed = values["numberOfFeed"];
      time1 = values["time1"]*1000;
      time2 = values["time2"]*1000;
      time3 = values["time3"]*1000;
      time4 = values["time4"]*1000;
    }
    setState(() {
      if (mode == true) {
        isSelected = [true, false];
      } else {
        isSelected = [false, true];
      }
      if (amount == 60) {
        feedAmount = [true, false, false];
      } else if (amount == 120) {
        feedAmount = [false, true, false];
      } else {
        feedAmount = [false, false, true];
      }
      if (numberOfFeed == 1) {
        numOfFeed = [true, false, false, false];
      } else if (numberOfFeed == 2) {
        numOfFeed = [false, true, false, false];
      } else if (numberOfFeed == 3) {
        numOfFeed = [false, false, true, false];
      } else {
        numOfFeed = [false, false, false, true];
      }
      isValuesLoaded = true;
    });
  }

  void saveValues() {
    if (feedAmount[0] == true) {
      amount = 60;
    } else if (feedAmount[1] == true) {
      amount = 120;
    } else if (feedAmount[2] == true) {
      amount = 180;
    }
  }

  void writeValues() async {
    final ref = FirebaseDatabase.instance.ref();
    await ref.update({
      "interval/interval": interval,
      "main/amount": amount,
      "main/mode": mode,
      "scheduled/time1": time1/1000,
      "scheduled/time2": time2/1000,
      "scheduled/time3": time3/1000,
      "scheduled/time4": time4/1000,
      "scheduled/numberOfFeed": numberOfFeed,
    });
  }
}


