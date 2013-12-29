module AnalysisDetailGrid

import List;
import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;
import util::Editors;
import String;
import IO;

import Analysis;
import AnalysisTypes;
import GridPager;

public Figure ccAnalysisDetail(int totalLines, customDataType risks, bool resetPager){
	return ccGrid(gridPager(ccAnalysis("cc"), risks, 10, resetPager));
}

public Figure ccGrid(ccUnsPager pager){	
	rows = [];
	rows += hcat([box(text(" Method Name", fontBold(true)), hshrink(0.5)), 
				  box(text(" Complexity index", fontBold(true), hshrink(0.3))),
				  box(text(" Lines", fontBold(true)), hshrink(0.2))],gap(0));	
	
	for(m <- pager.dataCollection)
		rows += hcat([box(text(" <m.name>"), hshrink(0.5),  popup(m.location), openFile(m.location)), 
					  box(text(" <toString(m.complexity)> "), hshrink(0.3)),
					  box(text(" <toString(m.lofc)>"), hshrink(0.2))]);
	dataGrid = grid([[vcat(rows)]], std(left()), vshrink(0.5));	
	return vcat([pager.control, dataGrid],gap(1));	
}

public FProperty openFile(loc location){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	     edit(location);//println(locFile);
         return true;});
}
public FProperty popup(loc location){
	return mouseOver(box(text(" Path: " + location.path + "\n" + " Click to view the source code.", fontItalic(true)), 
		fillColor("lightGray"), grow(1.1), resizable(false)));
}