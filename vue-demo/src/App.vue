<template>
  <div class="app-shell">
    <LiquidGlassNav />

    <main class="page-container">
      <router-view></router-view>
    </main>
  </div>
</template>

<script>
import LiquidGlassNav from './components/LiquidGlassNav.vue'

export default {
  name: 'App',
  components: {
    LiquidGlassNav
  }
}
</script>

<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-height: 100vh;
  font-family: Arial, "Microsoft YaHei", sans-serif;
  background: #fff;
  overflow-x: hidden;
}

.app-shell {
  min-height: 100vh;
}

.page-container {
  padding: 96px 24px 24px;
}
</style>