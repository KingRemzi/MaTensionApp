import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matension_app/tension_model.dart';
import 'package:matension_app/validator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> options = ["Bras Droit", "Bras Gauche"];
  TextEditingController textController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String  currentOption = "Bras Droit";
  List<Tension> tension =[];
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }


  void _handleGenderChange(String value) {
    setState(() {
      currentOption = value;
    });
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
      
    }),);
    
  }

  Future<void> _selectDate() async {
    DateTime? _choisedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now()
    );

    if(_choisedDate != null){
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(_choisedDate);
        print("DATE : ${dateController.text}");
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), 
          child: child ?? Container(),
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        print("Picked $picked");
        selectedTime = picked;
        
      });
    }
  }

  @override
  void initState() {
    //currentOption =  options[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemBuilder:(context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 2),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(15)
                ),
                minLeadingWidth: 100,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.back_hand_rounded, color: Colors.grey,),
                    Text(tension[index].bras)
                  ],
                ),
                title: Column(
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monitor_heart_rounded),
                        Text("Tension"),
                        
                        
                      ],
                    ),
                    Text("${tension[index].tension}")
                  ],
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.clock),
                        Text("Date et Heure"),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("${tension[index].date} ${tension[index].heure.hour}:${tension[index].heure.minute}")
                  ],
                ),
                onTap: () {
                  
                },
              ),
            );
          }, 
          
          itemCount: tension.length
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_incrementCounter();
          showModalBottomSheet(
            context: context, 
            builder:(context) {
              return StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Spacer(flex: 2,),
                              const Text("Ajouter une tension",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const Spacer(flex: 1,),
                              IconButton(
                                onPressed: () {
                                  
                                  Navigator.pop(context);
                                        
                                }, 
                                icon: const Icon(CupertinoIcons.xmark)
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20),
                            child: Row(
                              children: [
                                const Text("Choissisez un bras", style: TextStyle(fontSize: 16),),
                                const SizedBox(width: 50,),
                                DropdownButton(
                                  value: currentOption,
                                  items: const [
                                    DropdownMenuItem(
                                      value: "Bras Droit",
                                      child: Text("Bras Droit")
                                    ),
                                    DropdownMenuItem(
                                      value: "Bras Gauche",
                                      child: Text("Bras Gauche")
                                    ),
                                  ], 
                                  onChanged: (value) {
                                    setState(() {
                                      currentOption = value!;
                                                
                                    });
                                    print(currentOption);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:10.0, vertical: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                //filled: true,
                                // make the background transparent to show the color of the background
                                //fillColor: Colors.transparent,
                                label: const Text("Tension"),
                                labelStyle: Theme.of(context).textTheme.labelLarge,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color.fromARGB(255, 185, 185, 185), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Color.fromARGB(255, 185, 185, 185), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                                ),
                                prefixIcon: const Icon(CupertinoIcons.person_alt),
                                prefixIconColor: Colors.grey
                              ),
                              controller: textController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              validator: (value) => Validator.validateNumber(value),
                            ),
                          ),
                          DateField(),
                          ElevatedButton(
                            onPressed: () => _selectTime(context),
                            child: const Text("Sélectionner une heure"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 20),
                            child: SizedBox(
                              height: 50,
                              //width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()){
                                    print("Value ${textController.text.trim()}");
                                    print("Option ${currentOption}");
                                    Tension t= new Tension(
                                      bras: currentOption, 
                                      tension: double.parse(textController.text.trim()),
                                      date: dateController.text.trim(),
                                      heure: selectedTime);
                                    tension.add(t);
                                    print(tension);
                                    Navigator.pop(context);
                                  }
                                }, 
                                style: ButtonStyle(
                                  backgroundColor: const MaterialStatePropertyAll(Colors.purple),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  )
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Valider",
                                      style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          )
                        ],
                      )
                  );
                }
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget DateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom:10.0, right: 5,left: 5),
      child: TextField(
        controller: dateController,
        decoration: InputDecoration(
          label: const Text("Date"),
          labelStyle: Theme.of(context).textTheme.labelLarge,
          prefixIcon: const Icon(CupertinoIcons.calendar),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 185, 185, 185), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.purple, width: 2),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(),
      ),
    );
  }
}