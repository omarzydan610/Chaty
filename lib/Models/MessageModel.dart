class Message {
  final String message;
  final String From;
  final String To;

  Message({required this.message, required this.From, required this.To});

  factory Message.fromJson(jsonData) {
    return Message(
      message: jsonData["message"],
      From: jsonData["from"],
      To: jsonData["to"],
    );
  }
}
