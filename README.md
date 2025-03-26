# Super Custom Keycaps

Customizable keycaps with side prints for QMK Tri Layouts opmimized for 3D printing

These keykaps were initially a part of my layout for [TypeS Tri Layout](https://github.com/andruhon/type-s-tri-layout), but it seems like they deserve a separate repo.

Keycaps printed on P1S with AMS, 0.2mm nozzle
![Keycaps AMS](keycaps-ams.png)

![Keyboard with almost full set of keycaps](blog-assets/keyboard.png)

## Generating keycaps

Keycaps are at early prototyping stage. I will later organise and document everything properly.
Some insights may be find in [Blog](blog.md)

## Svg preparation process

In Inkscape

- (T) and type letter
- (CTRL+SHIFT+C) to convert letter to path
- (CTRL+D) and then select resize to content
- (CTRL+SHIFT+E) type file name matching short QMK code, select "Plain SVG" and click Export.

Once new svg is added to `/svg` directory the `node measure-svg.js` has to be executed.

## Printing

- You need 0.2 mm nozzle to print these keycaps.
- Layer height 0.1 mm
- Exported 3mf file will have 4 subparts. Allocate desired colours to them.
- No supports. Buttons are small enough bridging should work well.
- No AUX fan. Stems will peel if it's on, generally buttons closer to the fan look worse.
- Top layer and infill - Aligned rectilinear.
- Infill direction 90
- Top shell layers 16 to avoid sparse infill (sparce infill won't save anything on such small prints)
- Seams position: Back
