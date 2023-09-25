include <lib/units.scad>;

pillar_n = 3;
pillar_h = 10 * cm;
pillar_r = 2.5;
pillar_padding = 1;
pillar_spacing_deg = 360 / pillar_n;

element_r = 37.5;
element_padding = 2;
element_h = 10;

base_h = 4;
base_r = element_r + element_padding + pillar_r*2 + element_padding + pillar_padding;

border_width = 2.5;

pillar_pos = element_r + element_padding + pillar_r;

module pillar (pos, nth_pillar, spacing_deg) {
    deg = nth_pillar * spacing_deg;
    
    pillar_x = pillar_pos * cos(deg);
    pillar_y = pillar_pos * sin(deg);
    
    translate([pillar_x, pillar_y, 0]) {
        cylinder(10*cm, 5, 5);
    }
}

module base () {
    cylinder(base_h, base_r, base_r);
}

module border () {
    translate([0, 0, base_h]) {            
        difference() { 
            cylinder(base_h, base_r, base_r);
            translate([0,0,-1])
                cylinder(base_h+2, base_r - border_width, base_r - border_width);
        }
    }    
}

border();
base();

translate([0, 0, base_h]) {
    //%cylinder(element_h, element_r, element_r);
    for(i = [0:pillar_n]) {
        pillar(pillar_pos, i, pillar_spacing_deg);
    }
}