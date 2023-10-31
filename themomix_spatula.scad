include <libs/round-anything/polyround.scad>
include <gridfinity_sv03_max_baseplate.scad>

function toGridfinityGridL(length) = (length/l_grid)+(1-((length/l_grid)%1));

spatchulaLength = 290;
spatchulaCircleD = 72;

// gridLength = toGridfinityGridL(41);
// gridWidth = toGridfinityGridL(209);
gridLength = 3;
gridWidth = 3;

groovePadding=10;
grooveGridN=5;
grooveDepth=h_base-1;
grooveThickness=4;

module spatulaGroove (gridN, padding, thickness, depth) {
        cube([
            (gridN * l_grid) - padding * 2,
            thickness,
            depth+1
        ]);
}

module base() {
    sv03Base();
    translate([gridWidth*l_grid,0,0]) {
        sv03Base();
    }
}

module baseplate () {
    sv03Baseplate();
    translate([gridWidth*l_grid,0,0]) {
        sv03Baseplate();
    }
}

difference() {    
    base();

    translate([groovePadding, l_grid-grooveThickness/2, h_base-grooveDepth+1]) {
        spatulaGroove(grooveGridN, groovePadding, grooveThickness, grooveDepth);
    }

    translate([groovePadding, (l_grid*3)/2-grooveThickness/2, h_base-grooveDepth+1]) {
        spatulaGroove(grooveGridN, groovePadding, grooveThickness, grooveDepth);
    }
}

// VERY SLOW TO RENDER!
difference() {
    baseplate();

    translate([groovePadding, l_grid-grooveThickness/2, h_base-grooveDepth+1]) {
        spatulaGroove(grooveGridN, groovePadding, grooveThickness, grooveDepth);
    }

    translate([groovePadding, (l_grid*3)/2-grooveThickness/2, h_base-grooveDepth+1]) {
        spatulaGroove(grooveGridN, groovePadding, grooveThickness, grooveDepth);
    }
}