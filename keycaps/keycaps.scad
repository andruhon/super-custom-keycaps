include <svg_dimensions.scad>;

KEYCAP_WIDTH = 17.5;
KEYCAP_HEIGHT = 9.2;
KEYCAP_SURFACE_LOWEST_POINT = 8.28; // Lowest point on the surface
KEYCAP_SURFACE_WIDTH = 10.5;
KEYCAP_SURFACE_LENGTH = 12;
KEYCAP_CONVEXITY = 7; // To address preview issues
KEYCAP_COLOUR = "LightGrey"; // This color and others below are for preview TO_RENDER

// SPACING between keycaps
SPACING = 4;
LAYER_HEIGHT = 0.06; // With 0.2 nozzle the layer height is usually 0.06
LAYER_LINE_WIDTH = 0.22;
PRINT_DEPTH = LAYER_HEIGHT * 2; // Best when it is double layer height


SURFACE_PRINT_ANGLE = 0; // In the case surface is at angle

/**
 * Surface Center Print (for Base layer)
 */
SURFACE_CENTER_PRINT_COLOUR = "black";
SURFACE_CENTER_PRINT_RELATIVE_Y = 0;
// Leaving one layer above the colour
// The calculation should be KEYCAP_SURFACE_LOWEST_POINT - PRINT_DEPTH - LAYER_HEIGHT,
// but we want it to be dividable by layer height
SURFACE_CENTER_PRINT_POSITION_Z = KEYCAP_SURFACE_LOWEST_POINT - PRINT_DEPTH - LAYER_HEIGHT;

/**
 * Surface Upper Right Print (for Upper / Raise layer)
 */
 SURFACE_RIGHT_PRINT_COLOUR = "red";
 SURFACE_RIGHT_PRINT_POSITION_Z = SURFACE_CENTER_PRINT_POSITION_Z;
 
/**
 * Surface Lower Left Print (for Lower layer)
 */
 SURFACE_LEFT_PRINT_COLOUR = "blue";
 SURFACE_LEFT_PRINT_POSITION_Z = SURFACE_CENTER_PRINT_POSITION_Z;

/**
 * Side print (for Adjust Layer)
 */
SIDE_PRINT_ANGLE = 74.798;
SIDE_PRINT_POSITION_Z = 6;
SIDE_PRINT_RELATIVE_Y = -6.67;
SIDE_PRINT_COLOUR = "purple";

/**
 * TO_RENDER print selected part
 * Options are: all, body, print, center, left, right, side
 */
TO_RENDER = "all";

// Default keycap body to be TO_RENDERed if alternative not provided
defaultBody = "bodies/cylindric-concave.3mf";

// Data to TO_RENDER keycaps
keycaps = [
    /*keycap(2, 0, side_svg = "shift"),
    keycap(2, 1, side_svg = "ctrl"),*/
    keycap(2, 2, center_svg = "c", left_svg = "f2", side_svg = "alt"),
    keycap(2, 3, center_svg = "v", left_svg = "f3", right_svg = "test_big", side_svg = "gui"),
    keycap(2, 4, center_svg = "b", left_svg = "f11", right_svg = "test_tiny",  side_svg = "del"),
    
    keycap(2, 5, center_svg = "n", side_svg = "enter"),
    keycap(2, 6, center_svg = "m", side_svg = "gui"),
    keycap(2, 7, center_svg = "dot", side_svg = "alt"),
    keycap(2, 8, center_svg = "comma", side_svg = "ctrl"),
    keycap(2, 9, center_svg = "slash", side_svg = "shift"),
];

// Prepares data for keycap
function keycap(
    line, row, // Row and line how the keycap should appear on the print board
    body = defaultBody,
    center_svg="",
    left_svg="",
    right_svg="",
    side_svg="",
    side_relative_y=SIDE_PRINT_RELATIVE_Y,
    side_position_z=SIDE_PRINT_POSITION_Z,
    side_angle=SIDE_PRINT_ANGLE,    
) = [    
    ["line", line],
    ["row", row],
    ["body", body],
    ["center_svg", center_svg],
    ["left_svg", left_svg],
    ["right_svg", right_svg],
    ["side_svg", side_svg],
    ["side_relative_y", side_relative_y],
    ["side_position_z", side_position_z],
    ["side_angle", side_angle]
];

if (TO_RENDER == "all" || TO_RENDER == "body") {
    color(KEYCAP_COLOUR) union() for (keycap = keycaps) printBody(
        get(keycap, "row"), get(keycap, "line"),
        body = get(keycap, "body"),
        center_svg = get(keycap, "center_svg"),
        left_svg = get(keycap, "left_svg"),
        right_svg = get(keycap, "right_svg"),
        side_svg = get(keycap, "side_svg"),
        side_relative_y = get(keycap, "side_relative_y"),
        side_position_z = get(keycap, "side_position_z"),
        side_angle = get(keycap, "side_angle")    
    );
}

// Surface center (Base Layer)
if (TO_RENDER == "all" || TO_RENDER == "base" || TO_RENDER == "print") {
    color(SURFACE_CENTER_PRINT_COLOUR) union() for (keycap = keycaps) printText(
        get(keycap, "row"), get(keycap, "line"),
        svg = get(keycap, "center_svg"),
        relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
        position_z = SURFACE_CENTER_PRINT_POSITION_Z,
        angle = SURFACE_PRINT_ANGLE
    );
}
// Surface left (Lower Layer)
if (TO_RENDER == "all" || TO_RENDER == "left" || TO_RENDER == "print") {
    color(SURFACE_LEFT_PRINT_COLOUR) union() for (keycap = keycaps) printText(
        get(keycap, "row"), get(keycap, "line"),
        svg = get(keycap, "left_svg"),
        relative_x = -getRelativeSvgPositionX(get(keycap, "left_svg")),
        relative_y = -getRelativeSvgPositionY(get(keycap, "left_svg")),       
        position_z = SURFACE_LEFT_PRINT_POSITION_Z,
        angle = SURFACE_PRINT_ANGLE
    );
}
// Surface right (Raise / Upper Layer)
if (TO_RENDER == "all" || TO_RENDER == "right" || TO_RENDER == "print") {
    color(SURFACE_RIGHT_PRINT_COLOUR) union() for (keycap = keycaps) printText(
        get(keycap, "row"), get(keycap, "line"),
        svg = get(keycap, "right_svg"),
        relative_x = getRelativeSvgPositionX(get(keycap, "right_svg")),
        relative_y = getRelativeSvgPositionY(get(keycap, "right_svg")),       
        position_z = SURFACE_LEFT_PRINT_POSITION_Z,
        angle = SURFACE_PRINT_ANGLE
    );
}
// Surface center (Adjust Layer)
if (TO_RENDER == "all" || TO_RENDER == "side" || TO_RENDER == "print") {
    color(SIDE_PRINT_COLOUR) union() for (keycap = keycaps) printText(
        get(keycap, "row"), get(keycap, "line"),
        get(keycap, "side_svg"),
        relative_y = get(keycap, "side_relative_y"),
        position_z = get(keycap, "side_position_z"),
        angle = get(keycap, "side_angle"),
        depth = LAYER_LINE_WIDTH*2
    );
}

module printBody(
    row, line,
    body,
    center_svg,
    left_svg,
    right_svg,
    side_svg, side_relative_y, side_position_z, side_angle    
) {
    difference() {
        translate([row * (KEYCAP_WIDTH + SPACING), -line * (KEYCAP_WIDTH + SPACING), 0]) {
            import(body, convexity=KEYCAP_CONVEXITY);
        }
        printText(
            row, line,
            svg = center_svg,
            relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
            position_z = SURFACE_CENTER_PRINT_POSITION_Z,
            angle = SURFACE_PRINT_ANGLE,
            depth = KEYCAP_HEIGHT - KEYCAP_SURFACE_LOWEST_POINT
        );
        printText(
            row, line,
            svg = left_svg,
            relative_x = -getRelativeSvgPositionX(left_svg),
            relative_y = -getRelativeSvgPositionY(left_svg),            
            position_z = SURFACE_LEFT_PRINT_POSITION_Z,
            angle = SURFACE_PRINT_ANGLE,
            depth = KEYCAP_HEIGHT - KEYCAP_SURFACE_LOWEST_POINT
        );
        printText(
            row, line,
            svg = right_svg,
            relative_x = getRelativeSvgPositionX(right_svg),
            relative_y = getRelativeSvgPositionY(right_svg),            
            position_z = SURFACE_RIGHT_PRINT_POSITION_Z,
            angle = SURFACE_PRINT_ANGLE,
            depth = KEYCAP_HEIGHT - KEYCAP_SURFACE_LOWEST_POINT
        );
        printText(
            row, line,
            svg = side_svg,
            relative_y = side_relative_y,
            position_z = side_position_z,
            angle = side_angle,
            depth = LAYER_LINE_WIDTH*2
        );
    }
}

module printText(
    row, line,
    svg,
    relative_x = 0,
    relative_y,
    position_z,
    angle = 0,
    depth = PRINT_DEPTH
) {
    echo(svg);
    if (svg != "") {
        translate([row * (KEYCAP_WIDTH + SPACING), -line * (KEYCAP_WIDTH + SPACING), 0]) {
            translate([relative_x, relative_y, position_z])
            rotate([angle])
            linear_extrude(height=depth) {                
                import(str("svg/", svg, ".svg"), center=true);
            }
        }
    }
}

// Finds a value from pseudo-map (a collection of tuples)
function get(map, key) = map[search([key], map)[0]][1];

function getRelativeSvgPositionX(name) = name != "" ? KEYCAP_SURFACE_WIDTH/2 - get(svg_dimensions, name)[0]/2 : 0;
function getRelativeSvgPositionY(name) = name != "" ? KEYCAP_SURFACE_LENGTH/2 - get(svg_dimensions, name)[1]/2 : 0;