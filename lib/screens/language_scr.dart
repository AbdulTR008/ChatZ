import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/languages.dart';
import '../riverpod/language_provider.dart';

class LanguagesScreen extends ConsumerStatefulWidget {
  const LanguagesScreen({super.key});

  @override
  ConsumerState<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends ConsumerState<LanguagesScreen> {
  final List<Language> _language = Language.languages();

  int? selectedLanguageIndex;

  Color selectedCardColor = Colors.yellow;

  Color unSelectedCardColor = Colors.white;
  String? languageRec;

  void language(int index, String pickLang) {
    languageRec = pickLang;
    selectedLanguageIndex = index;
    setState(() {});
  }

  void onSubmit() {
    ref
        .read(selectedLanguageProvider.notifier)
        .pickedLanguage(languageRec ?? 'en');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
          child: Image.asset('assets/images/lan.jpg'),
        ),
        Expanded(
          flex: 1,
          child: GridView.builder(
            padding: const EdgeInsets.all(30),
            itemCount: _language.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => language(index, _language[index].languageCode),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey, style: BorderStyle.solid),
                        color: selectedLanguageIndex == index
                            ? selectedCardColor
                            : unSelectedCardColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        '${_language[index].name} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
              ); // Replace with your desired widget
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 100.0, right: 40, left: 40),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: const Color(0xffffffff)),
              onPressed: onSubmit,
              child: Text(AppLocalizations.of(context)!.submit)),
        )
      ],
    ));
  }
}
