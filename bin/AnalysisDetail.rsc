module AnalysisDetail
import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;

import AnalysisTypes;

import IO;
import util::Editors;
import AnalysisTypes;
import String;
import Set;

public list[Figure] analysisMain(int totalLines, customDataType risks){
	rows = [];
	list[Figure] treeItems = [];
	for(m <- risks.methods){
	  loc locFile = m.location;
	  if (m.lofc == 0) 
	    continue;
	  treeItems += [box(area(m.lofc), fillColor(getColor(m.complexity)) ,
		                onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	                      edit(locFile);//println(locFile);
                          return true;
	                    }),
	                    popup("Name : " + m.name + "\n" + "Complexity : " + toString(m.complexity) + "\n" + "LOC : " + toString(m.lofc)) 
	                    )];
	 }
	return treeItems;
}

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
    rows1 += ([box(size(40,m.complexity), fillColor(getColor(m.complexity)) , vresizable(false), popup("Name : " + m.name + "\n" + "Complexity : " + toString(m.complexity) )
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
  return(space(grid([[vcat(rows2)]], std(vgap(3))), std(bottom())));
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
    rows1 += ([box(size(40,m.lofc), fillColor(getColor(m.complexity)) , vresizable(false), popup("Name : " + m.name + "\n" + "LOC : " + toString(m.lofc) )
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
public Figure analysisDupDetail(int totalLines, dupDataType d){
  rows2 = [];
  for (m <- d.duplicates){
	rows1 = [];
	if (size(d.duplicates[m]) <= 1) // this is not necessary but is here due to wrong results from duplication program
	    continue;
	for (ml <- d.duplicates[m]){
	  fileLoc = ml;
	  rows1 += ([box(size(5,30), fillColor("LightGreen") , vresizable(false), popup("File : <ml.path> \n\nDuplicate Lines: <ml.begin.line> - <ml.end.line> \n\nDuplicate Code : \n\n \'<m>\'" ),
	                 onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	                   edit(fileLoc);
                       return true;
	                 })
	              )]);
	  
	}
	rows2 += hcat(rows1);	
  }
  return(space(grid([[vcat(rows2)]], std(vgap(3))), std(bottom())));
}

