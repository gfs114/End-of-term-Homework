<template>
  <div class="admin-login-page">
    <section class="login-card">
      <div class="card-header">
        <h1>管理员登录</h1>
      </div>
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" label-position="top" class="admin-form" @keyup.enter="handleLogin">
        <el-form-item label="账号" prop="username">
          <el-input prefix-icon="UserFilled" v-model="loginForm.username" placeholder="请输入用户名" clearable/>
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input prefix-icon="Lock" show-password v-model="loginForm.password" placeholder="请输入密码"/>
        </el-form-item>
        <el-button type="primary" class="login-btn" :loading="loading" @click="handleLogin">
          登录后台
        </el-button>
      </el-form>

      <div class="card-footer">
        <router-link to="/login">返回用户登录</router-link>
      </div>
    </section>
  </div>
</template>

<script>
import http from '@/utils/http'

export default {
  name: 'AdminLogin',
  data() {
    const validateUsername = (rule, value, callback) => {
      const usernameRegex = /^[a-zA-Z0-9_]{3,16}$/

      if (value === '') {
        callback(new Error('请输入用户名'))
      } else if (!usernameRegex.test(value)) {
        callback(new Error('在3-16个字符之间，且只能包含字母，数字或下划线'))
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
      loginForm: {
        username: '',
        password: '',
        role: 'ADMIN'
      },
      loginRules: {
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
            username: this.loginForm.username,
            password: this.loginForm.password,
            role: 'ADMIN'
          })
          const result = response.data || response

          if (result.code === '200' || result.code === 200) {
            this.$message.success('登录成功')
            this.$router.push('/hello')//跳转页面在这改
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
.admin-login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  box-sizing: border-box;
  background: #fff;
}

.login-card {
  width: 100%;
  max-width: 400px;
  padding: 36px 32px 30px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  box-shadow: 0 16px 40px rgba(31, 41, 55, 0.08);
  box-sizing: border-box;
}

.card-header {
  margin-bottom: 28px;
  text-align: center;
}

.card-header h1 {
  margin: 0;
  color: #1f2937;
  font-size: 26px;
  font-weight: 700;
}

.card-header p {
  margin: 10px 0 0;
  color: #6b7280;
  font-size: 14px;
}

.admin-form {
  width: 100%;
}

.login-btn {
  width: 100%;
  height: 42px;
  margin-top: 8px;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 600;
}

.card-footer {
  margin-top: 20px;
  font-size: 14px;
  text-align: center;
}

.card-footer a {
  color: #409eff;
  text-decoration: none;
}

.card-footer a:hover {
  text-decoration: underline;
}

:deep(.el-input__wrapper) {
  min-height: 42px;
  border-radius: 8px;
}

@media (max-width: 760px) {
  .admin-login-page {
    padding: 16px;
  }

  .login-card {
    padding: 30px 22px 26px;
  }
}
</style>
