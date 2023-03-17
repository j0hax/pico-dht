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
            translate([w/2 - 1, -w/2, 0])
            cube([1, w, h]);
        }
        
        // Inner cylinder and slit
        cylinder(h=h, d=d);
        
        rotate([0, 0, 67.5])
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
        translate([sxo + sheight, mid, 2])
        cube([l, 10, h]);
        
        // Screw holes
        translate([l/3, 0, 0]) {
            translate([0, 5, 0])
            cylinder(h=h, d=3);
            
            
            translate([0, w-5, 0])
            cylinder(h=h, d=3);
        }
        
        // Pi section
        translate([pxo, pyo, 2])
        cube([pheight, pwidth, h]);
        
        // IKM Logo in the Pi Part
        translate([pheight, w, h/4])
        rotate([90, 0, 0])
        linear_extrude(w)
        import("ikm-logo.svg");
    }
    
    // Pin
    translate([sxo + (5.1 / 1.5), syo + swidth/2, szo])
    cylinder(d=2.9, h=(h-szo)/2);
}

translate([-15, 15, 0])
hook();
sensorbody();