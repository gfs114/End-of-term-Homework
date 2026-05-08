<template>
  <div class="app-shell">

    <header class="navbar-host">
      <LiquidGlass class="nav-liquid-glass" padding="0" effect="liquidGlass" mode="polar" :corner-radius="30" :displacement-scale="64" :blur-amount="0" :saturation="150" :aberration-intensity="2" :elasticity="0.3" :style="navGlassStyle">
        <nav class="navbar-shell">
          <div class="glass-navbar">
            <div class="nav-content">
              <div class="nav-group nav-main">
                <router-link to="/hello" class="nav-link" :style="navButtonGlassStyle" data-refraction-mode="standard">首页</router-link>
                <router-link to="/phone" class="nav-link" :style="navButtonGlassStyle" data-refraction-mode="standard">手机专区</router-link>
                <router-link to="/computer" class="nav-link" :style="navButtonGlassStyle" data-refraction-mode="standard" >电脑专区</router-link>
                <router-link to="/mine" class="nav-link" :style="navButtonGlassStyle" data-refraction-mode="standard">我的</router-link>
              </div>

              <div class="nav-group nav-auth">
                <router-link  to="/login"  class="nav-link"  :style="navButtonGlassStyle"  data-refraction-mode="standard">登录</router-link>
                <router-link to="/register" class="nav-link" :style="navButtonGlassStyle" data-refraction-mode="standard">注册</router-link>
                <router-link to="/alogin" class="nav-link" :style="navButtonGlassStyle" data-refraction-mode="standard">管理员登录</router-link>
              </div>
            </div>
          </div>
        </nav>
      </LiquidGlass>
    </header>
    <main class="page-container">
      <router-view />
    </main>
  </div>
</template>

<script>
import { LiquidGlass } from '@wxperia/liquid-glass-vue';

export default {
  name: 'App',
  components: {
    LiquidGlass
  },
  data() {
    return {
      navGlassStyle: {
        position: 'absolute',
        top: '50%',
        left: '50%',
        width: '100%',
        zIndex: 1
      },
      navButtonGlassStyle: {
        '--button-displacement-scale': '64px',
        '--button-blur-amount': '0px',
        '--button-saturation': '150%',
        '--button-elasticity': '0.35s',
        '--button-corner-radius': '100px'
      }
    }
  }
}
</script>

<style scoped>

* {
  box-sizing: border-box;
}

:global(body) {
  margin: 0;
  min-height: 100vh;
  font-family: Arial, "Microsoft YaHei", sans-serif;
  background: #fff;
  overflow-x: hidden;
}

.app-shell {
  min-height: 100vh;
}

.navbar-host {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 1000;
  width: 100%;
  height: 72px;
  background: transparent;
  border-bottom: none;
}

.navbar-host :deep(.glass) {
  width: 100%;
  height: 72px;
  display: flex !important;
  padding: 0 !important;
}

.navbar-host :deep(.glass > div:last-child) {
  width: 100%;
  height: 100%;
}

.navbar-shell {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 72px;
  background: rgba(29, 29, 31, 0.36);
}

.glass-navbar {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 100%;
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 24px;
  display: flex;
  align-items: center;
}

.nav-content {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.nav-group {
  display: flex;
  align-items: center;
  gap: 8px;
}

.nav-auth {
  margin-left: auto;
}

.nav-link {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 40px;
  padding: 0 18px;
  border-radius: var(--button-corner-radius);
  color: #f5f5f7;
  text-decoration: none;
  font-size: 15px;
  font-weight: 500;
  background:
    linear-gradient(
      180deg,
      rgba(255, 255, 255, 0.22),
      rgba(255, 255, 255, 0.08)
    );
  backdrop-filter:
    blur(var(--button-blur-amount))
    saturate(var(--button-saturation));
  -webkit-backdrop-filter:
    blur(var(--button-blur-amount))
    saturate(var(--button-saturation));
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow:
    0 8px 22px rgba(0, 0, 0, 0.18),
    0 0 var(--button-displacement-scale) rgba(255, 255, 255, 0.06),
    inset 0 1px 1px rgba(255, 255, 255, 0.32);
  transition:
    background var(--button-elasticity) cubic-bezier(.4,0,.2,1),
    box-shadow var(--button-elasticity) cubic-bezier(.4,0,.2,1),
    transform var(--button-elasticity) cubic-bezier(.4,0,.2,1);
  overflow: hidden;
  isolation: isolate;
}

.nav-link::after {
  content: "";
  position: absolute;
  inset: 1px;
  border-radius: inherit;
  background:
    linear-gradient(
      115deg,
      transparent 0%,
      rgba(255, 255, 255, 0.2) 34%,
      rgba(255, 255, 255, 0.05) 50%,
      transparent 68%
    );
  pointer-events: none;
}

.nav-link:hover {
  background:
    linear-gradient(
      180deg,
      rgba(255, 255, 255, 0.28),
      rgba(255, 255, 255, 0.12)
    );
  box-shadow:
    0 10px 26px rgba(0, 0, 0, 0.2),
    0 0 var(--button-displacement-scale) rgba(255, 255, 255, 0.08),
    inset 0 1px 1px rgba(255, 255, 255, 0.34);
}

.nav-link:active {
  transform: scale(0.96);
}

.page-container {
  padding: 96px 24px 24px;
  padding-top: 96px;
}

@media (max-width: 768px) {
  .glass-navbar {
    padding: 0 12px;
  }

  .nav-content {
    gap: 10px;
    overflow-x: auto;
    scrollbar-width: none;
  }

  .nav-content::-webkit-scrollbar {
    display: none;
  }

  .nav-group {
    flex: 0 0 auto;
  }

  .nav-link {
    font-size: 14px;
    padding: 0 14px;
  }
}
</style>
