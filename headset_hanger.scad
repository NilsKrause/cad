$fn = 100;

translate([0,35,0]) {
    linear_extrude(4) {
        square([20,70],true);
    }
}

translate([-153,-30,-4])
    import("libs/stl/Headset_Hanger.stl");
//     linear_extrude(2)
//         circle(7);