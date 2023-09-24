esp_8622_board_x = 16;
esp_8622_board_y = 24;
esp_8622_board_z = 0.87;

esp_8622_chip_x = 12;
esp_8622_chip_y = 15;
esp_8622_chip_z = 2.53;

module esp_8622 () {
    cube([esp_8622_board_x,esp_8622_board_y,esp_8622_board_z]);
    translate([2,7.5,0.87]) {
        cube([esp_8622_chip_x,esp_8622_chip_y,esp_8622_chip_z]);
    }
}