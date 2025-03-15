# Changelog

I'm trying to design keycaps which are good when printed on
3D printer with AMS or similar material changing system.

## 16 Mar 2025

After failure with JSCAD I decided to tidy up my OpenSCAD scripts. Upgraded to OpenSCAD-2025.03.12.

## 15 Mar 2025

OpenSCAD language feels a bit awkward for me, I had hopes to make it easier writing JavaScript with JSCAD (aka OPENJSCAD),
and it all looked good, until I tried to extrude my SVGs. So far JSCAD is really weak with extruding SVGs.
See https://github.com/jscad/OpenJSCAD.org/issues/1253 and https://github.com/jscad/OpenJSCAD.org/issues/1386

## 3 Mar 2025

Decided that it's better to have every symbol in a separate file.
This will help me exporting for 3D printing (with separate file for each material).

## 26 Feb 2025

Moved keycaps from https://github.com/andruhon/34KeysLayoutQMK into this separate repo.

## 23 Feb 2025

Printed first keycaps on P1S with AMS with 0.2mm nozzle. They look really nice!
![Keyboard](keycaps-ams.png)

## 27 Nov 2024

A photograph of different prototypes on my keyboard
![Keyboard](keyboard-with-prototype-keycaps.jpg)

- P,T and R are from newcaps.scad - illed with automotive enamel and sanded.
- zxcvbnmjkli and thumb cluster are from keycap-edit-gui.scad painted with ultra fine point permanent markers. These caps currently have some advantage that they do not need to be sanded - they come smooth enough by themselves, because they are flat.
- Q and W are also from newcaps.scad, but painted with permanent marker. Q first painted and sanded, P first sanded then painted. It is important to notice that layer lines work as capillary and suck all the paint, so it is preferrable to sand the button first.
- Black keys except R,T and P are Keychron caps.
