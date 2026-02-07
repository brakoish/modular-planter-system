// Modular Hexagonal Planter - CORRECTED VERSION
// Fixes: Attached connectors, proper positioning

hex_size = 60;
height = 80;
wall_thickness = 2;
bottom_thickness = 3;
drainage_hole_d = 5;
connector_size = 4;

// Distance from center to flat face of hexagon
apothem = hex_size * sqrt(3) / 2;
inner_apothem = apothem - wall_thickness;

// CORRECTED planter with proper connectors
module planter_fixed() {
    difference() {
        union() {
            // Main hexagon body
            linear_extrude(height = height)
                hexagon(apothem);
            
            // Male dovetail connectors on 3 faces (properly attached)
            for (i = [0:2]) {
                rotate([0, 0, i * 120])
                    translate([apothem, 0, height * 0.5])
                        rotate([0, 90, 0])
                            dovetail_shape();
            }
        }
        
        // Inner cavity (hollow it out)
        translate([0, 0, bottom_thickness])
            linear_extrude(height = height - bottom_thickness + 1)
                hexagon(inner_apothem);
        
        // Drainage holes
        for (i = [0:2]) {
            rotate([0, 0, i * 120])
                translate([inner_apothem * 0.5, 0, -1])
                    cylinder(d = drainage_hole_d, h = bottom_thickness + 2, $fn=20);
        }
        
        // Female dovetail slots on other 3 faces
        for (i = [0:2]) {
            rotate([0, 0, i * 120 + 60])
                translate([apothem - wall_thickness/2, 0, height * 0.5])
                    rotate([0, 90, 0])
                        scale([1.1, 1.1, 1])  // Tolerance
                            dovetail_shape();
        }
    }
}

// Helper: hexagon with flat faces
module hexagon(r) {
    circle(r = r / cos(30), $fn = 6);
}

// Helper: dovetail connector shape
module dovetail_shape() {
    linear_extrude(height = 3, center = true)
        polygon([
            [-connector_size, -connector_size*0.7],
            [connector_size, -connector_size*0.7],
            [connector_size*0.6, connector_size*0.7],
            [-connector_size*0.6, connector_size*0.7]
        ]);
}

// Render it
planter_fixed();
