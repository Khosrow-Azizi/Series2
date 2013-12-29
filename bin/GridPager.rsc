module GridPager

import List;
import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Math;
import util::Editors;
import String;
import IO;

import Analysis;
import AnalysisTypes;
import AnalysisOverview;
import AnalysisDetailGrid;

private customDataType dataCollection;
private tuple[int begin, int end] selectedPage = <0,0>;
private tuple[int begin, int end] pageBoundary = <0,0>;

public alias ccUnsPager = tuple[Figure control, list[tuple[str name, loc location, int complexity, int lofc]] dataCollection];

public ccUnsPager gridPager(Analysis analysisType, customDataType analysisData, int maxPageSize, bool reset){
	dataCollection = analysisData;
	if(reset){
		pageBoundary = <0, size(dataCollection.methods)>;
		selectedPage = <0, maxPageSize>;
	}
	
	if(selectedPage.begin < pageBoundary.begin)
		selectedPage.begin = pageBoundary.begin;
	selectedPage.end = selectedPage.begin + maxPageSize;
	if(selectedPage.end > pageBoundary.end)
		selectedPage.end = pageBoundary.end;
		
	prevBtn = box(text("\<\< Previous", resizable(false)), changePage(false, analysisType, maxPageSize), fillColor("lightGray"), height(30), width(100), resizable(false));
	nextBtn = box(text("Next \>\>", resizable(false)), changePage(true, analysisType, maxPageSize), fillColor("lightGray"),  height(30), width(100), resizable(false));	
	buttons = [];
	if(selectedPage.begin != pageBoundary.begin)
		buttons += prevBtn;
	buttons += box(text("page <toString((selectedPage.begin/maxPageSize)+1)> of <toString((pageBoundary.end/maxPageSize)+1)>"), center(),height(30), vresizable(false));
	if(selectedPage.end != pageBoundary.end)
		buttons += nextBtn;	
	return <hcat(buttons), dataCollection.methods[selectedPage.begin..selectedPage.end]>;
}

public FProperty changePage(bool forward, ccAnalysis(str name), int maxPageSize){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		selectedPage.begin = forward ? (selectedPage.begin + maxPageSize) : (selectedPage.begin - maxPageSize);
	 	render(hcat([overview(0.9, top(), left(), true), box(ccAnalysisDetail(totalMethodLines, dataCollection, false))], gap(5)));
	  	return true;});
}