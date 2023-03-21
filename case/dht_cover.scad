$fn=128;

// Sensor dimensions
swidth = 12 * 0.9;
sheight = 15.5 * 0.9;

// Pi dimensions
pwidth = 21 + 2;
pheight = 51 + 2;

module cover(l=100, w=30, h=2) {
    difference() {
        cube([l, w, h]);
        
        // Sensor Hole
        syo = (w-swidth)/2;
        sxo = 2;
        translate([sxo, syo, 0])
        cube([sheight, swidth, h]);
        
        // Screw Holes
        translate([l/3, 0, 0]) {
            translate([0, 5, 0])
            cylinder(h=h, d=3);
            
            
            translate([0, w-5, 0])
            cylinder(h=h, d=3);
        }
    }
    
    // Bottom cover
    hull() {
       inswidth = 9;
       byo = (w - inswidth) / 2;
       translate([l - 2, byo, -22]) {
           translate([-10, 0, 22])
           cube([1, inswidth, 1]);
           cube([2, inswidth, 22]);
       }
    }
}

cover();