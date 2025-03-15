KEYCAP_WIDTH = 17.5;
KEYCAP_HEIGHT = 9.2;
KEYCAP_SURFACE_LOWEST_POINT = 8.28; // Lowest point on the surface
KEYCAP_SURFACE_WIDTH = 12.5;
KEYCAP_CONVEXITY = 7; // To address preview issues
KEYCAP_COLOUR = "LightGrey"; // This color and others below are for preview only

// SPACING between keycaps
SPACING = 4;
LAYER_HEIGHT = 0.06; // With 0.2 nozzle the layer height is usually 0.06
LAYER_LINE_WIDTH = 0.22;
PRINT_DEPTH = LAYER_HEIGHT * 2; // Best when it is double layer height
SIDE_PRINT_ANGLE = 74.798;
SIDE_PRINT_POSITION_Z = 6;
SIDE_PRINT_POSITION_Y = 6.67;
SIDE_PRINT_COLOUR = "purple";
TOP_PRINT_ANGLE = 0;
TOP_CENTER_PRINT_COLOUR = "black";
TOP_CENTER_PRINT_POSITION_Y = 0;
// Leaving one layer above the colour
// The calculation should be KEYCAP_SURFACE_LOWEST_POINT - PRINT_DEPTH - LAYER_HEIGHT,
// but we want it to be dividable by layer height
TOP_CENTER_PRINT_POSITION_Z = KEYCAP_SURFACE_LOWEST_POINT - PRINT_DEPTH - LAYER_HEIGHT;

// Default keycap body to be rendered if alternative not provided
defaultBody = "bodies/cylindric-concave.3mf";

// Data to render keycaps
keycaps = [
    /*keycap(2, 0, side_svg = "shift"),
    keycap(2, 1, side_svg = "ctrl"),*/
    keycap(2, 2, top_center_svg = "c", side_svg = "alt"),
    keycap(2, 3, top_center_svg = "v", side_svg = "gui"),
    keycap(2, 4, top_center_svg = "b", side_svg = "del"),
    
    keycap(2, 5, top_center_svg = "n", side_svg = "enter"),
    keycap(2, 6, top_center_svg = "m", side_svg = "gui"),
    keycap(2, 7, top_center_svg = "dot", side_svg = "alt"),
    keycap(2, 8, top_center_svg = "comma", side_svg = "ctrl"),
    keycap(2, 9, top_center_svg = "slash", side_svg = "shift"),
];

// Prepares data for keycap
function keycap(
    line, row, // Row and line how the keycap should appear on the print board
    body = defaultBody,
    top_center_svg="",
    top_left_svg="",
    top_right_svg="",
    side_svg="",
    side_position_y=SIDE_PRINT_POSITION_Y,
    side_position_z=SIDE_PRINT_POSITION_Z,
    side_angle=SIDE_PRINT_ANGLE,
) = [    
    ["line", line],
    ["row", row],
    ["body", body],
    ["top_center_svg", top_center_svg],
    ["top_right_svg", top_right_svg],
    ["side_svg", side_svg],
    ["side_position_y", side_position_y],
    ["side_position_z", side_position_z],
    ["side_angle", side_angle]
];

color(KEYCAP_COLOUR) union() for (keycap = keycaps) printBody(
    get(keycap, "row"), get(keycap, "line"),
    body = get(keycap, "body"),
    side_svg = get(keycap, "side_svg"),
    side_position_y = get(keycap, "side_position_y"),
    side_position_z = get(keycap, "side_position_z"),
    side_angle = get(keycap, "side_angle"),
    top_center_svg = get(keycap, "top_center_svg")
);
color(TOP_CENTER_PRINT_COLOUR) union() for (keycap = keycaps) printText(
    get(keycap, "row"), get(keycap, "line"),
    svg = get(keycap, "top_center_svg"),
    position_y = TOP_CENTER_PRINT_POSITION_Y,
    position_z = TOP_CENTER_PRINT_POSITION_Z,
    angle = TOP_PRINT_ANGLE
);
color(SIDE_PRINT_COLOUR) union() for (keycap = keycaps) printText(
    get(keycap, "row"), get(keycap, "line"),
    get(keycap, "side_svg"),
    position_y = get(keycap, "side_position_y"),
    position_z = get(keycap, "side_position_z"),
    angle = get(keycap, "side_angle"),
    depth = LAYER_LINE_WIDTH*2
);




module printBody(
    row, line,
    body,
    side_svg, side_position_y, side_position_z, side_angle,
    top_center_svg
) {
    difference() {
        translate([row * (KEYCAP_WIDTH + SPACING), -line * (KEYCAP_WIDTH + SPACING), 0]) {
            import(body, convexity=KEYCAP_CONVEXITY);
        }
        printText(
            row, line,
            svg = top_center_svg,
            position_y = TOP_CENTER_PRINT_POSITION_Y,
            position_z = TOP_CENTER_PRINT_POSITION_Z,
            angle = TOP_PRINT_ANGLE,
            depth = KEYCAP_HEIGHT - KEYCAP_SURFACE_LOWEST_POINT
        );
        printText(
            row, line,
            svg = side_svg,
            position_y = side_position_y,
            position_z = side_position_z,
            angle = side_angle,
            depth = LAYER_LINE_WIDTH*2
        );
    }
}

module printText(
    row, line,
    svg,
    position_y,
    position_z,
    angle = 0,
    depth = PRINT_DEPTH
) {
    if (svg != "") {
        translate([row * (KEYCAP_WIDTH + SPACING), -line * (KEYCAP_WIDTH + SPACING), 0]) {
            translate([0, -position_y, position_z])
            rotate([angle])
            linear_extrude(height=depth) {                
                import(str("svg/", svg, ".svg"), center=true);
            }
        }
    }
}

// Finds a value from pseudo-map (a collection of tuples)
function get(map, key) = map[search([key], map)[0]][1];