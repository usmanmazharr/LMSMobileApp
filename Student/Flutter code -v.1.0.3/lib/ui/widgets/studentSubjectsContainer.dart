import 'package:eschool/app/routes.dart';
import 'package:eschool/data/models/subject.dart';
import 'package:eschool/ui/widgets/subjectImageContainer.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class StudentSubjectsContainer extends StatelessWidget {
  final String subjectsTitleKey;
  final List<Subject> subjects;
  final int? childId;
  const StudentSubjectsContainer({
    Key? key,
    this.childId,
    required this.subjects,
    required this.subjectsTitleKey,
  }) : super(key: key);

  Widget _buildSubjectContainer(
      {required BoxConstraints boxConstraints,
      required int index,
      required Subject subject,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.subjectDetails, arguments: {
          "childId": childId,
          "subject": subject,
        });
      },
      child: Container(
        width: boxConstraints.maxWidth * (0.26),
        margin: EdgeInsets.only(
          bottom: 15.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SubjectImageContainer(
              showShadow: false,
              width: boxConstraints.maxWidth * (0.26),
              height: boxConstraints.maxWidth * (0.26),
              radius: 20,
              subject: subject,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              subject.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: UiUtils.getColorScheme(context).secondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width *
              UiUtils.screenContentHorizontalPaddingInPercentage),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(UiUtils.getTranslatedLabel(context, subjectsTitleKey),
                style: TextStyle(
                    color: UiUtils.getColorScheme(context).secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
                textAlign: TextAlign.start),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          LayoutBuilder(builder: (context, boxConstraints) {
            return Wrap(
              spacing: boxConstraints.maxWidth * (0.1),
              direction: Axis.horizontal,
              children: List.generate(subjects.length, (index) => index)
                  .map((index) => _buildSubjectContainer(
                      boxConstraints: boxConstraints,
                      context: context,
                      index: index,
                      subject: subjects[index]))
                  .toList(),
            );
          })
        ],
      ),
    );
  }
}
