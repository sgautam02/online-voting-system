import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../controllers/election_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/date_picker.dart';
import '../widgets/input_field.dart';

ElectionController _electionController = ElectionController();

TextEditingController _electionNameController = TextEditingController();
TextEditingController _electionDescriptionController = TextEditingController();
TextEditingController _electionStartDateController = TextEditingController();
TextEditingController _electionEndDateController = TextEditingController();
final owner = Get.find<UserController>().user;

class NewVote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _electionController = Get.put(ElectionController());
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
            sliver: SliverToBoxAdapter(
              child: Image(
                image: AssetImage('assets/icons/logo.png'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'CREATE NEW ELECTION',
                style: GoogleFonts.yanoneKaffeesatz(
                    fontSize: 28.0,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    InputField(
                      controller: _electionNameController,
                      hintText: 'Enter the election\'s name',
                      prefixIcon: Icons.person,
                      obscure: false,
                    ),
                    InputField(
                      controller: _electionDescriptionController,
                      hintText: 'Enter the election\'s description',
                      prefixIcon: Icons.edit,
                      obscure: false,
                    ),
                    VoteDate(
                        controller: _electionStartDateController,
                        title: 'START DATE',
                        hint: 'Start date of the election',
                        prefixIcon: Icons.calendar_view_day),
                    VoteDate(
                        controller: _electionEndDateController,
                        title: 'END DATE',
                        hint: 'End date of the election',
                        prefixIcon: Icons.date_range)
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () async {
                await _electionController.createElection(
                  _electionNameController.text,
                  _electionDescriptionController.text,
                  _electionStartDateController.text,
                  _electionEndDateController.text,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 55.0, bottom: 20.0, right: 55.0),
                decoration: BoxDecoration(
                    color: Colors.indigo[400],
                    borderRadius: BorderRadius.circular(18.0)),
                child: Column(
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                    Icon(
                      Icons.next_plan,
                      size: 32.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
