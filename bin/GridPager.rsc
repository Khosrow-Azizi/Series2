module GridPager

import List;
import Set;
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
private dupAnalysisDataType dupDataCollection;
private tuple[int begin, int end] selectedPage = <0,0>;
private tuple[int begin, int end] pageBoundary = <0,0>;

public alias ccUnitPager = tuple[Figure control, list[tuple[str name, loc location, int complexity, int lofc]] dataCollection];
public alias dupPager =  tuple[Figure control, set[tuple[list[str] code, set[tuple[loc location, int occurence]] locations]] dataCollection];

public ccUnitPager gridPager(Analysis analysisType, customDataType analysisData, int maxPageSize, bool initialize){
	dataCollection = analysisData;
	if(initialize){
		pageBoundary = <0, size(dataCollection.methods)>;
		selectedPage = <0, maxPageSize>;
	}
	
	if(selectedPage.begin >= pageBoundary.end)
		selectedPage.begin = pageBoundary.end - maxPageSize;
			
	if(selectedPage.begin < pageBoundary.begin)
		selectedPage.begin = pageBoundary.begin;
	
	selectedPage.end = selectedPage.begin + maxPageSize;
	if(selectedPage.end > pageBoundary.end)
		selectedPage.end = pageBoundary.end;
		
	prevBtn = box(hcat([
		box(text("\<\<", resizable(false)), reset(false, analysisType, maxPageSize), fillColor("lightGray"), height(30), width(30), resizable(false),left()),
		box(text("\< Previous", resizable(false)), changePage(false, analysisType, maxPageSize), fillColor("lightGray"), height(30), width(82), resizable(false), right())]),
		height(30), width(115), resizable(false));
	nextBtn = box(hcat([
		 box(text("Next \>", resizable(false)), changePage(true, analysisType, maxPageSize), fillColor("lightGray"),  height(30), width(82), resizable(false)),
		box(text("\>\>", resizable(false)), reset(true, analysisType, maxPageSize), fillColor("lightGray"), height(30), width(30), resizable(false))]),
		height(30), width(115), resizable(false));	
	buttons = [];
	if(selectedPage.begin != pageBoundary.begin)
		buttons += prevBtn;
	totalPages = 0;
	if((pageBoundary.end % maxPageSize) == 0)
		totalPages = pageBoundary.end / maxPageSize;
	else
		totalPages = (pageBoundary.end / maxPageSize) + 1;
	buttons += box(text("page <toString((selectedPage.begin/maxPageSize)+1)> of <toString(totalPages)>"), center(),height(30), vresizable(false));
	if(selectedPage.end != pageBoundary.end)
		buttons += nextBtn;	
	return <hcat(buttons), dataCollection.methods[selectedPage.begin..selectedPage.end]>;
}

public dupPager gridPager(Analysis analysisType, dupAnalysisDataType analysisData, int maxPageSize, bool initialize){
	dupDataCollection = analysisData;
	//return <box(), dupDataCollection.duplicates>;//toList(dupDataCollection.duplicates)[selectedPage.begin..selectedPage.end]>;
	if(initialize){
		pageBoundary = <0, size(dupDataCollection.duplicates)>;
		selectedPage = <0, maxPageSize>;
	}	
	
	if(selectedPage.begin >= pageBoundary.end)
		selectedPage.begin = pageBoundary.end - maxPageSize;
	if(selectedPage.begin < pageBoundary.begin)
		selectedPage.begin = pageBoundary.begin;
	selectedPage.end = selectedPage.begin + maxPageSize;
	if(selectedPage.end > pageBoundary.end)
		selectedPage.end = pageBoundary.end;
		
	prevBtn = box(hcat([
		box(text("\<\<", resizable(false)), reset(false, analysisType, maxPageSize), fillColor("lightGray"), height(30), width(30), resizable(false),left()),
		box(text("\< Previous", resizable(false)), changePage(false, analysisType, maxPageSize), fillColor("lightGray"), height(30), width(82), resizable(false), right())]),
		height(30), width(115), resizable(false));
	nextBtn = box(hcat([
		 box(text("Next \>", resizable(false)), changePage(true, analysisType, maxPageSize), fillColor("lightGray"),  height(30), width(82), resizable(false)),
		box(text("\>\>", resizable(false)), reset(true, analysisType, maxPageSize), fillColor("lightGray"), height(30), width(30), resizable(false))]),
		height(30), width(115), resizable(false));	
	buttons = [];
	if(selectedPage.begin != pageBoundary.begin)
		buttons += prevBtn;
	totalPages = 0;
	if((pageBoundary.end % maxPageSize) == 0)
		totalPages = pageBoundary.end / maxPageSize;
	else
		totalPages = (pageBoundary.end / maxPageSize) + 1;
	buttons += box(text("page <toString((selectedPage.begin/maxPageSize)+1)> of <toString(totalPages)>"), center(),height(30), vresizable(false));
	if(selectedPage.end != pageBoundary.end)
		buttons += nextBtn;	
	return <hcat(buttons), toSet(toList(dupDataCollection.duplicates)[selectedPage.begin..selectedPage.end])>;
}

public FProperty changePage(bool forward, ccAnalysis(str name), int maxPageSize){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		selectedPage.begin = forward ? (selectedPage.begin + maxPageSize) : (selectedPage.begin - maxPageSize);
	 	render(hcat([overview(0.9, top(), left(), true), box(ccAnalysisDetail(totalMethodLines, dataCollection, false))], gap(5)));
	  	return true;});
}

public FProperty changePage(bool forward, unitAnalysis(str name), int maxPageSize){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		selectedPage.begin = forward ? (selectedPage.begin + maxPageSize) : (selectedPage.begin - maxPageSize);
	 	render(hcat([overview(0.9, top(), left(), true), box(unitAnalysisDetail(totalMethodLines, dataCollection, false))], gap(5)));
	  	return true;});
}

public FProperty reset(bool forward, ccAnalysis(str name), int maxPageSize){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		selectedPage.begin = forward ? ((pageBoundary.end/maxPageSize) * maxPageSize) : 0;
	 	render(hcat([overview(0.9, top(), left(), true), box(ccAnalysisDetail(totalMethodLines, dataCollection, false))], gap(5)));
	  	return true;});
}

public FProperty reset(bool forward, unitAnalysis(str name), int maxPageSize){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		selectedPage.begin = forward ? ((pageBoundary.end/maxPageSize) * maxPageSize) : 0;
	 	render(hcat([overview(0.9, top(), left(), true), box(unitAnalysisDetail(totalMethodLines, dataCollection, false))], gap(5)));
	  	return true;});
}

public FProperty changePage(bool forward, dupAnalysis(str name), int maxPageSize){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		selectedPage.begin = forward ? (selectedPage.begin + maxPageSize) : (selectedPage.begin - maxPageSize);
	 	render(hcat([overview(0.9, top(), left(), true), box(dupAnalysisDetail(totalMethodLines, dupDataCollection, false))], gap(5)));
	  	return true;});
}

public FProperty reset(bool forward, dupAnalysis(str name), int maxPageSize){
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers){
		selectedPage.begin = forward ? ((pageBoundary.end/maxPageSize) * maxPageSize) : 0;
	 	render(hcat([overview(0.9, top(), left(), true), box(dupAnalysisDetail(totalMethodLines, dupDataCollection, false))], gap(5)));
	  	return true;});
}

private bool isEven(int number) = number%2 == 0;