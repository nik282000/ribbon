//circleNoise

//there is a bunch of bad practice in here because I am self taught
//like, I don't know how to avoid global variables like this, im sorry
//this code will run super slow, I am calculating a lot of stuff over and over instead of storing it and reusing it.
//There are a thousand ways to speed it up.

boolean saveing = false;  //are we saving images or just viewing the animation

float t = 0;  //keep track of time
float timeStep = 1;  //inrement time by this much on each loop
float noiseScale = 100;  //magic number used to tune the amplitude of the perlin noise
float ringStepSize = 0.1;  //resolution in degrees of the circle while it is being drawn
float DEG2RAD = PI/180;  //help me convert degrees to radians because I am bad at math and drink heavily
String fName;  //used later to store the name of each frame before it is stored

float roundNoise(float a, float t){  //this takes an angle and a time variable and returns a noise value
  //the x and y are used to plot the sum of 2 circles (one circle defined by 'a' that slides around in a circle defined by 't.' Like sliding a coin on a table)
  //the e and y values are the edge of the coin as it slide around in perlin noise space.
  float x, y;
  x = width + cos(t * DEG2RAD) + cos(a * DEG2RAD);
  y = height + sin(t * DEG2RAD) +  sin(a * DEG2RAD);
  //the x and y values are used to get a perlin noise value, it it multipled by the magic number AND a sin wave, this modulates the noise from 0 to a maximum and then back to 0
  float n = noise(x, y) * noiseScale * (1 + sin((t + 270) * DEG2RAD));
  return n;
}

void ribbon(float t, float i){ //takes t (time) and i (intensity/opacity) and makes a ring whos radiaus is determined by the roundNoise function
  for(float a = 0; a < 360; a = a + ringStepSize){  //0-360 makes a circle
    stroke((a + t)%360, 100, 100, i);  //colour is changed depending on where you are in the circle and the time
    strokeWeight(0.1); //this could go somewhere else
    float x = (width / 2) + (cos(a * DEG2RAD) * (50 + roundNoise(a, t))); //calculated the x an y location of the point to be drawn for a circle with the radius multiplied by the roundNoise function
    float y = (height / 2) + (sin(a * DEG2RAD) * (50 + roundNoise(a, t)));
    point(x, y);
  }
}

void setup(){ //setup the colorMode, sketch resolution, etc
  colorMode(HSB, 360, 100, 100, 100);
  fill(0, 0, 0, 10);
  size(640,480);
  background(0, 0, 0, 100);
}

void draw(){  //draw the ribbon, increase time by timeStep, repeat
  background(0, 0, 0, 100);
  for(float i = 0; i < 1; i = i + 0.02){
    ribbon(t + (i * 32), (i * i) * 100);
  }
  
  t = t + timeStep; //step one timeStep into the future
  if(saveing){  //if we are saving images then make a file name and then save the image
    fName = ("colour/" + nf(int(t%360), 5) + ".png");
    save(fName);
    println(fName);
    if(t>360){  //if you have made it to 360, you're done saving images!
      exit();
    }
  } else {
    t = t%360; //if time is ?360 then wrap around with modulus
  }
}
