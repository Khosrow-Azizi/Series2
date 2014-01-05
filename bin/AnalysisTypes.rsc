module AnalysisTypes

data Analysis = ccAnalysis(str name) | dupAnalysis(str name) | unitAnalysis(str name);
data Risk = veryHighRisk() | highRisk() | moderateRisk() | lowRisk();

alias customDataType = tuple[list[tuple[str name, loc location, int complexity, int lofc]] methods, int totalLoc, real ratio];
alias dupDataType = tuple[map[str dupCode, set[loc] dupLoc] duplicates, real ratio];

//alias dupAnalysisDataType = tuple[set[tuple[list[str] code, list[loc] locations]] duplicates, real ratio];
alias dupAnalysisDataType = tuple[set[tuple[list[str] code, set[tuple[loc location, int occurence]] locations]] duplicates, real ratio];