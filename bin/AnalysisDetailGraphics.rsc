module AnalysisDetailGraphics

import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

import AnalysisTypes;

import IO;
import util::Editors;
import AnalysisTypes;
import AnalysisDetailGrid;
import String;
import Set;



private str getColor(int complexity) {
	if (complexity <= 10)
		return "LightGreen";
	else if (complexity > 10 && complexity <= 20)
		return "Yellow";
	else if (complexity > 20 && complexity <= 50)
	  	return "Orange";
	else if (complexity > 50)
		return "Red";	
}

public FProperty popup(str s){
	return mouseOver(box(text(s), fillColor("white"), grow(1.2), shadow(true), resizable(false)));
}

/* display details for CC*/
public Figure analysisccDetail(int totalLines, customDataType risks){
  rows1  = [];
  rows2  = [];
  int cnt = 1;
  allMethods = false;
  for(m <- risks.methods){
    allMethods = false;
    loc locFile = m.location;
    if (m.lofc == 0) 
      continue;
    rows1 += ([box(size(10,(m.complexity * 2)), fillColor(getColor(m.complexity)) , vresizable(false), popup(" Method name : " + m.name + "\n" + " Complexity : " + toString(m.complexity) )
             )]);
    if (cnt == 6){
      allMethods = true;
      rows2 += hcat(rows1);
      cnt = 0;
      rows1 = [];
    }
    cnt += 1 ;
  }
  println(allMethods);
  if (allMethods == false){
      rows2 += hcat(rows1);
  }
  return(space(grid([[vcat(rows2)]], std(vgap(4)), std(hgap(2))), std(bottom()), std( left())));
}

/* display detail for unit size */
public Figure analysisuzDetail(int totalLines, customDataType risks){
  rows1  = [];
  rows2  = [];
  int cnt = 1;
  allMethods = false;
  for(m <- risks.methods){
    allMethods = false;
    loc locFile = m.location;
    if (m.lofc == 0) 
      continue;
    rows1 += ([box(size(40,m.lofc), fillColor(getColor(m.complexity)) , vresizable(false), popup(" Method name: < m.name>\n Size: <toString(m.lofc)> lines"    )
             )]);
    if (cnt == 6){
      allMethods = true;
      rows2 += hcat(rows1);
      cnt = 0;
      rows1 = [];
    }
    cnt += 1 ;
  }
  if (allMethods == false){
      rows2 += hcat(rows1);
  }
  return(space(grid([[vcat(rows2)]], std(vgap(3))), std(bottom())));
}

/* display detail for code duplication */
public Figure analysisDupDetail(int totalLines, dupAnalysisDataType risks){
  rows2 = [];
  for (dup <- risks.duplicates){
	rows1 = [];	
	dupCodeLines = "\n";
	for(l <- dup.code)
		dupCodeLines += "	<l> \n";
	for (dupLoc <- dup.locations){	 
	  rows1 += ([box(size(5,30), fillColor("LightGreen") , vresizable(false), popup(" File : <dupLoc.location.path> \n Duplicate code: <dupCodeLines>" ),
	                 onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	                   edit(dupLoc.location);
                       return true;
	                 })
	              )]);
	  
	}
	rows2 += hcat(rows1);	
  }
  return(space(grid([[vcat(rows2)]], std(vgap(3))), std(bottom())));
}

