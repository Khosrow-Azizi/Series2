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
import AnalysisOverview;
import AnalysisTypes;
import AnalysisDetailGraphics;
import GridPager;

private customDataType dataCollection;
private dupAnalysisDataType dupDataCollection;
private bool graphicalView = false;
private int totalMethodLines = 0;

public Figure ccAnalysisDetail(int totalLines, customDataType risks, bool initializePager){
	dataCollection = risks;
	totalMethodLines = totalLines;
	if(graphicalView)
		return vcat([analysisccDetail(totalLines, risks), 
				 box(text(" Switch to Textual View "), changeCcView(false), shadow(true), fillColor("lightGray"), top(), size(25), resizable(false))],gap(10));

	return vcat([ccGrid(gridPager(ccAnalysis("Complexity"), risks, 10, initializePager)), 
				 box(text(" Switch to Graphical View "), changeCcView(true), shadow(true), fillColor("lightGray"), top(), size(25), resizable(false))],gap(10));
}

public FProperty changeCcView(bool toGraphics){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		graphicalView = toGraphics;
	 	render(hcat([overview(0.9, top(), left(), true), box(ccAnalysisDetail(totalMethodLines, dataCollection, false))], gap(5)));
	  	return true;});
}

public Figure dupAnalysisDetail(int totalLines, dupAnalysisDataType risks, bool initializePager){
  	dupDataCollection = risks;
  	totalMethodLines = totalLines;
  	if(graphicalView)
		return vcat([analysisDupDetail(totalLines, risks), 
				 box(text(" Switch to Textual View "), changeDupView(false), shadow(true), fillColor("lightGray"), top(), size(25), resizable(false))],gap(10));
		
  	return vcat([dupGrid(gridPager(dupAnalysis("Duplication"), risks, 1, initializePager)), 
				 box(text(" Switch to Graphical View "), changeDupView(true), shadow(true), fillColor("lightGray"), top(), size(25), resizable(false))],gap(10));
}

public FProperty changeDupView(bool toGraphics){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		graphicalView = toGraphics;
	 	render(hcat([overview(0.9, top(), left(), true), box(dupAnalysisDetail(totalMethodLines, dupDataCollection, false))], gap(5)));
	  	return true;});
}

public Figure unitAnalysisDetail(int totalLines, customDataType risks, bool initializePager){
	dataCollection = risks;
	totalMethodLines = totalLines;
	if(graphicalView)
		return vcat([analysisuzDetail(totalLines, risks), 
				 box(text(" Switch to Textual View "), changeUnitView(false), shadow(true), fillColor("lightGray"), top(), size(25), resizable(false))],gap(10));
		
	return vcat([unitGrid(gridPager(unitAnalysis("Unit-size"), risks, 10, initializePager)), 
				 box(text(" Switch to Graphical View "), changeUnitView(true), shadow(true), fillColor("lightGray"), top(), size(25), resizable(false))],gap(10));
}

public FProperty changeUnitView(bool toGraphics){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		graphicalView = toGraphics;
	 	render(hcat([overview(0.9, top(), left(), true), box(unitAnalysisDetail(totalMethodLines, dataCollection, false))], gap(5)));
	  	return true;});
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
	//return box();
	rows = [];	
	Figure dupCodeGrid;
	Figure locationsGrid;
	for(dup <- pager.dataCollection){
		locationRows = [];
		locationRows += 
			hcat([box(text(" Locations", fontBold(true))),
				  box(text(" Occurrence", fontBold(true)), hresizable(false), width(100))]);
		for(dupLoc <- dup.locations){
			locationRows += hcat([box(text(" <dupLoc.location.file>") , popup(dupLoc.location), openFile(dupLoc.location)), 
					  box(text(" <dupLoc.occurence> "),hresizable(false), width(100))]);
		}
		locationsGrid = grid([[vcat(locationRows)]], std(left()));
		
		dupGridMaxSize = 10;// size(locationRows);
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

