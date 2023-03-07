$fn=128;

// Sensor dimensions
swidth = 15 + 1;
sheight = 25 + 1;

// Pi dimensions
pwidth = 21 + 2;
pheight = 51 + 2;

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
    inswidth = 9;
    byo = (w - inswidth) / 2;
    translate([l - 2, byo, -22])
    cube([2, inswidth, 22]);
}

cover();