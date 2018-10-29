//19 07 14 : initial code
//20 07 14 : it works with arduino !!
//07 07 15 : picture for the plane and for the grass
//06 12 15 : score system with the bird


int i, j; 

int Score ;
float DistancePlaneBird;


float Hauteur; //en Y
float Angle;
int DistanceUltra;
int IncomingDistance;
//float Pas; //pour deplacements X

float BirdX;
float BirdY;

float GrassX ;  //for X position




String DataIn; //incoming data on the serial port

//5 a 32 cm


float [] CloudX = new float[6];
float [] CloudY = new float[6];

//vitesse constante hein


PImage Cloud;
PImage Bird;
PImage Plane;
PImage Grass;



// serial port config
import processing.serial.*; 
Serial myPort;    



//preparation
void setup() 
{

    //myPort = new Serial(this, Serial.list()[2], 9600); 

    //myPort.bufferUntil(10);   //end the reception as it detects a carriage return

    frameRate(30); 

    size(800, 600);
    rectMode(CORNERS) ; //we give the corners coordinates 
    noCursor(); //why not ?
    textSize(16);

    Hauteur = 300; //initial plane value


    Cloud = loadImage("cloud.png");  //load a picture
    Bird = loadImage("bird.png");  
    Plane = loadImage("plane.png");  //the new plane picture

        Grass = loadImage("grass.png");  //some grass


    //int clouds position
    for  (int i = 1; i <= 5; i = i+1) {
        CloudX[i]=random(1000);
        CloudY[i]=random(400);
    }


    Score = 0;
}


//incoming data event on the serial port


void serialEvent(Serial p) { 
    DataIn = p.readString(); 
    // println(DataIn);

    IncomingDistance = int(trim(DataIn)); //conversion from string to integer

    println(IncomingDistance); //checks....

    if (IncomingDistance>1  && IncomingDistance<100 ) {
        DistanceUltra = IncomingDistance; //save the value only if its in the range 1 to 100     }
    }
}


//main drawing loop
void draw() 
{
    background(0, 0, 0);
    Ciel(); //draw the sky
    fill(5, 72, 0);



    //rect(0, 580, 800, 600); //some grass

    //new grass : 

    for  (int i = -2; i <= 4; i = i+1) {  //a loop to display the grass picture 6 times

        image(Grass, 224*i  + GrassX, 550, 224, 58);  // 224 58 : picture size
    }

    //calculates the X grass translation. Same formulae than the bird
    GrassX = GrassX  -  cos(radians(Angle))*10;

    if (GrassX < -224) {  //why 224 ? to have a perfect loop
        GrassX=224;
    }


    text(Angle, 10, 30); //debug things...
    text(Hauteur, 10, 60); 


    //new part : check the distance between the plane and bird and increase the score
    DistancePlaneBird = sqrt(pow((400-BirdX), 2) + pow((Hauteur-BirdY), 2)) ;

    if (DistancePlaneBird < 40) {
        //we hit the bird   
        Score = Score+ 1;

        //reset the bird position
        BirdX = 900;
        BirdY = random(600);
    }

    //here we draw the score
    text("Score :", 200, 30); 
    text( Score, 260, 30); 



    Angle = mouseY-300; //uncomment this line and comment the next one if you want to play with the mouse
    //Angle = (18- DistanceUltra)*4;  // you can increase the 4 value...



    Hauteur = Hauteur + sin(radians(Angle))*10; //calculates the vertical position of the plane

    //check the height range to keep the plane on the screen 
    if (Hauteur < 0) {
        Hauteur=0;
    }

    if (Hauteur > 600) {
        Hauteur=600;
    }

    TraceAvion(Hauteur, Angle);

    BirdX = BirdX - cos(radians(Angle))*10;

    if (BirdX < -30) {
        BirdX=900;
        BirdY = random(600);
    }

    //draw and move the clouds
    for  (int i = 1; i <= 5; i = i+1) {
        CloudX[i] = CloudX[i] - cos(radians(Angle))*(10+2*i);

        image(Cloud, CloudX[i], CloudY[i], 300, 200);

        if (CloudX[i] < -300) {
            CloudX[i]=1000;
            CloudY[i] = random(400);
        }
    }

    image(Bird, BirdX, BirdY, 59, 38); //displays the useless bird. 59 and 38 are the size in pixels of the picture
}


void Ciel() {
    //draw the sky

    noStroke();
    rectMode(CORNERS);

    for  (int i = 1; i < 600; i = i+10) {
        fill( 49    +i*0.165, 118   +i*0.118, 181  + i*0.075   );
        rect(0, i, 800, i+10);
    }
}


//file end
