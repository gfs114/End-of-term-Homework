<template>

  <div class="login-page">

    <div class="login-card">
      <h2>登录</h2>

      <el-form ref="loginForm" :model="form" :rules="rules" label-position="top" class="login-form">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" prefix-icon="UserFilled" placeholder="请输入用户名或者邮箱" clearable />
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" prefix-icon="Lock" placeholder="请输入密码" show-password />
        </el-form-item>

        <div class="form-options">
          <el-checkbox v-model="form.remember">记住我</el-checkbox>
          <div class="form-links">
            <router-link to="/alogin">管理员登录</router-link>
            <router-link to="/forget">忘记密码</router-link>
          </div>
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
import http from '@/utils/http'

export default {
  name: 'LoginPage',
  data() {
    const validateUsername = (rule, value, callback) => {
      const usernameRegex = /^[a-zA-Z0-9_]{3,16}$/
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

      if (value === '') {
        callback(new Error('请输入用户名或邮箱'))
      } else if (!usernameRegex.test(value) && !emailRegex.test(value)) {
        callback(new Error('请输入正确的用户名或邮箱'))
      } else {
        callback()
      }
    }

    const validatePassword = (rule, value, callback) => {
      const passwordRegex = /^[a-zA-Z0-9_]{2,16}$/

      if (value === '') {
        callback(new Error('请输入密码'))
      } else if (!passwordRegex.test(value)) {
        callback(new Error('在2-16个字符之间，且只能包含字母，数字或下划线'))
      } else {
        callback()
      }
    }

    return {
      loading: false,
      form: {
        username: '',
        password: '',
        remember: false,
        role: 'BUSINESS'
      },
      rules: {
        username: [
          { required: true, validator: validateUsername, trigger: 'blur' }
        ],
        password: [
          { required: true, validator: validatePassword, trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate(async (valid) => {
        if (!valid || this.loading) {
          return
        }

        this.loading = true

        try {
          const response = await http.post('/login', {
            username: this.form.username,
            password: this.form.password,
            role: 'BUSINESS'
          })
          const result = response.data || response

          if (result.code === '200' || result.code === 200) {
            localStorage.setItem('loginUsername', this.form.username)
            if (this.form.username.includes('@')) {
              localStorage.setItem('loginEmail', this.form.username)
            }
            this.$message.success('登录成功')
            this.$router.push(this.$route.query.redirect || '/hello')
          } else {
            this.$message.error(result.message || result.msg || '请检查输入的用户名和密码是否正确')
            console.log(result)
          }
        } catch (error) {
          const data = error.response && error.response.data
          this.$message.error((data && (data.message || data.msg)) || '请检查输入的用户名和密码是否正确')
          console.log(error)
        } finally {
          this.loading = false
        }
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
  box-sizing: border-box;
}

.login-card {
  position: relative;
  width: 100%;
  max-width: 400px;
  padding: 34px 32px 28px;
  background: rgba(255, 255, 255, 0.72);
  border: 1px solid rgba(255, 255, 255, 0.62);
  border-radius: 8px;
  box-shadow: 0 18px 42px rgba(28, 45, 75, 0.12);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
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

.form-links {
  display: flex;
  align-items: center;
  gap: 12px;
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
