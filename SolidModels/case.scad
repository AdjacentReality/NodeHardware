function mm(i) = i*25.4;

extra = 0.3;
wall = 1.3;
width = mm(1.5)+extra*2;
length = mm(1.5)+extra;
thickness = 11.5;
jst_t = 5.4;
pcb_t = 1.65;
bt_t = 0.6;
usb_w = 7.8+extra;

module cutout(w) {
    union() {
        intersection() {
            cylinder(r=w/2, h=20, $fn=20);
            translate([-w/2, -w/4, 0]) cube([w, w/2, 20]);
        }
        translate([-w/2, 0, 0]) cube([w, w, 20]);
    }
}       

module body() {
    difference() {
        union() {
            difference() {
                cube([width+wall*2, length+wall*2, thickness+wall*2]);
                translate([wall, wall, wall]) cube([width, length+wall*2, thickness]);
                // button cutouts
                translate([wall+9.7, wall, wall+jst_t]) rotate([0, 0, 180]) cutout(8);
                translate([wall+9.7, wall+length, wall+jst_t]) cutout(8);
            }
            // pcb holder on the button/hole side
            translate([wall, wall, wall]) cube([5.0, length, jst_t]);
            translate([wall, wall, wall+jst_t+pcb_t+extra]) cube([5, 5, thickness-jst_t-pcb_t-extra]);
            translate([wall, wall, wall+jst_t+pcb_t+extra+2]) cube([5, length, thickness-jst_t-pcb_t-extra-2]);
            // pcb holder on the bluetooth side
            translate([wall+width-5.0, wall, wall]) cube([5, 5, jst_t]);
        }
        translate([wall+2.5, wall+length-2.5, wall+thickness-0.2]) cylinder(r=2.6, h=5, $fn=20);
        translate([wall+2.5, wall+length-2.5, wall]) cylinder(r=1.5, h=20, $fn=20);
    }
}

module lid() {
    difference() {
        union () {
            cube([width-extra, wall, thickness-extra*2]);
            // holder around usb hole
            translate([(width-extra)/2-usb_w/2-wall, 0, jst_t+pcb_t-extra+1]) cube([usb_w+wall*2, 5, thickness-extra*2-(jst_t+pcb_t-extra)-1]);
            // screw hole piece
            translate([0, wall, jst_t+pcb_t+extra]) cube([5, 5, thickness-jst_t-pcb_t-2-extra*2]);
        }
        // usb hole
        translate([(width-extra)/2-usb_w/2, 0, jst_t+pcb_t-extra]) cube([usb_w, 10, 10]);
        // button cutout
        translate([9.7, 0, wall+jst_t]) cutout(8);
        // screw hole
        translate([2.5, wall+2.5, 0]) cylinder(r=1.5, h=20, $fn=20);
    }
}
    

rotate([90, 0, 0]) body();
translate([wall, wall, 0]) mirror([0, 1, 0]) rotate([90, 0, 0]) lid();

