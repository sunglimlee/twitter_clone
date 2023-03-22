// enum 이 클래스 맞지? 그럼 생성자를 생성할 수 있는것 맞지?

// 자세히 보니깐 알겠다. 각각 객체들의 묶음이네..
enum NotificationType {
  like('like'),
  follow('follow'),
  retweet('retweet'),
  reply('reply');

  final String type;
  const NotificationType(this.type);
}

// 기억하자. ConvertTweet 는 그냥 extension 의 이름일 뿐이었다.
// 'text'.toEnum() 이렇게 하면 TweetType.text 가 리턴될 거다.
extension ConvertTweet on String {
  NotificationType toNotificationTypeEnum() {
    switch(this) {
      case 'reply' : return NotificationType.reply;
      case 'follow' : return NotificationType.follow;
      case 'retweet' : return NotificationType.retweet;
      default : return NotificationType.like;
    }
  }
}

