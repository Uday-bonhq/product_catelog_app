import 'package:timeago/timeago.dart' as timeago;

String getRelativeTime(String isoDate) {
  final dateTime = DateTime.parse(isoDate);
  return timeago.format(dateTime);
}