import fs from "fs";
import path from "path";

/**
 * Reads svg files from ./svg directory and attempts to find their dimensions.
 * Writing resulting dimensions into svg_dimensions.scad
 * Make sure you check actual names produced. This script will replace characters including "-" with "_"
 */

// --- Main execution ---
const svgDirectory = "./svg";
const outputScadFile = "svg_dimensions.scad";

// Check if directory exists.
if (!fs.existsSync(svgDirectory)) {
  console.error(`Error: Directory "${svgDirectory}" does not exist.`);
  process.exit(1);
}

// Check if directory is actually a directory.
const stats = fs.statSync(svgDirectory);
if (!stats.isDirectory()) {
  console.error(`Error: "${svgDirectory}" is not a directory.`);
  process.exit(1);
}

processSVGs(svgDirectory, outputScadFile);

// --- Functions ---
function getSVGDimensions(svgContent) {
  let width = 0;
  let height = 0;
  let viewBox = null;

  // Find the root <svg> tag (and only the root tag).  Crucially,
  // this regex stops at the first closing bracket of the <svg> tag.
  const svgTagMatch = svgContent.match(/<svg\s+([^>]+)>/i);

  if (!svgTagMatch) {
    console.warn("");
    return null; // No <svg> tag found.
  }

  const svgTagAttributes = svgTagMatch[1]; // The attributes string

  // Extract width and height attributes (priority) from the root <svg> tag
  const widthMatch = svgTagAttributes.match(/width=["']([\d.]+)["']/i);
  if (widthMatch) {
    width = parseFloat(widthMatch[1]);
  }
  const heightMatch = svgTagAttributes.match(/height=["']([\d.]+)["']/i);
  if (heightMatch) {
    height = parseFloat(heightMatch[1]);
  }

  // Extract viewBox attribute if width/height are missing or we need to scale
  const viewBoxMatch = svgTagAttributes.match(
    /viewBox=["']([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)["']/i
  );
  if (viewBoxMatch) {
    viewBox = {
      x: parseFloat(viewBoxMatch[1]),
      y: parseFloat(viewBoxMatch[2]),
      width: parseFloat(viewBoxMatch[3]),
      height: parseFloat(viewBoxMatch[4]),
    };
  }

  // Calculate dimensions based on width/height and viewBox
  if (width > 0 && height > 0) {
    // If width/height exist use those, ignore viewbox scale
    return { width, height };
  } else if (viewBox) {
    // No width/height -> use viewBox.
    return { width: viewBox.width, height: viewBox.height };
  } else {
    return null; // No dimensions found.
  }
}

function processSVGs(svgDirPath, outputFilePath) {
  const files = fs.readdirSync(svgDirPath);
  let openscadCode = "// Auto-generated SVG dimensions\n";
  openscadCode += "svg_dimensions = [\n";
  const dimensions = [];

  for (const file of files) {
    if (path.extname(file).toLowerCase() === ".svg") {
      const filePath = path.join(svgDirPath, file);
      const svgContent = fs.readFileSync(filePath, "utf-8");
      const dims = getSVGDimensions(svgContent);

      if (dims) {
        const baseName = path.basename(file, ".svg");
        const safeBaseName = baseName.replace(/[^a-zA-Z0-9_]/g, "_");
        // Escape any characters that might cause issues in OpenSCAD variable names.  '-' is a common one.
        dimensions.push(
          `    ["${safeBaseName}", [${dims.width}, ${dims.height}]]`
        );
      } else {
        console.warn(`Warning: Could not determine dimensions for ${file}`);
      }
    }
  }

  openscadCode += dimensions.join(",\n") + "\n];\n";

  fs.writeFileSync(outputFilePath, openscadCode);
  console.log(`Wrote OpenSCAD dimensions to ${outputFilePath}`);
}
