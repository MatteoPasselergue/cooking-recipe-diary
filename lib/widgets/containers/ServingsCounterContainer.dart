import 'package:flutter/material.dart';

import '../../utils/AppConfig.dart';

class ServingsCounterContainer extends StatelessWidget {
  final int defaultCounter;
  final Function(int) onChanged;

  const ServingsCounterContainer({super.key, required this.defaultCounter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    int counter = defaultCounter;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.people, color: AppConfig.primaryColor),
        IconButton(icon: Icon(Icons.remove, size: 14, color: AppConfig.primaryColor,),
          onPressed: () {
            if(counter > 1) counter--;
            onChanged(counter);
          },
        ),
        Text('$counter', style: TextStyle(fontSize: 14, color: AppConfig.primaryColor)),
        IconButton(icon:  Icon(Icons.add, size: 14, color: AppConfig.primaryColor),
          onPressed: () {
            counter++;
            onChanged(counter);
          },
        ),
      ],
    );
  }

}