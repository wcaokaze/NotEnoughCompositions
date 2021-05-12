use <not_enough_compositions.scad>;

translate([0, 0, -3]) case_margin_top();
translate([133.35, 0, 2]) mirror([1, 0, 0]) case_margin_top();
translate([0, 0, 9.25]) case_margin_bottom(is_left_side = true);
translate([133.35, 89, 21]) rotate([180, 0]) mirror([1, 0, 0]) case_margin_bottom(is_left_side = false);
