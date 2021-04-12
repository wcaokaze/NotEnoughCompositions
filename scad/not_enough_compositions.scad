
$fs = 0.1;

key_pitch_h = 19.05;
key_pitch_v = 16;

alphanumeric_position = [0, key_pitch_v * 1.5];
alphanumeric_size = [key_pitch_h * 6, key_pitch_v * 4];
thumb_position = [key_pitch_h * 3, 0];
thumb_size = [key_pitch_h * 4, key_pitch_v];

tilt_a = atan2(3, 64.2);

alphanumeric_mounting_hole_positions = [
    [19.05, 40], [38.1, 80], [95.25, 40], [95.25, 72]
];

thumb_mounting_hole_positions = [
    [76.2, 8], [114.3, 8]
];

choc_v1_body_height = 5;
choc_v1_leg_height = 3;
choc_v1_travel = 3;

circuit_thickness = 0.6;
circuit_z = choc_v1_leg_height - circuit_thickness + 0.2;

rubber_padding = 4;

keycap_margin = 0.5;

case_wall_thickness = 1;
case_bottom_thickness = 3;

module key_choc_v1() {
    translate([-15 / 2, -15 / 2]) cube([15, 15, choc_v1_body_height]);
    translate([0, 0, -choc_v1_leg_height]) cylinder(choc_v1_leg_height, d = 3.2);
}

module circuit_board() {
    circuit_board_size = [133.35, 89];
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
                cube([circuit_board_size.x, circuit_board_size.y, circuit_thickness]);

                translate([bridge_width, bridge_width, -circuit_thickness]) {
                    cube([circuit_board_size.x - bridge_width * 2,
                          circuit_board_size.y - bridge_width * 2,
                          circuit_thickness * 3]);
                }
            }

            translate([alphanumeric_position.x, alphanumeric_position.y + rubber_padding]) {
                cube([alphanumeric_size.x, alphanumeric_size.y - rubber_padding, circuit_thickness]);
            }

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

        for (p = [each alphanumeric_mounting_hole_positions, each thumb_mounting_hole_positions]) {
            translate(p) cylinder(20, d = 2.2);
        }
    }
}

module rubber_alphanumeric() {
    module rubber_hole_choc_v1() {
        module pad_hole() {
            minkowski() {
                cylinder(4, d = 2, center = true);
                cube([2.2, 0.01, 0.01], center = true);
            }
        }

        cylinder((3.2 - circuit_thickness) * 2, d = 3.3, center = true);
        translate([ 5.5, 0]) cylinder((2.9 - circuit_thickness) * 2, d = 2.2, center = true);
        translate([-5.5, 0]) cylinder((2.9 - circuit_thickness) * 2, d = 2.2, center = true);

        translate([0, 5.9]) pad_hole();
        translate([5, 3.8]) pad_hole();
    }

    module pro_micro_hole() {
        translate([alphanumeric_position.x, alphanumeric_position.y + alphanumeric_size.y - 19]) {
            cube([34, 19, 10]);
        }
    }

    module diode_hole(positions) {
        rotate([tilt_a, 0]) {
            for (p = positions) {
                translate([p.x, p.y, circuit_z]) cube([2.7, 8, 1.8 * 2], center = true);
            }
        }
    }

    n = [alphanumeric_position.y + rubber_padding, circuit_z + tan(tilt_a) * alphanumeric_position.y];
    y1 = n.x * cos(tilt_a) + n.y * sin(tilt_a);
    y2 = (alphanumeric_position.y + alphanumeric_size.y) * cos(tilt_a);

    diode_positions = [
        [ 3.56, 36.5], [ 3.56, 52.5], [ 1.18, 64.0], [  1.18, 80.0],
        [22.61, 36.5], [22.61, 52.5], [20.23, 64.0], [ 20.23, 80.0],
        [41.66, 36.5], [41.66, 52.5], [41.66, 68.5], [ 41.66, 84.5],
        [60.71, 36.5], [60.71, 52.5], [60.71, 68.5], [ 60.71, 84.5],
        [79.76, 36.5], [79.76, 52.5], [79.76, 68.5], [ 82.14, 75.5],
        [98.81, 36.5], [98.81, 52.5], [98.81, 68.5], [101.19, 75.5]
    ];

    difference() {
        hull() {
            translate([alphanumeric_position.x, y1]) cube([alphanumeric_size.x, y2 - y1, 0.01]);

            rotate([tilt_a, 0]) {
                translate([alphanumeric_position.x,
                           alphanumeric_position.y + rubber_padding,
                           circuit_z])
                {
                    cube([alphanumeric_size.x, alphanumeric_size.y - rubber_padding, 0.01]);
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

        diode_hole(diode_positions);

        for (p = alphanumeric_mounting_hole_positions) {
            translate(p) cylinder(20, d = 2.2);
        }
    }
}

module rubber_thumb() {
    module rubber_hole_choc_v1() {
        module pad_hole() {
            minkowski() {
                cylinder(4, d = 2, center = true);
                cube([2.2, 0.01, 0.01], center = true);
            }
        }

        cylinder(10, d = 3.3, center = true);
        translate([ 5.5, 0]) cylinder(10, d = 2.2, center = true);
        translate([-5.5, 0]) cylinder(10, d = 2.2, center = true);

        translate([0, 5.9]) pad_hole();
        translate([5, 3.8]) pad_hole();
    }

    module diode_hole(positions) {
        rotate([tilt_a, 0]) {
            for (p = positions) {
                translate([p.x, p.y, circuit_z]) cube([2.7, 7, 1.8 * 2], center = true);
            }
        }
    }

    n = [thumb_position.y + rubber_padding, circuit_z + tan(tilt_a) * thumb_position.y];
    y1 = n.x * cos(tilt_a) + n.y * sin(tilt_a);
    y2 = (thumb_position.y + thumb_size.y) * cos(tilt_a);

    diode_positions = [[60.71, 12.5], [79.76, 12.5], [98.81, 12.5], [117.86, 12.5]];

    difference() {
        hull() {
            translate([thumb_position.x, y1]) cube([thumb_size.x, y2 - y1, 0.01]);

            rotate([tilt_a, 0]) {
                translate([thumb_position.x,
                           thumb_position.y + rubber_padding,
                           circuit_z])
                {
                    cube([thumb_size.x, thumb_size.y - rubber_padding, 0.01]);
                }
            }
        }

        for (x = [0 : 3]) {
            translate([key_pitch_h * (x + 3.5), key_pitch_v * 0.5, circuit_z]) {
                rubber_hole_choc_v1();
            }
        }

        diode_hole(diode_positions);

        for (p = thumb_mounting_hole_positions) {
            translate(p) cylinder(20, d = 2.2);
        }
    }
}

module case_alphanumeric() {
    case_size = [alphanumeric_size.x + case_wall_thickness * 2 + keycap_margin,
                 alphanumeric_size.y + case_wall_thickness * 2 + keycap_margin,
                 choc_v1_body_height + choc_v1_travel - 1.5];

    choc_v1_hole_size = [15.4, alphanumeric_size.y, 20];

    bottom_z = circuit_z + circuit_thickness + 1.5;
    bottom_thickness = choc_v1_body_height - 1;

    rotate([tilt_a, 0]) {
        difference() {
            translate([alphanumeric_position.x - case_wall_thickness - keycap_margin / 2,
                       alphanumeric_position.y - case_wall_thickness - keycap_margin / 2,
                       bottom_z])
            {
                cube(case_size);
            }

            translate([alphanumeric_position.x - keycap_margin / 2,
                       alphanumeric_position.y - keycap_margin / 2,
                       bottom_z + bottom_thickness])
            {
                cube([alphanumeric_size.x + keycap_margin,
                      alphanumeric_size.y + keycap_margin,
                      20]);
            }

            for (x = [0 : 5]) {
                translate([alphanumeric_position.x + key_pitch_h * (x + 0.5) - choc_v1_hole_size.x / 2,
                           alphanumeric_position.y])
                {
                    cube(choc_v1_hole_size);
                }
            }

            for (p = alphanumeric_mounting_hole_positions) {
                translate(p) {
                    translate([0, 0, bottom_z + bottom_thickness - 1.1]) cylinder(1.1, d1 = 2.2, d2 = 3.8);
                    cylinder(20, d = 2.2);
                }
            }
        }
    }
}

module case_thumb() {
    case_size = [thumb_size.x + case_wall_thickness * 2 + keycap_margin,
                 thumb_size.y + case_wall_thickness * 2 + keycap_margin,
                 choc_v1_body_height + choc_v1_travel - 1.5];

    choc_v1_hole_size = [15.4, thumb_size.y, 20];

    bottom_z = circuit_z + circuit_thickness + 1.5;
    bottom_thickness = choc_v1_body_height - 1;

    rotate([tilt_a, 0]) {
        difference() {
            translate([thumb_position.x - case_wall_thickness - keycap_margin / 2,
                       thumb_position.y - case_wall_thickness - keycap_margin / 2,
                       bottom_z])
            {
                cube(case_size);
            }

            translate([thumb_position.x - keycap_margin / 2,
                       thumb_position.y - keycap_margin / 2 - case_wall_thickness,
                       bottom_z + bottom_thickness])
            {
                cube([thumb_size.x + keycap_margin,
                      thumb_size.y + keycap_margin + case_wall_thickness,
                      20]);
            }

            for (x = [0 : 3]) {
                translate([thumb_position.x + key_pitch_h * (x + 0.5) - choc_v1_hole_size.x / 2,
                           thumb_position.y])
                {
                    cube(choc_v1_hole_size);
                }
            }

            for (p = thumb_mounting_hole_positions) {
                translate(p) {
                    translate([0, 0, bottom_z + bottom_thickness - 1.1]) cylinder(1.1, d1 = 2.2, d2 = 3.8);
                    cylinder(20, d = 2.2);
                }
            }
        }
    }
}

module keycap() {
    translate([0, 0, 0.5]) {
        cube([
                key_pitch_h - keycap_margin,
                key_pitch_v - keycap_margin,
                1
            ],
            center = true
        );
    }
}

rotate([tilt_a, 0, 0]) translate([0, 0, circuit_z]) circuit_board($fa = 8);

/*
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
*/

rubber_alphanumeric();
rubber_thumb();

case_alphanumeric();
case_thumb();

/*
rotate([tilt_a, 0]) {
    for (x = [0 : 5]) {
        for (y = [0 : 3]) {
            translate([key_pitch_h * (x + 0.5),
                       key_pitch_v * (y + 2),
                       circuit_z + circuit_thickness + choc_v1_body_height + choc_v1_travel])
            {
                keycap();
            }
        }
    }

    for (x = [0 : 3]) {
        translate([key_pitch_h * (x + 3.5),
                   key_pitch_v * 0.5,
                   circuit_z + circuit_thickness + choc_v1_body_height + choc_v1_travel])
        {
            keycap();
        }
    }
}
*/
