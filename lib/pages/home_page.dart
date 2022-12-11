import 'package:flutter/material.dart';
import 'package:tasks_app/pages/second_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Widget containing row information for listed diseases
// This simplifies use of grouped information
const List<Widget> groupBy = <Widget>[
  Text('disease'), 
  Text('type'), 
  Text('measurement unit')
];

List<String> diseases = <String>['Cholesterol HDL', 'Cholesterol LDL', 'Weight', 'Age', 'Blood Pressure'];
List<String> diseasesByType = <String>['Age', 'Weight', 'Blood Pressure', 'Cholesterol HDL', 'Cholesterol LDL'];
List<String> diseasesByMeasurement = <String>['Cholesterol HDL', 'Cholesterol LDL', 'Blood Pressure', 'Weight', 'Age'];
List<String> currDiseases = diseases;

List<String> units = <String>['mg/dl, mmol/L', 'mg/dl, mmol/L', 'Kg, pounds', 'Years', 'mmHg'];
List<String> unitsByType = <String>['Years', 'Kg, pounds', 'mmHg', 'mg/dl, mmol/L', 'mg/dl, mmol/L'];
List<String> unitsByMeasurement = <String>['mg/dl, mmol/L', 'mg/dl, mmol/L', 'mmHg', 'Kg, pounds', 'Years'];
List<String> currUnits = units;

List<bool> checkedDiseases = <bool>[false, false, false, false, false];

const List<int> listSpot = <int>[3, 2, 4, 0, 1];
List<bool> groupBySelected = <bool>[false, false, false];

// ignore: non_constant_identifier_names
bool isChecked_BiomarkerName = false;
// ignore: non_constant_identifier_names
bool isChecked_RequestSavingData = false;

String dataToRequest = "";
String qrCodeURL = "";

// Controller for saving link provided by user
final myController = TextEditingController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool vertical = false;

  @override
  void dispose() {
    // Dispose of controller once the Widget is disposed of
    myController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(249,251,255,255),
      body: SafeArea(
        child: Column(
          children: [
            // top icon and images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/Logo.png', height: 40),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                          child: Text("Esther", style: TextStyle(fontSize: 14)),
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/Profile.jpeg'),
                        radius: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // top text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text("Request Data", style: TextStyle(fontSize: 24))
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text("Request Patient Data to Run Analysis", style: TextStyle(fontSize: 12))
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // request section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8), 
                    child: Text("Data to Request", style: TextStyle(fontSize: 16))
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 400),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: 30,
                              child: TextField(
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                  labelText: 'Cholesterol, Weight, Age...',
                                ),
                                style: const TextStyle(fontSize: 14),
                                onSubmitted: (text){
                                  // setState() updates information in real time throughout the program
                                  setState(() {
                                    dataToRequest = text;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("Group by: ", style: TextStyle(fontSize: 14)),
                        ),
                        ToggleButtons(
                          textStyle: const TextStyle(fontSize: 12),
                          direction: vertical ? Axis.vertical : Axis.horizontal,
                          onPressed: (int index) {
                            // One button selectable at a time
                            setState(() {
                              for (int i = 0; i < groupBySelected.length; i++) {
                                groupBySelected[i] = i == index;
                              }
                              // Update displayed disease list based on ordering preferences selected by user
                              if (groupBySelected[0] == true) {
                                currDiseases = diseases;
                                currUnits = units;
                                uncheckBoxes();
                              }
                              else if (groupBySelected[1] == true) {
                                currDiseases = diseasesByType;
                                currUnits = unitsByType;
                                uncheckBoxes();
                              }
                              else if (groupBySelected[2] == true) {
                                currDiseases = diseasesByMeasurement;
                                currUnits = unitsByMeasurement;
                                uncheckBoxes();
                              }
                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          selectedColor: Colors.white,
                          fillColor: const Color.fromARGB(255, 85, 88, 237),
                          constraints: const BoxConstraints(
                            minHeight: 25.0,
                            minWidth: 120.0,
                          ),
                          isSelected: groupBySelected,
                          children: groupBy,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // options listed
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Row(
                children: [
                  Expanded(
                    child: 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                // Row 1 - Displaying basic identifier values and headers
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text("Biomarker Name", style: TextStyle(fontSize: 14)),
                                          Text("Description", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const Text("units"),
                                    Checkbox(
                                      checkColor: Colors.white,
                                      value: isChecked_BiomarkerName,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          // Below code makes it so that the checked box for the headers isn't checkable by the user
                                          //isChecked_BiomarkerName = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      // Builds the specified number of rows - one for each disease being displayed
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: 5,
                                        itemBuilder: (_, i) {
                                          Widget checkBoxWidget() => Checkbox(
                                            checkColor: Colors.white,
                                            value: checkedDiseases[i],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                checkedDiseases[i] = value!;
                                              });
                                            },
                                          );
                                          // Calls _buildRow which will build the individual rows with their respective 
                                          // information provided below
                                          return _buildRow(currDiseases[i], currUnits[i], checkBoxWidget());
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 70),
                                child: Text("Request ID"),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.file_open_outlined),
                                      border: OutlineInputBorder(),
                                      labelText: '# 000001',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 80),
                                child: Text("Expire by"),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.calendar_month_outlined),
                                      border: OutlineInputBorder(),
                                      labelText: '2022/12/10',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          // Evenly spaces out the elements in the row (horizontally)
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Request saving data"),
                            Checkbox(
                              checkColor: Colors.white,
                              value: isChecked_RequestSavingData,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked_RequestSavingData = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 15),
                          child: Row(
                            children: const [
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 50),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        enabled: false,
                                        prefixIcon: Icon(Icons.priority_high_rounded),
                                        border: OutlineInputBorder(),
                                        labelText: 'Ask patient for data storage permission\non your organization account',
                                        labelStyle: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: Text("Delete data after"),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.calendar_month_outlined),
                                      border: OutlineInputBorder(),
                                      labelText: '2022/12/10',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: Row(
                            children: const [
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 50),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        enabled: false,
                                        prefixIcon: Icon(Icons.priority_high_rounded),
                                        border: OutlineInputBorder(),
                                        labelText: 'User must be informed and allowed to\nrequest deletion anytime',
                                        labelStyle: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                          // Card is like a container with multiple components for easy displaying of information and components
                          Card(
                            color: const Color.fromARGB(230, 215, 226, 246),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                                  child: Container(
                                    color: Colors.white,
                                    // QR Code with respective data value - to be used by user or other individuals after shared
                                    child: QrImage(
                                      data: "1234567890",
                                      version: QrVersions.auto,
                                      size: 150.0,
                                    ),
                                  ),
                                ),
                                const Text("scan, share, or type in your browser:"),
                                const Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text("or wave the phone on terminal (NFC)", style: TextStyle(fontSize: 10)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: SizedBox(
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 18, bottom: 15),
                                      child: TextField(
                                        // myController will observe behavior in this Textfield where links are provided
                                        controller: myController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Provide URL',
                                          labelStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 77, 114, 217))
                                        ),
                                      ),
                                    ),
                                  ),
                              ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25, bottom: 15),
                                      child: SizedBox(
                                        height: 30,
                                        child: FloatingActionButton.extended(
                                          // Tag helps to identify differences between the various buttons in the program
                                          heroTag: "tag1",
                                          onPressed: () {}, label: const Text("Regenerate"),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 25, bottom: 15),
                                      child: SizedBox(
                                        height: 30,
                                        child: FloatingActionButton.extended(
                                          // Tag helps to identify differences between the various buttons in the program
                                          heroTag: "tag2",
                                          onPressed: () {
                                            // Updates the copied link in real time, once the "Copy" button is pressed by the user
                                            setState(() {
                                              qrCodeURL = myController.text;
                                            });
                                          }, label: const Text("Copy"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                // Button for next page
                FloatingActionButton.extended(
                  // Tag helps to identify differences between the various buttons in the program
                  heroTag: "tag3",
                  onPressed: () {
                    // Moves user from the home screen to the second page
                    Navigator.push(
                      context,
                      // Builds second page for user to move to it and access it
                      MaterialPageRoute(builder: (context) => const SecondPage()),
                    );
                  }, label: const Text("Next Page"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Requested Data: $dataToRequest"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Entered URL: $qrCodeURL"),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}

// Builder function which creates rows for the various diseases - rows are treated as Widgets in this case
Widget _buildRow(String disease, String units, Widget checkBoxWidget) => 
Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(disease),
          const Text("short description", style: TextStyle(fontSize: 12)),
          // Dividing line between sections - for some reason it doesn't work?
          // Kept it here for future reference or implementation
          /*const Divider(
            //height: 10,
            //thickness: 10,
            color: Colors.black,
          ),*/
        ],
      ),
      Text(units),
      checkBoxWidget,
    ],
  ),
);

// Function for clearing all bool values of checked boxes from disease list
uncheckBoxes() {
  checkedDiseases = <bool>[false, false, false, false, false];
}