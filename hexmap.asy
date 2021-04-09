//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// *************************************                                        //
// *** Hex Map Generator ***			                                        //
// *************************************                                        //
// Copyright (c) 2018-2021 by Harald Katzer & Mike Thielen                      //
// All rights reserved.                                                         //
//                                                                              //
// Permission is hereby granted, free of charge, to any person                  //
// obtaining a copy of this software and associated documentation               //
// files (the "Software"), to deal in the Software without restriction,         //
// including without limitation the rights to use, copy, modify, merge,         //
// publish, distribute, sublicense, and/or sell copies of the Software,         //
// and to permit persons to whom the Software is furnished to do so,            //
// subject to the following conditions:                                         //
//                                                                              //
// The above copyright notice and this permission notice shall                  //
// be included in all copies or substantial portions of the Software.           //
//                                                                              //
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,              //
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF           //
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.       //
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY         //
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,         //
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE            //
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                       //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

// package settings for Starfire counter font
// limited to PDF output only. If EPS/SVG desired, comment out the lines
// beginning with "usepackage" and do not use Starfire font
// use command: asy <filename> -tex xelatex

//usepackage("fontspec");
//usepackage("xunicode");
//usepackage("xltxtra");

// basic settings
unitsize(1cm, 1cm);

// map size and color
int int_MapsizeX = 83;
int int_MapsizeY = 64;
pen pen_MapBackgroundColor = black;
pen pen_HexColor = white;

// label style (classic/custom) and color
bool bool_LabelStyleClassic = true;
pen pen_LabelColor = white;
pen pen_LabelFillColor = invisible;

// systemhex position, size and color
bool bool_SystemHex = true;
int int_SystemHexRadius = 30;
int int_SystemHexPosX = 42;
int int_SystemHexPosY = 32;
pen pen_SystemHexColor = white;
pen pen_SystemHexWidth = linewidth(5pt);

// scattergram position and color
bool bool_Scattergram = true;
int int_ScatterPosX = 8;
int int_ScatterPosY = 58;
pen pen_ScatterColor = white;
pen pen_ScatterHexWidth = linewidth(5pt);

// set custom font for labels
bool bool_CustomFont = true;
pen pen_LabelText = font("T1", "phv", "m", "n");
pen pen_LargeText = font("T1", "phv", "b", "n");

// background image file
bool bool_BackgroundImage = false;
string string_imagefile = "somespace.eps";

// define hex geometry
real real_HexRadiusS2S = 1;
real real_HexRadiusP2P = real_HexRadiusS2S / Cos(30);
real real_Hexside = Sin(30) * real_HexRadiusP2P * 2;

defaultpen(fontsize(10pt));

// initialize polygon path and counting variables
path path_polygon = polygon(6);
int int_x = 0;
int int_y = 0;

// calculate hex stepping
real real_stepX = real_HexRadiusP2P + real_Hexside / 2;
real real_stepY = real_HexRadiusS2S * -2;
real real_halfstepY = real_HexRadiusS2S * -1;

// calculate real positions from coordinates
pair pair_getPos(int x, int y)
	{
	pair pair_newPos = ((x * real_stepX), (y * real_stepY));
	// even hexes are lower
	if((x % 2) == 1)
		{
		pair_newPos = ((x * real_stepX), (y * real_stepY + real_halfstepY));
		}
	return pair_newPos;
	}

// calculate relative points from hex position (for radians)
// using polar coordinate conversions: x = r * sin (angle)
pair pair_getRelPos(pair pair_Pos, int int_radian, real real_radius)
	{
	pair pair_newPos = (pair_Pos.x, pair_Pos.y);
	real real_unitRadius;

	if (int_radian % 2 == 1) {
	real_unitRadius = real_HexRadiusS2S;
	}
	else {
	real_unitRadius = real_HexRadiusP2P;
	}

	int int_radianAngle = (int_radian - 1) * 30;
	pair_newPos = (pair_Pos.x + real_radius*real_unitRadius*Sin(int_radianAngle), pair_Pos.y + real_radius*real_unitRadius*Cos(int_radianAngle));

	return pair_newPos;
	}

// drawing functions
void drawHex(int x, int y)
	{
	path path_Hex = scale(real_HexRadiusP2P)*path_polygon;
	draw(shift(pair_getPos(x,y))*path_Hex, pen_HexColor);
	}

void drawLabelClassic(int x, int y)
	{
	string s_x = format("%02d", x + 1);
	string s_y = format("%02d", y + 1);
	pair pair_hexCenter = pair_getPos(x,y);
	pair pair_hexLabelLoc = (pair_hexCenter.x, pair_hexCenter.y - real_halfstepY);
	label(s_x + s_y, pair_hexLabelLoc, S, pen_LabelColor + pen_LabelText);
	}

void drawLabelCustom(int x, int y)
	{
	string s_x = format("%02d", x + 1);
	string s_y = format("%02d", y + 1);
	pair pair_hexCenter = pair_getPos(x,y);
	pair pair_hexLabelLoc = (pair_hexCenter.x, pair_hexCenter.y - real_halfstepY);
	label(s_x + "-" + s_y, pair_hexLabelLoc, S, pen_LabelColor);
	}
	
void drawSystemHex(int x, int y)
	{
	draw(shift(pair_getPos(x,y))*scale(real_HexRadiusP2P)*path_polygon, pen_SystemHexColor + pen_SystemHexWidth);
	draw(shift(pair_getPos(x,y))*scale((int_SystemHexRadius * 2  + 1) * real_HexRadiusP2P)*path_polygon, pen_SystemHexColor + pen_SystemHexWidth);
	}

void drawRadians(int x, int y)
	{
	for(int i = 1; i <= 12; ++i)
		{
		path line=(pair_getRelPos(pair_getPos(x,y),i,1))--(pair_getRelPos(pair_getPos(x,y),i,(int_SystemHexRadius * 2) + 1));
		draw(line, pen_SystemHexColor + pen_SystemHexWidth);
		}
	}

void drawRadianLabels(int x, int y)
	{
	for(int i = 1; i <= 12; ++i)
		{
		if(bool_CustomFont == true)
			{
			Label L_Radian = Label((string) i, filltype=Fill(pen_LabelFillColor));
			label(scale(3)*L_Radian, pair_getRelPos(pair_getRelPos(pair_getPos(x,y),i,int_SystemHexRadius * 2 + 1), i, 1), pen_LabelColor + pen_LargeText, FillDraw(pen_LabelFillColor));
			}
		else
			{
			Label L_Radian = Label((string) i, filltype=Fill(pen_LabelFillColor));
			label(scale(3)*L_Radian, pair_getRelPos(pair_getRelPos(pair_getPos(x,y),i,int_SystemHexRadius * 2 + 1), i, 1), pen_LabelColor, FillDraw(pen_LabelFillColor));
			}
		}
	}

void drawScattergram(int x, int y)
	{
	for(int i = 1; i <= 12; i = i + 2)
		{
		draw(shift(pair_getRelPos(pair_getPos(x,y),i,2))*scale(real_HexRadiusP2P)*path_polygon, pen_ScatterColor + pen_ScatterHexWidth);
		}
	}

void drawScattergramLabels(int x, int y)
	{
	int i_Scatter = 1;
	for(int i = 1; i <= 12; i = i + 2)
		{
		if(bool_CustomFont == true)
			{
			Label L_Scatter = Label((string) i_Scatter, filltype=Fill(pen_LabelFillColor));
			label(scale(3)*L_Scatter, pair_getRelPos(pair_getPos(x,y),i,2), pen_LabelColor + pen_LargeText, FillDraw(pen_LabelFillColor));
			}
		else
			{
			Label L_Scatter = Label((string) i_Scatter, filltype=Fill(pen_LabelFillColor));
			label(scale(3)*L_Scatter, pair_getRelPos(pair_getPos(x,y),i,2), pen_LabelColor, FillDraw(pen_LabelFillColor));
			}
		++i_Scatter;
		}
	}

// placing counter via font (see package settings!)
//void placeCounterFont(int x, int y, string string_CounterType, int i_CounterNumber, pen pen_CounterColor, pen pen_CounterFillColor, int i_facing)
//	{
//	texpreamble("\setmainfont{StarfireCounters}");
//	path path_CounterFill = box((-0.55,-0.55), (0.55,0.5));
//	filldraw(shift(pair_getPos(x-1,y-1))*rotate(-60*(i_facing-1))*path_CounterFill, pen_CounterFillColor);
//	Label L_Counter = Label(scale(3)*rotate(-60*(i_facing-1))*string_CounterType, pair_getPos(x-1,y-1), pen_CounterColor);
//	label(L_Counter);
	// TODO add Numbering of the counters
	//Label L_CounterNumber = Label((string) i_CounterNumber, (0.55,0.5), SW, pen_CounterColor);
	//label(rotate(-60*(i_facing-1), (0,0))*L_CounterNumber);
//	}

// placing counter via image
void placeCounterImage(int x, int y, string string_CounterType, int i_CounterNumber, int i_facing)
	{
	Label L_Counter = Label(graphic("counter_images/" + string_CounterType + ".eps", "clip=true, width=1.2cm, height=1.2cm"));
	label(rotate(-60*(i_facing-1))*L_Counter, pair_getPos(x-1,y-1));
	}

// draw background image if true, else fill backgound with color
if(bool_BackgroundImage == true)
	{
	Label L_image = Label(graphic(string_imagefile, "clip=true, width=" + (string) (int_MapsizeX * real_stepX + 1.5) + "cm, height=" + (string) (int_MapsizeY * real_stepY - 2.5) + "cm"));
	label(L_image, (-1.6,2), SE);
	}
else
	{
	path path_Background = box((-1.5,2), (int_MapsizeX * real_stepX,int_MapsizeY * real_stepY - 0.5));
	filldraw(path_Background, pen_MapBackgroundColor);
	}

// draw main hexmap
layer();
while(int_x <= (int_MapsizeX - 1))
	{
	while(int_y <= (int_MapsizeY - 1))
		{
		drawHex(int_x, int_y);
        	if(bool_LabelStyleClassic == true)
        		{
			drawLabelClassic(int_x, int_y);
			}
        	else
			{
			drawLabelCustom(int_x, int_y);
			}
		++int_y;
		}
	++int_x;
	int_y = 0;
	}

// draw scattergram
layer();
if(bool_Scattergram == true)
	{
	drawScattergram(int_ScatterPosX, int_ScatterPosY);
	drawScattergramLabels(int_ScatterPosX, int_ScatterPosY);
	}

// draw big hex and radians
layer();
if(bool_SystemHex == true)
	{
	drawSystemHex(int_SystemHexPosX - 1, int_SystemHexPosY - 1);
	drawRadians(int_SystemHexPosX - 1, int_SystemHexPosY - 1);
	drawRadianLabels(int_SystemHexPosX - 1, int_SystemHexPosY - 1);
	}

// draw counters via font
//layer();
//placeCounterFont(42, 32, "X", 1, cyan, red, 1);
//placeCounterFont(42, 33, "A", 2, cyan, blue, 2);
//placeCounterFont(42, 34, "B", 3, cyan, red, 3);
//placeCounterFont(42, 35, "C", 4, cyan, blue, 4);
//placeCounterFont(42, 36, "D", 5, cyan, red, 5);
//placeCounterFont(42, 37, "E", 6, cyan, blue, 6);

// draw counters via imagefile
layer();
placeCounterImage(1, 1, "BBb", 1, 1);
placeCounterImage(1, 2, "BBr", 1, 2);
placeCounterImage(1, 3, "BCb", 1, 3);
placeCounterImage(1, 4, "BCr", 1, 4);
placeCounterImage(1, 5, "DNb", 1, 5);
placeCounterImage(1, 6, "DNr", 1, 6);

// print real mapsize, steppings and hex geometry
write("Mapsize: " + (string)(int_MapsizeX * real_stepX + 1.5) + "x" + (string)(int_MapsizeY * real_stepY + 2.5) + "cm");
write("StepsizeX: " + (string) real_stepX + "cm, " + "StepsizeY: " + (string) real_stepY + "cm");
write("HexRadiusP2P: " + (string) real_HexRadiusP2P + ", HexRadiusS2S: " + (string) real_HexRadiusS2S + "cm, " + "Hexside: " + (string) real_Hexside + "cm");

// draw some stuff for debugging
//draw(unitcircle);
//draw(shift(pair_getPos(int_MapsizeX - 1,int_MapsizeY - 1))*unitcircle);

// test pair_getRelPos() function
//label("0",pair_getRelPos((0,0),0,1), red + linewidth(1.0pt));
//label("1",pair_getRelPos((0,0),1,1), red + linewidth(1.0pt));
//label("2",pair_getRelPos((0,0),2,1), red + linewidth(1.0pt));
//label("3",pair_getRelPos((0,0),3,1), red + linewidth(1.0pt));
//label("4",pair_getRelPos((0,0),4,1), red + linewidth(1.0pt));
//label("5",pair_getRelPos((0,0),5,1), red + linewidth(1.0pt));
//label("6",pair_getRelPos((0,0),6,1), red + linewidth(1.0pt));
//label("7",pair_getRelPos((0,0),7,1), red + linewidth(1.0pt));
//label("8",pair_getRelPos((0,0),8,1), red + linewidth(1.0pt));
//label("9",pair_getRelPos((0,0),9,1), red + linewidth(1.0pt));
//label("10",pair_getRelPos((0,0),10,1), red + linewidth(1.0pt));
//label("11",pair_getRelPos((0,0),11,1), red + linewidth(1.0pt));
//label("12",pair_getRelPos((0,0),12,1), red + linewidth(1.0pt));
