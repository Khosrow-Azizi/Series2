module Analysis

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core; 
import lang::java::m3::Core;
import util::Math;
import util::Benchmark; 
import AnalysisTypes;

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
public customDataType veryHighCcRisks = <[],0,0.0>;
public customDataType highCcRisks =  <[],0,0.0>;
public customDataType moderateCcRisks = <[],0,0.0>;
public customDataType lowCcRisks = <[],0,0.0>;

public customDataType veryHighUzRisks = <[],0,0.0>;
public customDataType highUzRisks =  <[],0,0.0>;
public customDataType moderateUzRisks = <[],0,0.0>;
public customDataType lowUzRisks = <[],0,0.0>;

public dupDataType duplicate = <(),0.0>;
public dupDataType nonDuplicate = <(),0.0>;

public dupAnalysisDataType duplicateRisks = <{}, 0.0>;

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
	
	veryHighUzRisks = <[],0,0.0>;
	highUzRisks = <[],0,0.0>;
	moderateUzRisks = <[],0,0.0>;
	lowUzRisks = <[],0,0.0>;
	
	duplicate = <(),0.0>;
	nonDuplicate = <(),0.0>;
	
	set[loc] srcFiles = getSrcFiles(model);
	set[loc] srcMethods = getSrcMethods(srcFiles);
		
	int totalLoc = calculateProjectLoc(srcFiles);	
	totalMethodLines = calculateProjectLoc(srcMethods);	
	//int totalDublications = calculateDuplications(srcMethods, 6);
	list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult = getComplexityPerUnit(ast, true);
	processComplexityResult(totalMethodLines, ccAnalysisResult);
	processUnitSizeResult(totalMethodLines, ccAnalysisResult);
	countDupsLines = calculateDuplications({s | m <- srcMethods, <m, s> <- model@declarations}, 6); //??
//	iprintln(getAllDups());
	processDupResult(totalMethodLines,countDupsLines );
}

public void processComplexityResult(int totalMethodsLoc, list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult){
	lowCcRisks.methods =  [];
	moderateCcRisks.methods =  [];
	highCcRisks.methods =  [];
	veryHighCcRisks.methods =  [];
	lowRisks = [ cc | cc <- ccAnalysisResult, cc.complexity <= 10];
	moderateRisks = [cc | cc <- ccAnalysisResult, cc.complexity > 10 && cc.complexity <= 20];
	highRisks = [cc | cc <- ccAnalysisResult, cc.complexity > 20 && cc.complexity <= 50];
	veryHighRisks =  [cc | cc <- ccAnalysisResult, cc.complexity > 50];
	
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

public void processUnitSizeResult(int totalMethodsLoc, list[tuple[str name, loc location, int complexity, int lofc]] uzAnalysisResult){
	lowUzRisks.methods =  [];
	moderateUzRisks.methods =  [];
	highUzRisks.methods =  [];
	veryHighUzRisks.methods =  [];
	lowRisks = [ uz | uz <- uzAnalysisResult, uz.lofc <= 10];
	moderateRisks = [uz | uz <- uzAnalysisResult, uz.lofc > 10 && uz.lofc <= 20];
	highRisks = [uz | uz <- uzAnalysisResult, uz.lofc > 20 && uz.lofc <= 50];
	veryHighRisks =  [uz | uz <- uzAnalysisResult, uz.lofc > 50];
	
	lowUzRisks.methods = lowRisks;
	moderateUzRisks.methods = moderateRisks;
	highUzRisks.methods = highRisks;
	veryHighUzRisks.methods = veryHighRisks;sort(veryHighRisks);
	
	lowUzRisks.totalLoc = (0 | it + m.lofc | m <- lowRisks);
	lowUzRisks.ratio = toReal(lowUzRisks.totalLoc) / totalMethodsLoc;	
	
	moderateUzRisks.totalLoc = (0 | it + m.lofc | m <- moderateRisks);	
	moderateUzRisks.ratio = toReal(moderateUzRisks.totalLoc) / totalMethodsLoc;	
	
	highUzRisks.totalLoc = (0 | it + m.lofc | m <- highRisks);;	
	highUzRisks.ratio = toReal(highUzRisks.totalLoc) / totalMethodsLoc;
		
	veryHighUzRisks.totalLoc = (0 | it + m.lofc | m <- veryHighRisks);;
	veryHighUzRisks.ratio = toReal(veryHighUzRisks.totalLoc) / totalMethodsLoc;
}


public void processDupResult(int totalMethodsLoc, int dupAnalysisResult){
	//duplicate.methods =  [];
	//nonDuplicate.methods =  [];
	//duplicate.methods = moderateRisks;
	//nonDuplicate.methods = lowRisks;
	
	duplicate.ratio = toReal(dupAnalysisResult) / totalMethodsLoc;
	nonDuplicate.ratio = toReal(1 - duplicate.ratio);
	duplicate.duplicates = getAllDups();
	
	duplicateRisks = <foundDuplicates,toReal(dupAnalysisResult) / totalMethodsLoc> ;
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




