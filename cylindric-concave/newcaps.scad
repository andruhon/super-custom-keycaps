// The total space each button takes on the grid including button width and spacing
offset_step = 19;

// How much we should move text up to get it placed on the surface of the button
button_height_offset=8.08;

// Render options: all, body, center, left, right, side
render="side";

// Build only one button, set to -1, -1 to build all, set row and line to build only one
only = [-1, -1];

// There are currently three styles sharp, presoft and postsoft
// You can tinker with styles in newcap.scad or use your own stl files


// The way I produced SVGs in Inkscape:
// Create new document
// Type text with with Font Size 12 (face I used is free Harmony OS font)
// Select text and convert it to path (shift + ctrl + c)
// Go to document properties and click "Resize content to size"
// Dimensions in ducument properties are somewhat close to what will end up in print.
// Sometimes OpenSCAD does not like the SVG in this case do "Simplify" in Incscape

// import(str("button-", "sharp", ".stl"));
union() {
    ref_cube(); // Ref cube to avoid parts "falling down" in BambuLab
    add_button(1, 0, "presoft", svg_top_center="svg/z.svg", svg_side="svg/shift.svg");
    add_button(2, 0, "presoft", svg_top_center="svg/x.svg", svg_side="svg/ctrl.svg", svg_top_left="svg/f1.svg", svg_top_right="svg/bsls.svg");
};



module add_button(
    row, line,
    type,
    home_row=false,
    svg_top_center="",
    svg_top_left="",
    svg_top_right="",
    // Svg covers entire side
    svg_side=""
) {
    if (only == [-1, -1] || only == [row, line]) {
        translate([row * offset_step, -line * offset_step, 0]) {        
            if (render == "all" || render == "body") {
                difference() {
                    import(str("bodies/button-", type, ".3mf"), convexity=7);
                    faces_top_center(
                        svg=svg_top_center
                    );
                    faces_top_left(
                        svg=svg_top_left
                    );
                    faces_top_right(
                        svg=svg_top_right
                    );
                    faces_side(
                        svg=svg_side,
                        text_depth=0.4
                    );
                }
            }
            if (render == "all" || render=="center") {
                color("Grey") faces_top_center(
                    svg=svg_top_center,
                    text_depth=0.2
                );
            }
            if (render == "all" || render=="left") {
                color("Blue") faces_top_left(
                    svg=svg_top_left,
                    text_depth=0.2
                );
            }
            if (render == "all" || render=="right") {
                color("Red") faces_top_right(
                    svg=svg_top_right,
                    text_depth=0.2
                );
            }
            if (render == "all" || render=="side") {
                color("Purple") 
                    faces_side(
                        svg=svg_side,
                        text_depth=0.4
                );
            }
            if (home_row) {
                translate([-0.25,-5,button_height_offset]) sphere(1, $fn=50);
                /*hull() {           
                    translate([-0.75,-5,button_height_offset]) sphere(1, $fn=50);
                    translate([+0.75,-5,button_height_offset]) sphere(1, $fn=50);
                }*/
            }
        }
    }
}

module faces_top_center(
    svg,
    text_depth=2
) {
    if (svg != "") {
            translate([0,0,button_height_offset]) linear_extrude(height=text_depth) {
                import(svg, center=true);
            }
    }
}
module faces_top_left(
    svg,
    text_depth=2
) {
    // TODO need to figure out how to position by SVG corner, not by center
    if (svg != "") {
            translate([-3.4,-4.4,button_height_offset]) linear_extrude(height=text_depth) {
                import(svg, center=true);
            }
    }
}
module faces_top_right(
    svg,
    text_depth=2
) {
    if (svg != "") {
            translate([4.5,2.5,button_height_offset]) linear_extrude(height=text_depth) {
                import(svg, center=true);
            }
    }
}
module faces_side(
    // Svg covers entire side
    svg,
    text_depth=2
) {
    if (svg != "") {
        translate([0, 0.1, 0]) {
            rotate([74.7]) translate([0,3.5,8.16]) linear_extrude(height=text_depth) {
                import(svg, center=true);
            };
        }
    }
}

// Ref cube to avoid parts "falling down" in BambuLab
module ref_cube() {
    s = 0.4;
    translate([0, -10, 0]) cube([s,s,s]);
    translate([60, 10, 0]) cube([s,s,s]);
    /*if (render == "all" || render == "body") {
        cube([s,s,s]);
    }
    if (render=="center") {
        translate([0,s,0]) cube([s,s,s]);
    }
    if (render=="left") {
        translate([0,s*2,0]) cube([s,s,s]);
    }
    if (render=="right") {
        translate([0,s*3,0]) cube([s,s,s]);
    }
    if (render=="side") {
        translate([0,s*4,0]) cube([s,s,s]);
    }*/
}