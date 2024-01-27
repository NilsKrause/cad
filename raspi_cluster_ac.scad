// include <libs/round-anything/polyround.scad>
// include <libs/nopscad/tests/axials.scad>
include <libs/nopscad/lib.scad>
include <libs/nopscad/vitamins/pcb.scad>
include <libs/nopscad/printed/pcb_mount.scad>

// // pcb settings
pcb = PERF70x50;

// // case settings
// step_width=1;
// cave_depth=2;

// groove_depth=1.5;
// corner_size=3.5;

// floor_height=1;

// wall_thickness=2;

// width=50;
// length=70;

// module screw_hole (diameter, height) {
//     linear_extrude(height) {
//         circle(d=diameter);
//     }
// }

// module base (height=floor_height, with_walls=true, length_mod=0, width_mod=0) {
//     if (with_walls) {
//         linear_extrude(height) {
//             polygon([
//                 //bottom
//                 [0,                                         0],
//                 [width + width_mod + wall_thickness * 2,    0],
//                 [width + width_mod + wall_thickness * 2,    length +length_mod + wall_thickness * 2],
//                 [0,                                         length +length_mod + wall_thickness * 2],
//             ]);
//         }
//     } else {
//         linear_extrude(height) {
//             polygon([
//                 //bottom
//                 [0,                 0],
//                 [width+width_mod,   0],
//                 [width+width_mod,   length+length_mod],
//                 [0,                 length+length_mod],
//             ]);
//         }
//     }
// }
// module case() {
//     base();
//     translate([0, 0, floor_height]) {
//         difference() {
//             base(cave_depth, true);
//             translate([wall_thickness+step_width, wall_thickness+step_width, 0-0.1]) {
//                 linear_extrude(cave_depth+0.2) {
//                     polygon([
//                         [corner_size,                           corner_size],
//                         [corner_size,                           0],
//                         [width - corner_size - step_width * 2,  0],
//                         [width - corner_size - step_width * 2,  corner_size],
//                         [width - step_width * 2,                corner_size],
//                         [width - step_width * 2,                length - corner_size - step_width * 2],
//                         [width - corner_size - step_width * 2,  length - corner_size - step_width * 2],
//                         [width - corner_size - step_width * 2,  length - step_width * 2],
//                         [corner_size,                           length - step_width * 2],
//                         [corner_size,                           length - corner_size - step_width * 2],
//                         [0,                                     length - corner_size - step_width * 2],
//                         [0,                                     corner_size],
//                     ]);
//                 }
//             }
//         }
//     }
//     translate([0,0,floor_height+cave_depth]) {
//         difference() {
//             base(groove_depth);
//             translate([wall_thickness, wall_thickness, 0-0.1]) {
//                 base(groove_depth+0.2, false);
//             }
//         }
//     }
// }



// module ac() {
//     translate([((length+wall_thickness*2)/2), ((width+wall_thickness*2)/2) * -1, 0])
//         rotate([0,0,90])
//             case();

//     translate ([0,0,floor_height+cave_depth])
//         #pcb(pcb);
// }

// module assembled_thicc(type) {
//     thicc = 0;
//     for (component = pcb_components(type)) {
//         echo(component.h);
//     }
// }

pi1 = RPI4;
pi2 = RPI4;
pi3 = RPI4;
pi4 = RPI4;

meanwell = PD_150_12;

module screws(type) {
    pillar = ["M3x6_hex_pillar",        "hex",       2.5,  20, 5/cos(30), 5/cos(30),  6, 6, brass,     brass,   -5, 6];
    pcb_screw_positions(pi1)
        pillar(pillar);
}

module screwed_pcb(type) {
    pcb(type);
    screws(type);
}

module cluster() {
    screwed_pcb(pi1);
    translate([0,0,20])
        screwed_pcb(pi2);
    translate([0,0,40])
        screwed_pcb(pi3);
    translate([0,0,60])
        screwed_pcb(pi4);
}


// rotate([0,0,-90])
// translate([0,0,psu_height(meanwell)])
//     cluster();

// translate([
//     psu_length(meanwell) / 2 - pcb_length(pi1) / 2,
//     0,
//     0
// ]) {
//     psu(meanwell);
// }

// translate([
//     pcb_thickness(pcb) / 2 + pcb_length(pi1) / 2,
//     0,
//     0
// ])
// rotate([0,90,0])


pcb(pcb);