module boxOverview
import vis::Figure;
import vis::Render;


public void makeBox(){
//i = hcat([box(size(100,40),fillColor("blue"),project(text(s),"hscreen")) | s <- ["","",""]], hshrink(0.5), vshrink(0.5));
//sc = hscreen(i,id("hscreen"));
//render(sc);

b1 = box(shrink(0.5), align(0, 0), fillColor("green"));
b0 = box(b1, size(150,50), fillColor("lightGray") , shrink(.6));
render(b0);


//b1 = box(size(100,100), fillColor("Red"), ialign(.5));
//render(hvcat([b1]));

}