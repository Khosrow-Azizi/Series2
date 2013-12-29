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

public Figure ccAnalysisDetail(int totalLines, customDataType risks, bool initializePager){
	return ccGrid(gridPager(ccAnalysis("Complexity"), risks, 10, initializePager));
}

public Figure unitAnalysisDetail(int totalLines, customDataType risks, bool initializePager){
  return unitGrid(gridPager(unitAnalysis("Unit-size"), risks, 10, initializePager));
}

public Figure dupAnalysisDetail(int totalLines, dupAnalysisDataType risks, bool initializePager){
  	return dupGrid(gridPager(dupAnalysis("Duplication"), risks, 1, initializePager));
}

public Figure ccGrid(ccUnitPager pager){	
	rows = [];
	rows += hcat([box(text(" Method Name", fontBold(true)), hshrink(0.5)), 
				  box(text(" Complexity index", fontBold(true), hshrink(0.3))),
				  box(text(" Lines", fontBold(true)), hshrink(0.2))]);	
	
	for(m <- pager.dataCollection)
		rows += hcat([box(text(" <m.name>"), hshrink(0.5),  popup(m.location), openFile(m.location)), 
					  box(text(" <toString(m.complexity)>", fontBold(true)), hshrink(0.3)),
					  box(text(" <toString(m.lofc)>"), hshrink(0.2))]);
	dataGrid = grid([[vcat(rows)]], std(left()), vshrink(0.5));	
	return vcat([pager.control, dataGrid],gap(1));	
}

public Figure unitGrid(ccUnitPager pager){	
	rows = [];
	rows += hcat([box(text(" Method Name", fontBold(true)), hshrink(0.5)), 
				  box(text(" Lines", fontBold(true)),hshrink(0.2)),
				  box(text(" Complexity index", fontBold(true), hshrink(0.3)))]);	
	
	for(m <- pager.dataCollection)
		rows += hcat([box(text(" <m.name>"), hshrink(0.5),  popup(m.location), openFile(m.location)), 
					  box(text(" <toString(m.lofc)>", fontBold(true)), hshrink(0.2)),
					  box(text(" <toString(m.complexity)>"), hshrink(0.3))]);
	dataGrid = grid([[vcat(rows)]], std(left()), vshrink(0.5));	
	return vcat([pager.control, dataGrid],gap(1));	
}

public Figure dupGrid(dupPager pager){	
	rows = [];
	
	Figure dupCodeGrid;
	Figure locationsGrid;
	for(dup <- pager.dataCollection){
		locationRows = [];
		locationRows += 
			hcat([box(text(" Locations", fontBold(true))),
				  box(text(" Occurrence", fontBold(true)), hresizable(false), width(100))]);
		for(dupLoc <- dup.locations){
			locationRows += hcat([box(text(" <dupLoc.file>") , popup(dupLoc), openFile(dupLoc)), 
					  box(text(" t.b.d."),hresizable(false), width(100))]);
		}
		locationsGrid = grid([[vcat(locationRows)]], std(left()));
		
		dupGridMaxSize = size(locationRows);
		if(dupGridMaxSize > size(dup.code))
			dupGridMaxSize = size(dup.code);
		dupCodeLines = "\n";
		for(l <- dup.code[0..dupGridMaxSize])
			dupCodeLines += " <l> \n";
		dupCodeGrid = grid([[box(text(dupCodeLines,fontBold(true), fontItalic(true)))]], std(top()), std(left()), hshrink(0.3));
		
		rows += hcat([dupCodeGrid,locationsGrid]);
	}
	dataGrid = grid([[vcat(rows)]], std(left()), vshrink(0.5));	
	return vcat([pager.control, dataGrid],gap(1));	
}

public FProperty openFile(loc location){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	     edit(location);
         return true;});
}
public FProperty popup(loc location){
	return mouseOver(box(text(" Path: " + location.path + "\n" + " Click to view the source code.", fontItalic(true)), 
		fillColor("lightGray"), grow(1.1), resizable(false)));
}