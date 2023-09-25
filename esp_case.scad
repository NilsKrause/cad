include <azdelivery_esp8266_adapter_board.scad>

wall_thickness = 2;
esp_bottom_margin = 2;
tolerance = 0.2;
inside_margin_x = 2;

wall_z_x = board_x + wall_thickness*2 + tolerance*2 + inside_margin_x*2;
wall_z_y = board_y + wall_thickness*2 + tolerance*2;

wall_xy_z = esp_8266_adapterboard_assembled_z + wall_thickness + esp_bottom_margin;
wall_x_x = board_x + wall_thickness*2 + tolerance*2 + inside_margin_x*2;
wall_y_y = board_y + wall_thickness*2 + tolerance*2;

rail_x = wall_thickness * 0.4;
rail_y = wall_y_y;
rail_z = wall_thickness * 0.3;

esp_rail_x = 3;

module esp () {
    // esp board
    rotate([180,0,0])
        translate([
            wall_thickness + tolerance + inside_margin_x,
            -1 * board_y - wall_thickness - tolerance, 
            esp_8266_adapterboard_assembled_z * -1 - wall_thickness - esp_bottom_margin
        ])
        azdelivery_esp8266_adapter_board();
}

// wall_z
module wall_z () {
    cube([wall_z_x, wall_z_y, wall_thickness]);
}

// wall y
module wall_y () {
    cube([wall_thickness, wall_y_y, wall_xy_z]);
}

//wall x
module wall_x () {
    cube([wall_x_x, wall_thickness, wall_xy_z]);
}

module rail (tolerance_enabled=false, additional_y=0) {
    x = tolerance_enabled ? rail_x+tolerance*2 : rail_x;
    z = tolerance_enabled ? rail_z+tolerance*2 : rail_z;
    cube([
        x,
        rail_y + additional_y - wall_thickness - tolerance,
        z
    ]);
}

// leftside lid rail female
module leftside_femail_lid_rail () {
        translate([
            - (rail_x / 2) - 0.01,
            wall_thickness,
            wall_xy_z - (wall_thickness / 2) - (rail_z / 2) - tolerance
        ]) {
            rail(true, tolerance + 0.01);
        }
}

//rightside lid rail female
module rightside_female_lid_rail() {
    translate([
        wall_thickness - rail_x + 0.01,
        wall_thickness,
        wall_xy_z - (wall_thickness / 2) - (rail_z / 2) - tolerance
    ]) {
            rail(true, tolerance + 0.01);
    }
}

module box() {
    // backside wall
    wall_x();

    // bottom/floor
    wall_z();

    rail_height = wall_thickness + esp_bottom_margin + esp_8266_z;

    left_point_right_rail = wall_thickness + pin_x + inside_margin_x + tolerance;
    right_point_right_rail = wall_thickness + inside_margin_x + board_x/2 - esp_8266_x/2;
    translate([
        left_point_right_rail + ((right_point_right_rail-left_point_right_rail)/2),
        wall_z_y/2,
        rail_height/2
    ])
        cube([
            esp_rail_x,
            wall_z_y, 
            rail_height
        ], true);

    left_point_left_rail = wall_thickness + inside_margin_x + board_x/2 + esp_8266_x/2;
    right_point_left_rail = wall_thickness + inside_margin_x + board_x + tolerance - pin_x;
    translate([
        left_point_left_rail + ((right_point_left_rail-left_point_left_rail)/2),
        wall_z_y/2,
        rail_height/2
    ])
        cube([
            esp_rail_x,
            wall_z_y, 
            rail_height
        ], true);

    // frontside wall
    translate([0, wall_y_y - wall_thickness, 0]) {
        difference() {
            wall_x();
            translate([0,-tolerance,wall_xy_z-wall_thickness-tolerance])
                cube([board_x + tolerance*2 + inside_margin_x*2 + wall_thickness*2, wall_thickness+tolerance*2, wall_thickness+tolerance*2]);
        }
    }

    // rightside wall
    difference() {
        wall_y();
        rightside_female_lid_rail();
    }

    // leftside wall
    translate([wall_x_x - wall_thickness, 0, 0]) {
        difference() {
            wall_y();
            leftside_femail_lid_rail();
        }
    }
}

// lid
module lid() {
    difference() {
        translate([0,0,wall_xy_z - wall_thickness]) {
            // rightside lid rail male
            translate([wall_thickness+tolerance-rail_x+0.01, wall_thickness+tolerance, wall_thickness/2-rail_z/2]) {
                rail();
            }
            // leftside lid rail male
            translate([wall_z_x-wall_thickness-tolerance-0.01, wall_thickness+tolerance, wall_thickness/2-rail_z/2]) {
                rail();
            }
            difference() {
                cube([wall_z_x, wall_z_y, wall_thickness]);
                translate([-tolerance,-tolerance,-tolerance])
                    cube([wall_thickness+tolerance*2, wall_z_y+tolerance*2, wall_thickness+tolerance*2]);
                translate([wall_x_x-wall_thickness-tolerance,-tolerance,-tolerance])
                    cube([wall_thickness+tolerance*2, wall_z_y+tolerance*2, wall_thickness+tolerance*2]);
                translate([-tolerance,-tolerance,-tolerance])
                    cube([wall_x_x, wall_thickness+tolerance*2, wall_thickness+tolerance*2]);
            }
        }
        translate([0, -0.01, 0])
            esp();
    }
}

%esp();
box();
lid();