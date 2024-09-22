import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectItemDropdown extends ChangeNotifier{
  List<String> lstSelect = [];

  void addItem(String val){
    lstSelect.add(val);
    notifyListeners();
  }

  void removeItem(String val){
    lstSelect.remove(val);
    notifyListeners();
  }
}

final selectItemDropdownPVD = ChangeNotifierProvider.autoDispose<SelectItemDropdown>((ref) {
  return SelectItemDropdown();
});


class WdropdownSelect extends ConsumerWidget {
  double? width;
  List<String> items;
  String hintText;
  WdropdownSelect({super.key,this.width, required this.items, this.hintText = ''});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final selectedItems = ref.watch(selectItemDropdownPVD);
    final rselectedItems = ref.read(selectItemDropdownPVD.notifier);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            elevation: 2,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
            )),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            //disable default onTap to avoid closing menu when selecting an item
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final isSelected = selectedItems.lstSelect.contains(item);
                return InkWell(
                  onTap: () {

                    isSelected ? rselectedItems.removeItem(item) : rselectedItems.addItem(item);
                    // selectedState.update(['toi']);
                    //This rebuilds the StatefulWidget to update the button's text
                    // setState(() {});
                    //This rebuilds the dropdownMenu Widget to update the check mark
                    menuSetState(() {});
                  },
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    // padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check_box_outlined)
                        else
                          const Icon(Icons.check_box_outline_blank),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
        //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
        value: selectedItems.lstSelect.isEmpty ? null : selectedItems.lstSelect.last,
        onChanged: (value) {
        },
        selectedItemBuilder: (context) {
          return items.map(
                (item) {
              return Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  selectedItems.lstSelect.join(', '),
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              );
            },
          ).toList();
        },
        buttonStyleData: ButtonStyleData(
          height: 30,
          overlayColor: const WidgetStatePropertyAll(Colors.white),
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.black, width: .3)),
          width: width ?? 200,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 30,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
