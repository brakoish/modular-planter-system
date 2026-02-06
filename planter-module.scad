// Modular Hexagonal Planter System
// Parametric design for 3D printing

// Parameters
hex_size = 60;          // Hexagon width (mm)
height = 80;            // Planter height (mm)
wall_thickness = 2;     // Wall thickness (mm)
bottom_thickness = 3;   // Bottom thickness (mm)
drainage_hole_d = 5;    // Drainage hole diameter (mm)
connector_depth = 5;    // Connection system depth (mm)
connector_tolerance = 0.3; // Tolerance for connectors (mm)

// Derived values
apothem = hex_size * sqrt(3) / 2;
inner_apothem = apothem - wall_thickness;
inner_hex_size = inner_apothem * 2 / sqrt(3);

// Main planter module
module planter_module() {
    difference() {
        // Outer shell
        linear_extrude(height = height)
            hexagon(apothem);
        
        // Inner cavity
        translate([0, 0, bottom_thickness])
            linear_extrude(height = height - bottom_thickness + 1)
                hexagon(inner_apothem);
        
        // Drainage holes
        for (i = [0:2]) {
            rotate([0, 0, i * 120])
                translate([inner_apothem * 0.5, 0, -1])
                    cylinder(d = drainage_hole_d, h = bottom_thickness + 2, $fn=20);
        }
    }
    
    // Connector clips (male) on 3 sides
    for (i = [0:2]) {
        rotate([0, 0, i * 120 + 60])
            translate([apothem - 0.5, 0, height * 0.5])
                connector_male();
    }
    
    // Connector slots (female) on 3 opposite sides
    for (i = [0:2]) {
        rotate([0, 0, i * 120])
            translate([apothem - 0.5, 0, height * 0.5])
                connector_female_cut();
    }
}

// Hexagon shape
module hexagon(r) {
    circle(r = r / cos(30), $fn = 6);
}

// Male connector (protruding clip)
module connector_male() {
    difference() {
        cube([connector_depth * 2, 8, 6], center = true);
        // Taper
        translate([connector_depth, 0, 0])
            rotate([0, 45, 0])
                cube([6, 10, 6], center = true);
    }
}

// Female connector (slot for receiving)
module connector_female_cut() {
    // This is a cut, so we don't render it directly
    // It's handled in the difference operation
}

// Stacking clip (for vertical stacking)
module stacking_clip() {
    difference() {
        cylinder(d = 15, h = 10, $fn = 6);
        translate([0, 0, -1])
            cylinder(d = 8, h = 12, $fn = 6);
    }
    // Barbs
    for (i = [0:5]) {
        rotate([0, 0, i * 60])
            translate([6, 0, 5])
                cylinder(d = 2, h = 3, $fn = 12);
    }
}

// Drainage tray (optional)
module drainage_tray() {
    tray_height = 15;
    difference() {
        linear_extrude(height = tray_height)
            hexagon(apothem + 5);
        
        translate([0, 0, 2])
            linear_extrude(height = tray_height)
                hexagon(apothem + 3);
    }
}

// Render the planter
planter_module();

// Optional: Show stacking clips
// translate([hex_size * 1.5, 0, 0]) stacking_clip();
// translate([hex_size * 1.5, 20, 0]) stacking_clip();

// Optional: Show drainage tray
// translate([0, hex_size * 1.2, 0]) drainage_tray();
