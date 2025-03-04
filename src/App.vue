<script setup>
import JscadRendererWrapper from './components/JscadRendererWrapper.vue';
</script>

<template>
    <div class="wrapper">
      <div id="renderArea">
        <JscadRendererWrapper />
      </div>
    </div>
</template>

<style scoped>
body {
  display: flex;
}
</style>
