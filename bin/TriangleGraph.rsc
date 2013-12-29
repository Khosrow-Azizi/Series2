module TriangleGraph

import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

import Analysis;
import AnalysisTypes;
import TriGraphConfig;
import AnalysisDetail;
import IO;
//HelloWorldLoc
public void renderGraph(){	
	//startAnalysis(HellowWorldLoc);
	startAnalysis(smallsqlLoc);
	initCCConfigValues(veryHighCcRisks.ratio, highCcRisks.ratio, moderateCcRisks.ratio,lowCcRisks.ratio);
	initUzConfigValues(veryHighUzRisks.ratio, highUzRisks.ratio, moderateUzRisks.ratio,lowUzRisks.ratio);
	initDupConfigValues(duplicate.ratio, nonDuplicate.ratio);
	
	render(overview(0.9, center(), center(), false));
}

public Figure overview(num vShrink, FProperty vPos, FProperty hPos, bool isVertArranged){
	ccGraph = triGraph(ccGraphConfig);
	unitGraph = triGraph(unitGraphConfig);
    dupGraph = triGraph(dupGraphConfig);	
	if(isVertArranged){
		Figures leftSide = [button("Main menu", void() { render(overview(0.9, center(), center(), false));  }, size(5), resizable(false) )];  
		leftSide += vcat([ccGraph,dupGraph,unitGraph], gap(0), vshrink(vShrink), vPos, hPos); 
		return vcat(leftSide);
	}
		
	Figures result = [hcat([ccGraph,dupGraph,unitGraph], gap(0), vshrink(0.35)) ]; 
	result += [button("System treemap", void() { render(vcat([button("Back", void() { render(overview(0.9, center(), center(), false)); }, size(10), resizable(false)), getTreeMap()])); }, width(100), height(10), resizable(false)) ];
	
	return vcat(result, gap(5));				
	
}

Figure getTreeMap() {
	return box(treemap( analysisMain(totalMethodLines, lowCcRisks) + 
						analysisMain(totalMethodLines, highCcRisks) + 
						analysisMain(totalMethodLines, moderateCcRisks) +
						analysisMain(totalMethodLines, veryHighCcRisks)));
}

public Figure triGraph(triConfig(Analysis analysis, tuple[num ratio, bool isSelected] vhRisk,
		                                            tuple[num ratio, bool isSelected] hRisk,
		                                            tuple[num ratio, bool isSelected] mRisk, 
			                                        tuple[num ratio, bool isSelected] lRisk, bool isSelected)){	
    endVeryHigh = vhRisk.ratio;
    veryHighSlice = generateTriSlice(0.0, endVeryHigh, "<round(vhRisk.ratio * 100)>%", "Red", vhRisk.isSelected, click(analysis, veryHighRisk(), "Very high risk"));	
	
	endHigh = endVeryHigh + hRisk.ratio;
	highSlice = generateTriSlice(endVeryHigh, endHigh, "<round(hRisk.ratio * 100)>%", "Orange", hRisk.isSelected, click(analysis, highRisk(), "High risk"));
	
	endMod = endHigh + mRisk.ratio;			
	modSlice = generateTriSlice(endHigh, endMod, "<round(mRisk.ratio * 100)>%", "Yellow", mRisk.isSelected, click(analysis, moderateRisk(), "Moderate risk"));
					
	endLow = endMod + lRisk.ratio;
	lowSlice = generateTriSlice(endMod, endLow, "<round(lRisk.ratio * 100)>%", "LightGreen", lRisk.isSelected, click(analysis, lowRisk(), "Low risk"));
	
	ht = isSelected ? 200 : 80;
	return vcat([overlay([veryHighSlice, highSlice, modSlice, lowSlice], width(270), height(ht), resizable(false)), 
		         text(analysis.name, fontBold(isSelected), resizable(false), top())]);
}

public Figure generateTriSlice(num begin, num end, str txt, str color, bool isSelected, FProperty prop){
	coords = [<0.5,0.0>,<begin,1.0>,<end,1.0>];
	lWidth = isSelected ? 5 : 1;
	lColor = isSelected ? "Blue" : "Black";
	ovl = overlay([point(x,y) | <x,y> <- coords], fillColor(color), lineWidth(lWidth), lineColor(lColor),
					shapeConnected(true),shapeClosed(true), prop, popup("Click to see the details"));
	return overlay([ovl, text(txt, fontSize(6),size(20), align(begin + 0.04, 1.0))]);
}

public FProperty popup(str s){
	return mouseOver(box(text(s), fillColor("white"), grow(1.2), shadow(true), resizable(false)));
}

/************************************ click properties ****************************************/
public FProperty click(ccAnalysis(str name), veryHighRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
 		resetSelectionValues();
 		ccGraphConfig.veryHighRisk.isSelected = true;
 		ccGraphConfig.graphIsSelected = true;
	 	render(hcat([overview(0.9, top(), left(), true), box(analysisccDetail(totalMethodLines, veryHighCcRisks)  )  ],   gap(5)));
	  	return true;});
}

public FProperty click(ccAnalysis(str name), highRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		ccGraphConfig.highRisk.isSelected = true;
 		ccGraphConfig.graphIsSelected = true;
	 	render(hcat([overview(0.9, top(), left(), true), box(analysisccDetail(totalMethodLines, highCcRisks))], gap(5)));
	  	return true;});
}

public FProperty click(ccAnalysis(str name), moderateRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		ccGraphConfig.modRisk.isSelected = true;
 		ccGraphConfig.graphIsSelected = true;
	 	render(hcat([overview(0.9, top(), left(), true), box(analysisccDetail(totalMethodLines, moderateCcRisks))], gap(5)));
	  	return true;});
}

public FProperty click(ccAnalysis(str name), lowRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		ccGraphConfig.lowRisk.isSelected = true;
 		ccGraphConfig.graphIsSelected = true;
	 	render(hcat([overview(  0.9, top(), left(), true  ), box(analysisccDetail(totalMethodLines, lowCcRisks ))   ], gap(5)));
	  	return true;});
}

public FProperty click(dupAnalysis(str name), veryHighRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
 		resetSelectionValues();
 		dupGraphConfig.veryHighRisk.isSelected = true;
 		dupGraphConfig.graphIsSelected = true;
	 	render(overview(0.9, top(), left(), true));
	  	return true;});
}

public FProperty click(dupAnalysis(str name), highRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		dupGraphConfig.highRisk.isSelected = true;
 		dupGraphConfig.graphIsSelected = true;
	 	render(overview(0.9, top(), left(), true));
	  	return true;});
}

public FProperty click(dupAnalysis(str name), moderateRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		dupGraphConfig.modRisk.isSelected = true;
 		dupGraphConfig.graphIsSelected = true;
 		render(hcat([overview(  0.9, top(), left(), true  ), box(analysisDupDetail(totalMethodLines, duplicate ))   ], gap(5)));
	  	return true;});
}

public FProperty click(dupAnalysis(str name), lowRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		dupGraphConfig.lowRisk.isSelected = true;
 		dupGraphConfig.graphIsSelected = true;
	 render(hcat([overview(  0.9, top(), left(), false  ) ], gap(5)));
	  	return true;});
}

public FProperty click(unitAnalysis(str name), veryHighRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
 		resetSelectionValues();
 		unitGraphConfig.veryHighRisk.isSelected = true;
 		unitGraphConfig.graphIsSelected = true;
	 	render(hcat([overview(  0.9, top(), left(), true  ), box(analysisuzDetail(totalMethodLines, veryHighUzRisks ))   ], gap(5)));
	  	return true;});
}

public FProperty click(unitAnalysis(str name), highRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		unitGraphConfig.highRisk.isSelected = true;
 		unitGraphConfig.graphIsSelected = true;
	    render(hcat([overview(  0.9, top(), left(), true  ), box(analysisuzDetail(totalMethodLines, highUzRisks ))   ], gap(5)));
	 
	  	return true;});
}

public FProperty click(unitAnalysis(str name), moderateRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		unitGraphConfig.modRisk.isSelected = true;
 		unitGraphConfig.graphIsSelected = true;
	 	render(hcat([overview(  0.9, top(), left(), true  ), box(analysisuzDetail(totalMethodLines, moderateUzRisks ))   ], gap(5)));
	  	return true;});
}

public FProperty click(unitAnalysis(str name), lowRisk(), str txt){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
	 	resetSelectionValues();
 		unitGraphConfig.lowRisk.isSelected = true;
 		unitGraphConfig.graphIsSelected = true;
	   render(hcat([overview(  0.9, top(), left(), true  ), box(analysisuzDetail(totalMethodLines, lowUzRisks ))   ], gap(5)));
	  	return true;});
}




/**********************************************************************************************/

public Figure detail(str txt){
	return box(text(txt, lineWidth(2), top()));
}