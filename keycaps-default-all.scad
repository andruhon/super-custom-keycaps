include <keycaps-inner.scad>;

/**
 * ----------------------------------------------
 * Config
 * Default setup with all keycaps using 5 colours.
 * Data with keys follows below.
 * ----------------------------------------------
 */
KEYCAP_WIDTH = 17.5;
KEYCAP_HEIGHT = 9.2;
KEYCAP_SURFACE_LOWEST_POINT = 8.28; // Lowest point on the surface
KEYCAP_SURFACE_WIDTH = 10.5;
KEYCAP_SURFACE_LENGTH = 12;
KEYCAP_CONVEXITY = 7; // To address preview issues
KEYCAP_COLOUR = "LightGrey"; // This color and others below are for preview TO_RENDER

/**
 * SPACING between keycaps
 */
SPACING = 4;
LAYER_HEIGHT = 0.1; // With 0.2 nozzle the layer height is usually 0.1
LAYER_LINE_WIDTH = 0.22;
PRINT_DEPTH = LAYER_HEIGHT * 2; // Best when it is double layer height
SURFACE_DIFF_DEPTH = KEYCAP_HEIGHT - KEYCAP_SURFACE_LOWEST_POINT + PRINT_DEPTH;

SURFACE_PRINT_ANGLE = 0; // In the case surface is at angle

/**
 * Surface Center Print (for Base layer)
 */
SURFACE_CENTER_PRINT_COLOUR = "black";
SURFACE_CENTER_PRINT_RELATIVE_Y = 0;

/**
 * Leaving one layer above the colour
 * The calculation should be KEYCAP_SURFACE_LOWEST_POINT - PRINT_DEPTH - LAYER_HEIGHT,
 * but we want it to be dividable by layer height
 */
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
SIDE_FILL = true; // Should the side (longest part of the print be filled?)
SIDE_PRINT_ANGLE = 74.798;
SIDE_PRINT_POSITION_Z = 6;
SIDE_PRINT_RELATIVE_Y = -6.67;
SIDE_PRINT_COLOUR = "purple";

HOME_ROW_PIMPLE_DIAMETER = 3;
HOME_ROW_PIMPLE_RELATIVE_Y = -(KEYCAP_WIDTH/2 - 4);
HOME_ROW_PIMPLE_RELATIVE_Z = KEYCAP_SURFACE_LOWEST_POINT - 5.6;

/**
 * Place one layer of center into right and one layer of center into left,
 * because 0.1mm of filament is nearly tranclucent it makes colours mix,
 * the mixture of red and blue looks nearly black.
 * This allows to have fifth colour with single AMS unit.
 * I think this is only going to be helpful if body is white.
 */
MIXED_COLOUR_CENTER = false;

/**
 *Default keycap body to be rendered if alternative not provided
 */
DEFAULT_BODY = "bodies/cylindric-concave.3mf";

/**
 * To render selected part
 * Options are: all, body, print, center, left, right, side
 */
TO_RENDER = "all";

/**
 * Either place keys in a precise layout you configured them,
 * or just in a number of rows one by one
 */
AUTO_LAYOUT = false;
AUTO_LAYOUT_KEYS_PER_ROW = 5;

/**
 * Number of rows in one side
 */
SIDE_BUTTON_ROWS_COUNT = 5;
VERBOSE_LABELS = false;

KC_Q = keycap(0, 0, center_svg = "KC_Q",    side_svg = "KC_ESC");
KC_Q_VERBOSE = keycap(0, 0, center_svg = "KC_Q", left_svg = "KC_ESC", right_svg = "KC_ESC", side_svg = "KC_ESC");
LOWR = keycap(3, 4, body="bodies/cylindric-concave-thumb.3mf", left_svg = "TL_LOWR", side_svg = "ADJUST", left_relative_y=0);
LOWR_VERBOSE = keycap(3, 4, body="bodies/cylindric-concave-thumb.3mf", left_svg = "TL_LOWR", side_svg = "ADJUST_v", side_position_z=3.3, side_relative_y=-7.4, left_relative_y=0);

KC_P = keycap(0, 9, center_svg = "KC_P",    side_svg = "KC_BSPC_s");
KC_P_VERBOSE = keycap(0, 9, center_svg = "KC_P", left_svg = "KC_BSPC_s", right_svg = "KC_BSPC_s", side_svg = "KC_BSPC_s");

UPPR = keycap(3, 5, body="bodies/cylindric-concave-thumb.3mf", right_svg  = "TL_UPPR", side_svg = "ADJUST", right_relative_y=0);
UPPR_VERBOSE = keycap(3, 5, body="bodies/cylindric-concave-thumb.3mf", right_svg  = "TL_UPPR", side_svg = "ADJUST_v", side_position_z=3.3, side_relative_y=-7.4, right_relative_y=0);


// Data to to render keycaps
keycaps = [
    // Left
    VERBOSE_LABELS ? KC_Q_VERBOSE : KC_Q,
    keycap(0, 1, center_svg = "KC_W",    left_svg = "KC_F7",    right_svg = "MS_BTN2",  side_svg = "KC_VOLD"),
    keycap(0, 2, center_svg = "KC_E",    left_svg = "KC_F8",    right_svg = "MS_UP",    side_svg = "KC_MUTE"),
    keycap(0, 3, center_svg = "KC_R",    left_svg = "KC_F9",    right_svg = "MS_BTN1",  side_svg = "KC_VOLU"),
    keycap(0, 4, center_svg = "KC_T",    left_svg = "KC_F12",   right_svg = "MS_WHLU",  side_svg = "KC_PAUSE"),
    
    keycap(1, 0, center_svg = "KC_A",    left_svg = "KC_GRV",   right_svg = "KC_QUOT",  side_svg = "KC_TAB_i"),
    keycap(1, 1, center_svg = "KC_S",    left_svg = "KC_F4",    right_svg = "MS_LEFT",  side_svg = "KC_LPRN"),
    keycap(1, 2, center_svg = "KC_D",    left_svg = "KC_F5",    right_svg = "MS_DOWN",  side_svg = "KC_RPRN"),
    keycap(1, 3, center_svg = "KC_F",    left_svg = "KC_F6",    right_svg = "MS_RGHT",  side_svg = "KC_SPC", home_row = true),
    keycap(1, 4, center_svg = "KC_G",    left_svg = "KC_F10",   right_svg = "MS_WHLD",  side_svg = "KC_GRV"),

    keycap(2, 0, center_svg = "KC_Z",    left_svg = "KC_LSFT",  right_svg = "MS_BTN3",  side_svg = "KC_LSFT"),
    keycap(2, 1, center_svg = "KC_X",    left_svg = "KC_F1",    right_svg = "KC_BSLS",  side_svg = "KC_LCTL"),
    keycap(2, 2, center_svg = "KC_C",    left_svg = "KC_F2",    right_svg = "KC_COMM",  side_svg = "KC_LALT"),
    keycap(2, 3, center_svg = "KC_V",    left_svg = "KC_F3",    right_svg = "KC_DOT",   side_svg = "KC_LGUI"),
    keycap(2, 4, center_svg = "KC_B",    left_svg = "KC_F11",                           side_svg = "KC_DEL"),

    keycap(3, 3, body="bodies/cylindric-concave-thumb.3mf", center_svg = "KC_SPC"),
    VERBOSE_LABELS ? LOWR_VERBOSE : LOWR,

    // Rigth
    keycap(0, 5, center_svg = "KC_Y",    left_svg = "KC_PGUP",  right_svg = "KC_MINS",  side_svg = "KC_PSCR"),
    keycap(0, 6, center_svg = "KC_U",    left_svg = "KC_HOME",  right_svg = "KC_7",     side_svg = "KC_CAPS"),
    keycap(0, 7, center_svg = "KC_I",    left_svg = "KC_UP",    right_svg = "KC_8",     side_svg = "KC_LBRC"),
    keycap(0, 8, center_svg = "KC_O",    left_svg = "KC_END",   right_svg = "KC_9",     side_svg = "KC_RBRC"),
    VERBOSE_LABELS ? KC_P_VERBOSE : KC_P,

    keycap(1, 5, center_svg = "KC_H",    left_svg = "KC_PGDN",  right_svg = "KC_EQL",   side_svg = "KC_EQL_s"),
    keycap(1, 6, center_svg = "KC_J",    left_svg = "KC_LEFT",  right_svg = "KC_4",     side_svg = "KC_RABK", home_row = true),
    keycap(1, 7, center_svg = "KC_K",    left_svg = "KC_DOWN",  right_svg = "KC_5",     side_svg = "KC_LCBR"),
    keycap(1, 8, center_svg = "KC_L",    left_svg = "KC_RGHT",  right_svg = "KC_6",     side_svg = "KC_RCBR"),
    keycap(1, 9, center_svg = "KC_SCLN", left_svg = "KC_QUOT",  right_svg = "KC_0",     side_svg = "KC_MINS"),
    
    keycap(2, 5, center_svg = "KC_N",    left_svg = "KC_DEL",   right_svg = "MS_BTN1",  side_svg = "KC_ENT"),
    keycap(2, 6, center_svg = "KC_M",    left_svg = "KC_TAB",   right_svg = "KC_1",     side_svg = "KC_LGUI"),
    keycap(2, 7, center_svg = "KC_COMM", left_svg = "KC_INS",   right_svg = "KC_2",     side_svg = "KC_LALT"),
    keycap(2, 8, center_svg = "KC_DOT",  left_svg = "KC_APP",   right_svg = "KC_3",     side_svg = "KC_LCTL"),
    keycap(2, 9, center_svg = "KC_SLSH",                        right_svg = "MS_ACL0",  side_svg = "KC_LSFT"),

    VERBOSE_LABELS ? UPPR_VERBOSE : UPPR,
    keycap(3, 6, body="bodies/cylindric-concave-thumb.3mf", center_svg = "KC_ENT_i")
    
];