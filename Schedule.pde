class Event {
  int startTime;
  String[] text;
  boolean spectators;
  
  Event(int startTime, String event, String location, String teams, boolean spectators) {
    this.startTime = startTime;
    event = event.substring(0, 1) + event.toLowerCase().substring(1);
    text = new String[] {
      event, location, teams
    };
    this.spectators = spectators;
  }
  
  boolean inProgress(int time) {
    return time >= startTime && time <= startTime + 60;
  }
  
  boolean upcoming(int time) {
    return time >= (startTime - 60) && time < startTime;
  }
  
  String toString() {
    return timeString(startTime) + ": " + text[2] + ": " + text[0] + "    " + text[1] + "    " + "    " + spectators;
  }
}