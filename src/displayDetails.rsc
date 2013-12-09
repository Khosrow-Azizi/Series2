module displayDetails
import main;
import SourceCodeFilter;
import LinesOfCodeCalculator;
import CyclomaticComplexity;


import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core; 
import lang::java::m3::Core;
import List;
import IO;

import util::Editors;
import vis::Figure;
import vis::Render;
import vis::KeySym;


public void tmp(){

 	loc project= |project://smallsql|;

	model = createM3FromEclipseProject(project);
	ast = createAstsFromEclipseProject(project, false);	
	
	set[loc] srcFiles = getSrcFiles(model);
	set[loc] srcMethods = getSrcMethods(srcFiles);
		
//--	int totalLoc = calculateProjectLoc(srcFiles);	
    	int totalMethodsLoc = calculateProjectLoc(srcMethods);	
//--	int totalDublications = calculateDuplications(srcMethods, 6);
   	list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult = getComplexityPerUnit(ast, true);
 
  //  list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult = [];
    dispDetails(ccAnalysisResult);
}

public void dispDetails(ccAnalysisResult){

   
//    ccAnalysisResult = [<"commit",|project://smallsql/src/smallsql/database/CreateFile.java|(1904,52,<60,17>,<63,5>),0,4>];
	// text(str () {return s; }),
	//text (str () {fontsize(20); return s; }),
   list[Figure] i = [];
   for (t <- ccAnalysisResult ){
      s = t.name;
      loc1 = t.location;
	  i += box( text(s), fillColor("lightgreen"), onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	                                                openEditor(loc1);
	                                                return true;
	                                              }),
	           // project(text(s),"vscreen"),
	            shrink(0.1)
	          );
	}
	//sc = vscreen(vcat(i),id("vscreen"));
	render(pack(i, std(gap(10)) ));   // treemap
	//render(vcat(i)); - gives grid constrained
//	render(grid(i));
//	render(box(text("Rascal", fontSize(20), fontColor("blue")), grow(2.0)));
}


public void testclick(){

Figure point(num x, num y){ return ellipse(shrink(0.05),fillColor("red"),align(x,y));}
list[tuple[num,num]] coords = [<0.0,0.0>,<0.5,0.5>,<0.8,0.5>,<1.0,0.0>];
ovl = overlay([point(x,y) | <x,y> <- coords], shapeConnected(true), shapeClosed(true), fillColor("yellow"),
                onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
  	            openEditor(|project://smallsql/src/smallsql/database/CreateFile.java|(1904,52,<60,17>,<63,5>));
	              return true;
	            })
	            );
render(ovl);

/*
s = "";
s2 = "";
b = box(text(str () { return s; }),
	fillColor("red"),
	onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		s = "Prajan";
		return true;
	}));

render(b);
*/

/*
c = false; 
b = box(fillColor(Color () { return c ? color("red") : color("green"); }),
	onMouseEnter(void () { c = true; }), onMouseExit(void () { c = false ; })
	,shrink(0.5));
render(b);
*/
}


public void openEditor(location ){
  public void tt1(){
    return vcat([box( edit(location)) , shrink(.5), align(1,1) ]);
  }
  render(tt1());

/*public Figure tfield(){
  str entered = "";
  return vcat([ box(textfield("", void(str s){ entered = s;}, fillColor("yellow")), fillColor("yellow"), shrink(.5), align(1,1)),
                text(str(){return "entered: <entered>";}, left())
              ]);
}  
render(tfield()); 
*/
}





