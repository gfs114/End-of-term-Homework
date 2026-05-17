<template>
  <div class="register-page">
    <div class="register-card">
      <h2>用户注册</h2>

      <el-form ref="registerForm" :model="form" :rules="rules" label-position="top" class="register-form">
        <el-form-item label="用户名" prop="username">
          <el-input prefix-icon="UserFilled" v-model="form.username" placeholder="请输入用户名" />
        </el-form-item>

        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" clearable prefix-icon="Message" />
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" show-password prefix-icon="Key" />
        </el-form-item>

        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" placeholder="请再次输入密码" show-password />
        </el-form-item>

        <el-button type="primary" class="submit-button" :loading="loading" @click="handleRegister">
          注册
        </el-button>
      </el-form>

      <div class="login-link">
        已有账号？
        <router-link to="/login">去登录</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import http from '@/utils/http'

export default {
  name: 'RegisterPage',
  data() {
    return {
      loading: false,
      form: {
        username: '',
        email: '',
        password: '',
        confirmPassword: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 2, max: 16, message: '用户名长度为 2 到 16 个字符', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '邮箱格式不正确', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '密码至少 6 位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入密码', trigger: 'blur' },
          { validator: this.validateConfirmPassword, trigger: 'blur' }
        ]
      }
    }
  },
  methods: {

    validateConfirmPassword(rule, value, callback) {
      if (value !== this.form.password) {
        callback(new Error('两次输入的密码不一致'))
        return
      }
      callback()
    },
    handleRegister() {
      this.$refs.registerForm.validate(async (valid) => {
        if (!valid || this.loading) {
          return
        }

        this.loading = true

        try {
          const response = await http.post('/register', {
            username: this.form.username,
            email: this.form.email,
            password: this.form.password
          })
          const result = response.data || response

          if (result.code === '200' || result.code === 200) {
            this.$message.success(result.message || result.msg || '注册成功')
            this.$router.push('/login')
          } else {
            this.$message.error(result.message || result.msg || '注册失败')
            console.log(result)
          }
        } catch (error) {
          const data = error.response && error.response.data
          this.$message.error((data && (data.message || data.msg)) || '注册失败')
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
.register-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  box-sizing: border-box;
}

.register-card {
  width: 100%;
  max-width: 420px;
  padding: 34px 32px 28px;
  background: rgba(255, 255, 255, 0.72);
  border: 1px solid rgba(255, 255, 255, 0.62);
  border-radius: 8px;
  box-shadow: 0 12px 32px rgba(28, 45, 75, 0.08);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  box-sizing: border-box;
}

.register-card h2 {
  margin: 0;
  color: #1f2937;
  font-size: 24px;
  font-weight: 600;
  text-align: center;
}

.register-form {
  width: 100%;
}

.submit-button {
  width: 100%;
  height: 40px;
  margin-top: 6px;
}

.login-link {
  margin-top: 22px;
  color: #6b7280;
  font-size: 14px;
  text-align: center;
}

.login-link a {
  color: #409eff;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>
