import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/booking_payload_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DepartureAndMisc extends ConsumerStatefulWidget {
  const DepartureAndMisc({
    super.key,
    required this.initDate,
    required this.luggageCallback,
    required this.passengerCallback,
    required this.budgetCallback,
    required this.wheelChairFriendlyCallback,
    required this.withPetCallback,
    required this.onNoteCallback,
    required this.onDateCallback,
    this.dateEditable = true,
    required this.onTimeCallback,
  });
  final bool dateEditable;
  final DateTime initDate;
  final ValueChanged<int> passengerCallback, luggageCallback;
  final ValueChanged<double> budgetCallback;
  final ValueChanged<bool> withPetCallback, wheelChairFriendlyCallback;
  final ValueChanged<String> onNoteCallback;
  final ValueChanged<TimeOfDay> onTimeCallback;
  final ValueChanged<DateTime> onDateCallback;
  @override
  ConsumerState<DepartureAndMisc> createState() => DepartureAndMiscState();
}

class DepartureAndMiscState extends ConsumerState<DepartureAndMisc>
    with ColorPalette {
  late final TextEditingController _date;
  late final TextEditingController _time;
  late final TextEditingController _price;
  late final TextEditingController _note;
  // late final TextEditingController _
  late DateTime _departureDate = widget.initDate;
  final int maxPassenger = 10;
  final int maxLuggage = 10;
  int numOfPassengers = 1;
  int numOfLuggage = 0;
  bool withPet = false;
  bool wheelChairFriendly = true;
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  final BookingPayloadVM _vm = BookingPayloadVM.instance;
  TimeOfDay? _departureTime;
  @override
  void initState() {
    super.initState();
    initPlatform();
  }

  void updateDate(DateTime d) {
    setState(() {
      _departureDate = d;
    });
    _date.text = DateFormat('MMM dd, yyyy').format(_departureDate);
    widget.onDateCallback(_departureDate);
  }

  void initPlatform() {
    _date = TextEditingController()
      ..text = DateFormat('MMM dd, yyyy').format(_departureDate);
    _time = TextEditingController();
    _price = TextEditingController();
    _note = TextEditingController();
    // _vm.stream.listen((event) {
    //   numOfPassengers = event.passengers;
    //   numOfLuggage = event.luggage;
    //   _departureDate = event.departureDate;
    //   _departureTime = event.departureTime;
    //   _date.text = DateFormat('MMM dd, yyyy').format(_departureDate);
    //   _time.text = event.departureTime.format(context);
    //   _price.text = event.price.toStringAsFixed(2);
    //   wheelChairFriendly = event.isWheelchairFriendly;
    //   withPet = event.withPet;
    //   _note.text = event.note ?? "";
    //   if (mounted) setState(() {});
    //   // _price
    // });
    // ref.watch(bookDataProvider.notifier).addListener((state) {
    //   if (state == null) return;
    //   setState(() {
    // numOfPassengers = state.payload.passengers;
    // numOfLuggage = state.payload.luggage;
    //   });
    // });
    // widget.passengerCallback(numOfPassengers);
    // widget.luggageCallback(numOfLuggage);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _date.dispose();
    _time.dispose();
    _price.dispose();
    _note.dispose();
  }

  bool isValidated() => _kForm.currentState!.validate();
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    // final data = ref.read(bookingPayloadNotifier);
    return Form(
      key: _kForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Departure Date",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _date,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                            ),
                            validator: (text) {
                              if (text == null) {
                                return "Unexpected error";
                              } else if (text.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },

                            readOnly: true,
                            enabled: widget.dateEditable,
                            // selectionHeightStyle:
                            //     BoxHeightStyle.includeLineSpacingTop,
                            onTap: widget.dateEditable
                                ? () async {
                                    await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now().add(1.days),
                                      lastDate: DateTime.now().add(30.days),
                                    ).then((value) {
                                      if (value == null) return;
                                      _vm.updateDepartureDate(value);
                                      setState(() {
                                        _date.text = DateFormat('MMM dd, yyyy')
                                            .format(_departureDate);
                                        _departureDate = value;
                                      });
                                      _kForm.currentState!.validate();
                                      widget.onDateCallback(value);
                                    });
                                  }
                                : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: textColor.withOpacity(.1),
                              prefixIcon: Icon(
                                Icons.calendar_month,
                                color: textColor,
                              ),
                              hintText: "When to pick you up?",
                              hintStyle: TextStyle(
                                color: textColor.withOpacity(.3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Gap(20),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Departure Time",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    TextFormField(
                      controller: _time,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                      ),
                      validator: (text) {
                        if (text == null) {
                          return "Unexpected error";
                        } else if (text.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () async {
                        await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) {
                          if (value == null) return;

                          _departureTime = value;
                          _time.text = value.format(context);
                          _vm.updateDepartureTime(value);
                          if (mounted) setState(() {});
                          _kForm.currentState!.validate();
                          widget.onTimeCallback(value);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: textColor.withOpacity(.1),
                        prefixIcon: Icon(
                          Icons.watch_later_outlined,
                          color: textColor,
                        ),
                        hintText: "--:--",
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              // Expanded(
              //   flex: 5,
              //   child:
              // ),
              // const Gap(20),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Passenger(s)",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        validator: (i) {
                          if (i == null) {
                            return "Required";
                          } else if (i.isNaN) {
                            return "Invalid value";
                          }
                        },
                        focusColor: Colors.red,
                        value: numOfPassengers,
                        dropdownColor: bgColor.lighten(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: textColor.withOpacity(.1),
                          prefixIcon: Icon(
                            Icons.person,
                            color: textColor,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            maxWidth: 50,
                            minWidth: 40,
                            minHeight: 50,
                          ),
                        ),
                        items: List.generate(
                          maxPassenger,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (i) {
                          if (i == null) return;
                          // ref.watch(bookDataProvider.notifier).update((state) =>
                          //     state.copyWith(
                          //         payload:
                          //             state.payload.copyWith(passengers: i)));
                          _vm.updatePassenger(i);
                          _kForm.currentState!.validate();
                          widget.passengerCallback(i);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Luggage(s)",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        dropdownColor: bgColor.lighten(),
                        validator: (i) {
                          if (i == null) {
                            return "Required";
                          } else if (i.isNaN) {
                            return "Invalid value";
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.luggage,
                            color: textColor,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            maxWidth: 50,
                            minWidth: 40,
                            minHeight: 50,
                          ),
                          filled: true,
                          fillColor: textColor.withOpacity(.1),
                        ),
                        value: numOfLuggage,
                        items: List.generate(
                          maxLuggage,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(
                              (index).toString(),
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (i) {
                          if (i == null) return;
                          _vm.updateLuggage(i);
                          // dataProvider.update((state) => state!.copyWith(
                          //       payload: state.payload.copyWith(luggage: i),
                          //     ));
                          // setState(() {
                          //   numOfLuggage = i;
                          // });
                          _kForm.currentState!.validate();
                          widget.luggageCallback(i);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Budget",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(10),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _price,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                ),
                onChanged: (t) {
                  final double? ff = double.tryParse(
                      t.replaceAll(',', ".").replaceAll('-', "."));

                  if (ff != null) {
                    print(ff);
                    widget.budgetCallback(ff);
                    _vm.updatePrice(ff);
                    _kForm.currentState!.validate();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textColor.withOpacity(.1),
                  prefixIconConstraints: const BoxConstraints(
                    maxWidth: 60,
                    minHeight: 50,
                  ),
                  prefixIcon: Center(
                    child: Text(
                      "AUD",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  hintText: "0.0",
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(.3),
                  ),
                ),
                validator: (text) {
                  if (text == null) {
                    return "Unexpected error";
                  } else if (text.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
            ],
          ),
          const Gap(10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            title: const Text("Wheelchair Friendly"),
            titleTextStyle: TextStyle(
              color: textColor,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
            ),
            subtitle: const Text(
                "Enable if you want a vehicle that is wheelchair friendly"),
            subtitleTextStyle: TextStyle(
              color: textColor.withOpacity(.5),
              fontFamily: "Montserrat",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            trailing: Switch.adaptive(
                activeTrackColor: purplePalette,
                // activeColor: purplePalette,
                value: wheelChairFriendly,
                onChanged: (b) {
                  setState(() {
                    wheelChairFriendly = b;
                  });
                  _vm.updateWheelChair(b);
                  widget.wheelChairFriendlyCallback(b);
                }),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            title: const Text("Pet Companion"),
            titleTextStyle: TextStyle(
              color: textColor,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
            ),
            subtitle: const Text("Enable if you are with your pet companion"),
            subtitleTextStyle: TextStyle(
              color: textColor.withOpacity(.5),
              fontFamily: "Montserrat",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            trailing: Switch.adaptive(
                activeTrackColor: purplePalette,
                // activeColor: purplePalette,
                value: withPet,
                onChanged: (b) {
                  setState(() {
                    withPet = b;
                  });
                  _vm.updateWithPet(b);
                  widget.withPetCallback(b);
                }),
          ),
          const Gap(10),
          Divider(
            color: textColor.withOpacity(.3),
          ),
          const Gap(10),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notes to driver",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(10),
                TextFormField(
                  controller: _note,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                  ),
                  // onFieldSubmitted: (t) {
                  //   _kForm.currentState!.validate();
                  //   widget.onNoteCallback(t);
                  // },
                  onChanged: (t) {
                    _vm.updateNote(t);
                    widget.onNoteCallback(t);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textColor.withOpacity(.1),
                    hintText: "(Optional)",
                    hintStyle: TextStyle(
                      color: textColor.withOpacity(.3),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
