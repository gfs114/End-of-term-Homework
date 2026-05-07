<template>
  <div class="login-page">
    <svg class="glass-filter" aria-hidden="true" focusable="false">
      <filter id="liquid-glass">
        <feDisplacementMap in="SourceGraphic" in2="BackgroundImage" scale="10" xChannelSelector="R" yChannelSelector="G"/>
      </filter>
    </svg>

    <div class="login-card">
      <h2>登录</h2>

      <el-form ref="loginForm" :model="form" :rules="rules" label-position="top" class="login-form">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" prefix-icon="UserFilled" placeholder="请输入用户名" clearable/>
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" prefix-icon="Lock" placeholder="请输入密码" show-password/>
        </el-form-item>

        <div class="form-options">
          <el-checkbox v-model="form.remember">记住我</el-checkbox>
          <a href="javascript:void(0)">忘记密码</a>
        </div>

        <el-button type="primary" class="submit-button" :loading="loading" @click="handleLogin">
          登录
        </el-button>
      </el-form>

      <div class="register-link">
        没有账号？
        <router-link to="/register">去注册</router-link>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoginPage',
  data() {
    return {
      loading: false,
      form: {
        username: '',
        password: '',
        remember: false
      },
      rules: {
        username: [
          { required: true, 
            message: '请输入用户名', 
            trigger: 'blur' 
          }
        ],
        password: [
          { required: true, 
            message: '请输入密码', 
            trigger: 'blur' 
          },
          { min: 6, 
            message: '密码至少 6 位', 
            trigger: 'blur' 
          }
        ]
      }
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (!valid) {
          return
        }

        this.loading = true
        setTimeout(() => {
          this.loading = false
          this.$message.success('登录成功')
        }, 600)
      })
    }
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background:
    linear-gradient(135deg, rgba(245, 247, 251, 0.95), rgba(234, 242, 255, 0.9)),
    linear-gradient(45deg, #f8fafc 0%, #eef6f3 45%, #f5f0ff 100%);
  box-sizing: border-box;
}

.glass-filter {
  position: absolute;
  width: 0;
  height: 0;
  overflow: hidden;
}

.login-card {
  position: relative;
  width: 100%;
  max-width: 400px;
  padding: 34px 32px 28px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.58);
  border: 1px solid rgba(255, 255, 255, 0.72);
  border-radius: 8px;
  box-shadow:
    0 18px 42px rgba(28, 45, 75, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  box-sizing: border-box;
  backdrop-filter: blur(18px) saturate(160%);
}

.login-card::before {
  content: "";
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  background:
    linear-gradient(135deg, rgba(255, 255, 255, 0.78), rgba(255, 255, 255, 0.12) 46%, rgba(255, 255, 255, 0.42)),
    linear-gradient(90deg, rgba(255, 255, 255, 0.18), rgba(64, 158, 255, 0.08));
  filter: url("#liquid-glass");
  opacity: 0.9;
}

.login-card::after {
  content: "";
  position: absolute;
  top: 1px;
  left: 14px;
  right: 14px;
  height: 1px;
  z-index: 0;
  background: rgba(255, 255, 255, 0.9);
}

.login-card > * {
  position: relative;
  z-index: 1;
}

.login-card h2 {
  margin: 0 0 28px;
  color: #1f2937;
  font-size: 24px;
  font-weight: 600;
  text-align: center;
}

.login-form {
  width: 100%;
}

.form-options {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: -4px 0 18px;
  font-size: 14px;
}

.form-options a,
.register-link a {
  color: #409eff;
  text-decoration: none;
}

.form-options a:hover,
.register-link a:hover {
  text-decoration: underline;
}

.submit-button {
  width: 100%;
  height: 40px;
}

.register-link {
  margin-top: 22px;
  color: #6b7280;
  font-size: 14px;
  text-align: center;
}
</style>
