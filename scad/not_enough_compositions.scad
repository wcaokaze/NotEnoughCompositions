
$fs = 0.1;

key_pitch_h = 19.05;
key_pitch_v = 16;

alphanumeric_position = [0, key_pitch_v * 1.5];
alphanumeric_size = [key_pitch_h * 6, key_pitch_v * 4];
thumb_position = [key_pitch_h * 3, 0];
thumb_size = [key_pitch_h * 4, key_pitch_v];

tilt_a = atan2(3, 64.2);

choc_v1_body_bottom_size = [15, 15, 3];
choc_v1_body_top_size = [13.8, 13.8, 2];
choc_v1_leg_height = 3;
choc_v1_travel = 3;

circuit_board_size = [133.35, 89];
circuit_bridge_width = 1.2;
circuit_thickness = 0.6;
circuit_z = choc_v1_leg_height - circuit_thickness;

rubber_horizontal_padding = 4;
rubber_vertical_padding = 4;

keycap_margin = 0.4;
keycap_thickness = 1;

keycap_horizontal_wall_d = max(choc_v1_body_top_size.x / 2 + 0.4 + keycap_thickness - (key_pitch_h - keycap_margin) / 2, 0);
keycap_vertical_wall_d   = max(choc_v1_body_top_size.y / 2 + 0.4 + keycap_thickness - (key_pitch_v - keycap_margin) / 2, 0);

case_margin_top_thickness = 1.5;
screw_bridge_thickness = 1.4;
case_wall_thickness = 1;
case_bottom_thickness = choc_v1_body_bottom_size.z - case_margin_top_thickness;

case_alphanumeric_size = [
    alphanumeric_size.x + keycap_margin + case_wall_thickness * 2 + keycap_horizontal_wall_d,
    alphanumeric_size.y + keycap_margin + case_wall_thickness * 2 + keycap_vertical_wall_d,
    choc_v1_body_bottom_size.z + choc_v1_body_top_size.z - case_margin_top_thickness + keycap_thickness - 0.2
];

case_alphanumeric_position = [
    alphanumeric_position.x - keycap_margin / 2 - case_wall_thickness - keycap_horizontal_wall_d,
    alphanumeric_position.y - keycap_margin / 2 - case_wall_thickness - keycap_vertical_wall_d,
    circuit_z + circuit_thickness + case_margin_top_thickness
];

case_thumb_size = [
    thumb_size.x + keycap_margin + case_wall_thickness * 2 + keycap_horizontal_wall_d,
    thumb_size.y + keycap_margin + case_wall_thickness * 2 + keycap_vertical_wall_d,
    choc_v1_body_bottom_size.z + choc_v1_body_top_size.z - case_margin_top_thickness + keycap_thickness - 0.2
];

case_thumb_position = [
    thumb_position.x - keycap_margin / 2 - case_wall_thickness - keycap_horizontal_wall_d,
    thumb_position.y - keycap_margin / 2 - case_wall_thickness - keycap_vertical_wall_d,
    circuit_z + circuit_thickness + case_margin_top_thickness
];

screw_d = 2.2;
screw_head_d = 3.8;
alphanumeric_screw_length = 8;
thumb_screw_length = 6;
alphanumeric_screw_z = case_alphanumeric_position.z + case_bottom_thickness - alphanumeric_screw_length;
thumb_screw_z = case_thumb_position.z + case_bottom_thickness - thumb_screw_length;
screw_nut_thickness = 1.2;

alphanumeric_screw_positions = [
    [19.05, 40], [38.1, 80], [95.25, 40], [95.25, 72]
];

thumb_screw_positions = [
    [76.2, 8], [114.3, 8]
];

alphanumeric_diode_positions = [
    [ 3.56, 36.5], [ 3.56, 52.5], [ 1.18, 64.0], [  1.18, 80.0],
    [22.61, 36.5], [22.61, 52.5], [20.23, 64.0], [ 20.23, 80.0],
    [41.66, 36.5], [41.66, 52.5], [41.66, 68.5], [ 41.66, 84.5],
    [60.71, 36.5], [60.71, 52.5], [60.71, 68.5], [ 60.71, 84.5],
    [79.76, 36.5], [79.76, 52.5], [79.76, 68.5], [ 82.14, 75.5],
    [98.81, 36.5], [98.81, 52.5], [98.81, 68.5], [101.19, 75.5]
];

thumb_diode_positions = [
    [60.71, 12.5], [79.76, 12.5], [98.81, 12.5], [117.86, 12.5]
];

module key_choc_v1() {
    union() {
        translate([-choc_v1_body_bottom_size.x / 2,
                   -choc_v1_body_bottom_size.y / 2])
        {
            cube(choc_v1_body_bottom_size);
        }
        translate([-choc_v1_body_top_size.x / 2,
                   -choc_v1_body_top_size.y / 2,
                    choc_v1_body_bottom_size.z])
        {
            cube(choc_v1_body_top_size);
        }
        translate([0, 0, -choc_v1_leg_height]) cylinder(choc_v1_leg_height, d = 3.2);
    }
}

module choc_v1_hole(through_hole = false) {
    module pad_hole() {
        minkowski() {
            cylinder(4, d = 2, center = true);
            cube([2.2, 0.01, 0.01], center = true);
        }
    }

    cylinder(through_hole ? 10 : (3.2 - circuit_thickness) * 2,
             d = 3.5, center = true);
    translate([ 5.5, 0]) cylinder(through_hole ? 10 : (3 - circuit_thickness) * 2,
                                  d = 1.9, center = true);
    translate([-5.5, 0]) cylinder(through_hole ? 10 : (3 - circuit_thickness) * 2,
                                  d = 1.9, center = true);

    translate([0, 5.9]) pad_hole();
    translate([5, 3.8]) pad_hole();
}

module diode_hole(positions) {
    rotate([tilt_a, 0]) {
        for (p = positions) {
            translate([p.x, p.y, circuit_z]) cube([2.7, 8, 1.8 * 2], center = true);
        }
    }
}

module alphanumeric_screw() {
    head_height = screw_head_d / 2 * tan(45);

    translate([0, 0, alphanumeric_screw_z]) {
        union() {
            translate([0, 0, alphanumeric_screw_length - head_height]) {
                cylinder(head_height, d1 = 0, d2 = screw_head_d);
            }

            cylinder(alphanumeric_screw_length, d = screw_d);
        }
    }
}

module thumb_screw() {
    head_height = screw_head_d / 2 * tan(45);

    translate([0, 0, thumb_screw_z]) {
        union() {
            translate([0, 0, thumb_screw_length - head_height]) {
                cylinder(head_height, d1 = 0, d2 = screw_head_d);
            }

            cylinder(thumb_screw_length, d = screw_d);
        }
    }
}

module circuit_board() {
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

                translate([circuit_bridge_width, circuit_bridge_width, -circuit_thickness]) {
                    cube([circuit_board_size.x - circuit_bridge_width * 2,
                          circuit_board_size.y - circuit_bridge_width * 2,
                          circuit_thickness * 3]);
                }
            }

            translate([alphanumeric_position.x, alphanumeric_position.y + rubber_vertical_padding]) {
                cube([alphanumeric_size.x, alphanumeric_size.y - rubber_vertical_padding, circuit_thickness]);
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

        for (p = alphanumeric_screw_positions) {
            translate(p) alphanumeric_screw();
        }

        for (p = thumb_screw_positions) {
            translate(p) thumb_screw();
        }
    }
}

module rubber_alphanumeric() {
    module pro_micro_hole() {
        translate([alphanumeric_position.x, alphanumeric_position.y + alphanumeric_size.y - 19]) {
            cube([34, 19, 10]);
        }
    }

    module reset_button_hole() {
        rotate([tilt_a, 0]) translate([47.61, 74]) cube([11, 7, 10], center = true);
    }

    module trrs_connector_hole() {
        rotate([tilt_a, 0]) translate([95.24, 89]) cube([6.5, 13 * 2, 5.5], center = true);
    }

    module screw_bridge() {
        horizontal_bridge_width = 12;
        vertical_bridge_width = 8;
        hole_margin_radius = 6;

        rotate([tilt_a, 0]) union() {
            for (p = alphanumeric_screw_positions) {
                eastmost = alphanumeric_position.x + alphanumeric_size.x;

                horizontal_bridge = p.x > eastmost - 30;
                vertical_bridge = p.y < alphanumeric_position.y + 30;
                z = alphanumeric_screw_z + screw_nut_thickness
                    + (horizontal_bridge || vertical_bridge ? screw_bridge_thickness : 0);

                if (horizontal_bridge) {
                    translate([p.x,
                               p.y - horizontal_bridge_width / 2,
                               z - 20])
                    {
                        cube([eastmost - p.x + vertical_bridge_width / 2,
                              horizontal_bridge_width,
                              20]);
                    }
                }

                if (vertical_bridge) {
                    translate([p.x - vertical_bridge_width / 2,
                               alphanumeric_position.y,
                               z - 20])
                    {
                        cube([vertical_bridge_width,
                              p.y - alphanumeric_position.y,
                              20]);
                    }
                }

                translate([p.x, p.y, z - 20]) {
                    cylinder(20, r = hole_margin_radius);
                }
            }
        }
    }

    ry = alphanumeric_position.y + rubber_vertical_padding;
    rz = circuit_z + tan(tilt_a) * ry;

    y1 = ry * cos(tilt_a) + rz * sin(tilt_a);
    y2 = (alphanumeric_position.y + alphanumeric_size.y) * cos(tilt_a);

    difference() {
        hull() {
            translate([alphanumeric_position.x + rubber_horizontal_padding, y1]) {
                cube([alphanumeric_size.x - rubber_horizontal_padding * 2,
                      y2 - y1,
                      0.01]);
            }

            rotate([tilt_a, 0]) {
                translate([alphanumeric_position.x + rubber_horizontal_padding,
                           alphanumeric_position.y + rubber_vertical_padding,
                           circuit_z])
                {
                    cube([alphanumeric_size.x - rubber_horizontal_padding * 2,
                          alphanumeric_size.y - rubber_vertical_padding,
                          0.01]);
                }
            }
        }

        pro_micro_hole();
        reset_button_hole();
        trrs_connector_hole();

        for (x = [0 : 5]) {
            for (y = [0 : 3]) {
                rotate([tilt_a, 0]) {
                    translate([key_pitch_h * (x + 0.5), key_pitch_v * (y + 2), circuit_z]) {
                        choc_v1_hole(through_hole = false);
                    }
                }
            }
        }

        diode_hole(alphanumeric_diode_positions);
        screw_bridge();

        for (p = alphanumeric_screw_positions) {
            rotate([tilt_a, 0]) translate(p) alphanumeric_screw();
        }
    }
}

module rubber_thumb() {
    ry = thumb_position.y + rubber_vertical_padding;
    rz = circuit_z + tan(tilt_a) * ry;

    y1 = ry * cos(tilt_a) + rz * sin(tilt_a);
    y2 = (thumb_position.y + thumb_size.y) * cos(tilt_a);

    difference() {
        hull() {
            translate([thumb_position.x + rubber_horizontal_padding, y1]) {
                cube([thumb_size.x - rubber_horizontal_padding * 2,
                      y2 - y1,
                      0.01]);
            }

            rotate([tilt_a, 0]) {
                translate([thumb_position.x + rubber_horizontal_padding,
                           thumb_position.y + rubber_vertical_padding,
                           circuit_z])
                {
                    cube([thumb_size.x - rubber_horizontal_padding * 2,
                          thumb_size.y - rubber_vertical_padding,
                          0.01]);
                }
            }
        }

        for (x = [0 : 3]) {
            translate([key_pitch_h * (x + 3.5), key_pitch_v * 0.5, circuit_z]) {
                choc_v1_hole(through_hole = true);
            }
        }

        diode_hole(thumb_diode_positions);

        for (p = thumb_screw_positions) {
            rotate([tilt_a, 0]) translate(p) {
                thumb_screw();
                translate([0, 0, screw_nut_thickness - 20]) {
                    cylinder(20, r = 4);
                }
            }
        }
    }
}

module case_alphanumeric() {
    choc_v1_hole_size = [15.4, alphanumeric_size.y, 20];

    difference() {
        translate(case_alphanumeric_position) cube(case_alphanumeric_size);

        translate([case_alphanumeric_position.x + case_wall_thickness,
                   case_alphanumeric_position.y + case_wall_thickness,
                   case_alphanumeric_position.z + case_bottom_thickness])
        {
            cube([case_alphanumeric_size.x - case_wall_thickness * 2,
                  case_alphanumeric_size.y - case_wall_thickness * 2,
                  20]);
        }

        for (x = [0 : 5]) {
            translate([alphanumeric_position.x + key_pitch_h * (x + 0.5) - choc_v1_hole_size.x / 2,
                       alphanumeric_position.y])
            {
                cube(choc_v1_hole_size);
            }
        }

        for (p = alphanumeric_screw_positions) {
            translate(p) alphanumeric_screw();
        }
    }
}

module case_thumb() {
    choc_v1_hole_size = [15.4, thumb_size.y, 20];

    difference() {
        translate(case_thumb_position) cube(case_thumb_size);

        translate([case_thumb_position.x + case_wall_thickness,
                   case_thumb_position.y + case_wall_thickness,
                   case_thumb_position.z + case_bottom_thickness])
        {
            cube([case_thumb_size.x - case_wall_thickness * 2,
                  case_thumb_size.y - case_wall_thickness * 2,
                  20]);
        }

        for (x = [0 : 3]) {
            translate([thumb_position.x + key_pitch_h * (x + 0.5) - choc_v1_hole_size.x / 2,
                       thumb_position.y])
            {
                cube(choc_v1_hole_size);
            }
        }

        for (p = thumb_screw_positions) {
            translate(p) thumb_screw();
        }
    }
}

module case_margin_bottom() {
    module circuit_board_hole() {
        a = 10;

        rotate([tilt_a, 0]) translate([0, 0, circuit_z]) union() {
            difference() {
                translate([-a, -a]) {
                    cube([circuit_board_size.x + a * 2, circuit_board_size.y + a * 2, 10]);
                }

                translate([circuit_bridge_width, circuit_bridge_width, -5]) {
                    cube([circuit_board_size.x - circuit_bridge_width * 2,
                          circuit_board_size.y - circuit_bridge_width * 2,
                          20]);
                }
            }

            translate([alphanumeric_position.x, alphanumeric_position.y + rubber_vertical_padding]) {
                cube([alphanumeric_size.x, alphanumeric_size.y - rubber_vertical_padding, 10]);
            }

            translate(thumb_position) cube([thumb_size.x, thumb_size.y, 10]);
        }
    }

    module alphanumeric_rubber_hole() {
        a = 10;

        ry = alphanumeric_position.y + rubber_vertical_padding;
        rz = circuit_z + tan(tilt_a) * ry;

        y1 = ry * cos(tilt_a) + rz * sin(tilt_a);

        hull() {
            translate([alphanumeric_position.x - a, y1]) {
                cube([alphanumeric_size.x - rubber_horizontal_padding + a,
                      100,
                      0.01]);
            }

            rotate([tilt_a, 0]) {
                translate([alphanumeric_position.x - a,
                           alphanumeric_position.y + rubber_vertical_padding,
                           circuit_z])
                {
                    cube([alphanumeric_size.x - rubber_horizontal_padding + a,
                          100,
                          10]);
                }
            }
        }
    }

    module thumb_rubber_hole() {
        ry = thumb_position.y + rubber_vertical_padding;
        rz = circuit_z + tan(tilt_a) * ry;

        y1 = ry * cos(tilt_a) + rz * sin(tilt_a);
        y2 = (thumb_position.y + thumb_size.y) * cos(tilt_a);

        hull() {
            translate([thumb_position.x + rubber_horizontal_padding, y1]) {
                cube([thumb_size.x - rubber_horizontal_padding * 2,
                      y2 - y1,
                      0.01]);
            }

            rotate([tilt_a, 0]) {
                translate([thumb_position.x + rubber_horizontal_padding,
                           thumb_position.y + rubber_vertical_padding,
                           circuit_z])
                {
                    cube([thumb_size.x - rubber_horizontal_padding * 2,
                          thumb_size.y - rubber_vertical_padding,
                          10]);
                }
            }
        }
    }

    module screw_bridge() {
        horizontal_bridge_width = 8;
        vertical_bridge_width = 5;
        hole_margin_radius = 4;

        difference() {
            intersection() {
                rotate([tilt_a, 0]) union() {
                    for (p = alphanumeric_screw_positions) {
                        eastmost = alphanumeric_position.x + alphanumeric_size.x;

                        horizontal_bridge = p.x > eastmost - 30;
                        vertical_bridge = p.y < alphanumeric_position.y + 30;
                        z = alphanumeric_screw_z + screw_nut_thickness;

                        if (horizontal_bridge) {
                            translate([p.x,
                                       p.y - horizontal_bridge_width / 2,
                                       z])
                            {
                                cube([eastmost - p.x + vertical_bridge_width / 2,
                                      horizontal_bridge_width,
                                      screw_bridge_thickness]);
                            }
                        }

                        if (vertical_bridge) {
                            translate([p.x - vertical_bridge_width / 2,
                                       alphanumeric_position.y,
                                       z])
                            {
                                cube([vertical_bridge_width,
                                      p.y - alphanumeric_position.y,
                                      screw_bridge_thickness]);
                            }
                        }

                        if (horizontal_bridge || vertical_bridge) {
                            translate([p.x, p.y, z]) {
                                cylinder(screw_bridge_thickness,
                                    r = hole_margin_radius);
                            }
                        }
                    }
                }

                translate([0, 0, 0.75]) cube([circuit_board_size.x, size_y, 20]);
            }

            for (p = alphanumeric_screw_positions) {
                rotate([tilt_a, 0]) translate(p) cylinder(20, d = screw_d, center = true);
            }
        }
    }

    ry = circuit_board_size.y;
    rz = circuit_z + tan(tilt_a) * ry - 1;

    size_y = ry * cos(tilt_a) + rz * sin(tilt_a);

    difference() {
        union() {
            difference() {
                hull() {
                    translate([0, 0, 0.75]) cube([circuit_board_size.x, size_y, 0.01]);

                    rotate([tilt_a, 0]) {
                        translate([0, 0, circuit_z]) {
                            cube([circuit_board_size.x, circuit_board_size.y, circuit_thickness]);
                        }
                    }
                }

                circuit_board_hole();
                alphanumeric_rubber_hole();
                thumb_rubber_hole();
            }

            screw_bridge();
        }

        for (x = [0 : 5]) {
            for (y = [0 : 3]) {
                rotate([tilt_a, 0]) {
                    translate([key_pitch_h * (x + 0.5), key_pitch_v * (y + 2), circuit_z]) {
                        choc_v1_hole(through_hole = false);
                    }
                }
            }
        }

        for (x = [0 : 3]) {
            translate([key_pitch_h * (x + 3.5), key_pitch_v * 0.5, circuit_z]) {
                choc_v1_hole(through_hole = true);
            }
        }

        diode_hole(alphanumeric_diode_positions);

        rotate([tilt_a, 0]) {
            for (p = thumb_diode_positions) {
                translate([p.x, p.y - 0.5, circuit_z]) cube([2.7, 8, 10], center = true);
            }
        }
    }
}

module case_margin_top() {
    difference() {
        translate([0, 0, circuit_z + circuit_thickness]) {
            cube([
                circuit_board_size.x,
                circuit_board_size.y,
                choc_v1_body_bottom_size.z + choc_v1_body_top_size.z - case_wall_thickness
            ]);
        }

        translate(case_alphanumeric_position) cube([case_alphanumeric_size.x, case_alphanumeric_size.y, 20]);
        translate(case_thumb_position) cube([case_thumb_size.x, case_thumb_size.y, 20]);

        for (x = [0 : 5]) {
            translate([alphanumeric_position.x + key_pitch_h * (x + 0.5) - 14.2 / 2,
                       alphanumeric_position.y])
            {
                cube([14.2, 100, 20]);
            }
        }

        for (p = [each alphanumeric_screw_positions, each thumb_screw_positions]) {
            translate(p) cylinder(20, d = 2.2);
        }
    }
}

module keycap(north_wall = false,
              east_wall  = false,
              south_wall = false,
              west_wall  = false)
{
    outer_north = -(key_pitch_v - keycap_margin) / 2 + (north_wall ? keycap_vertical_wall_d   : 0);
    outer_east  =  (key_pitch_h - keycap_margin) / 2 + (east_wall  ? keycap_horizontal_wall_d : 0);
    outer_south =  (key_pitch_v - keycap_margin) / 2 + (south_wall ? keycap_vertical_wall_d   : 0);
    outer_west  = -(key_pitch_h - keycap_margin) / 2 + (west_wall  ? keycap_horizontal_wall_d : 0);

    inner_north = outer_north + (north_wall ? keycap_thickness : 0);
    inner_east  = outer_east  - (east_wall  ? keycap_thickness : 0);
    inner_south = outer_south - (south_wall ? keycap_thickness : 0);
    inner_west  = outer_west  + (west_wall  ? keycap_thickness : 0);

    difference() {
        translate([outer_west, outer_north]) {
            cube([outer_east - outer_west, outer_south - outer_north, choc_v1_travel]);
        }

        translate([inner_west, inner_north, keycap_thickness]) {
            cube([inner_east - inner_west, inner_south - inner_north, choc_v1_travel]);
        }
    }
}

rotate([tilt_a, 0, 0]) translate([0, 0, circuit_z]) circuit_board($fa = 8);

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

rubber_alphanumeric();
rubber_thumb();

rotate([tilt_a, 0]) case_alphanumeric();
rotate([tilt_a, 0]) case_thumb();

color("#ffffff33") case_margin_bottom();
color("#ffffff33") rotate([tilt_a, 0]) case_margin_top();

for (p = alphanumeric_screw_positions) {
    color("#333333") rotate([tilt_a, 0]) translate(p) alphanumeric_screw();
}

for (p = thumb_screw_positions) {
    color("#333333") rotate([tilt_a, 0]) translate(p) thumb_screw();
}

rotate([tilt_a, 0]) {
    for (x = [0 : 5]) {
        for (y = [0 : 3]) {
            z = (x == 0 && y == 0)
                ? circuit_z + circuit_thickness + choc_v1_body_bottom_size.z + choc_v1_body_top_size.z + keycap_thickness
                : circuit_z + circuit_thickness + choc_v1_body_bottom_size.z + choc_v1_body_top_size.z + keycap_thickness + choc_v1_travel;

            translate([key_pitch_h * (x + 0.5),
                       key_pitch_v * (y + 2),
                       z])
            {
               rotate([180, 0]) {
                   keycap(north_wall = false,  east_wall = x == 5,
                          south_wall = y == 0, west_wall = x == 0);
               }
            }
        }
    }

    for (x = [0 : 3]) {
        translate([key_pitch_h * (x + 3.5),
                   key_pitch_v * 0.5,
                   circuit_z + circuit_thickness + choc_v1_body_bottom_size.z + choc_v1_body_top_size.z + choc_v1_travel])
        {
            rotate([180, 0]) {
                keycap(north_wall = false, east_wall = x == 3,
                       south_wall = true,  west_wall = x == 0);
            }
        }
    }
}
