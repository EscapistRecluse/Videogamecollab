#define menuHandler
//Here we manage menu related things
//==================================

//Parse through all of the menu options
    for (j=0; j<5; j+=1)
    {
        //Set the positions of the menu options
        menu[j,1] = cos(degtorad(j*menuSpacing - menuRotOffset))*menuPosOffset + menuController.x;
        menu[j,2] = sin(degtorad(j*menuSpacing - menuRotOffset))*menuPosOffset + menuController.y;
    }

//Change the selected menu option using the arrow keys
if (keyboard_check_pressed(vk_up)) menuHighlight += 1
if (keyboard_check_pressed(vk_down)) menuHighlight -= 1
menuHighlight = min(max(menuHighlight, 0),menuOpNum[menuDepth]);

if (menuRotOffset != menuHighlight*menuSpacing)
{
    if (menuRotOffset < menuHighlight*menuSpacing) {menuRotOffset += menuRotSpeed;} else {menuRotOffset -= menuRotSpeed;}
    
    if (abs(menuRotOffset-menuHighlight*menuSpacing) < menuRotSpeed) {menuRotOffset = menuHighlight*menuSpacing} 
    
}



#define menuInit
//Here we set up the main menu
//============================

/*--------------NOTES-------------
I have this crazy idea for the main menu - basically rotary set against the game backgrounds
*/

transTime = 20;     //Transitions take 20 frames to happen
menuSpacing = 25;   //Degrees between one menu option and another
menuMoveDist = 200;     //Distance to retreat the previous menu from the current one
menuDepth = 0;      //Current depth in the menu
menuSel[2] = 0;         //Selected options for the menu
menuHighlight = 0;      //Currently highlighted option
menuRotOffset = 0;      //The dynamic rotational offset in the menu
menuPosOffset = 150;    //The static positional offset in the menu
menuRotSpeed = 5;

//Set up a menu
//X dimension holds menu options (room for 6 options)
//Y Dimension stores data about that option (position, picture, etc)
//Number after "menu" indicates menu depth

for (a=0; a<5; a+=1)
{
    for (b=0; b<3; b+=1)
    {
        menu[a,b] = -1
        menu2[a,b] = -1
        menu3[a,b] = -1
    }
}

//Set the number of menu options
menuOpNum[0] = 2;   //First menu has 3 options

//Set the pictures for the first depth level in the menu (depth level 0):
menu[0,0] = menuStart;
menu[1,0] = menuOptions;
menu[2,0] = menuExit;

#define drawMenu
//Draw the menu
//=============

/*
menu[,] y positions are as follows:
0 = image to use for menu option
1 = image x position
2 = image y position
*/

//Parse through all of the images, drawing them to the selected menu depth

for (a=0; a<5; a+=1)        //This loop parses through all six available menu spots
    {
        if (menu[a,0] > -1)   //Check to make sure the menu option has a picture. If not, don't draw
        {
            draw_sprite(menu[a,0], 0, menu[a,1], menu[a,2]);
        }
}

#define drawPlayer
//This script draws the player
//============================

//NOTE: Since this is a drawing script, we need to draw in the proper order (or else the wrong things will be on top of the wrong stuff etc)

//Define some temp variables for screen-based wing offsets
a = plyrX/window_get_width()*6 - 3
b = plyrY/window_get_height()*6 - 3

//Draw the player craft rear wing
draw_sprite(plyrShipWinggun, plyrMainWeapon, plyrX-3 - a, plyrY-plyrSpdY/3-1 - b);
draw_set_blend_mode(bm_add);    //Set the blend mode
if plyrFXBeaconTimer = 1 then draw_sprite_ext(FXbeacon, -1, plyrX-3 - a, plyrY-plyrSpdY/3-1 - b, 0.6, 0.6, 0, c_green, 0.5);
if plyrFXBeaconTimer = 0 then draw_sprite_ext(FXbeacon, -1, plyrX-3 - a, plyrY-plyrSpdY/3-1 - b, 0.2, 0.2, 0, c_green, 0.5);
draw_set_blend_mode(bm_normal);    //Reset the blend mode

//Draw the player craft body
draw_sprite(plyrShipBase,-1,plyrX,plyrY);

//Draw the player craft front wing
draw_sprite(plyrShipWinggun, plyrMainWeapon, plyrX-3 + a, plyrY+plyrSpdY/3-1 + b);
draw_set_blend_mode(bm_add);    //Set the blend mode
if plyrFXBeaconTimer = 1 then draw_sprite_ext(FXbeacon, -1, plyrX-3 + a, plyrY-plyrSpdY/3-1 + b, 0.6, 0.6, 0, c_red, 0.5);
if plyrFXBeaconTimer = 0 then draw_sprite_ext(FXbeacon, -1, plyrX-3 + a, plyrY-plyrSpdY/3-1 + b, 0.2, 0.2, 0, c_red, 0.5);
draw_set_blend_mode(bm_normal);    //Reset the blend mode

//Manage the timer for the beacon FX
if plyrFXBeaconTimer = 0 then
{
      plyrFXBeaconTimer = 70
} else {plyrFXBeaconTimer -= 1}


//TODO: Animate the ship roll

#define gameController
//Call the playerHandler Scripts
playerHandler();

#define playerHandler
//This script is the master script for player control
//===================================================

//Control player X movement
if (keyboard_check(keyLog[0]) ^^ keyboard_check(keyLog[1]))     //Check that the player is holding EITHER left or right (^^ = XOR in GML)
{
   //Add the acceleration value to his X speed, but cap it at max speed
    plyrSpdX = min(max(plyrSpdX + plyrAcc*(keyboard_check(keyLog[1])*2-1),-1*plyrMaxSpdX),plyrMaxSpdX);
    
    //I love doing fancy things like the above. Basically, we know the player is pressing either left/right.
    //If the player is pressing right, we add a positive acceleration value (positive moves the player right)
    //and if the player is not holding right, then he must be holding left and we add a negative acceleration value.
    //To see how it works, just evaluate the event in your head. If you see what is going on here, I will do more of this
    //since this helps keep your code concise with fewer lines. Fewer lines = runs faster.
} else {
    //Here, they are either holding neither key or both keys
    
    if ( abs(plyrSpdX) < plyrAcc)
    {
        //If the player speed is less than the acceleration value from zero, we just set to zero to avoid overshooting zero
        //(the craft will vibrate back and forth when it should be sitting still)
        plyrSpdX = 0;
    } else {
        if (plyrSpdX > 0) {plyrSpdX -= plyrAcc} else {plyrSpdX += plyrAcc}
    }
};

//Control player Y movement (the above copied down and all "X" replaced with "Y"
if (keyboard_check(keyLog[2]) ^^ keyboard_check(keyLog[3]))
{
    plyrSpdY = min(max(plyrSpdY + plyrAcc*(keyboard_check(keyLog[3])*2-1),-1*plyrMaxSpdY),plyrMaxSpdY);

} else {    
    if ( abs(plyrSpdY) < plyrAcc)
    {
        plyrSpdY = 0;
    } else {
        if (plyrSpdY > 0) {plyrSpdY -= plyrAcc} else {plyrSpdY += plyrAcc}
    }
};

//Add the speed values to the X and Y coordinates
//Also use Max/Min to keep the player within game borders
plyrX = max(min(plyrX + plyrSpdX, window_get_region_width()-xBorders), xBorders);
plyrY = max(min(plyrY + plyrSpdY, window_get_region_height()-yBorders), yBorders);



//Manage player shooting
//----------------------

//Shoot main weapon
if (keyboard_check_direct(keyLog[4]) && plyrMainWpnRld < 1) then
{
    //Create the bullet particles (one per wing)
    aa = instance_create(plyrX-3 - a, plyrY+plyrSpdY/3-2 - b, particle);
    ab = instance_create(plyrX+3 + a, plyrY+plyrSpdY/3-2 + b, particle);
    aa.depth = 10;      //Set the depth so that the bullet appears behind the ship
    
    switch (plyrCurMainWpn)
    {
        case gun_gatling:   //Turn the bullets into gatling gun bullets
        aa.xSpd = 19 + plyrSpdX*0.6;
        ab.xSpd = 19 + plyrSpdX*0.6;
        aa.yAcc = 0.05;     //Give the bullets slight gravity
        ab.yAcc = 0.05;
        aa.dmg = 1;
        ab.dmg = 1;
    }
    
    //Set the reload timer
    plyrMainWpnRld = 5;


}

//Reduce shooting timer
plyrMainWpnRld -= 1












#define Initialization
//In this script, we define all of the variables we are going to use elsewhere in the game
//========================================================================================

///SET THE FUCKING FRAMES PER SECOND
//my GOD 30FPS games piss me off (and make my eyes hurt).
display_set_frequency(60);
room_speed = 60;

//Declare the player control array. This array will be used to keep track of the player
//keyboard key configuration. We do this so that the player may reconfigure his keys in game.
keyLog[5] = -1;     //Declare an array with spaces for 6 buttons

//Set the keyboard presets
keyLog[0] = vk_left;
keyLog[1] = vk_right;
keyLog[2] = vk_up;
keyLog[3] = vk_down;
keyLog[4] = vk_lcontrol;    //The left control button
keyLog[5] = vk_lshift;      //The left shift button


//Declare game variables
yBorders = 20;          //Prevent the player from going closer than 20 pixels to Y screen edges
xBorders = 10;           //Prevent the player from going closer than 0 pixels to X screen edges


//Declare player Variables
plyrX = 0;   //Player X position
plyrY = 0;   //Player Y position
plyrSpdX = 0;        //Speed in X direction, in pixels per second
plyrSpdY = 0;        //Speed in Y direction, in pixels per second
plyrMaxSpdX = 7.5;        //Max speed in X direction, in pixels per second
plyrMaxSpdY = 6;        //Max speed in Y direction, in pixels per second
plyrAcc = 3;    //Player Acceleration, in pixels per second squared
plyrMainWeapon = 0;     //Default main weapon, chaingun
plyrMainWpnRld = 0;         //Main weapon reload timer
plyrCurMainWpn = gun_gatling;         //Current main weapon

plyrFXBeaconTimer = 0;      //The timer for the flashy light beacon things

#define particleHandler
//Here we manage the day-to-day lives of the particles
//----------------------------------------------------

//Manage position
x += xSpd;
y += ySpd;

//Destroy out of-play-particles
if (abs(window_get_width()/2 - x) > window_get_width()/2) then {instance_destroy()}
if (abs(window_get_height()/2 - y) > window_get_height()/2) then {instance_destroy()}

//Manage collisions between particles
a = collision_line(x, y, x+xSpd, y+ySpd, particle, false, true)
if (a > 0)
{
    if (depth = a.depth)    //Have to do nested ifs like this because game maker is gay
    {
        a.ySpd = random(200)/10-10;
        a.xSpd = 21;
        ySpd = random(200)/10-10;
        xSpd = 21;
        //TODO Create sparks and shit
    }
}




//Manage acceleration
xSpd += xAcc;
ySpd += yAcc;

#define particleInit
//Script called by particles upon creation to initialize their variables
xSpd = 0;
ySpd = 0;
xAcc = 0;
yAcc = 0;
dmg = 0;        //Damage the particle inflicts
coll = 0;       //Whether or not the particle can collide with stuff


