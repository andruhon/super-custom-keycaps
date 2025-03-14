import { commands as drawCommands, cameras, controls } from '@jscad/regl-renderer'

const width = 300
const height = 200

// prepare the camera
export const perspectiveCamera = cameras.perspective
export const camera = Object.assign({}, { ...perspectiveCamera.defaults, position: [1, 30, 15] })
export const orbitControls = controls.orbit
perspectiveCamera.setProjection(camera, camera, { width, height })
perspectiveCamera.update(camera, camera)

export const options = {
  glOptions: { container: null },
  camera,
  drawCommands: {
    // draw commands bootstrap themselves the first time they are run
    drawAxis: drawCommands.drawAxis,
    drawGrid: drawCommands.drawGrid,
    drawLines: drawCommands.drawLines,
    drawMesh: drawCommands.drawMesh,
  },
  // data
  entities: [
    /*{ // grid data
      // the choice of what draw command to use is also data based
      visuals: {
        drawCmd: 'drawGrid',
        show: true
      },
      size: [500, 500],
      ticks: [25, 5]
      // color: [0, 0, 1, 1],
      // subColor: [0, 0, 1, 0.5]
    },
    {
      visuals: {
        drawCmd: 'drawAxis',
        show: true
      },
      size: 300
      // alwaysVisible: false,
      // xColor: [0, 0, 1, 1],
      // yColor: [1, 0, 1, 1],
      // zColor: [0, 0, 0, 1]
    },
    []*/
  ],
}
