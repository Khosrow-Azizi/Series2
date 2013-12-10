module PieGraph

import vis::Figure;
import vis::Render;
import util::Math;
import vis::KeySym;
import util::Editors;

import List;
import IO;

public real degToRad(real deg) = (deg / 180) * PI();
public real percentToDeg(real perc) = (360.0/100 * perc); 
public tuple[real x,real y] center = <0.5, 0.5>;


public void renderSlice(){
	render(overlay([overlay([createSlice(percentToDeg(0.0), percentToDeg(90.0), "Red"),createSlice(percentToDeg(90.0), percentToDeg(100.0), "yellow")],shrink(0.5)),
		overlay([createSlice(percentToDeg(0.0), percentToDeg(90.0), "Red"),createSlice(percentToDeg(90.0), percentToDeg(100.0), "green")], shrink(0.4))]));
}

public Figure point(num x, num y, str color) =
	ellipse(shrink(0.0), align(x,y), fillColor(color));

public Figure createSlice(real begingDeg, real endDeg, str color){
	list[tuple[real, real]] coords = [center];
	for (deg <- [begingDeg..endDeg+1] ){
		x = center.x + cos(degToRad(deg));
		y = center.y + sin(degToRad(deg));
		coords += <x, y>;
	}
	return overlay([point(x,y,color) | <x,y> <- coords],aspectRatio(1), shapeConnected(true),shapeClosed(true), fillColor(color));
}
