module PieGraph

import vis::Figure;
import vis::Render;
import util::Math;
import vis::KeySym;
import util::Editors;

import List;
import IO;

data Analysis = ccAnalysis() | dupAnalysis() | unitAnalysis();
public Figure point(num x, num y, str color) = ellipse(shrink(0.0), align(x,y), fillColor(color));
public real degToRad(real deg) = (deg / 180) * PI();
public real percentToDeg(real perc) = (perc * 360.0 / 100); 
public tuple[real x,real y] center = <0.5, 0.5>;

public void renderPieGraph(){
	render(pieGraph(0.9, top()));
}

public Figure pieGraph(num shrinkRatio, FProperty position){
	ccPie = createPie([<40.0, "Red", false>,<10.0, "yellow", false>,<15.0, "orange", false>,<5.0, "green", false>,<20.0, "pink", false>, <10.0, "gray", false>], 0.5,ccAnalysis());
	dupPie = createPie([<20.0, "Red", false>,<20.0, "yellow", false>,<15.0, "orange", false>,<10.0, "green", false>,<35.0, "pink", false>], 0.4,dupAnalysis());
	//unitPie = triGraph("Unit-size analysis", 0.05,0.30,0.50, unitAnalysis(), unitSelected);
	return overlay([ccPie,dupPie], shrink(shrinkRatio), position);
}

public Figure createPie(list[tuple[real perc, str color, bool isSelected]] recipe, num shrinkRatio, Analysis analysisType){
	real startPerc = 0.0;
	slices = [];
	for(rec <- recipe){		
		endPerc = startPerc + rec.perc;
		slices += createSlice(startPerc, endPerc, rec.color, rec.isSelected, analysisType);
		startPerc += rec.perc;		
	}
	return overlay(slices, shrink(shrinkRatio));
}

public Figure createSlice(real fromPerc, real toPerc, str color, bool isSelected, Analysis analysisType){
	list[tuple[real x, real y]] coords = [center];	
	fromDeg = percentToDeg(fromPerc);
	toDeg = percentToDeg(toPerc) + 1;
	for (deg <- [fromDeg..toDeg] ){
		x = center.x + cos(degToRad(deg));
		y = center.y + sin(degToRad(deg));
		coords += <x, y>;
	}	
		
	lWidth = isSelected ? 10 : 1;
	lColor = isSelected ? "Blue" : "Black";
	ovl = overlay([point(x,y,color) | <x,y> <- coords], aspectRatio(1), shapeConnected(true),shapeClosed(true), 
	lineWidth(lWidth), lineColor(lColor), fillColor(color), click(analysisType));
	return ovl;
}

public FProperty click(ccAnalysis()){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	render(vcat([pieGraph(0.5, top()), detail("Complexity analysis detail: ")], gap(5)));
	  	return true;});
}

public FProperty click(dupAnalysis()){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	render(vcat([pieGraph(0.5, top()), detail("Duplication analysis detail: ")], gap(5)));
	  	return true;});
}

public FProperty click(unitAnalysis()){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	render(vcat([pieGraph(0.5, top()), detail("Unit-size analysis detail: ")], gap(5)));
	  	return true;});
}

public Figure detail(str txt){
	return box(text(txt, lineWidth(2)));
}

public void renderSlice(){
	render(overlay([createSlice(0.0, 5.0, "Yellow")], shrink(0.5)));
}

public Figure createSlice(real fromPerc, real toPerc, str color){
	return createSlice(fromPerc, toPerc, color, false);
}