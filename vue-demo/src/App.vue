<template>
  <div class="app-shell">

    <!-- Apple Liquid Glass Navbar -->
    <nav
      ref="navbar"
      class="navbar-shell"
    >

      <div class="glass-navbar">

        <div class="nav-content">

          <!-- 左侧 -->
          <div class="nav-group nav-main">

            <router-link
              to="/hello"
              class="nav-link"
            >
              首页
            </router-link>

            <router-link
              to="/phone"
              class="nav-link"
            >
              手机专区
            </router-link>

            <router-link
              to="/computer"
              class="nav-link"
            >
              电脑专区
            </router-link>

            <router-link
              to="/mine"
              class="nav-link"
            >
              我的
            </router-link>

          </div>

          <!-- 右侧 -->
          <div class="nav-group nav-auth">

            <router-link
              to="/login"
              class="nav-link"
            >
              登录
            </router-link>

            <router-link
              to="/register"
              class="nav-link"
            >
              注册
            </router-link>

          </div>

        </div>

      </div>

    </nav>

    <!-- 页面 -->
    <main class="page-container">
      <router-view />
    </main>

  </div>
</template>

<script>
export default {

  name: 'App',

  data() {
    return {
      handleMouseMove: null,
      handleMouseLeave: null,
      handleScroll: null,
    }
  },

  mounted() {

    const navbar = this.$refs.navbar

    // 鼠标移动液态光效
    this.handleMouseMove = (e) => {

      const rect =
        navbar.getBoundingClientRect()

      const x =
        e.clientX - rect.left

      const y =
        e.clientY - rect.top

      navbar.style.setProperty(
        '--mouse-x',
        `${x}px`
      )

      navbar.style.setProperty(
        '--mouse-y',
        `${y}px`
      )

      navbar.style.setProperty(
        '--glow-opacity',
        '1'
      )
    }

    // 鼠标离开
    this.handleMouseLeave = () => {

      navbar.style.setProperty(
        '--glow-opacity',
        '0'
      )
    }

    // 滚动液态漂移
    this.handleScroll = () => {

      const scrollY = window.scrollY

      navbar.style.setProperty(
        '--scroll-offset',
        `${scrollY * 0.05}px`
      )
    }

    navbar.addEventListener(
      'mousemove',
      this.handleMouseMove
    )

    navbar.addEventListener(
      'mouseleave',
      this.handleMouseLeave
    )

    window.addEventListener(
      'scroll',
      this.handleScroll
    )
  },

  beforeUnmount() {

    const navbar = this.$refs.navbar

    navbar.removeEventListener(
      'mousemove',
      this.handleMouseMove
    )

    navbar.removeEventListener(
      
      'mouseleave',
      this.handleMouseLeave
    )

    window.removeEventListener(
      'scroll',
      this.handleScroll
    )
  }

}
</script>

<style scoped>

/* =========================
   GLOBAL
========================= */

* {
  box-sizing: border-box;
}

:global(body) {
  margin: 0;
  min-height: 100vh;

  font-family:
    Arial,
    "Microsoft YaHei",
    sans-serif;

  background: #000;

  overflow-x: hidden;
}

.app-shell {
  min-height: 100vh;
}

/* =========================
   APPLE LIQUID GLASS
========================= */

.navbar-shell {

  --mouse-x: 50%;
  --mouse-y: 50%;
  --glow-opacity: 0;
  --scroll-offset: 0px;

  position: sticky;
  top: 0;

  z-index: 1000;

  width: 100%;
  height: 72px;

  overflow: hidden;

  isolation: isolate;

  backdrop-filter:
    blur(30px)
    saturate(180%)
    brightness(1.08);

  -webkit-backdrop-filter:
    blur(30px)
    saturate(180%)
    brightness(1.08);

  background:
    linear-gradient(
      180deg,
      rgba(255,255,255,0.34),
      rgba(255,255,255,0.14)
    );

  border-bottom:
    1px solid rgba(255,255,255,0.28);

  box-shadow:
    0 8px 32px rgba(0,0,0,0.06),
    inset 0 1px 1px rgba(255,255,255,0.65),
    inset 0 -1px 1px rgba(255,255,255,0.18);

  transition:
    backdrop-filter 0.25s ease,
    background 0.25s ease;
}

/* =========================
   鼠标液态高光
========================= */

.navbar-shell::before {
  content: "";

  position: absolute;
  inset: 0;

  background:

    radial-gradient(
      circle at var(--mouse-x) var(--mouse-y),

      rgba(255,255,255,0.55) 0%,
      rgba(255,255,255,0.22) 12%,
      rgba(255,255,255,0.08) 20%,
      transparent 42%
    ),

    radial-gradient(
      circle at top left,
      rgba(255,255,255,0.75),
      transparent 36%
    ),

    radial-gradient(
      circle at top right,
      rgba(255,255,255,0.24),
      transparent 30%
    ),

    linear-gradient(
      135deg,
      rgba(255,255,255,0.18),
      rgba(255,255,255,0.02)
    );

  opacity: var(--glow-opacity);

  transform:
    translateY(var(--scroll-offset));

  transition:
    opacity 0.35s ease,
    transform 0.15s ease-out;

  pointer-events: none;
}

/* =========================
   NAV CONTENT
========================= */

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

/* 左右 */
.nav-group {
  display: flex;
  align-items: center;
  gap: 8px;
}

.nav-auth {
  margin-left: auto;
}

/* =========================
   APPLE BUTTONS
========================= */

.nav-link {
  position: relative;

  display: inline-flex;
  align-items: center;
  justify-content: center;

  height: 40px;
  padding: 0 18px;

  border-radius: 999px;

  color: #1d1d1f;

  text-decoration: none;

  font-size: 15px;
  font-weight: 500;

  transition:
    all 0.28s cubic-bezier(.4,0,.2,1);

  overflow: hidden;
}

/* hover */
.nav-link:hover {

  transform:
    translateY(-1px);

  background:
    rgba(255,255,255,0.22);

  box-shadow:
    inset 0 1px 1px rgba(255,255,255,0.35);

  color: #0071e3;
}

/* =========================
   PAGE
========================= */

.page-container {
  padding: 24px;
}

/* =========================
   MOBILE
========================= */

@media (max-width: 768px) {

  .navbar-shell {
    height: auto;
    min-height: 72px;
  }

  .glass-navbar {
    padding: 12px;
  }

  .nav-content {
    flex-direction: column;
    gap: 12px;
  }

  .nav-group {
    flex-wrap: wrap;
    justify-content: center;
  }

  .nav-auth {
    margin-left: 0;
  }

  .nav-link {
    font-size: 14px;
    padding: 0 14px;
  }

}
</style>