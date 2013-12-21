module Analysis

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core; 
import lang::java::m3::Core;
import util::Math;
import util::Benchmark; 

import List;
import IO;

import series1::SourceCodeFilter;
import series1::LinesOfCodeCalculator;
import series1::DuplicatesCalculator;
import series1::CyclomaticComplexity;

public loc HelloWorldLoc = |project://HelloWorld|;
public loc smallsqlLoc = |project://smallsql|; 
public loc hsqldbLoc = |project://hsqldb231|;

public int totalMethodLines = 0;
public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] veryHighCcRisks = <[],0,0.0>;
public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] highCcRisks =  <[],0,0.0>;
public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] moderateCcRisks = <[],0,0.0>;
public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] lowCcRisks = <[],0,0.0>;

public void startAnalysis(loc project){
	println("Analysis started. Please wait..");
	int totalExecTime = cpuTime(void() {run(project);});
	println("Analysis finished. Total execution time <toReal(totalExecTime)/1000000000> seconds.");
}

public void run(loc project){
	model = createM3FromEclipseProject(project);
	ast = createAstsFromEclipseProject(project, false);	
	veryHighCcRisks = <[],0,0.0>;
	highCcRisks = <[],0,0.0>;
	moderateCcRisks = <[],0,0.0>;
	lowCcRisks = <[],0,0.0>;
	set[loc] srcFiles = getSrcFiles(model);
	set[loc] srcMethods = getSrcMethods(srcFiles);
		
	int totalLoc = calculateProjectLoc(srcFiles);	
	totalMethodLines = calculateProjectLoc(srcMethods);	
	//int totalDublications = calculateDuplications(srcMethods, 6);
	list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult = getComplexityPerUnit(ast, true);
	processComplexityResult(totalMethodLines, ccAnalysisResult);
}

public void processComplexityResult(int totalMethodsLoc, list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult){
		
	lowRisks = [ cc | cc <- ccAnalysisResult, cc.complexity <= 10];
	moderateRisks = [cc | cc <- ccAnalysisResult, cc.complexity > 10 && cc.complexity <= 20];
	highRisks = [cc | cc <- ccAnalysisResult, cc.complexity > 20 && cc.complexity <= 50];
	veryHighRisks =  [cc | cc <- ccAnalysisResult, cc.complexity > 10];
	
	lowCcRisks.methods = lowRisks;// sort(lowRisks);
	moderateCcRisks.methods = moderateRisks;//sort(moderateRisks);
	highCcRisks.methods = highRisks;//sort(highRisks);
	veryHighCcRisks.methods = veryHighRisks;sort(veryHighRisks);
	
	lowCcRisks.totalLoc = (0 | it + m.lofc | m <- lowRisks);
	lowCcRisks.ratio = toReal(lowCcRisks.totalLoc) / totalMethodsLoc;	
	
	moderateCcRisks.totalLoc = (0 | it + m.lofc | m <- moderateRisks);	
	moderateCcRisks.ratio = toReal(moderateCcRisks.totalLoc) / totalMethodsLoc;	
	
	highCcRisks.totalLoc = (0 | it + m.lofc | m <- highRisks);;	
	highCcRisks.ratio = toReal(highCcRisks.totalLoc) / totalMethodsLoc;
		
	veryHighCcRisks.totalLoc = (0 | it + m.lofc | m <- veryHighRisks);;
	veryHighCcRisks.ratio = toReal(veryHighCcRisks.totalLoc) / totalMethodsLoc;
}

public list[tuple[str name, loc location, int complexity, int lofc]] sort(list[tuple[str name, loc location, int complexity, int lofc]] methods){
	if(isEmpty(methods))
		return [];
	return add(tail(methods), head(methods));
}

public list[tuple[str name, loc location, int complexity, int lofc]] add(list[tuple[str name, loc location, int complexity, int lofc]] orderedList, 
	tuple[str name, loc location, int complexity, int lofc] method){
	if(isEmpty(orderedList))
		return [method];		
	if(head(orderedList).complexity > method.complexity)
			return head(orderedList) + add(tail(orderedList), method);
	return [method] + orderedList;		
}




