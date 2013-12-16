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

public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] veryHighCcRisks = <[],0,0.0>;
public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] highCcRisks =  <[],0,0.0>;
public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] moderateCcRisks = <[],0,0.0>;
public tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio] lowCcRisks = <[],0,0.0>;

public void startAnalysis(loc project){
	println("Analysis started. Please wait..");
	int totalExecTime = cpuTime(void() {run(project);});
	println("Total execution time <toReal(totalExecTime)/1000000000> seconds.");
}

public void run(loc project){
	model = createM3FromEclipseProject(project);
	ast = createAstsFromEclipseProject(project, false);	
	
	set[loc] srcFiles = getSrcFiles(model);
	set[loc] srcMethods = getSrcMethods(srcFiles);
		
	int totalLoc = calculateProjectLoc(srcFiles);	
	int totalMethodsLoc = calculateProjectLoc(srcMethods);	
	//int totalDublications = calculateDuplications(srcMethods, 6);
	list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult = getComplexityPerUnit(ast, true);
	processComplexityResult(totalMethodsLoc, ccAnalysisResult);
}

public void processComplexityResult(int totalMethodsLoc, list[tuple[str name, loc location, int complexity, int lofc]] ccAnalysisResult){
	int lowRiskLoc = 0;
	int modRiskLoc = 0;
	int highRiskLoc = 0;
	int veryHighRiskLoc = 0;	

	for(cc <- ccAnalysisResult){
		if(cc.complexity <= 10) 
			{ 
				lowRiskLoc += cc.lofc; 
				lowCcRisks.methods += [cc];
				continue; 
			}
		if(cc.complexity > 10 && cc.complexity <= 20) 
			{
				modRiskLoc += cc.lofc;
				moderateCcRisks.methods += [cc];
				continue; 
			}
		if(cc.complexity > 20 && cc.complexity <= 50) 
			{ 
				highRiskLoc += cc.lofc; 
				highCcRisks.methods += [cc];
				continue; 
			}
		veryHighRiskLoc += cc.lofc;
		veryHighCcRisks.methods += [cc];
	}
	lowCcRisks.totalLoc = lowRiskLoc;
	lowCcRisks.ratio = toReal(lowRiskLoc) / totalMethodsLoc;
	
	moderateCcRisks.totalLoc = modRiskLoc;	
	moderateCcRisks.ratio = toReal(modRiskLoc) / totalMethodsLoc;
	
	highCcRisks.totalLoc = highRiskLoc;	
	highCcRisks.ratio = toReal(highRiskLoc) / totalMethodsLoc;
	
	veryHighCcRisks.totalLoc = veryHighRiskLoc;
	veryHighCcRisks.ratio = toReal(veryHighRiskLoc) / totalMethodsLoc;
	
	println(veryHighCcRisks);
	println(highCcRisks);
	println(moderateCcRisks);
	println(lowCcRisks);
}