
$fs = 0.1;

key_pitch_h = 19.05;
key_pitch_v = 16;

base_position = [0, 28];
base_size = [114.3, 61];
thumb_position = [57.15, 0];
thumb_size = [76.2, 16];

tilt_a = atan2(3, 64.2);

choc_v1_leg_height = 3;
circuit_thickness = 0.6;
circuit_z = choc_v1_leg_height - circuit_thickness + 0.2;

module key_choc_v1() {
    translate([-15 / 2, -15 / 2]) cube([15, 15, 5]);
    translate([0, 0, -3]) cylinder(3, d = 3.2);
}

module circuit_board() {
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

module rubber_base() {
    module rubber_hole_choc_v1() {
        cylinder((3.2 - circuit_thickness) * 2, d = 3.3, center = true);
        translate([ 5.5, 0]) cylinder((2.9 - circuit_thickness) * 2, d = 2.2, center = true);
        translate([-5.5, 0]) cylinder((2.9 - circuit_thickness) * 2, d = 2.2, center = true);
    }

    module pro_micro_hole() {
        translate([base_position.x, base_position.y + base_size.y - 19]) {
            cube([34, 19, 10]);
        }
    }

    n = [base_position.y, circuit_z + tan(tilt_a) * base_position.y];
    y1 = n.x * cos(tilt_a) + n.y * sin(tilt_a);
    y2 = (base_position.y + base_size.y) * cos(tilt_a);

    difference() {
        hull() {
            translate([base_position.x, y1]) cube([base_size.x, y2 - y1, 0.01]);

            rotate([tilt_a, 0]) {
                translate([base_position.x, base_position.y, circuit_z]) {
                    cube([base_size.x, base_size.y, 0.01]);
                }
            }
        }

        pro_micro_hole();

        for (x = [0 : 5]) {
            for (y = [0 : 3]) {
                rotate([tilt_a, 0]) {
                    translate([key_pitch_h * (x + 0.5), key_pitch_v * (y + 2), circuit_z]) {
                        rubber_hole_choc_v1();
                    }
                }
            }
        }
    }
}

module rubber_thumb() {
    module rubber_hole_choc_v1() {
        cylinder(10, d = 3.3, center = true);
        translate([ 5.5, 0]) cylinder(10, d = 2.2, center = true);
        translate([-5.5, 0]) cylinder(10, d = 2.2, center = true);
    }

    n = [thumb_position.y + 4, circuit_z + tan(tilt_a) * thumb_position.y];
    y1 = n.x * cos(tilt_a) + n.y * sin(tilt_a);
    y2 = (thumb_position.y + thumb_size.y) * cos(tilt_a);

    difference() {
        hull() {
            translate([thumb_position.x, y1]) cube([thumb_size.x, y2 - y1, 0.01]);

            rotate([tilt_a, 0]) {
                translate([thumb_position.x, thumb_position.y + 4, circuit_z]) {
                    cube([thumb_size.x, thumb_size.y - 4, 0.01]);
                }
            }
        }

        for (x = [0 : 3]) {
            translate([key_pitch_h * (x + 3.5), key_pitch_v * 0.5, circuit_z]) {
                rubber_hole_choc_v1();
            }
        }
    }
}

color("#00ff0044") rotate([tilt_a, 0, 0]) translate([0, 0, circuit_z]) circuit_board($fa = 8);

color("#ff000044") {
    rotate([tilt_a, 0]) {
        translate([0, 0, choc_v1_leg_height]) {
            for (x = [0 : 5]) {
                for (y = [0 : 3]) {
                    translate([key_pitch_h * (x + 0.5), key_pitch_v * (y + 2)]) {
                        key_choc_v1();
                    }
                }
            }

            for (x = [0 : 3]) {
                translate([key_pitch_h * (x + 3.5), key_pitch_v * 0.5]) {
                    key_choc_v1();
                }
            }
        }
    }
}

rubber_base();
rubber_thumb();
