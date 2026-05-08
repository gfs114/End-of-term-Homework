<template>

  <div class="login-page">

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
          <router-link to="#">忘记密码</router-link>
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
  background: #fff;
  box-sizing: border-box;
}

.login-card {
  position: relative;
  width: 100%;
  max-width: 400px;
  padding: 34px 32px 28px;
  background: #fff;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  box-shadow: 0 18px 42px rgba(28, 45, 75, 0.12);
  box-sizing: border-box;
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
