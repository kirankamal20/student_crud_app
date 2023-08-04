import 'package:flutter/material.dart';
import 'package:student_crud_app/data/model/country_model.dart';

class CountryPicker extends StatefulWidget {
  final Function(Country) onCountrySelected;

  const CountryPicker({super.key, required this.onCountrySelected});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  Country? _selectedCountry;
  final List<Country> countries = [
    Country(name: 'United States', flagCode: '🇺🇸'),
    Country(name: 'Canada', flagCode: '🇨🇦'),
    Country(name: 'United Kingdom', flagCode: '🇬🇧'),
    Country(name: 'Germany', flagCode: '🇩🇪'),
    Country(name: 'France', flagCode: '🇫🇷'),
    Country(name: 'Italy', flagCode: '🇮🇹'),
    Country(name: 'Spain', flagCode: '🇪🇸'),
    Country(name: 'Australia', flagCode: '🇦🇺'),
    Country(name: 'Japan', flagCode: '🇯🇵'),
    Country(name: 'China', flagCode: '🇨🇳'),
    Country(name: 'India', flagCode: '🇮🇳'),
    // Add more countries as needed
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Country>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), contentPadding: EdgeInsets.all(13)),
      value: _selectedCountry,
      hint: const Text(
        'Select a country',
      ),
      onChanged: (newValue) {
        setState(() {
          _selectedCountry = newValue;
          widget.onCountrySelected(newValue!);
        });
      },
      validator: (value) => value == null ? 'Select the Country' : null,
      items: countries.map<DropdownMenuItem<Country>>((Country country) {
        return DropdownMenuItem<Country>(
          value: country,
          child: Row(
            children: <Widget>[
              Text(country.flagCode),
              const SizedBox(width: 10),
              Text(country.name),
            ],
          ),
        );
      }).toList(),
    );
  }
}
