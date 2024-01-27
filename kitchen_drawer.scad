include <libs/gridfinity/gridfinity-rebuilt-utility.scad>
include <libs/gridfinity/standard.scad>
include <libs/gridfinity/gridfinity-rebuilt-baseplate.scad>

/* [General Settings] */
// number of bases along x-axis
gridx = 3;  
// number of bases along y-axis   
gridy = 3; 

/* [Screw Together Settings - Defaults work for M3 and 4-40] */
// screw diameter
d_screw = 3.35;
// screw head diameter
d_screw_head = 5;
// screw spacing distance
screw_spacing = .5;
// number of screws per grid block
n_screws = 1; // [1:3]


/* [Fit to Drawer] */
// minimum length of baseplate along x (leave zero to ignore, will automatically fill area if gridx is zero)
distancex = 0;
// minimum length of baseplate along y (leave zero to ignore, will automatically fill area if gridy is zero)
distancey = 0;

// where to align extra space along x
fitx = 0; // [-1:0.1:1]
// where to align extra space along y
fity = 0; // [-1:0.1:1]


/* [Styles] */

// baseplate styles
style_plate = 0; // [0: thin, 1:weighted, 2:skeletonized, 3: screw together, 4: screw together minimal]

// enable magnet hole
enable_magnet = true; 

// hole styles
style_hole = 2; // [0:none, 1:contersink, 2:counterbore]


// ===== IMPLEMENTATION ===== //
screw_together = (style_plate == 3 || style_plate == 4);

color("tomato") 
gridfinityBaseplate(gridx, gridy, l_grid, distancex, distancey, style_plate, enable_magnet, style_hole, fitx, fity);