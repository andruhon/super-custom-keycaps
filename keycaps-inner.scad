include <svg_dimensions.scad>;

/**
 * This is internal file generating keycaps.
 * Open one of files with configuration instead,
 * keycaps-default-all.scad, for example,
 * or cereate your own.
 */


/**
 * Prepares keycap definition
 */
function keycap(
    line, row, // Row and line how the keycap should appear on the print board
    body = DEFAULT_BODY,
    center_svg="",
    left_svg="",
    right_svg="",
    side_svg="",
    side_relative_y=SIDE_PRINT_RELATIVE_Y,
    side_position_z=SIDE_PRINT_POSITION_Z,
    side_angle=SIDE_PRINT_ANGLE,
    left_relative_y="",
    right_relative_y="",
    home_row=false
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
    ["side_angle", side_angle],
    ["left_relative_y", left_relative_y == "" ? -getRelativeSvgPositionY(left_svg) : left_relative_y],
    ["right_relative_y", right_relative_y == "" ? getRelativeSvgPositionY(right_svg) : right_relative_y],
    ["home_row", home_row]
];

if (TO_RENDER == "all" || TO_RENDER == "body") {
    color(KEYCAP_COLOUR) union() for (i = [0:len(keycaps)-1]) printBody(keycaps[i], i);
}

// Surface center (Base Layer)
if (TO_RENDER == "all" || TO_RENDER == "base" || TO_RENDER == "print") {
    color(SURFACE_CENTER_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printBase(keycaps[i], i);
}
// Surface left (Lower Layer)
if (TO_RENDER == "all" || TO_RENDER == "left" || TO_RENDER == "print") {
    color(SURFACE_LEFT_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printLower(keycaps[i], i);
}
// Surface right (Raise / Upper Layer)
if (TO_RENDER == "all" || TO_RENDER == "right" || TO_RENDER == "print") {
    color(SURFACE_RIGHT_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printRaise(keycaps[i], i);
}
// Surface center (Adjust Layer)
if (TO_RENDER == "all" || TO_RENDER == "side" || TO_RENDER == "print") {
    color(SIDE_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printAdjust(keycaps[i], i);
}

module printBody(definition, index) {    
    row = getRow(definition, index);
    line = getLine(definition, index);
    body = get(definition, "body");
    center_svg = get(definition, "center_svg");
    left_svg = get(definition, "left_svg");
    right_svg = get(definition, "right_svg");
    side_svg = get(definition, "side_svg");
    side_relative_y = get(definition, "side_relative_y");
    side_position_z = get(definition, "side_position_z");
    left_relative_y = get(definition, "left_relative_y");
    right_relative_y = get(definition, "right_relative_y");
    side_angle = get(definition, "side_angle");
    home_row = get(definition, "home_row");
    if (shouldPrint(row)) {
        difference() {
            translate([row * (KEYCAP_WIDTH + SPACING), -line * (KEYCAP_WIDTH + SPACING), KEYCAP_HEIGHT/2]) {
                // There's some issue with 2025.03.16 imported files are floating a few mm above XY plane
                union() {
                    import(body, center=true, convexity=KEYCAP_CONVEXITY);
                    if (home_row) {
                        translate([0, HOME_ROW_PIMPLE_RELATIVE_Y, HOME_ROW_PIMPLE_RELATIVE_Z]) difference() {
                            sphere(d = HOME_ROW_PIMPLE_DIAMETER, $fn=15);
                            translate([0, 0, -HOME_ROW_PIMPLE_DIAMETER/2]) cube([HOME_ROW_PIMPLE_DIAMETER,HOME_ROW_PIMPLE_DIAMETER,HOME_ROW_PIMPLE_DIAMETER], center=true);
                        }
                    }
                }
            }            
            printSvg(
                row, line,
                svg = center_svg,
                relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
                position_z = SURFACE_CENTER_PRINT_POSITION_Z,
                angle = SURFACE_PRINT_ANGLE,
                depth = SURFACE_DIFF_DEPTH
            );
            printSvg(
                row, line,
                svg = left_svg,
                relative_x = -getRelativeSvgPositionX(left_svg),
                relative_y = left_relative_y,            
                position_z = SURFACE_LEFT_PRINT_POSITION_Z,
                angle = SURFACE_PRINT_ANGLE,
                depth = SURFACE_DIFF_DEPTH
            );
            printSvg(
                row, line,
                svg = right_svg,
                relative_x = getRelativeSvgPositionX(right_svg),
                relative_y = right_relative_y,            
                position_z = SURFACE_RIGHT_PRINT_POSITION_Z,
                angle = SURFACE_PRINT_ANGLE,
                depth = SURFACE_DIFF_DEPTH
            );
            printSvg(
                row, line,
                svg = side_svg,
                relative_y = side_relative_y,
                position_z = side_position_z,
                angle = side_angle,
                depth = LAYER_LINE_WIDTH*2
            );
        }
    }
}

module printBase(definition, index) {
    if (!MIXED_COLOUR_CENTER && shouldPrint(get(definition, "row"))) {
        printSvg(
            getRow(definition, index), getLine(definition, index),
            svg = get(definition, "center_svg"),
            relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
            position_z = SURFACE_CENTER_PRINT_POSITION_Z,
            angle = SURFACE_PRINT_ANGLE
        );
    }
}

module printLower(definition, index) {
    if (shouldPrint(get(definition, "row"))) {
        union() {
            printSvg(
                getRow(definition, index), getLine(definition, index),
                svg = get(definition, "left_svg"),
                relative_x = -getRelativeSvgPositionX(get(definition, "left_svg")),
                relative_y = get(definition, "left_relative_y"),       
                position_z = SURFACE_LEFT_PRINT_POSITION_Z,
                angle = SURFACE_PRINT_ANGLE
            );
            if (MIXED_COLOUR_CENTER) {
                printSvg(
                    getRow(definition, index), getLine(definition, index),
                    svg = get(definition, "center_svg"),
                    relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
                    position_z = SURFACE_CENTER_PRINT_POSITION_Z + LAYER_HEIGHT,
                    angle = SURFACE_PRINT_ANGLE,
                    depth = LAYER_HEIGHT
                );
            }
        }
    }
}

module printRaise(definition, index) {
    if (shouldPrint(get(definition, "row"))) {
        union() {
            printSvg(
                getRow(definition, index), getLine(definition, index),
                svg = get(definition, "right_svg"),
                relative_x = getRelativeSvgPositionX(get(definition, "right_svg")),
                relative_y = get(definition, "right_relative_y"),       
                position_z = SURFACE_LEFT_PRINT_POSITION_Z,
                angle = SURFACE_PRINT_ANGLE
            );
            if (MIXED_COLOUR_CENTER) {
                printSvg(
                    getRow(definition, index), getLine(definition, index),
                    svg = get(definition, "center_svg"),
                    relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
                    position_z = SURFACE_CENTER_PRINT_POSITION_Z,
                    angle = SURFACE_PRINT_ANGLE,
                    depth = LAYER_HEIGHT
                );
            }
        }
    }
}

module printAdjust(definition, index) {
    if (SIDE_FILL && shouldPrint(get(definition, "row"))) {
    printSvg(
        getRow(definition, index), getLine(definition, index),
        get(definition, "side_svg"),
        relative_y = get(definition, "side_relative_y"),
        position_z = get(definition, "side_position_z"),
        angle = get(definition, "side_angle"),
        depth = LAYER_LINE_WIDTH*2
    );
    }
}

module printSvg(
    row, line,
    svg,
    relative_x = 0,
    relative_y,
    position_z,
    angle = 0,
    depth = PRINT_DEPTH
) {
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

/**
 * Finds a value from pseudo-map (a collection of tuples)
 */
function get(map, key) = map[search([key], map)[0]][1];

function getRow(definition, index) = AUTO_LAYOUT ? index %AUTO_LAYOUT_KEYS_PER_ROW : get(definition, "row");
function getLine(definition, index) = AUTO_LAYOUT ? floor(index/AUTO_LAYOUT_KEYS_PER_ROW) : get(definition, "line");

/**
 * Decides either to print this row or not
 */
function shouldPrint(row) = (is_undef(SIDE) || (SIDE=="left" && row<SIDE_BUTTON_ROWS_COUNT) || (SIDE=="right" && row>=SIDE_BUTTON_ROWS_COUNT));

function getRelativeSvgPositionX(name) = name != "" ? KEYCAP_SURFACE_WIDTH/2 - get(svg_dimensions, name)[0]/2 : 0;
function getRelativeSvgPositionY(name) = name != "" ? KEYCAP_SURFACE_LENGTH/2 - get(svg_dimensions, name)[1]/2 : 0;