

Event events[];

void loadEvents() {
  ArrayList<Event> eventList = new ArrayList<Event>();
  eventList.add(new Event(am(8, 15), "Impound (ends 8:45)", "Building Event Room", "All", false));
  
  String[] lines = loadStrings("schedule.txt");
  
  for(String line : lines) {
    line = line.trim();
    if(line.length() == 0)
      continue;
    String[] words = line.split("\t");
    String[] xTimes = words[2].split("\t");
    String[] yTimes = words[3].split("\t");
    String eventName = words[0].trim();
    boolean spectator = eventName.endsWith("*");
    if(spectator)
      eventName = eventName.substring(0, eventName.length() - 1);
    for(String time : xTimes) {
      Event e = new Event(timeFromString(time), eventName, words[1].trim(), "X", spectator);
      if(DEBUG)
        println(e);
      eventList.add(e);
    }
    for(String time : yTimes) {
      Event e = new Event(timeFromString(time), eventName, words[1].trim(), "Y", spectator);
      if(DEBUG)
        println(e);
      eventList.add(e);
    }
  }
  
  events = eventList.toArray(new Event[0]);
}