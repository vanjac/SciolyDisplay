int currentTimeOffset = 0;

int am(int hour, int minute) {
  if(hour == 12)
    hour = 0;
  return hour * 60 + minute;
}

int pm(int hour, int minute) {
  if(hour == 12)
    hour = 0;
  return (hour + 12) * 60 + minute;
}

int currentTime() {
  return hour() * 60 + minute() + currentTimeOffset;
}

String timeString(int time) {
  return blinkingTimeString(time, true);
}

String blinkingTimeString(int time, boolean blink) {
  int h = time / 60;
  h %= 12;
  if(h == 0)
    h = 12;
  int m = time % 60;
  boolean pm = (time % (60*24)) >= 60*12;
  String mStr = str(m);
  if(mStr.length() == 1)
    mStr = "0" + mStr;
  return h + (blink ? ":" : " ") + mStr + (pm ? " PM" : " AM");
}

int timeFromString(String time) {
  time = time.trim();
  String[] words = time.split(":");
  int h = int(words[0]);
  int m = 0;
  if(words.length > 1)
    m = int(words[1]);
  if(h < 8)
    h += 12;
  return h * 60 + m;
}