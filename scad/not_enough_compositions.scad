
$fs = 0.1;

key_pitch_h = 19.05;
key_pitch_v = 16;

base_position = [0, 28];
base_size = [114.3, 61];
thumb_position = [57.15, 0];
thumb_size = [76.2, 16];

tilt_a = atan2(5, 71.1);

module circuit_board() {
    circuit_thickness = 0.6;
    bridge_width = 1.2;

    module choc_v1_foot_print() {
        cylinder(circuit_thickness * 3, d = 3.3, center = true);
        translate([ 5.5, 0]) cylinder(circuit_thickness * 3, d = 2.2, center = true);
        translate([-5.5, 0]) cylinder(circuit_thickness * 3, d = 2.2, center = true);

        translate([0, 5.9]) cube([2.2, 1, circuit_thickness * 3], center = true);
        translate([5, 3.8]) cube([2.2, 1, circuit_thickness * 3], center = true);
    }

    difference() {
        union() {
            difference() {
                whole_size = [
                    max(base_position.x + base_size.x, thumb_position.x + thumb_size.x),
                    max(base_position.y + base_size.y, thumb_position.y + thumb_size.y)
                ];

                cube([whole_size.x, whole_size.y, circuit_thickness]);

                translate([bridge_width, bridge_width, -circuit_thickness]) {
                    cube([whole_size.x - bridge_width * 2, whole_size.y - bridge_width * 2, circuit_thickness * 3]);
                }
            }

            translate(base_position) cube([base_size.x, base_size.y, circuit_thickness]);
            translate(thumb_position) cube([thumb_size.x, thumb_size.y, circuit_thickness]);
        }

        for (x = [0 : 5]) {
            for (y = [0 : 3]) {
                translate([key_pitch_h * (x + 0.5), key_pitch_v * (y + 2)]) {
                    choc_v1_foot_print();
                }
            }
        }

        for (x = [0 : 3]) {
            translate([key_pitch_h * (x + 3.5), key_pitch_v * 0.5]) {
                choc_v1_foot_print();
            }
        }
    }
}

color("#00ff0044") rotate([tilt_a, 0, 0]) circuit_board($fa = 8);
