<script setup>
import { prepareRender, drawCommands, cameras, entitiesFromSolids } from '@jscad/regl-renderer'
import { colors } from '@jscad/modeling'
import { primitives } from '@jscad/modeling'
import { booleans } from '@jscad/modeling'
import { deserializers } from '@jscad/io'
import { onMounted, useTemplateRef, ref } from 'vue'

const rendererArea = useTemplateRef('renderer')

const { colorize, hexToRgb } = colors;
const { cube, sphere, cylinder } = primitives;
const { subtract, union } = booleans;

const file = ref();

fetch('newcap.amf').then((d) => d.text()).then(renderModel)

function renderModel(blob) {
  const demoSolids = (parameters) => {
    if (!blob) {
      var cubes = []
      var spheres = []
      for (let i = 0; i < 10; i++) {
        let myCube = cube({ center: [0, i * 10, 0], size: 5 })
        let mySphere = sphere({ center: [0, i * 10, 0], radius: 3 })
        cubes.push(subtract(myCube, mySphere))
        spheres.push(mySphere)
      }
      const spheresUnion = colorize(hexToRgb('#FF0000'), union.apply(undefined, spheres));
      const cubesUnion = union.apply(undefined, cubes);
      return [spheresUnion, cubesUnion]
    } else {
      const myCylinder = cylinder({center: [5, 5, 5], radius: 5, height: 10})
      const keycapGeometry = deserializers.amf({output: 'geometry'}, blob);

      return [subtract(keycapGeometry, myCylinder)];
    }
  }

  const width = 300
  const height = 200

  // process entities and inject extras
  const entities = entitiesFromSolids({}, demoSolids({ scale: 1 }))

  // prepare the camera
  const perspectiveCamera = cameras.perspective
  const camera = Object.assign({}, { ...perspectiveCamera.defaults, position: [160, 160, 100] });
  perspectiveCamera.setProjection(camera, camera, { width, height })
  perspectiveCamera.update(camera, camera)

  const options = {
    glOptions: { container: rendererArea.value },
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
  // prepare
  const render = prepareRender(options)
  // do the actual render :  it is a simple function !
  render(options)



  // some live animation example
  /* let tick = 0

  let updateCounter = 0
  const updateAndRender = () => {
    tick += 0.01
    camera.position[0] = Math.cos(tick) * 800
    perspectiveCamera.update(camera, camera)
    options.camera = camera

    // dynamic geometries, yes indeed !, uncoment this if you want to show it
    // updateCounter += 1

    if (updateCounter > 360) {
      const entitiesDynamic = entitiesFromSolids({}, demoSolids({ scale: Math.random() }))
      options.entities = entitiesDynamic
      updateCounter = 0
    }

    // you can change the state of the viewer at any time by just calling the viewer
    // function again with different params
    render(options)
    window.requestAnimationFrame(updateAndRender)
  }
  window.requestAnimationFrame(updateAndRender)*/
}

onMounted(() => {
  // setup demo solids data
  // deserializers.stl({output: 'geometry'}, newcapRawData);  
});


</script>

<template>
  <div class="regl-renderer" ref="renderer"></div>
</template>

<style scoped>
.regl-renderer {
  border: 1px solid gray;
}
</style>