esp_board_x = 16;
esp_board_y = 24;
esp_board_z = 0.87;

esp_chip_x = 12;
esp_chip_y = 15;
esp_chip_z = 2.53;

module esp_8622 () {
    cube([esp_board_x,esp_board_y,esp_board_z]);
    translate([2,7.5,0.87]) {
        cube([esp_chip_x,esp_chip_y,esp_chip_z]);
    }
}

esp_8622();