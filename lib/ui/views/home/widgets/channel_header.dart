import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';

class ChannelListHeader extends StatefulWidget {
  const ChannelListHeader({Key? key}) : super(key: key);

  @override
  State<ChannelListHeader> createState() => _ChannelListHeaderState();
}

class _ChannelListHeaderState extends State<ChannelListHeader> {
  String selectedValue = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      ...Category.values.map(
        (e) => e.name[0].toUpperCase() + e.name.substring(1),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            'All Channels',
            style: titleMedium.copyWith(
              color: kcPrimaryTextColor,
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: SizedBox(
              width: 80.w,
              child: DropdownButton<String>(
                isExpanded: true,
                menuWidth: 120.w,
                alignment: Alignment.center,
                iconSize: 18.r,
                isDense: true,
                value: selectedValue,

                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: kcPrimaryColor,
                ),

                dropdownColor: Colors.black,

                // ✅ Selected value style
                selectedItemBuilder: (context) {
                  return categories.map((category) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        category,
                        style: bodySmall.copyWith(
                          color: kcPrimaryColor, // RED selected value
                        ),
                      ),
                    );
                  }).toList();
                },

                // ✅ Dropdown items style
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: bodySmall.copyWith(
                        color: Colors.white, // WHITE menu items
                      ),
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              )),
        ),
      ],
    );
  }
}
