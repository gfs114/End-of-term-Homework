<template>
  <div class="app-shell">
    <LiquidGlassNav v-if="!isAdminPage" />

    <main :class="['page-container', { 'page-container--admin': isAdminPage }]">
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
  },
  computed: {
    isAdminPage() {
      return this.$route.path === '/alogin/admin'
    }
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

.page-container--admin {
  padding-top: 24px;
}
</style>
