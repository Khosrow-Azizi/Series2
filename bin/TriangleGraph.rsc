module TriangleGraph

import vis::Figure;
import vis::Render;
import vis::KeySym;

public void renderGraph(){
	render(triGraph());
}

public Figure triGraph(){
	coords1 = [<0.5,0.0>,<0.0,1.0>,<0.2,1.0>];
	ov1 = overlay([point(x,y) | <x,y> <- coords1], fillColor("red"),
					shapeConnected(true),shapeClosed(true));
	coords2 = [<0.5,0.0>,<0.2,1.0>,<0.5,1.0>];
	ov2 = overlay([point(x,y) | <x,y> <- coords2], fillColor("orange"),
					shapeConnected(true),shapeClosed(true));
					
	coords3 = [<0.5,0.0>,<0.5,1.0>,<0.6,1.0>];
	ov3 = overlay([point(x,y) | <x,y> <- coords3], fillColor("yellow"),
					shapeConnected(true),shapeClosed(true));
					
	coords4 = [<0.5,0.0>,<0.6,1.0>,<1.0,1.0>];
	ov4 = overlay([point(x,y) | <x,y> <- coords4], fillColor("green"),
					shapeConnected(true),shapeClosed(true));
	tex = text("Example text");
	return vcat([overlay([ov1,ov2,ov3,ov4], std(size(150))), tex], shrink(0.5));
}

public Figure point(num x, num y){ return ellipse(width(1), height(1),resizable(false),fillColor("black"),align(x,y));}
