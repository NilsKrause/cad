translate([0,0,1]) {
    import("libs/stl/wall_hook.stl");
}

minkowski() {
    translate([-10,0,1]) {
        linear_extrude(6.4) {
            square([70,20], true);
        }
    }

    sphere(1.25);
}