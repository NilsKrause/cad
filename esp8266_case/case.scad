include <lib/units.scad>;
include <../esp_8622/esp_8622.scad>

board_x = 31.5;
board_y = 28;
board_z = 0.93;


board_esp_margin_x = (board_x - esp_board_x) / 2;


cube([board_x,board_y,board_z]);
translate([0,0,board_z]) {
    translate([board_esp_margin_x,0,0]){
        esp_8622();
    }
    translate([0,7,0]) {
        cube([1,21,1.6]);
    }
}