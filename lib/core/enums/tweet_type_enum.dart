// enum 이 클래스 맞지? 그럼 생성자를 생성할 수 있는것 맞지?

enum TweetType {
  text('text'),
  image('image');

  final String type;
  const TweetType(this.type);
}

// 기억하자. ConvertTweet 는 그냥 extension 의 이름일 뿐이었다.
// 'text'.toEnum() 이렇게 하면 TweetType.text 가 리턴될 거다.
extension ConvertTweet on String {
  TweetType toTweetTypeEnum() {
    switch(this) {
      case 'text' : return TweetType.text;
      case 'image' : return TweetType.image;
      default : return TweetType.text;
    }
  }
}
