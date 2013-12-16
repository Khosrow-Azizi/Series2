module TriGraphConfig

import vis::Figure;
import vis::Render;
import vis::KeySym;

data Analysis = ccAnalysis(str name) | dupAnalysis(str name) | unitAnalysis(str name);
data Risk = veryHighRisk() | highRisk() | moderateRisk() | lowRisk();
data GraphConfig = triConfig(Analysis analysis,
	tuple[num perc, bool isSelected] veryHighRisk, tuple[num perc, bool isSelected] highRisk, 
	tuple[num perc, bool isSelected] modRisk, tuple[num perc, bool isSelected] lowRisk, bool graphIsSelected);
	
public Figure point(num x, num y){ return ellipse(width(1), height(1),resizable(false),fillColor("black"),align(x,y));}

public GraphConfig ccGraphConfig = 
	triConfig(ccAnalysis("Complexity analysis"),<0.0, false>,<0.0, false>, <0.0, false>,<0.0, false>, true);
public GraphConfig dupGraphConfig = 
	triConfig(dupAnalysis("Duplication analysis"),<0.0, false>,<0.0, false>, <0.0, false>,<0.0, false>, true);
public GraphConfig unitGraphConfig = 
	triConfig(unitAnalysis("Unit-size analysis"),<0.0, false>,<0.0, false>, <0.0, false>,<0.0, false>, true);
	
public void initConfigValues(){
	ccGraphConfig.veryHighRisk.perc = 0.10;
	ccGraphConfig.highRisk.perc = 0.50;
	ccGraphConfig.modRisk.perc = 0.20;
	ccGraphConfig.lowRisk.perc = 0.20;
	
	dupGraphConfig.veryHighRisk.perc = 0.10;
	dupGraphConfig.highRisk.perc = 0.50;
	dupGraphConfig.modRisk.perc = 0.20;
	dupGraphConfig.lowRisk.perc = 0.20;
	
	unitGraphConfig.veryHighRisk.perc = 0.10;
	unitGraphConfig.highRisk.perc = 0.50;
	unitGraphConfig.modRisk.perc = 0.20;
	unitGraphConfig.lowRisk.perc = 0.20;
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