pin_x = 2.5;
pin_y = 2.5;
pin_z = 11.6;

function connector_length(pin_n) = (pin_x + 0.01) * pin_n;

module connector_pins(pin_n) {
    cube([connector_length(pin_n),pin_y,pin_z]);
}

module 8x_connector_pins() {
    connector_pins(8);
}