<script setup>
import { prepareRender, entitiesFromSolids } from '@jscad/regl-renderer'
import { colors } from '@jscad/modeling'
import { primitives } from '@jscad/modeling'
import { booleans, extrusions, transforms } from '@jscad/modeling'
import { deserializers } from '@jscad/io'
import { onMounted, useTemplateRef, ref } from 'vue'
import { options as initialOptions, camera, perspectiveCamera, orbitControls } from "./defaultOptions.js"

const { colorize, hexToRgb } = colors;
const { cube, sphere, cylinder } = primitives;
const { subtract, union } = booleans;


const rendererArea = useTemplateRef('renderer')

const renderFn = ref();
const options = ref();
const keycapGeometry = ref();
const svg = ref();

const withModel = ref(true);

function renderModel() {
  const demoSolids = () => {
    if (!withModel.value) {
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
      const myCylinder = cylinder({ center: [5, 5, 5], radius: 5, height: 10 })

      // return [subtract(keycapGeometry.value, myCylinder)];
      // FIXME Somehow it does not accept zeroes
      // see https://github.com/jscad/OpenJSCAD.org/issues/1087
      // const letter = transforms.translate([1, 1, 7.3], extrusions.extrudeLinear({ height: 3 }, svg.value));
      // return [letter];
      return [booleans.subtract(keycapGeometry.value, myCylinder)]
    }
  }


  // process entities and inject extras
  const entities = entitiesFromSolids({}, demoSolids({ scale: 1 }))
  options.value.entities = entities;

  // do the actual render :  it is a simple function !
  renderFn.value(options.value)


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

  // Initial render
  options.value = { ...initialOptions, ...{ glOptions: { container: rendererArea.value } }, entities: [] };
  renderFn.value = prepareRender(options.value);
  // options.value.glOptions.container = rendererArea.value;
  // renderModel();
  refreshModel();

  const state = { camera, controls: orbitControls.defaults };

  let updateView = true

  const doRotatePanZoom = () => {

    if (rotateDelta[0] || rotateDelta[1]) {
      const updated = orbitControls.rotate({ controls: state.controls, camera: state.camera, speed: rotateSpeed }, rotateDelta)
      state.controls = { ...state.controls, ...updated.controls }
      updateView = true
      rotateDelta = [0, 0]
    }

    if (panDelta[0] || panDelta[1]) {
      const updated = orbitControls.pan({ controls: state.controls, camera: state.camera, speed: panSpeed }, panDelta)
      state.controls = { ...state.controls, ...updated.controls }
      panDelta = [0, 0]
      state.camera.position = updated.camera.position
      state.camera.target = updated.camera.target
      updateView = true
    }

    if (zoomDelta) {
      const updated = orbitControls.zoom({ controls: state.controls, camera: state.camera, speed: zoomSpeed }, zoomDelta)
      state.controls = { ...state.controls, ...updated.controls }
      zoomDelta = 0
      updateView = true
    }
  }

  const updateAndRender = (timestamp) => {
    doRotatePanZoom()

    if (updateView) {
      const updates = orbitControls.update({ controls: state.controls, camera: state.camera })
      state.controls = { ...state.controls, ...updates.controls }
      updateView = state.controls.changed // for elasticity in rotate / zoom

      state.camera.position = updates.camera.position
      perspectiveCamera.update(state.camera)

      renderFn.value(options.value)
    }
    window.requestAnimationFrame(updateAndRender)
  }
  window.requestAnimationFrame(updateAndRender)

  // convert HTML events (mouse movement) to viewer changes
  let lastX = 0
  let lastY = 0

  const rotateSpeed = 0.002
  const panSpeed = 1
  const zoomSpeed = 0.08
  let rotateDelta = [0, 0]
  let panDelta = [0, 0]
  let zoomDelta = 0
  let pointerDown = false

  const moveHandler = (ev) => {
    if (!pointerDown) return
    const dx = lastX - ev.pageX
    const dy = ev.pageY - lastY

    const shiftKey = (ev.shiftKey === true) || (ev.touches && ev.touches.length > 2)
    if (shiftKey) {
      panDelta[0] += dx
      panDelta[1] += dy
    } else {
      rotateDelta[0] -= dx
      rotateDelta[1] -= dy
    }

    lastX = ev.pageX
    lastY = ev.pageY

    ev.preventDefault()
  }
  const downHandler = (ev) => {
    pointerDown = true
    lastX = ev.pageX
    lastY = ev.pageY
    rendererArea.value.setPointerCapture(ev.pointerId)
  }

  const upHandler = (ev) => {
    pointerDown = false
    rendererArea.value.releasePointerCapture(ev.pointerId)
  }

  const wheelHandler = (ev) => {
    zoomDelta += ev.deltaY
    ev.preventDefault()
  }

  rendererArea.value.onpointermove = moveHandler
  rendererArea.value.onpointerdown = downHandler
  rendererArea.value.onpointerup = upHandler
  rendererArea.value.onwheel = wheelHandler

});

function refreshModel() {
  console.log(withModel.value);
  Promise.all([
    fetch('newcap.amf').then((d) => d.text()).then((blob) => {
      keycapGeometry.value = deserializers.amf({ output: 'geometry' }, blob);
    }),
    fetch('x.svg').then((d) => d.text()).then((blob) => {
      svg.value = deserializers.svg({ output: 'script' }, blob);
    })
  ]).then(renderModel)
}


</script>

<template>
  <div class="regl-renderer" ref="renderer"></div>
  <label for="withModelCheckbox">With model</label>
  <input type="checkbox" id="withModelCheckbox" v-model="withModel" />
  <button v-on:click="refreshModel">Render</button>
</template>

<style scoped>
.regl-renderer {
  border: 1px solid gray;
}
</style>
