use <not_enough_compositions.scad>;

translate([-4, -13]) rubber_alphanumeric(is_left_side = true);
translate([-61, -3]) rubber_thumb(is_left_side = true);
translate([110, 103, 12]) rotate([180, 0]) mirror([1, 0, 0]) rubber_alphanumeric(is_left_side = false);
translate([130, 17, 9]) rotate([180, 0]) mirror([1, 0, 0]) rubber_thumb(is_left_side = false);
