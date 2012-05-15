function mm(i) = i*25.4;

extra_w = 1.0;
wall = 2.0;
board = mm(1.5)+extra_w;
screw_r = 1.5;
screw_head = 2.6;
sphere_r = (board/2)*sqrt(2)+wall;
jst_t = 5.4;
pcb_t = 1.65;
shelf_h = jst_t+wall;
roundness = 64;

module top() {
    difference() {
        sphere(r=sphere_r, $fn=roundness);
        // hollow it out
        difference() {
            sphere(r=sphere_r-wall, $fn=roundness);
            // screw hole ledge
            translate([-sphere_r+wall, -sphere_r+wall, 0]) cube([5.0, 50, 50]);
            translate([sphere_r-wall-5.0, -sphere_r+wall, 0]) cube([5.0, 50, 50]);
            // flatten off the underside of the top for printability
            translate([-sphere_r, -sphere_r, sphere_r*(2/3)]) cube([sphere_r*2, sphere_r*2, sphere_r]);
        }
        // cut off the bottom
        translate([-sphere_r, -sphere_r, -sphere_r]) cube([sphere_r*2, sphere_r*2, sphere_r]);
        // screw holes
        translate([-sphere_r+wall+screw_r, 0, 0]) cylinder(r=screw_r, h=50, $fn=roundness);
        translate([sphere_r-wall-screw_r, 0, 0]) cylinder(r=screw_r, h=50, $fn=roundness);
        translate([-sphere_r+wall+screw_r, 0, wall]) cylinder(r=screw_head, h=50, $fn=roundness);
        translate([sphere_r-wall-screw_r, 0, wall]) cylinder(r=screw_head, h=50, $fn=roundness);
        // cutout to ensure the Tracker sits properly
        translate([0, -board/2, 0]) cube([board/2, board, 1.2]);
        translate([-board/2, -board/2, 0]) cube([board, board, 0.25]);
        // a cutout for the reset button
        translate([-15, 0, 0]) cube([8, 50, 3]);
    }
}

module bottom() {
    difference() {
        sphere(r=sphere_r, $fn=roundness);
        // hollow it out
        difference() {
            sphere(r=sphere_r-wall, $fn=roundness);
            // screw hole ledge
            translate([-sphere_r+wall, -sphere_r+wall, -sphere_r]) cube([5.0, sphere_r*2, sphere_r*2]);
            translate([sphere_r-wall-5.0, -sphere_r+wall, -sphere_r]) cube([5.0, sphere_r*2, sphere_r*2]);
            // screw hole ledge
            translate([-sphere_r, -sphere_r+wall, -shelf_h]) cube([sphere_r-8, sphere_r*2, sphere_r*2]);
            translate([8, -sphere_r+wall, -shelf_h]) cube([sphere_r-8, sphere_r*2, sphere_r*2]);
            // flatten off the underside of the top for printability
            translate([-sphere_r, -sphere_r, -sphere_r]) cube([sphere_r*2, sphere_r*2, sphere_r/3]);
        }
        // cut off the top
        translate([-sphere_r, -sphere_r, 0]) cube([sphere_r*2, sphere_r*2, sphere_r]);
        // screw holes
        translate([-sphere_r+wall+screw_r, 0, -10]) cylinder(r=screw_r, h=50, $fn=roundness);
        translate([sphere_r-wall-screw_r, 0, -10]) cylinder(r=screw_r, h=50, $fn=roundness);
        // hole for the tracker
        translate([-board/2, -board/2, -shelf_h+wall+jst_t]) cube([board, board, shelf_h]);
        translate([-board/2+5.0, -board/2, -shelf_h+wall]) cube([board-5.0, board, shelf_h]);
        translate([-board/2+2.5, board/2-2.5, -shelf_h]) cylinder(r=screw_r, h=20, $fn=roundness);
    }
}

top();
bottom();

