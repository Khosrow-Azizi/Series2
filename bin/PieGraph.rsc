module PieGraph

import vis::Figure;
import vis::Render;
import util::Math;
import vis::KeySym;
import util::Editors;

import List;
import IO;

public real degToRad(real deg) = (deg / 180) * PI();
public real percentToDeg(real perc) = (perc * 360.0 / 100); 
public tuple[real x,real y] center = <0.5, 0.5>;

private real startDeg = 0.0;

public void renderPieGraph(){
    render(overlay([createPie([<40.0, "Red">,<10.0, "yellow">,<15.0, "orange">,<5.0, "green">,<20.0, "pink">, <10.0, "gray">], 0.5),
    createPie([<20.0, "Red">,<20.0, "yellow">,<15.0, "orange">,<10.0, "green">,<35.0, "pink">], 0.4)]));
}

public Figure point(num x, num y, str color) =
	ellipse(shrink(0.0), align(x,y), fillColor(color));


public Figure createPie(list[tuple[real perc, str color]] recipe, num shrinkRatio){
	real startPerc = 0.0;
	slices = [];
	for(rec <- recipe){		
		endPerc = startPerc + rec.perc;
		slices += createSlice(startPerc, endPerc, rec.color);
		startPerc += rec.perc;		
	}
	return overlay(slices, shrink(shrinkRatio));
}

public Figure createSlice(real fromPerc, real toPerc, str color){
	return createSlice(fromPerc, toPerc, color, false);
}
public Figure createSlice(real fromPerc, real toPerc, str color, bool isSelected){
	list[tuple[real, real]] coords = [center];	
	fromDeg = percentToDeg(fromPerc);
	toDeg = percentToDeg(toPerc) + 1;
	for (deg <- [fromDeg..toDeg] ){
		x = center.x + cos(degToRad(deg));
		y = center.y + sin(degToRad(deg));
		coords += <x, y>;
	}	
	
	lWidth = isSelected ? 4 : 1;
	return overlay([point(x,y,color) | <x,y> <- coords],aspectRatio(1), shapeConnected(true),shapeClosed(true), lineWidth(lWidth), fillColor(color));
}
