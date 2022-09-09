import 'package:flutter/material.dart';
import 'package:src/helpers/helpers.dart';

class ReminderTimeDialog extends StatefulWidget {
  final Function setStartTime;
  final Function setEndTime;
  final Function setInterval;
  final TimeOfDay selectedStartReminderTime;
  final TimeOfDay selectedFinishReminderTime;
  final int selectedReminderInterval;
  const ReminderTimeDialog(
      {required this.setEndTime,
      required this.selectedReminderInterval,
      required this.setStartTime,
      required this.setInterval,
      required this.selectedFinishReminderTime,
      required this.selectedStartReminderTime,
      Key? key})
      : super(key: key);

  @override
  ReminderTimeDialogState createState() => ReminderTimeDialogState();
}

class ReminderTimeDialogState extends State<ReminderTimeDialog> {
  late TimeOfDay selectedStartReminderTime;
  late TimeOfDay selectedFinishReminderTime;
  late int selectedReminderInterval;

  @override
  void initState() {
    selectedStartReminderTime = widget.selectedStartReminderTime;
    selectedFinishReminderTime = widget.selectedFinishReminderTime;
    selectedReminderInterval = widget.selectedReminderInterval;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Reminder Time",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Start time"),
              InkWell(
                onTap: () async {
                  showTimePicker(
                          context: context,
                          initialTime: selectedStartReminderTime)
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        selectedStartReminderTime = value;
                      });
                    }
                  });
                },
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor))),
                  child: Text(formatTimeOfDay(selectedStartReminderTime)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Finish time"),
              InkWell(
                onTap: () async {
                  showTimePicker(
                          context: context,
                          initialTime: selectedFinishReminderTime)
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        selectedFinishReminderTime = value;
                      });
                    }
                  });
                },
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor))),
                  child: Text(formatTimeOfDay(selectedFinishReminderTime)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Interval"),
              SizedBox(
                width: 130,
                child: DropdownButton<int>(
                  borderRadius: BorderRadius.circular(5),
                  elevation: 1,
                  dropdownColor: Colors.white,
                  value: selectedReminderInterval,
                  items:
                      <int>[0, 1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(getReminderIntervalText(value)),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedReminderInterval = newValue as int;
                    });
                  },
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(
                  context,
                  false,
                ),
                style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  widget.setEndTime(selectedFinishReminderTime);
                  widget.setStartTime(selectedStartReminderTime);
                  widget.setInterval(selectedReminderInterval);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    primary: Theme.of(context).primaryColor),
                child: const Text('Save',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ],
          )
        ]),
      ],
    );
  }
}
