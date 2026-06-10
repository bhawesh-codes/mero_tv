// lib/ui/views/home/widgets/country_dropdown_widget.dart
import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/models/country_model.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

const _kAll = 'ALL';

class CountryDropdownWidget extends ViewModelWidget<HomeViewModel> {
  const CountryDropdownWidget({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final countries = viewModel.dropdownCountries;
    final bool isFiltered = viewModel.selectedCountry != null;
    final String? homeCountryCode = viewModel.userCountryCode?.toUpperCase();

    const CountryModel allEntry =
        CountryModel(code: _kAll, name: 'All Countries');

    final CountryModel? currentCountry = viewModel.selectedCountry == null
        ? null
        : countries.firstWhereOrNull(
            (c) => c.code?.toUpperCase() == viewModel.selectedCountry,
          );

    final List<CountryModel> remaining = countries
        .where((c) => c.code?.toUpperCase() != viewModel.selectedCountry)
        .toList();

    final List<CountryModel> orderedItems = [
      allEntry,
      if (currentCountry != null) currentCountry,
      ...remaining,
    ];

    final selectedItem = viewModel.selectedCountry == null
        ? allEntry
        : currentCountry ?? allEntry;

    return SizedBox(
      height: 36.h,
      width: double.infinity,
      child: DropdownSearch<CountryModel>(
        items: (filter, loadProps) {
          if (filter.isNotEmpty) {
            return orderedItems
                .where((c) =>
                    c.name?.toLowerCase().contains(filter.toLowerCase()) ??
                    false)
                .toList();
          }
          return orderedItems;
        },
        selectedItem: selectedItem,
        compareFn: (a, b) => a.code?.toUpperCase() == b.code?.toUpperCase(),
        itemAsString: (CountryModel c) => c.name ?? c.code ?? '',
        // ── Decorator: the pill button ────────────────────────────────────
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
            filled: true,
            fillColor: kcDisabledTextColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: kcSecondaryTextColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: kcSecondaryTextColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: kcSecondaryTextColor),
            ),
          ),
        ),
        suffixProps: DropdownSuffixProps(
          dropdownButtonProps: DropdownButtonProps(
            iconClosed: Icon(
              Icons.keyboard_arrow_down,
              color: kcPrimaryColor,
              size: 16.r,
            ),
            iconOpened: Icon(
              Icons.keyboard_arrow_up,
              color: kcPrimaryColor,
              size: 16.r,
            ),
          ),
        ),
        // ── Popup: full-width, search on top ──────────────────────────────
        popupProps: PopupProps.menu(
          // Show search inside the popup but we'll override with searchFieldProps
          showSearchBox: true,
          // Full width — no maxWidth cap, tight fit stretches to button width
          fit: FlexFit.tight,
          constraints: BoxConstraints(maxHeight: 400.h, minHeight: 300.h),
          menuProps: MenuProps(
            backgroundColor: kcDisabledTextColor,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // ── Search field styled to look like the button ─────────────────
          searchFieldProps: TextFieldProps(
            autofocus: true,
            style: bodySmall.copyWith(color: kcPrimaryTextColor),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search country...',
              hintStyle: bodySmall.copyWith(
                  color: kcPrimaryTextColor.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: kcPrimaryTextColor.withOpacity(0.7),
                size: 16.r,
              ),
              filled: true,
              fillColor: kcSecondaryTextColor,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                borderSide: BorderSide.none,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          itemBuilder: (context, item, isDisabled, isSelected) {
            final bool isHomeCountry =
                item.code?.toUpperCase() == homeCountryCode;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  if (isHomeCountry) ...[
                    Icon(
                      Icons.location_on,
                      color: kcPrimaryColor,
                      size: 14.r,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Expanded(
                    child: Text(
                      item.name ?? item.code ?? '',
                      style: bodySmall.copyWith(
                        color: kcPrimaryTextColor,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        // ── Closed state label ────────────────────────────────────────────
        dropdownBuilder: (context, selectedItem) => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            selectedItem?.name ?? 'All Countries',
            style: bodySmall.copyWith(
              color: kcPrimaryTextColor,
              fontWeight: isFiltered ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onSelected: (CountryModel? value) {
          final code = value?.code?.toUpperCase();
          viewModel.onCountryChanged(code == _kAll ? null : code);
        },
      ),
    );
  }
}
