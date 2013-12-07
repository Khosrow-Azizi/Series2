module TriangleGraph

import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

data Analysis = ccAnalysis() | dupAnalysis() | unitAnalysis();

public void renderGraph(){
	ccGraph = triGraph("Complexity analysis", 0.60,0.10,0.20, click(ccAnalysis()), false);
	dupGraph = triGraph("Duplication analysis", 0.10,0.23,0.50, click(dupAnalysis()), false);
	unitGraph = triGraph("Unit-size analysis", 0.05,0.30,0.50, click(unitAnalysis()), false);
	render(hcat([ccGraph,dupGraph,unitGraph], gap(20), vshrink(0.6)));
}

public Figure triGraph(str name, num veryHighPerc, num highPerc, num modPerc, FProperty prop, bool selected){
	
    endVeryHigh = veryHighPerc;
    veryHighSlice = generateTriSlice(0.0, endVeryHigh, "<round(veryHighPerc * 100)>%", "Red", prop);	
	
	endHigh = endVeryHigh + highPerc;
	highSlice = generateTriSlice(endVeryHigh, endHigh, "<round(highPerc * 100)>%", "Orange", prop);
	
	endMod = endHigh + modPerc;			
	modSlice = generateTriSlice(endHigh, endMod, "<round(modPerc * 100)>%", "Yellow", prop);
					
	lowPrec = 1 - (veryHighPerc + highPerc + modPerc);
	lowSlice = generateTriSlice(endMod, 1.0, "<round(lowPrec * 100)>%", "Green", prop);
	sz = selected ? 0.9 : 0.5;
	return vcat([overlay([veryHighSlice, highSlice, modSlice, lowSlice],shrink(sz)), text(name, fontBold(true))]);
}

public Figure generateTriSlice(num begin, num end, str txt, str color, FProperty prop){
	coords = [<0.5,0.0>,<begin,1.0>,<end,1.0>];
	ovl = overlay([point(x,y) | <x,y> <- coords], fillColor(color),
					shapeConnected(true),shapeClosed(true), prop);
	return overlay([ovl, text(txt, fontSize(6),size(20), align(begin + 0.04, 1.0))]);
}

public Figure point(num x, num y){ return ellipse(width(1), height(1),resizable(false),fillColor("black"),align(x,y));}


public FProperty click(ccAnalysis()){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	ccGraph = triGraph("Complexity analysis", 0.60,0.10,0.20, click(ccAnalysis()), true);
		dupGraph = triGraph("Duplication analysis", 0.10,0.23,0.50, click(dupAnalysis()), false);
		unitGraph = triGraph("Unit-size analysis", 0.05,0.30,0.50, click(unitAnalysis()), false);
		render(hcat([ccGraph,dupGraph,unitGraph], gap(20), vshrink(0.6),top()));
	  	return true;});
}

public FProperty click(dupAnalysis()){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	ccGraph = triGraph("Complexity analysis", 0.60,0.10,0.20, click(ccAnalysis()), false);
	dupGraph = triGraph("Duplication analysis", 0.10,0.23,0.50, click(dupAnalysis()), true);
	unitGraph = triGraph("Unit-size analysis", 0.05,0.30,0.50, click(unitAnalysis()), false);
		render(hcat([ccGraph,dupGraph,unitGraph], gap(20), vshrink(0.6),top()));
	  	return true;});
}

public FProperty click(unitAnalysis()){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	ccGraph = triGraph("Complexity analysis", 0.60,0.10,0.20, click(ccAnalysis()), false);
	dupGraph = triGraph("Duplication analysis", 0.10,0.23,0.50, click(dupAnalysis()), false);
	unitGraph = triGraph("Unit-size analysis", 0.05,0.30,0.50, click(unitAnalysis()), true);
		render(hcat([ccGraph,dupGraph,unitGraph], gap(20), vshrink(0.6),top()));
	  	return true;});
}
