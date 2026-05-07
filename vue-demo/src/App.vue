<template>
  <div class="app-shell">
    <LiquidGlass>
    <nav class="navbar-shell">
      <div class="glass-navbar">
        <div class="nav-content">
          <div class="nav-group nav-main">
            <a href="/hello" class="nav-link">首页</a>
            <a href="/phone" class="nav-link">手机专区</a>
            <a href="/computer" class="nav-link">电脑专区</a>
            <a href="/mine" class="nav-link">我的</a>
          </div>

          <div class="nav-group nav-auth">
            <a href="/login" class="nav-link auth-link">登录</a>
            <a href="/register" class="nav-link auth-link">注册</a>
          </div>
        </div>
      </div>
    </nav>
    </LiquidGlass>

    <router-view></router-view>
  </div>
</template>

<script>
import { LiquidGlass } from '@wxperia/liquid-glass-vue';

export default {
  components: {
    LiquidGlass,
  },
  data() {
    return {};
  },
}
</script>

<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-height: 100vh;
  background: linear-gradient(180deg, #f4f8ff 0%, #f7f9fc 100%);
  font-family: Arial, "Microsoft YaHei", sans-serif;
}

.app-shell {
  min-height: 100vh;
}

.app-shell > :deep(div):first-child {
  position: sticky;
  top: 0;
  z-index: 10;
}

.navbar-shell {
  width: 100%;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.glass-navbar {
  display: flex;
  align-items: center;
  width: 100%;
  height: 64px;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.nav-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  height: 100%;
}

.nav-group {
  display: flex;
  align-items: center;
  height: 100%;
  gap: 8px;
}

.nav-auth {
  margin-left: auto;
}

.nav-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 38px;
  padding: 0 18px;
  border-radius: 19px;
  color: #2f3d4f;
  font-size: 15px;
  font-weight: 500;
  text-decoration: none;
  transition: color 0.2s ease, background-color 0.2s ease;
}

.nav-link:hover,
.nav-link.router-link-active {
  background: rgba(64, 158, 255, 0.12);
  color: #1677d2;
}

.nav-auth .auth-link:last-child {
  background: #409eff;
  color: #fff;
}

.nav-auth .auth-link:last-child:hover,
.nav-auth .auth-link:last-child.router-link-active {
  background: #1677d2;
  color: #fff;
}

@media (max-width: 720px) {
  .glass-navbar {
    flex-wrap: wrap;
    height: auto;
    min-height: 64px;
    padding: 10px 12px;
  }

  .nav-content {
    flex-wrap: wrap;
    gap: 8px;
  }

  .nav-group {
    flex-wrap: wrap;
    height: auto;
  }

  .nav-auth {
    justify-content: flex-end;
    margin-left: 0;
  }

  .nav-link {
    padding: 0 12px;
    font-size: 14px;
  }
}
</style>
