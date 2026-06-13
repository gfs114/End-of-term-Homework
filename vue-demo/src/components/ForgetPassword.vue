<template>
  <div class="forget-page">
    <div class="forget-card">
      <h2>忘记密码</h2>

      <el-form ref="forgetForm" :model="form" :rules="rules" label-position="top" class="forget-form">
        <el-form-item label="用户名或邮箱" prop="account">
          <el-input
            v-model.trim="form.account"
            prefix-icon="UserFilled"
            placeholder="请输入注册时的用户名或邮箱"
            clearable
          />
        </el-form-item>

        <el-form-item label="新密码" prop="password">
          <el-input
            v-model="form.password"
            type="password"
            prefix-icon="Lock"
            placeholder="请输入新密码"
            show-password
          />
        </el-form-item>

        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input
            v-model="form.confirmPassword"
            type="password"
            prefix-icon="Lock"
            placeholder="请再次输入新密码"
            show-password
          />
        </el-form-item>

        <el-button type="primary" class="submit-button" :loading="loading" @click="handleResetPassword">
          重置密码
        </el-button>
      </el-form>

      <div class="login-link">
        想起密码了？
        <router-link to="/login">返回登录</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import http from '@/utils/http'

export default {
  name: 'ForgetPassword',
  data() {
    // 校验找回账号，允许用户输入用户名或邮箱。
    const validateAccount = (rule, value, callback) => {
      const usernameRegex = /^[a-zA-Z0-9_]{2,16}$/
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

      if (!value) {
        callback(new Error('请输入用户名或邮箱'))
      } else if (!usernameRegex.test(value) && !emailRegex.test(value)) {
        callback(new Error('请输入正确的用户名或邮箱'))
      } else {
        callback()
      }
    }

    // 校验新密码格式，保证重置后的密码符合登录规则。
    const validatePassword = (rule, value, callback) => {
      const passwordRegex = /^[a-zA-Z0-9_]{6,16}$/

      if (!value) {
        callback(new Error('请输入新密码'))
      } else if (!passwordRegex.test(value)) {
        callback(new Error('密码为 6 到 16 位，只能包含字母、数字或下划线'))
      } else {
        callback()
      }
    }

    return {
      loading: false,
      form: {
        account: '',
        password: '',
        confirmPassword: ''
      },
      rules: {
        account: [
          { required: true, validator: validateAccount, trigger: 'blur' }
        ],
        password: [
          { required: true, validator: validatePassword, trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: this.validateConfirmPassword, trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    // 确认两次新密码输入一致。
    validateConfirmPassword(rule, value, callback) {
      if (value !== this.form.password) {
        callback(new Error('两次输入的新密码不一致'))
        return
      }

      callback()
    },
    // 查找账号并更新密码，成功后清空表单并返回登录页。
    handleResetPassword() {
      this.$refs.forgetForm.validate(async (valid) => {
        if (!valid || this.loading) {
          return
        }

        this.loading = true

        try {
          const user = await this.findUserByAccount()

          if (!user) {
            this.$message.error('未找到对应用户，请检查用户名或邮箱')
            return
          }

          await http.put(`/users/${user.id}`, {
            username: user.username,
            email: user.email,
            password: this.form.password
          })

          this.$message.success('密码重置成功，请重新登录')
          this.resetForm()
          this.$router.push('/login')
        } catch (error) {
          const data = error.response && error.response.data
          this.$message.error((data && (data.message || data.msg)) || '密码重置失败')
          console.log(error)
        } finally {
          this.loading = false
        }
      })
    },
    // 从用户列表中按用户名或邮箱查找当前要重置密码的用户。
    async findUserByAccount() {
      const response = await http.get('/users')
      const result = response.data || {}
      const users = Array.isArray(result.data) ? result.data : []
      const account = this.form.account.toLowerCase()

      return users.find((user) => {
        const username = String(user.username || '').toLowerCase()
        const email = String(user.email || '').toLowerCase()

        return username === account || email === account
      })
    },
    // 重置忘记密码表单和校验状态。
    resetForm() {
      this.form = {
        account: '',
        password: '',
        confirmPassword: ''
      }

      this.$nextTick(() => {
        if (this.$refs.forgetForm) {
          this.$refs.forgetForm.clearValidate()
        }
      })
    }
  }
}
</script>

<style scoped>
.forget-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  box-sizing: border-box;
}

.forget-card {
  width: 100%;
  max-width: 420px;
  padding: 34px 32px 28px;
  border: 1px solid rgba(255, 255, 255, 0.62);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.72);
  box-shadow: 0 18px 42px rgba(28, 45, 75, 0.12);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  box-sizing: border-box;
}

.forget-card h2 {
  margin: 0 0 28px;
  color: #1f2937;
  font-size: 24px;
  font-weight: 600;
  text-align: center;
}

.forget-form {
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
