$fn=128;

// Sensor dimensions
swidth = 15 + 1;
sheight = 25 + 1;

// Pi dimensions
pwidth = 21 + 2;
pheight = 51 + 2;

module hook(d=15, w=30, h=32) {
    difference() {
        hull() {
            //translate([0, 0, 10])
            cylinder(h=h/2, d=w);
            translate([w - 1, -w/2, 0])
            cube([1, w, h]);
        }
        
        // Inner cylinder and slit
        cylinder(h=h, d=d);
        
        rotate([0, 0, 45])
        translate([0, -2.55, 0])
        cube([w, d/2, 30]);
    }
}

module sensorbody(l=100, w=30, h=30) {
    // Sensor offsets
    sxo = 2;
    syo = (w-swidth)/2;
    szo = h - 8;
    
    pxo = (l-pheight) - 2;
    pyo = (w-pwidth)/2;

    
    difference() {
        // Body
        cube([l, w, h]);
        
        // Sensor section
        translate([sxo, syo, szo])
        cube([sheight, swidth, h]);
        
        // Cable channel
        mid = (w - 10) / 2;
        translate([sxo + sheight, mid, 1])
        cube([l, 10, h]);
        
        // Screw holes
        translate([l/3, 0, 0]) {
            translate([0, 5, 0])
            cylinder(h=h, d=3);
            
            
            translate([0, w-5, 0])
            cylinder(h=h, d=3);
        }
        
        // Pi section
        translate([pxo, pyo, 1])
        cube([pheight, pwidth, h]);
    }
    
    // Pin
    translate([sxo + (5.1 / 1.5), syo + swidth/2, szo])
    cylinder(d=2.9, h=(h-szo)/2);
    
    // Pi Pins
    /*
    translate([pxo + 2 + 1, pyo + 4.8 + 1, 0])
    cylinder(d=2, h= 10);
    translate([pxo + 2 + 1, pyo + 11.4 + 4.8 + 1, 0])
    cylinder(d=2, h= 10);
    
    translate([pxo + pheight - 1.6 - 1, pyo + 4.8 + 1, 0])
    cylinder(d=2, h= 10);
    translate([pxo + pheight - 1.6 - 1, pyo + 11.4 + 4.8 + 1, 0])
    cylinder(d=2, h= 10);
    */
}

module cover(l=100, w=30, h=2) {
    difference() {
        cube([l, w, h]);
        
        // Sensor Hole
        syo = (w-swidth)/2;
        sxo = 2 + 5;
        translate([sxo, syo, 0])
        cube([sheight - 5, swidth, h]);
        
        // Screw Holes
        translate([l/3, 0, 0]) {
            translate([0, 5, 0])
            cylinder(h=h, d=3);
            
            
            translate([0, w-5, 0])
            cylinder(h=h, d=3);
        }
        
        // IKM Logo ;)
        linear_extrude(h)
        translate([l * 0.5, w/4, 0])
        import("ikm-logo.svg");

    }
    
    // Bottom cover
    byo = (w - 10) / 2;
    translate([l - 2, byo, -22])
    cube([2, 10, 22]);
}

translate([-30, 15, 0])
hook();
sensorbody();