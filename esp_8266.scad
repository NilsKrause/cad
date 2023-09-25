esp_8266_board_x = 16;
esp_8266_board_y = 24;
esp_8266_board_z = 0.87;

esp_8266_chip_x = 12;
esp_8266_chip_y = 15;
esp_8266_chip_z = 2.53;

esp_8266_x = esp_8266_board_x;
esp_8266_y = esp_8266_board_y;
esp_8266_z = esp_8266_board_z + esp_8266_chip_z;

module esp_8266 () {
    cube([esp_8266_board_x,esp_8266_board_y,esp_8266_board_z]);
    translate([2,7.5,0.87]) {
        cube([esp_8266_chip_x,esp_8266_chip_y,esp_8266_chip_z]);
    }
}