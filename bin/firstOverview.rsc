module firstOverview
import vis::Figure;
import vis::Render;
import util::Math;

import List;
import IO;

real radius = sqrt(pow(0.5, 2)+ pow(0.5,2));
real deg2rad(real deg) = (deg / 180) * PI();

real percent2deg(real perc) = (360.0/100 * perc); 


public void callMain(){
  list[Figure] circlesMain = [];
  circlesMain += cduplication();
  circlesMain += usize();
  circlesMain += cc();
  render(overlay(circlesMain));
}

public Figure cc(){
  tuple[real ovShrink, str ovColors] overview = <0.3,"Blue">;
  list[tuple[real persc, str colors]] percnt = [<60.0,"red">,<10.0,"blue">,<15.0,"yellow">,<15.0,"green">];
  return makeCircle(percnt, overview.ovShrink, overview.ovColors);
}

public Figure usize(){
  tuple[real ovShrink, str ovColors] overview = <0.6,"White">;
  list[tuple[real persc, str colors]] percnt = [<80.0,"green">,<5.0,"blue">,<5.0,"pink">,<10.0,"orange">];
  return makeCircle(percnt, overview.ovShrink, overview.ovColors);
}
public Figure cduplication(){
  tuple[real ovShrink, str ovColors] overview = <0.9,"Blue">;
  list[tuple[real persc, str colors]] percnt = [<20.0,"red">, <80.0,"green">];
  return makeCircle(percnt, overview.ovShrink, overview.ovColors);
  
}



public void renderCircle(){
    list[tuple[real persc, str colors]] percnt = [<60.0,"red">,<10.0,"blue">,<15.0,"yellow">,<15.0,"green">];
	render(makeCircle(percnt));
}
public Figure makeCircle(percnt, ovShrink, ovColors){
  Figure point(num x, num y){ return ellipse(shrink(0.0),align(x,y));}
// radisu = .7071
  list[tuple[real, real ]] coXY  = [];
  real minDegree = 0.0;
  Figure ovl4 = point(0.5,0.5);
  for (p <- percnt){
    maxDegree = minDegree + percent2deg(p.persc);
    for(i <- [minDegree,minDegree+5 .. maxDegree] ){
      x = 0.5+radius*cos(deg2rad(i));
      y = 0.5+radius*sin(deg2rad(i));
      coXY += <x,y>;
    }
    coXY += <0.5+radius*cos(deg2rad(maxDegree)),0.5+radius*sin(deg2rad(maxDegree))>;
    minDegree = maxDegree;
  
    coords4 = [<0.5,0.5>]+coXY;
    iprintln (size(coords4));
    ovl4 = overlay([point(x,y) | <x,y> <- coords4]+[ovl4], shapeConnected(true),shapeClosed(true), fillColor(p.colors));
    coXY = [];
  }
  return  ellipse(ovl4, shrink(ovShrink), aspectRatio(1), lineColor(ovColors), align(0.5,0.5));;

//coords4 = [<0.5,0.5>, <0.5+0.7071*cos(deg2rad(0.0)), 0.5+0.7071*sin(deg2rad(0.0))>,<0.5+0.7071*cos(deg2rad(10.0)), 0.5+0.7071*sin(deg2rad(10.0))>,
//<0.5+0.7071*cos(deg2rad(20.0)), 0.5+0.7071*sin(deg2rad(20.0))>
//	];


//ovl3 = overlay([point(x,y) | <x,y> <- coords3], shapeConnected(true),fillColor("yellow"));
//c3 = ellipse(ovl3,fillColor("white"), shrink(0.6), aspectRatio(1.0),align(0.5,0.5));

//ovl2 = overlay([point(x,y) | <x,y> <- coords2], shapeConnected(true));
//c2 = ellipse(ovl2,fillColor("white"), shrink(0.3), aspectRatio(1.0),align(0.5,0.5));



//render(overlay([c4,c3,c2]));
//render(ovl4);
}

