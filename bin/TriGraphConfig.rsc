module TriGraphConfig

import vis::Figure;
import vis::Render;
import vis::KeySym;

import AnalysisTypes;

data GraphConfig = triConfig(Analysis analysis,
	tuple[num ratio, bool isSelected] veryHighRisk, tuple[num ratio, bool isSelected] highRisk, 
	tuple[num ratio, bool isSelected] modRisk, tuple[num ratio, bool isSelected] lowRisk, bool graphIsSelected);
	
public Figure point(num x, num y){ return ellipse(width(1), height(1),resizable(false),fillColor("black"),align(x,y));}

public GraphConfig ccGraphConfig = 
	triConfig(ccAnalysis("Complexity analysis"),<0.0, false>,<0.0, false>, <0.0, false>,<0.0, false>, true);
public GraphConfig dupGraphConfig = 
	triConfig(dupAnalysis("Duplication analysis"),<0.0, false>,<0.0, false>, <0.0, false>,<0.0, false>, true);
public GraphConfig unitGraphConfig = 
	triConfig(unitAnalysis("Unit-size analysis"),<0.0, false>,<0.0, false>, <0.0, false>,<0.0, false>, true);
	
public void initCCConfigValues(num a, num b, num c, num d){
	ccGraphConfig.veryHighRisk.ratio = a;
	ccGraphConfig.highRisk.ratio = b;
	ccGraphConfig.modRisk.ratio = c;
	ccGraphConfig.lowRisk.ratio = d;
}

public void initDupConfigValues(num a, num b) {
	dupGraphConfig.veryHighRisk.ratio = 0;
	dupGraphConfig.highRisk.ratio = 0;
	dupGraphConfig.modRisk.ratio = a;
	dupGraphConfig.lowRisk.ratio = b;
}

public void initUzConfigValues(num a, num b, num c, num d) {	
	unitGraphConfig.veryHighRisk.ratio = a;
	unitGraphConfig.highRisk.ratio = b;
	unitGraphConfig.modRisk.ratio = c;
	unitGraphConfig.lowRisk.ratio = d;
}

public void resetSelectionValues(){
	ccGraphConfig.graphIsSelected = false;
	ccGraphConfig.veryHighRisk.isSelected = false;
	ccGraphConfig.highRisk.isSelected = false;
	ccGraphConfig.modRisk.isSelected = false;
	ccGraphConfig.lowRisk.isSelected = false;
 	
 	dupGraphConfig.graphIsSelected = false;
 	dupGraphConfig.veryHighRisk.isSelected = false;
 	dupGraphConfig.highRisk.isSelected = false;
	dupGraphConfig.modRisk.isSelected = false;
	dupGraphConfig.lowRisk.isSelected = false;
 	
 	unitGraphConfig.graphIsSelected = false;
 	unitGraphConfig.veryHighRisk.isSelected = false;
 	unitGraphConfig.highRisk.isSelected = false;
	unitGraphConfig.modRisk.isSelected = false;
	unitGraphConfig.lowRisk.isSelected = false;
}