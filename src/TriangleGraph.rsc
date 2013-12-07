module TriangleGraph

import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

data Analysis = ccAnalysis() | dupAnalysis() | unitAnalysis();

public Figure overview(bool ccSelected, bool dupSelected, bool unitSelected, num vShrink, FProperty position){
	ccGraph = triGraph("Complexity analysis", 0.60,0.10,0.20, ccAnalysis(), ccSelected);
	dupGraph = triGraph("Duplication analysis", 0.10,0.23,0.50, dupAnalysis(), dupSelected);
	unitGraph = triGraph("Unit-size analysis", 0.05,0.30,0.50, unitAnalysis(), unitSelected);
	return hcat([ccGraph,dupGraph,unitGraph], gap(20), vshrink(vShrink), position);
}

public void renderGraph(){	
	render(overview(true, true, true, 0.9, center()));
}

public Figure triGraph(str name, num veryHighPerc, num highPerc, num modPerc, Analysis analysisType, bool selected){	
    endVeryHigh = veryHighPerc;
    veryHighSlice = generateTriSlice(0.0, endVeryHigh, "<round(veryHighPerc * 100)>%", "Red", click(analysisType, "Very high risk"));	
	
	endHigh = endVeryHigh + highPerc;
	highSlice = generateTriSlice(endVeryHigh, endHigh, "<round(highPerc * 100)>%", "Orange", click(analysisType, "High risk"));
	
	endMod = endHigh + modPerc;			
	modSlice = generateTriSlice(endHigh, endMod, "<round(modPerc * 100)>%", "Yellow", click(analysisType, "Moderate risk"));
					
	lowPrec = 1 - (veryHighPerc + highPerc + modPerc);
	lowSlice = generateTriSlice(endMod, 1.0, "<round(lowPrec * 100)>%", "Green", click(analysisType, "Low risk"));
	ht = selected ? 200 : 120;
	return vcat([overlay([veryHighSlice, highSlice, modSlice, lowSlice], width(270), height(ht), resizable(false)), text(name, fontBold(selected), resizable(false), top())]);
}

public Figure generateTriSlice(num begin, num end, str txt, str color, FProperty prop){
	coords = [<0.5,0.0>,<begin,1.0>,<end,1.0>];
	ovl = overlay([point(x,y) | <x,y> <- coords], fillColor(color),
					shapeConnected(true),shapeClosed(true), prop, popup("Click to see the details"));
	return overlay([ovl, text(txt, fontSize(6),size(20), align(begin + 0.04, 1.0))]);
}

public Figure point(num x, num y){ return ellipse(width(1), height(1),resizable(false),fillColor("black"),align(x,y));}

public FProperty click(ccAnalysis(), str txt){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	render(vcat([overview(true, false, false, 0.5, top()), detail("Complexity analysis detail: " + txt), backButton()], gap(5)));
	  	return true;});
}

public FProperty click(dupAnalysis(), str txt){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	render(vcat([overview(false, true, false, 0.5, top()), detail("Duplication analysis detail: " + txt), backButton()], gap(5)));
	  	return true;});
}

public FProperty click(unitAnalysis(), str txt){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	render(vcat([overview(false, false, true, 0.5, top()), detail("Unit-size analysis detail: " + txt), backButton()], gap(5)));
	  	return true;});
}

public FProperty popup(str s){
	return mouseOver(box(text(s), fillColor("white"), grow(1.2), shadow(true), resizable(false)));
}

public Figure backButton(){
	coords = [<0.0,0.3>,<0.3,0.0>,<0.3,0.6>];
	return overlay([point(x,y) | <x,y> <- coords], back(),popup("Back to main page"), left(),shapeConnected(true),shapeClosed(true),fillColor("Blue"), shrink(0.1));
}

public FProperty back(){
 return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	renderGraph();
	  	return true;});
}

public Figure detail(str txt){
	return box(text(txt, lineWidth(2)));
}