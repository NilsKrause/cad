pin_long_z = 6.3;
pin_short_z = 2.9;
plastic_z = 2.4;

pin_x = 2.5;
pin_y = 2.5;
pin_z = pin_long_z + pin_short_z + plastic_z;

function connector_length(pin_n) = (pin_x + 0.01) * pin_n;

module connector_pins(pin_n) {
    cube([connector_length(pin_n),pin_y,pin_z]);
}

module 8x_connector_pins() {
    connector_pins(8);
}