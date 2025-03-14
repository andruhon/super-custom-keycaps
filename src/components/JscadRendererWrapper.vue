<script setup>
import { onMounted, useTemplateRef } from 'vue';
import { prepareRender, commands as drawCommands, cameras, entitiesFromSolids } from '@jscad/regl-renderer'
import { cube } from '@jscad/modeling'

const renderArea = useTemplateRef("renderHere");

onMounted(() => {

  const width = 500
  const height = 300

  const myCube = cube({ size: 10 })

  const entities = entitiesFromSolids({}, [myCube])

  const perspectiveCamera = cameras.perspective
  const camera = Object.assign({}, perspectiveCamera.defaults)
  perspectiveCamera.setProjection(camera, camera, { width, height })
  perspectiveCamera.update(camera, camera)

  const options = {
    glOptions: { container: renderArea.value },
    camera,
    drawCommands: {
      // draw commands bootstrap themselves the first time they are run
      drawAxis: drawCommands.drawAxis,
      drawGrid: drawCommands.drawGrid,
      drawLines: drawCommands.drawLines,
      drawMesh: drawCommands.drawMesh
    },
    // data
    entities: [
      { // grid data
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
      ...entities
    ]
  }

  const render = prepareRender(options);

  render(options);
});
</script>

<template>
  <div id="renderHere">Hi!</div>
</template>

<style scoped>
.regl-renderer {
  border: 1px solid gray;
}
</style>
