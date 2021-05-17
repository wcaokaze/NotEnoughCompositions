use <not_enough_compositions.scad>;

module b(x, y, n = false, e = false, s = false, w = false) {
    translate([20 * (x + 0.5), 17 * (y + 0.5)]) {
        keycap(north_wall = n, east_wall = e, south_wall = s, west_wall = w);
    }
}

module t(x, y, n = false, e = false, s = false, w = false) {
    translate([20 * (x + 0.5), 17 * (y + 0.75), 7]) {
        rotate([180, 0]) keycap(north_wall = n, east_wall = e, south_wall = s, west_wall = w);
    }
}

for (i = [0 : 1]) {
    translate([0, 0, i * 8]) {
        b(0, 0, w = true);
        b(1, 0);
        b(2, 0);
        b(3, 0, e = true);
        b(0, 1, w = true);
        b(1, 1);
        b(2, 1);
        b(3, 1, e = true);
        b(0, 2, w = true);
        b(1, 2);
        b(2, 2);
        b(3, 2, e = true);
        b(0, 3, s = true, w = true);
        b(1, 3, s = true);
        b(2, 3, s = true);
        b(3, 3, s = true, e = true);
        t(0, 0, s = true, w = true);
        t(1, 0, s = true);
        t(2, 0, s = true);
        t(3, 0, s = true, e = true);
        t(0, 1);
        t(1, 1);
        t(2, 1);
        t(3, 1);
        t(0, 2);
        t(1, 2, n = true);
        t(2, 2, n = true);
        t(3, 2);
    }
}
