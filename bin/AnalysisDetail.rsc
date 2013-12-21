module AnalysisDetail


import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

import AnalysisTypes;

public Figure analysisDetail(int totalLines, ccAnalysis(str name), lowRisk(),
	tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] risks){
	rows = [];
	rows += hcat([box(text("Method Name", fontBold(true))), 
				  box(text("Complexity index", fontBold(true))),
				  box(text("Lines", fontBold(true)))], std(width(50)));
	for(m <- risks.methods)
		rows += hcat([box(text(m.name)), box(text(toString(m.complexity))),
					  box(text(toString(m.lofc)))],std(width(50)));
	 
	return(grid([[vcat(rows)]]));
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
	 
	return(space(grid([[vcat(rows)]]), std(left()),top(), std(left()),top()));
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
	 
	return(space(grid([[vcat(rows)]]), std(left()),top(), std(left()),top()));
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
	 
	return(space(grid([[vcat(rows)]]), std(left()),top(), std(left()),top()));
}