final boolean DEBUG = false;
final boolean FULLSCREEN = true;

PGraphics noiseGraphics;

float fontScale = 100;
float scroll = 0;

PImage spectatorIcon;

void keyPressed() {
  if(!DEBUG)
    return;
  if(keyCode == LEFT)
    currentTimeOffset -= 15;
  if(keyCode == RIGHT)
    currentTimeOffset += 15;
}

void settings() {
  if(FULLSCREEN)
    fullScreen(P3D);
  else {
    size(1024, 768);
  }
}

void setup() {
  if(!FULLSCREEN)
    surface.setResizable(true);
  PFont theFont = loadFont("Roboto-Light-100.vlw");
  textFont(theFont, fontScale);
  noiseGraphics = createGraphics(160, 90);
  loadEvents();
  spectatorIcon = loadImage("eye.png");
}

void draw() {
  fontScale = height / 6.5;
  
  float millis = millis();
  
  noiseGraphics.beginDraw();
  noiseGraphics.loadPixels();
  for(int i = 0; i < noiseGraphics.pixels.length; i++) {
    noiseGraphics.pixels[i] = lerpColor(color(17,178,67), color(255,243,49),
      noise((i % noiseGraphics.width) / 20.0, i / noiseGraphics.width / 20.0, millis/2000));
  }
  noiseGraphics.updatePixels();
  noiseGraphics.endDraw();
  
  image(noiseGraphics, 0, 0, width, height);
  
  //background(255,255,255);
  fill(#2d742d);
  noStroke();
  textAlign(CENTER, TOP);
  textSize(.5 * fontScale);
  text("Sehome SciOly 2018!", width/2, fontScale * .2);
  
  textSize(fontScale);
  fill(#026CA0);
  text(timeString(currentTime()), width/2, .9 * fontScale);
  
  int scheduleY = int(fontScale * 2.25);
  clip(0, scheduleY - fontScale * .25, width, height);
  int endY = scheduleY + int(scroll);
  endY = drawSchedule(endY);
  boolean shouldScroll = endY - scroll > height;
  if(endY < scheduleY) {
    scroll = endY - scheduleY;
    if(DEBUG)
      println("next!");
  }
  if(shouldScroll)
    while(endY < height)
      endY = drawSchedule(endY);
  noClip();
  
  if(shouldScroll)
    scroll -= 60.0 / frameRate;
  else
    scroll = 0;
}

int drawSchedule(int itemY) {
  int currentTime = currentTime();
  
  int itemNum = 0;
  
  textSize(fontScale * .3);
  textAlign(LEFT, CENTER);
  
  boolean inProgressEvents = false;
  for(Event event : events)
    if(event.inProgress(currentTime)) {
      inProgressEvents = true;
      break;
    }
  
  if(inProgressEvents) {
    fill(#026CA0);
    text("In Progress:", fontScale * .2, itemY);
    itemY += fontScale * .6;
  }
  
  for(Event event : events) {
    if(!event.inProgress(currentTime))
      continue;
    drawScheduleItem(event, itemNum, itemY);
    itemNum++;
    itemY += fontScale * .5;
  }
  
  boolean upcomingEvents = false;
  for(Event event : events)
    if(event.upcoming(currentTime)) {
      upcomingEvents = true;
      break;
    }
  
  if(upcomingEvents) {
    itemY += fontScale * .1;
    fill(#026CA0);
    text("Upcoming:", fontScale * .2, itemY);
    itemY += fontScale * .5;
  }
  
  for(Event event : events) {
    if(!event.upcoming(currentTime))
      continue;
    drawScheduleItem(event, itemNum, itemY);
    itemNum++;
    itemY += fontScale * .5;
  }
  
  return itemY;
}

void drawScheduleItem(Event event, int itemNum, int itemY) {
  if(itemNum % 2 == 0) {
    fill(#056d03, 127);
  } else {
    fill(#29b026, 127);
  }
  rect(0, itemY - fontScale * .25, width, fontScale * .5);
  
  fill(#000000);
  text(timeString(event.startTime), fontScale * .2, itemY);
  text(event.text[2] + ": " + event.text[0], fontScale * 2, itemY);
  text(event.text[1], fontScale * 6, itemY);
  
  if(event.spectators) {
    imageMode(CENTER);
    image(spectatorIcon, fontScale * 1.7, itemY, fontScale * .3, fontScale * .3);
    imageMode(CORNER);
  }
}