//database urls
//Please add your admin panel url here and make sure you do not add '/' at the end of the url
import 'package:eschool_teacher/utils/labelKeys.dart';

const String baseUrl = "http://suffahwelfarefoundation.com";

const String databaseUrl = "$baseUrl/api/";

//error message display duration
const Duration errorMessageDisplayDuration = Duration(milliseconds: 3000);

String getExamStatusTypeKey(String examStatus) {
  if (examStatus == "0") {
    return upComingKey;
  }
  if (examStatus == "1") {
    return onGoingKey;
  }
  return completedKey;
}

List<String> examFilters = [allExamsKey, upComingKey, onGoingKey, completedKey];
