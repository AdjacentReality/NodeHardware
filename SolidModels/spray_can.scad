function mm(i) = i*25.4;

extra_w = 1.0;
board = mm(1.5)+extra_w;
wall = 2.5;
can_r = (board/2)*sqrt(2)+wall;
can_h = 60;
lip = 3;
jst_t = 5.4;
pcb_t = 1.65;
shelf_h = jst_t+pcb_t+wall;
screw_r = 1.5;
screw_head = 2.6;
pushbutton_h = 4.0;
pushbutton_w = 6.2+extra_w;
push_r = 3.5/2+0.3;
button_hole_r = 10.0+extra_w;
off_the_top = 8.0;
top_button_b = can_r-wall-pushbutton_h-wall-off_the_top;
button_h = 17;
led_r = 6.0/2+0.5;

roundness = 32;

module lip(r, h, t) {
    union () {
        cylinder(r1=r, r2=r+t, h=h/4, $fn=roundness);
        translate([0, 0, h/4]) cylinder(r=r+t, h=h/2, $fn=roundness);
        translate([0, 0, 3*h/4]) cylinder(r1=r+t, r2=r, h=h/4, $fn=roundness);
    }
}

module shelf() {
    difference() {
        // tracker shelf
        cylinder(r=can_r-1.0, h=shelf_h);
        // hole for the tracker
        translate([-board/2, -board/2, wall+jst_t]) cube([board, board, shelf_h]);
        translate([-board/2+5.0, -board/2, wall]) cube([board-5.0, board, shelf_h]);
        // hole to keep it hollow
        translate([-8, -50, 0]) cube([16, 100, shelf_h]);
        // screw holes
        translate([-board/2-wall-screw_r, 0, 0]) cylinder(r=screw_r, h=shelf_h, $fn=roundness);
        translate([board/2+wall+screw_r, 0, 0]) cylinder(r=screw_r, h=shelf_h, $fn=roundness);
        translate([-board/2+2.5, board/2-2.5, 0]) cylinder(r=screw_r, h=20, $fn=roundness);
    }
}

module bottom() {
    union() {
        difference() {
            union() {
                cylinder(r=can_r, h=can_h, $fn=roundness);
                lip(can_r, lip, 1.0);
                translate([0, 0, can_h-lip]) lip(can_r, lip*2, 1.0);
            }
            translate([0, 0, wall]) cylinder(r=can_r-wall, h=can_h+10, $fn=roundness);
            // a cutout for the reset button
            translate([-15, 0, can_h]) cube([8, 50, lip]);
        }
        translate([0, 0, can_h-shelf_h]) shelf();
    }
}

module top() {
    difference() {
        union() {
            scale([1.0, 1.0, 0.9]) sphere(r=can_r-wall);
            // top lip
            translate([0, 0, (can_r-wall)*0.95-4.5]) lip(button_hole_r, 4, 1.0);
        }
        // hollow it out
        difference() {
            scale([1.0, 1.0, 0.9]) sphere(r=can_r-wall*2);
            translate([-can_r+wall*2, -can_r+wall*2, 0]) cube([5.0, 50, 50]);
            translate([can_r-wall*2-5.0, -can_r+wall*2, 0]) cube([5.0, 50, 50]);
            translate([-can_r, -can_r, top_button_b]) cube([can_r*2, can_r*2, 50]);
        }
        // cutout to ensure the Tracker sits properly
        translate([0, -board/2, 0]) cube([board/2, board, 1.2]);
        translate([-board/2, -board/2, 0]) cube([board, board, 0.25]);
        // screw holes
        translate([-board/2-wall-screw_r, 0, 0]) cylinder(r=screw_r, h=50, $fn=roundness);
        translate([board/2+wall+screw_r, 0, 0]) cylinder(r=screw_r, h=50, $fn=roundness);
        translate([-board/2-wall-screw_r, 0, wall]) cylinder(r=screw_head, h=50, $fn=roundness);
        translate([board/2+wall+screw_r, 0, wall]) cylinder(r=screw_head, h=50, $fn=roundness);
        // cut off the bottom of the sphere
        translate([-can_r, -can_r, -can_r]) cube([can_r*2, can_r*2, can_r]);
        // a cutout for the reset button
        translate([-15, 0, 0]) cube([8, 50, lip]);
        // hollow for the button
        translate([0, 0, top_button_b+wall+pushbutton_h]) cylinder(r=button_hole_r, h=50, $fn=roundness);
        translate([-pushbutton_w/2, -pushbutton_w/2, top_button_b+wall]) cube([pushbutton_w, pushbutton_w, 50]);
        // holes for leads
        translate([-wall/2, -pushbutton_w/2, 0]) cube([wall, pushbutton_w, 50]);
        translate([-pushbutton_w/2, -pushbutton_w/2-wall*2, 0]) cube([pushbutton_w, wall, 50]);
    }
}

module button() {

    difference() {
        cylinder(r1=button_hole_r-0.5, r2=button_hole_r-wall, h=button_h, $fn=roundness);
        // pushbutton hole
        cylinder(r=push_r, h=5.0, $fn=roundness);
        // led hole
        translate([0, -button_hole_r+0.5+wall, button_h-led_r-wall]) rotate([-90, 0, 0]) cylinder(r=led_r, h=50, $fn=roundness);
        // led leads hole
        translate([-wall, -push_r-wall*2.5, 0]) cube([wall*2, wall*2, button_h-led_r-wall]);
        // direction triangle on the top
        translate([0, -1, 0]) scale([0.5, 1.0, 1.0]) rotate([0, 0, 210]) translate([0, 0, button_h+button_hole_r/2+1.0]) sphere(r=button_hole_r, $fn=3);
    }
}

bottom();
translate([0, 0, can_h]) top();
translate([0, 0, can_h+top_button_b+wall+pushbutton_h]) button();
