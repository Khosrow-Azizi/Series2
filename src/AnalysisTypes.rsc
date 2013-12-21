module AnalysisTypes

data Analysis = ccAnalysis(str name) | dupAnalysis(str name) | unitAnalysis(str name);
data Risk = veryHighRisk() | highRisk() | moderateRisk() | lowRisk();