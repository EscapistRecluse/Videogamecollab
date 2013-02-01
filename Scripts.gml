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

draw_sprite(plyrShipBase,-1,plyrX,plyrY);

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

















#define gameController
//Call the playerHandler Scripts
playerHandler();

#define Initialization
//In this script, we define all of the variables we are going to use elsewhere in the game
//========================================================================================

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
plyrMaxSpdX = 15;        //Max speed in X direction, in pixels per second
plyrMaxSpdY = 12;        //Max speed in Y direction, in pixels per second
plyrAcc = 3;    //Player Acceleration, in pixels per second squared



