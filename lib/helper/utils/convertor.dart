String formatTime(String createdAt) {
  try {
    DateTime dateTime = DateTime.parse(createdAt);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return createdAt;
  }
}
