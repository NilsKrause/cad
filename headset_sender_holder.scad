$fn=100;
width=50;
height=55;
thicc=15;

wall_thicc=2;

linear_extrude(wall_thicc) {
    square([width,height+wall_thicc*2], true);
}

difference() {
    translate([0, 0, thicc+wall_thicc]) {
        linear_extrude(wall_thicc) {
            square([width,height], true);
        }
    }
    
    translate([0, height/6, thicc+wall_thicc-1]) {
        linear_extrude(wall_thicc+2) {
            resize([width,height])circle(d=width);
        }
    }

    translate([0, height/1.5, thicc+wall_thicc-1]) {
        linear_extrude(wall_thicc+2) {
            square([width,height],true);
            // circle([width,height], true);
        }
    }
}

linear_extrude(thicc+wall_thicc*2) {
    translate([width/2+wall_thicc/2, 0, 0]) {
        square([wall_thicc,height+wall_thicc*2], true);
    }

    translate([(width/2+wall_thicc/2)*-1, 0, 0]) {
        square([wall_thicc,height+wall_thicc*2], true);
    }

    translate([0, (height/2+wall_thicc/2)*-1, 0]) {
        square([width+wall_thicc*2,wall_thicc], true);
    }
    
}