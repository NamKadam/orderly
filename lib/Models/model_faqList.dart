class FAQResp {
  dynamic status;
  dynamic faq;
  dynamic msg;

  FAQResp({this.status, this.faq, this.msg});

  factory FAQResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return FAQResp(
        msg: json['msg'],
        faq: json['faq'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return FAQResp(
        msg: false,
        faq: null,
        status: '',
      );
    }
  }

}

class Faq {
  int faqId;
  String question;
  String answer;

  Faq({this.faqId, this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    faqId = json['faq_id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faq_id'] = this.faqId;
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}
