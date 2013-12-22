module AnalysisDetail


import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

import AnalysisTypes;

import IO;
import util::Editors;

public Figure analysisDetail(int totalLines, ccAnalysis(str name), lowRisk(),
	tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] risks){
	rows = [];
	list[Figure] treeItems = [];
	for(m <- risks.methods){
	  loc locFile = m.location;
	  treeItems += [box(text(m.name), area(m.lofc), fillColor("green"),
		                onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	                      edit(locFile);
                          return true;
	                    })
		           )];
	 }
	return treemap(treeItems);
}

public Figure analysisDetail(int totalLines, ccAnalysis(str name), moderateRisk(),
	tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] risks){
	rows = [];
	rows += hcat([box(text("Method Name", fontBold(true))), 
				  box(text("Complexity index", fontBold(true))),
				  box(text("Lines", fontBold(true)))]);
	for(m <- risks.methods)
		rows += hcat([box(text(m.name)), box(text(toString(m.complexity))),
					  box(text(toString(m.lofc)))]);
	 
	return(space(grid([[vcat(rows)]]), std(left()),top()));
}

public Figure analysisDetail(int totalLines, ccAnalysis(str name), highRisk(),
	tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] risks){
	rows = [];
	rows += hcat([box(text("Method Name", fontBold(true))), 
				  box(text("Complexity index", fontBold(true))),
				  box(text("Lines", fontBold(true)))]);
	for(m <- risks.methods)
		rows += hcat([box(text(m.name)), box(text(toString(m.complexity))),
					  box(text(toString(m.lofc)))]);
	 
	return(space(grid([[vcat(rows)]]), std(left()),top()));
}

public Figure analysisDetail(int totalLines, ccAnalysis(str name), veryHighRisk(),
	tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] risks){
	rows = [];
	rows += hcat([box(text("Method Name", fontBold(true))), 
				  box(text("Complexity index", fontBold(true))),
				  box(text("Lines", fontBold(true)))]);
	for(m <- risks.methods)
		rows += hcat([box(text(m.name)), box(text(toString(m.complexity))),
					  box(text(toString(m.lofc)))]);
	 
	return(space(grid([[vcat(rows)]]), std(left()),top()));
}

