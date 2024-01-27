include <libs/round-anything/polyround.scad>

width = 100;
length = 100;
wall_thickness = 3;
floor_thickness = 3;

linear_extrude(floor_thickness) {
    polygon([
        //bottom
        [0,0],
        [width,0],
        [width,length],
        [0,length],
    ]);
}

translate([0,0,floor_thickness]) {
    difference(){
        linear_extrude(wall_thickness) {
            polygon([
                //outside ring
                [0,0],
                [width,0],
                [width,length],
                [0,length],
            ]);
        }

        translate([0, 0, -1]) {
            linear_extrude(wall_thickness+2) {
                polygon([
                    [wall_thickness,wall_thickness],
                    [width-wall_thickness,wall_thickness],
                    [width-wall_thickness,length-wall_thickness],
                    [wall_thickness,length-wall_thickness],
                ]);
            }
        }
    }
}