import 'package:flutter/material.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_form_status_bar.dart';

class SignupBasicInfoForm extends StatefulWidget {
  const SignupBasicInfoForm({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  State<SignupBasicInfoForm> createState() => _SignupBasicInfoFormState();
}

class _SignupBasicInfoFormState extends State<SignupBasicInfoForm>
    with AutomaticKeepAliveClientMixin<SignupBasicInfoForm> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Image.asset(
              'assets/images/auth-img-01.jpg',
              height: 300,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                child: const Text(
                  'Informações pessoais',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: const Center(
                child: SignupFormStatusBar(indexCount: 4, currentIndex: 0),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          prefixIconColor: MyColors.green,
                          isDense: true,
                          labelText: 'Nome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          prefixIconColor: MyColors.green,
                          isDense: true,
                          labelText: 'Sobrenome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownMenu<AngolaProvinces>(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          menuHeight: 200,
                          enableSearch: false,
                          requestFocusOnTap: false,
                          leadingIcon: const Icon(Icons.location_on),
                          inputDecorationTheme: InputDecorationTheme(
                            prefixIconColor: MyColors.green,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          dropdownMenuEntries: AngolaProvinces.values
                              .map(
                                (province) => DropdownMenuEntry(
                                  value: province,
                                  label: province.label,
                                ),
                              )
                              .toList(),
                          label: const Text('Local atual'),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: widget.onContinue,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum AngolaProvinces {
  bengo(label: 'Bengo', value: 1),
  benguela(label: 'Benguela', value: 2),
  bie(label: 'Bié', value: 3),
  cabinda(label: 'Cabinda', value: 4),
  cuandoCubango(label: 'Cuando Cubango', value: 5),
  cuanzaNorte(label: 'Cuanza Norte', value: 6),
  cuanzaSul(label: 'Cuanza Sul', value: 7),
  cunene(label: 'Cunene', value: 8),
  huambo(label: 'Huambo', value: 9),
  huila(label: 'Huíla', value: 10),
  luanda(label: 'Luanda', value: 11),
  lundaNorte(label: 'Lunda Norte', value: 12),
  lundaSul(label: 'Lunda Sul', value: 13),
  malanje(label: 'Malanje', value: 14),
  moxico(label: 'Moxico', value: 15),
  namibe(label: 'Namibe', value: 16),
  uige(label: 'Uíge', value: 17),
  zaire(label: 'Zaire', value: 18);

  const AngolaProvinces({required this.label, required this.value});

  final String label;
  final int value;
}
