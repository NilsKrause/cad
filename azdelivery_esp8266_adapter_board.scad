include <esp_8266.scad>
include <connector_pins.scad>

board_x = 31.5;
board_y = 28;
board_z = 0.93;

board_esp_margin_x = (board_x - esp_8266_x) / 2;

esp_8266_adapterboard_assembled_x = board_x;
esp_8266_adapterboard_assembled_y = board_y;
esp_8266_adapterboard_assembled_z = board_z + esp_8266_z + plastic_z + pin_long_z;

module pins() {
    rotate(90)
        8x_connector_pins();
}

module azdelivery_esp8266_adapter_board (with_esp=true,with_pins=true) {
        z_offset = with_pins ? pin_long_z + plastic_z : 0;
        
        translate([0,0,z_offset])
        {
            cube([board_x,board_y,board_z]);
            translate([0,0,board_z]) {
                
                if (with_esp) {
                    translate([board_esp_margin_x,0,0]){
                        esp_8266();
                    }
                }
                
                if (with_pins) {
                    translate([pin_x,board_y - connector_length(8),-1 * (pin_z-1.8)])
                        pins();
                    translate([board_x,board_y - connector_length(8),-1 * (pin_z-1.8)])
                        pins();
                }
            }
        }
}