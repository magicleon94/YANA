class Note {
  String title;
  String text;
  String uid;

  Note({this.text,this.title,this.uid});

  Note.fromMap(Map<String, dynamic> map)
      : title = map["title"],
        text = map["text"];

  Map<String, dynamic> toMap() {
    return {"title": this.title, "text": this.text};
  }
}
