$fn = 100;

module holder() {
    linear_extrude(2) {
        circle(d=61);
    }

    difference() {
        linear_extrude(20) {
            circle(d=63);
        }
        translate([0, 0, 2]) {
            linear_extrude(2) {
                circle(d=36.5);
            }
        }
        translate([0, 0, 3]) {
            linear_extrude(20) {
                circle(d=61);
            }
        }
    }
}

module mount() {
    difference() {
        translate([-14, 0, 0]) {
            linear_extrude(30) {
                square([28,31.5]);
            }
        }
        // translate([-20.5,0,20]) {
        //     linear_extrude(30.5) {
        //         square([41,62]);
        //     }
        // }
        linear_extrude(41) {
            circle(d=61);
        }
    }
}

mount();
holder();