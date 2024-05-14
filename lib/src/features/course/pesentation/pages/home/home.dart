import 'package:flutter/material.dart';
import 'package:online_course/core/utils/dummy_data.dart';
import 'package:online_course/src/features/course/pesentation/pages/course_functions/course_add.dart';
import 'package:online_course/src/features/course/pesentation/pages/home/widgets/home_appbar.dart';
import 'package:online_course/src/features/course/pesentation/pages/home/widgets/home_category.dart';
import 'package:online_course/src/features/course/pesentation/pages/home/widgets/home_feature_block.dart';
import 'package:online_course/src/features/course/pesentation/pages/instructor/add_instructor.dart';
import 'package:online_course/src/features/course/pesentation/pages/instructor/delete_instructor.dart';
import 'package:online_course/src/features/course/pesentation/pages/instructor/edit_instructor_infos.dart';
import 'package:online_course/src/theme/app_color.dart';
import 'package:online_course/src/widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showButton = true;

  @override
  void initState() {
    super.initState();
    // Example: Set showButton to true based on some condition
    // showButton = shouldShowButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: HomeAppBar(profile: profile),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeCategory(
            categories: categories,
          ),
          const SizedBox(
            height: 15,
          ),
          const HomeFeatureBlock(),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "Öğretmen",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Butonların arasında boşluk olacak şekilde hizalama yapar
            children: [
              if (showButton)
                CustomButton(
                  radius: 10,
                  title: "Ekle",
                  onTap: _addInstructor,
                ),
              CustomButton(
                radius: 10,
                title: "Sil",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteInstructorPage()),
                  );
                },
              ),
              CustomButton(
                radius: 10,
                title: "Düzenle",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditInstructorPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "Kurs",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Butonların arasında boşluk olacak şekilde hizalama yapar
            children: [
              if (showButton)
                CustomButton(
                  radius: 10,
                  title: "Ekle",
<<<<<<< HEAD
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCoursePage()),
                    );
                  },
=======
                  onTap: _addInstructor,
>>>>>>> 4abfa489529a7a26596799ac393c6360ebb09e37
                ),
              CustomButton(
                radius: 10,
                title: "Sil",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteInstructorPage()),
                  );
                },
              ),
              CustomButton(
                radius: 10,
                title: "Düzenle",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditInstructorPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addInstructor() {
    // Implementation of _addInstructor method
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddInstructorPage()),
    );
  }
}
