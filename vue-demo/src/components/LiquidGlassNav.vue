<template>
  <header ref="navbar" class="liquid-navbar" :style="navbarVars">
    <svg class="liquid-filter-svg" aria-hidden="true" focusable="false">
      <defs>
        <filter :id="filterId" filterUnits="userSpaceOnUse" x="0" y="0" :width="filterWidth" :height="filterHeight"
          color-interpolation-filters="sRGB">
          <feImage v-if="displacementMap" x="0" y="0" :width="filterWidth" :height="filterHeight"
            preserveAspectRatio="none" :href="displacementMap" result="displacementMap" />
          <feDisplacementMap in="SourceGraphic" in2="displacementMap" :scale="displacementScale" xChannelSelector="R"
            yChannelSelector="G" />
        </filter>
      </defs>
    </svg>

    <div class="liquid-glass-layer"></div>

    <nav class="nav-content" aria-label="主导航">
      <div class="nav-group nav-main">
        <button type="button" class="nav-link nav-theme-btn" :title="isDark ? '切换白天模式' : '切换夜间模式'" @click="toggleTheme">
          <span class="theme-icon">{{ isDark ? '☀' : '☾' }}</span>
        </button>
        <router-link to="/hello" class="nav-link">首页</router-link>
        <router-link to="/phone" class="nav-link">手机专区</router-link>
        <router-link to="/computer" class="nav-link">电脑专区</router-link>
        <router-link to="/mine" class="nav-link">我的</router-link>
      </div>

      <div class="nav-group nav-auth">
        <!-- <router-link v-if="loginUsername || adminUsername" to="/submit" class="nav-link nav-submit">投稿</router-link> -->
        <template v-if="adminUsername">
          <span class="nav-greeting">{{ adminUsername }}</span>
          <router-link to="/alogin/admin" class="nav-link nav-admin-back">返回后台</router-link>
          <button type="button" class="nav-link nav-button" @click="handleLogout">登出</button>
        </template>
        <template v-if="loginUsername">
          <span class="nav-greeting">你好，{{ loginUsername }}</span>
          <button type="button" class="nav-link nav-button" @click="handleLogout">登出</button>
        </template>
        <template v-if="!loginUsername && !adminUsername">
          <router-link to="/login" class="nav-link">登录</router-link>
          <router-link to="/register" class="nav-link">注册</router-link>
        </template>
        <!-- <router-link to="/alogin" class="nav-link">管理员登录</router-link> -->
      </div>
    </nav>
  </header>
</template>

<script>
function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value))
}

function smoothStep(a, b, t) {
  const x = clamp((t - a) / (b - a), 0, 1)
  return x * x * (3 - 2 * x)
}

function vectorLength(x, y) {
  return Math.sqrt(x * x + y * y)
}

function roundedRectSDF(x, y, width, height, radius) {
  const qx = Math.abs(x) - width + radius
  const qy = Math.abs(y) - height + radius
  return Math.min(Math.max(qx, qy), 0) + vectorLength(Math.max(qx, 0), Math.max(qy, 0)) - radius
}

export default {
  name: 'LiquidGlassNav',
  data() {
    return {
      filterId: `nav-liquid-glass-${Math.random().toString(36).slice(2)}`,
      filterWidth: 1280,
      filterHeight: 72,
      displacementMap: '',
      displacementScale: 24,
      resizeHandler: null,
      resizeFrame: null,
      loginUsername: '',
      adminUsername: '',
      isDark: true
    }
  },
  computed: {
    navbarVars() {
      return {
        '--liquid-filter': `url(#${this.filterId})`
      }
    }
  },
  watch: {
    '$route.fullPath'() {
      this.loadLoginUsername()
    }
  },
  mounted() {
    this.loadLoginUsername()
    this.initTheme()
    this.updateFilterSize()
    this.resizeHandler = () => this.scheduleFilterUpdate()
    window.addEventListener('resize', this.resizeHandler)
  },
  beforeUnmount() {
    if (this.resizeHandler) {
      window.removeEventListener('resize', this.resizeHandler)
    }
    if (this.resizeFrame) {
      cancelAnimationFrame(this.resizeFrame)
    }
  },
  methods: {
    loadLoginUsername() {
      this.loginUsername = localStorage.getItem('loginUsername') || ''
      this.adminUsername = localStorage.getItem('adminUsername') || ''
      this.$nextTick(() => this.scheduleFilterUpdate())
    },
    handleLogout() {
      localStorage.removeItem('loginUsername')
      localStorage.removeItem('loginEmail')
      localStorage.removeItem('adminUsername')
      localStorage.removeItem('adminRole')
      this.loginUsername = ''
      this.adminUsername = ''
      this.$router.push('/login')
    },
    initTheme() {
      const saved = localStorage.getItem('theme')
      this.isDark = saved !== 'light'
      this.applyTheme()
    },
    toggleTheme() {
      this.isDark = !this.isDark
      this.applyTheme()
    },
    applyTheme() {
      const theme = this.isDark ? 'dark' : 'light'
      localStorage.setItem('theme', theme)
      document.documentElement.setAttribute('data-theme', theme)
    },
    scheduleFilterUpdate() {
      if (this.resizeFrame) {
        cancelAnimationFrame(this.resizeFrame)
      }
      this.resizeFrame = requestAnimationFrame(() => this.updateFilterSize())
    },
    updateFilterSize() {
      if (!this.$refs.navbar) {
        return
      }

      const rect = this.$refs.navbar.getBoundingClientRect()
      const nextWidth = Math.max(320, Math.round(rect.width))
      const nextHeight = Math.max(72, Math.round(rect.height))

      if (nextWidth === this.filterWidth && nextHeight === this.filterHeight && this.displacementMap) {
        return
      }

      this.filterWidth = nextWidth
      this.filterHeight = nextHeight
      this.generateDisplacementMap()
    },
    generateDisplacementMap() {
      const mapWidth = clamp(Math.round(this.filterWidth / 2), 360, 1200)
      const mapHeight = this.filterHeight
      const canvas = document.createElement('canvas')
      const context = canvas.getContext('2d')
      canvas.width = mapWidth
      canvas.height = mapHeight

      const data = new Uint8ClampedArray(mapWidth * mapHeight * 4)
      const rawValues = []
      let maxOffset = 0

      for (let y = 0; y < mapHeight; y += 1) {
        for (let x = 0; x < mapWidth; x += 1) {
          const uv = {
            x: x / Math.max(1, mapWidth - 1),
            y: y / Math.max(1, mapHeight - 1)
          }
          const warped = this.fragment(uv)
          const dx = (warped.x - uv.x) * mapWidth
          const dy = (warped.y - uv.y) * mapHeight
          rawValues.push(dx, dy)
          maxOffset = Math.max(maxOffset, Math.abs(dx), Math.abs(dy))
        }
      }

      const normalizer = Math.max(1, maxOffset * 2)
      let rawIndex = 0

      for (let i = 0; i < data.length; i += 4) {
        const r = rawValues[rawIndex++] / normalizer + 0.5
        const g = rawValues[rawIndex++] / normalizer + 0.5
        data[i] = clamp(r, 0, 1) * 255
        data[i + 1] = clamp(g, 0, 1) * 255
        data[i + 2] = 128
        data[i + 3] = 255
      }

      context.putImageData(new ImageData(data, mapWidth, mapHeight), 0, 0)
      this.displacementMap = canvas.toDataURL('image/png')
      this.displacementScale = clamp(Math.round(maxOffset * 1.2), 18, 42)
    },
    fragment(uv) {
      const ix = uv.x - 0.5
      const iy = uv.y - 0.5
      const shape = roundedRectSDF(ix, iy, 0.5, 0.44, 0.16)
      const rim = smoothStep(0.18, -0.08, shape)
      const edge = Math.min(uv.y, 1 - uv.y)
      const edgePull = smoothStep(0.34, 0, edge)
      const wave = Math.sin(uv.x * Math.PI * 7.5) * 0.006 * edgePull
      const lensX = ix * rim * edgePull * 0.035
      const lensY = iy * rim * edgePull * -0.09 + wave

      return {
        x: clamp(uv.x + lensX, 0, 1),
        y: clamp(uv.y + lensY, 0, 1)
      }
    }
  }
}
</script>

<style scoped>
.liquid-navbar {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 1000;
  width: 100%;
  height: 72px;
  isolation: isolate;
}

.liquid-filter-svg {
  position: absolute;
  width: 0;
  height: 0;
  pointer-events: none;
}

.liquid-glass-layer {
  position: absolute;
  inset: 0;
  overflow: hidden;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.16), rgba(255, 255, 255, 0.05)),
    rgba(19, 20, 24, 0.34);
  border-bottom: 1px solid rgba(255, 255, 255, 0.22);
  box-shadow:
    0 18px 44px rgba(0, 0, 0, 0.22),
    inset 0 1px 1px rgba(255, 255, 255, 0.42),
    inset 0 -16px 30px rgba(255, 255, 255, 0.08);
  backdrop-filter:
    var(--liquid-filter) blur(2px) saturate(155%) contrast(1.08) brightness(1.04);
  -webkit-backdrop-filter:
    var(--liquid-filter)
    /* 调整模糊 */
    blur(4px) saturate(155%) contrast(1.08) brightness(1.04);
}

.nav-content {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 1280px;
  height: 100%;
  margin: 0 auto;
  padding: 0 24px;
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

.nav-submit {
  border-color: rgba(255, 59, 48, 0.55);
  background: linear-gradient(180deg, rgba(255, 59, 48, 0.22), rgba(255, 59, 48, 0.06)), rgba(19, 20, 24, 0.58);
  color: #fff;
  font-weight: 700;
}

.nav-submit:hover {
  border-color: rgba(255, 59, 48, 0.8);
  background: linear-gradient(180deg, rgba(255, 59, 48, 0.32), rgba(255, 59, 48, 0.1)), rgba(19, 20, 24, 0.68);
  box-shadow: 0 0 16px rgba(255, 59, 48, 0.2);
}

.nav-link {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 64px;
  height: 40px;
  padding: 0 18px;
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 100px;
  color: #f5f5f7;
  text-decoration: none;
  font-size: 15px;
  font-weight: 600;
  background: rgba(255, 255, 255, 0.09);
  box-shadow:
    inset 0 1px 1px rgba(255, 255, 255, 0.32),
    inset 0 -10px 18px rgba(255, 255, 255, 0.06),
    0 8px 20px rgba(0, 0, 0, 0.14);
  overflow: hidden;
  transition:
    background 0.22s ease,
    border-color 0.22s ease,
    transform 0.22s ease;
}

.nav-link::before {
  content: "";
  position: absolute;
  inset: 1px;
  border-radius: inherit;
  background:
    linear-gradient(145deg,
      rgba(255, 255, 255, 0.38),
      rgba(255, 255, 255, 0.05) 44%,
      rgba(255, 255, 255, 0.2));
  opacity: 0.5;
  pointer-events: none;
}

.nav-link:hover,
.nav-link.router-link-active {
  color: #fff;
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.34);
}

.nav-link:active {
  transform: scale(0.96);
}

.nav-button {
  border: 1px solid rgba(255, 255, 255, 0.18);
  cursor: pointer;
  font-family: inherit;
}

.nav-greeting {
  display: inline-flex;
  align-items: center;
  min-height: 40px;
  padding: 0 18px;
  color: #f5f5f7;
  font-size: 15px;
  font-weight: 600;
  white-space: nowrap;
}

@media (max-width: 768px) {
  .nav-content {
    gap: 10px;
    padding: 0 12px;
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
    min-width: auto;
    padding: 0 14px;
    font-size: 14px;
  }

  .nav-greeting {
    padding: 0 12px;
    font-size: 14px;
  }
}

/* ===== THEME BUTTON ===== */
.nav-theme-btn {
  min-width: 40px !important;
  padding: 0 !important;
  border: 1px solid rgba(245, 245, 247, 0.16);
  cursor: pointer;
}

.nav-theme-btn::before {
  display: none;
}

.theme-icon {
  font-size: 18px;
  line-height: 1;
}
</style>
