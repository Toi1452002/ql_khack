import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ql_khach/utils/extension.dart';
import 'package:ql_khach/widgets/widgets.dart';

import 'dropdown_textfield_search.dart';

export 'dropdown_item.dart';
export 'wdropdown_select.dart';
class Wdropdown extends StatelessWidget {
  Wdropdown(
      {super.key,
      this.selected,
      this.onChanged,
      this.width,
      this.hint = '',
      this.lstSelected,
      required this.data,
      this.label,
      this.search = false, this.height, this.screenSmall = false});

  double? width;
  double? height;
  bool screenSmall;
  void Function(String?)? onChanged;
  String? selected;
  List<String>? lstSelected;
  List<DropdownItem> data;
  bool search;
  String hint;
  String? label;

  final txtSearch = TextEditingController();
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label ?? '',
            style: context.textTheme.labelSmall!.copyWith(fontSize: 13),
          ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            focusNode: focus,
            isExpanded: true,
            onMenuStateChange: (open) {
              if (!open) {
                txtSearch.clear();
              }else{
                focus.requestFocus();
              }
            },
            hint: Text(hint),
            dropdownSearchData: !search
                ? null
                : DropdownSearchData<String>(
                    searchInnerWidgetHeight: 20,
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: DropdownTextfieldSearch(
                        // height: 25,
                        controller: txtSearch,
                        focusNode: focus,
                      ),
                    ),
                    searchController: txtSearch,
                    searchMatchFn: (item, searchValue) {
                      return item.value.toString().contains(searchValue);
                    }
                    // searchInnerWidget: Text('sadas')
                    ),
            style: const TextStyle(fontSize: 13, color: Colors.black),
            menuItemStyleData: MenuItemStyleData(
                height: 25,
                padding: const EdgeInsets.only(left: 5),
                selectedMenuItemBuilder: (context, e) {
                  return Focus(
                    focusNode: search ? null : focus,
                    child: Container(
                      height: 25,
                      padding: const EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      color: color.primary,
                      child: Text(
                        softWrap: false,
                        data.firstWhere((e) =>  e.value == selected).title,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                overlayColor: WidgetStatePropertyAll(Colors.grey.shade100)),
            buttonStyleData: ButtonStyleData(
              height:height ?? 30,
              overlayColor: const WidgetStatePropertyAll(Colors.white),
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Colors.black, width: .3)),
              width: width ?? 200,
            ),
            dropdownStyleData: DropdownStyleData(
                width: screenSmall ? 150 : null,
                isOverButton: search,
                maxHeight: 200,
                elevation: 2,
                padding: EdgeInsets.zero,
                scrollbarTheme: ScrollbarThemeData(
                  thickness: WidgetStatePropertyAll(3)
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                )),
            value: lstSelected==null ? selected : lstSelected!.last,
            items: data
                .map((e) => DropdownMenuItem(
                      value: e.value,
                      child: Text(
                        softWrap: false,
                        e.title,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
