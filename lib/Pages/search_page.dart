import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  //A fake database for now, to be deleted later

  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: _appBar(),
        body: ListView(
          children: [
            _searchField(),
            const SizedBox(height: 40),
          ],
        ));
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 90,
      leading: GestureDetector(
        onTap: () {},
        child: FittedBox(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
            child: SvgPicture.asset('assets/icons/setting_gold.svg'),
          )
        ),
      ),
      actions: [
        GestureDetector(
          onTap: (){},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'UserName ',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic
                ),
              ),
              SvgPicture.asset('assets/icons/share_gold.svg',height: 32, width: 32)
            ],
          ),
        ),
        Container(
          width: 20,
        )
      ],
    );
  }

  Container _searchField() {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),

        child: TextField(
          decoration: InputDecoration(
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: secondaryColor,
                width: 2
              )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                    color: secondaryColor,
                    width: 2
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                    color: secondaryColor,
                    width: 2
                )
            ),

            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Color(0xffffE8A3), fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/search_gold.svg'),
            ),
            suffixIcon: Container(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const VerticalDivider(
                      color: Color(0xffFFE8A3),
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 12, 12, 12),
                      child: SvgPicture.asset('assets/icons/filter_search_gold.svg'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }


}
