// fase
module fase(length=1, rotation=60) {
    rotate(rotation, [0,1,0]) {
        cube([4,length,1], true);
    }
}

module box_holder() {
    // bottom
    linear_extrude(2) {
        square([27.5, 23.5], true);
    }

    // right  wall
    difference() {
        linear_extrude(10) {
            translate([14.5,0,0]) {
                    square([2, 27], true);
            }
        }
        translate([14, -1.5, 10]) {
            fase(26, -60);
        }
    }


    // left wall
    difference() {
        linear_extrude(10) {
            translate([-14.5,0,0]) {
                square([2, 27], true);
            }
        }
        translate([-14, -1.5, 10]) {
            fase(26, 60);
        }
    }

    // front wall
    difference() {
        linear_extrude(10){
            translate([0,-12.5,0]) {
                square([30, 2], true);
            }
        }
        translate([0, -12, 10]) {
            rotate(90, [0,0,1]) {
                fase(30);
            }
        }
    }

    // back wall
    linear_extrude(30) {
        translate([0,12.5,0]) {
            square([27, 2], true);
        }
    }
}

module card_holder() {
    translate([0.5,2,2]) {
    import("libs/stl/SD_Holder.stl");
    }
}

box_holder();
// card_holder();