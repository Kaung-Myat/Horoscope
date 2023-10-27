import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:zodiac/models/zodiac.dart';
import 'package:zodiac/providers/zodiac_provider.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadZodiacData();
    });
  }

  Future<void> _loadZodiacData() async {
    try {
      await Provider.of<ZodiacProvider>(context, listen: false).getAllZodiacs();
    } catch (error) {
      print('Error loading zodiac data: $error');
    }
  }

  String formatDate = "Choose you birthdate";

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<ZodiacProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
                child: SizedBox(
              width: 180,
              child: RiveAnimation.asset('assets/animations/loader.riv'),
            ));
          }
          final zodiacs = value.getZodiac;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    await _selectDate(context);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDate),
                        IconButton(
                          onPressed: () {
                            if (formatDate == "Choose you birthdate") {
                              return;
                            } else {
                              DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(formatDate);
                              int i=0;
                              while(i<zodiacs.length){
                                final zodiac = zodiacs[i];
                                if(zodiac.name == getHoroscope(parsedDate)){
                                  _showModalBottomSheet(context, zodiac, isDarkMode, getHoroscope(parsedDate));
                                  break;
                                }
                                i++;
                              }
                            }
                          },
                          icon: const Icon(Icons.search),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "Select your sign",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    children: List.generate(zodiacs.length, (index) {
                      final zodiac = zodiacs[index];
                      return InkWell(
                        onTap: () {
                          _showModalBottomSheet(
                              context, zodiac, isDarkMode, zodiac.name);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 185, 185, 185),
                                  width: 0.5)),
                          elevation: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                zodiac.zodiacSignImageUrl,
                                colorFilter: isDarkMode
                                    ? const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn)
                                    : const ColorFilter.mode(
                                        Colors.black, BlendMode.srcIn),
                                semanticsLabel: zodiac.name,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                zodiac.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> _showModalBottomSheet(
    BuildContext context,
    Zodiac zodiac,
    bool isDarkMode,
    String zodiacName,
  ) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return zodiacName == zodiac.name
            ? SizedBox(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              opacity: 0.3,
                              image: AssetImage(
                                zodiac.zodiacSign2ImageUrl,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Column(
                            children: [
                              Text(
                                zodiac.name,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                zodiac.dates,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Personality Traits",
                      style: TextStyle(
                        fontSize: 23,
                        color: isDarkMode ? Colors.grey : Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 85,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: zodiac.traits.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  CircularPercentIndicator(
                                    animation: true,
                                    animationDuration: 1500,
                                    radius: 30,
                                    lineWidth: 6,
                                    backgroundColor: Colors.grey,
                                    percent:
                                        zodiac.traits[index].percentage / 100,
                                    progressColor: Colors.greenAccent,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: Text(
                                      "${zodiac.traits[index].percentage.toString()}%",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(zodiac.traits[index].name)
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          children: [
                            _headingTextWidget(isDarkMode,"မြန်မာလ"),
                            Text(
                              "- ${zodiac.myanmarMonth}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _headingTextWidget(isDarkMode, "ဒြပ် / ELEMENT"),
                            Text(
                              "- ${zodiac.element}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            _headingTextWidget(isDarkMode, "Life Purpose"),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              zodiac.lifePurpose,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _headingTextWidget(isDarkMode, "Loyal"),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              zodiac.loyal,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _headingTextWidget(isDarkMode, "Angry"),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              zodiac.angry,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _headingTextWidget(isDarkMode, "Character"),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              zodiac.character,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _headingTextWidget(isDarkMode, "Pretty Features"),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              zodiac.prettyFeatures,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _headingTextWidget(isDarkMode, 'Representative Flower'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              zodiac.representativeFlower,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }

  Text _headingTextWidget(bool isDarkMode,String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 23,
        color: isDarkMode ? Colors.grey : Colors.black54,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        formatDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  String getHoroscope(DateTime birthDate) {
    var month = birthDate.month;
    var day = birthDate.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return "Aries";
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return "Taurus";
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return "Gemini";
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return "Cancer";
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return "Leo";
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return "Virgo";
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return "Libra";
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return "Scorpio";
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return "Sagittarius";
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return "Capricorn";
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return "Aquarius";
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return "Pisces";
    } else {
      throw "Invalid birth date.";
    }
  }
}
