module Overview

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core; 
import lang::java::m3::Core;
import vis::Figure;
import vis::Render;
import vis::KeySym;

public loc HelloWorldLoc = |project://HelloWorld|;
public loc smallsqlLoc = |project://smallsql|; 
public loc hsqldbLoc = |project://hsqldb|;

//model = createM3FromEclipseProject(project);
//	ast = createAstsFromEclipseProject(project, false);
public void renderTree(){
	ast = createAstsFromEclipseProject(HelloWorldLoc, false);
	t = tree(box(text("Program"), shrink(0.2), fillColor("grey")),[visAst(t) | t <- ast]);
 	render(space(t, std(size(30)), std(gap(10))));
}	

public M3 model = createM3FromEclipseProject(HelloWorldLoc);

public Figure visAst(Declaration ast){
	switch(ast){
	    case \compilationUnit(list[Declaration] imports, list[Declaration] types):{
	    	return visComUnit("Compilation Unit", types);
	    }
		case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types):{
			return visComUnit("Compilation Unit", types);
		}
		
		//case \class(str name, _, _, list[Declaration] body):{
		//	return visClass(name, body);
		//}	
	}
	return box(fillColor("grey"));
}

public Figure visComUnit(str name, list[Declaration] types){
    return tree(box(text(name), fillColor("White")),
	[visClass(t.name, t.body) | t <- types]);
	//return tree(ellipse(fillColor(color)), [visAst(b)| b <- body]);
}

public Figure visClass(str name, list[Declaration] body){
	return tree(ellipse(text("<name>"),fillColor("Red")), 
	[visMethod(name)| b <- body, \method(_, str name, _, _, _) := b]);
}

public Figure visMethod(str name){
	return box(text("<name>"), gap(2), fillColor("lightyellow"));
}