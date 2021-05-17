use <not_enough_compositions.scad>;

translate([1.2, -22.3, -4.5]) case_alphanumeric();
translate([-36.9, 6, -2]) case_thumb();
translate([153.6, 30, -2]) mirror([1, 0, 0]) case_thumb();
translate([1.2, -22.3, 4.5 + 4.3 * 2 + 1]) rotate([0, 180]) mirror([1, 0, 0]) case_alphanumeric();
