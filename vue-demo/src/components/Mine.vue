<template>
    <section class="mine-page">
        <div class="profile-card">
            <div class="profile-header">
                <h1>我的账号</h1>
            </div>

            <div class="profile-info">
                <div v-for="field in profileFields" :key="field.label">
                    <span>{{ field.label }}</span>
                    <strong>{{ field.value }}</strong>
                </div>
            </div>

            <el-button type="primary" class="change-button" @click="openPasswordDialog">
                修改密码
            </el-button>
        </div>

        <transition name="password-modal">
            <div v-if="passwordDialogVisible" class="password-overlay" @click.self="closePasswordDialog">
                <div class="password-dialog">
                    <div class="dialog-head">
                        <h2>修改密码</h2>
                        <button type="button" class="dialog-close" @click="closePasswordDialog">×</button>
                    </div>

                    <el-form ref="passwordForm" :model="passwordForm" :rules="rules" label-position="top"
                        class="password-form">
                        <el-form-item label="原密码" prop="oldPassword">
                            <el-input v-model="passwordForm.oldPassword" type="password" show-password
                                placeholder="请输入原密码" />
                        </el-form-item>

                        <el-form-item label="新密码" prop="newPassword">
                            <el-input v-model="passwordForm.newPassword" type="password" show-password
                                placeholder="请输入新密码" />
                        </el-form-item>

                        <el-form-item label="确认新密码" prop="confirmPassword">
                            <el-input v-model="passwordForm.confirmPassword" type="password" show-password
                                placeholder="请再次输入新密码" />
                        </el-form-item>

                        <el-button type="primary" class="submit-button" :loading="loading"
                            @click="handleChangePassword">
                            保存新密码
                        </el-button>
                    </el-form>
                </div>
            </div>
        </transition>
    </section>
</template>

<script>
import http from '@/utils/http'

export default {
    name: 'MinePage',
    data() {
        return {
            loading: false,
            passwordDialogVisible: false,
            username: localStorage.getItem('loginUsername') || '未登录用户',
            email: localStorage.getItem('loginEmail') || '暂未绑定邮箱',
            passwordForm: {
                oldPassword: '',
                newPassword: '',
                confirmPassword: ''
            },
            rules: {
                oldPassword: [
                    { required: true, message: '请输入原密码', trigger: 'blur' }
                ],
                newPassword: [
                    { required: true, message: '请输入新密码', trigger: 'blur' },
                    { min: 6, max: 16, message: '密码长度为 6 到 16 个字符', trigger: 'blur' }
                ],
                confirmPassword: [
                    { required: true, message: '请再次输入新密码', trigger: 'blur' },
                    { validator: this.validateConfirmPassword, trigger: 'blur' }
                ]
            }
        }
    },
    computed: {
        profileFields() {
            return [
                { label: '用户名', value: this.username },
                { label: '邮箱', value: this.email }
            ]
        },
        passwordPayload() {
            return {
                username: this.username,
                oldPassword: this.passwordForm.oldPassword,
                newPassword: this.passwordForm.newPassword
            }
        }
    },
    mounted() {
        if (!localStorage.getItem('loginUsername')) {
            this.$message.warning('请先登录')
            this.$router.push('/login')
        }
    },
    methods: {
        openPasswordDialog() {
            this.passwordDialogVisible = true
        },
        closePasswordDialog() {
            if (this.loading) {
                return
            }

            this.passwordDialogVisible = false
            this.resetPasswordForm()
        },
        validateConfirmPassword(rule, value, callback) {
            if (value !== this.passwordForm.newPassword) {
                callback(new Error('两次输入的新密码不一致'))
                return
            }

            callback()
        },
        handleChangePassword() {
            this.$refs.passwordForm.validate(async (valid) => {
                if (!valid || this.loading) {
                    return
                }

                this.loading = true

                try {
                    const response = await http.post('/users/password', this.passwordPayload)
                    const result = response.data || response

                    if (result.code === '200' || result.code === 200) {
                        this.$message.success(result.message || result.msg || '密码修改成功')
                        this.closePasswordDialog()
                    } else {
                        this.$message.error(result.message || result.msg || '密码修改失败')
                    }
                } catch (error) {
                    const data = error.response && error.response.data
                    this.$message.error((data && (data.message || data.msg)) || '密码修改失败')
                    console.log(error)
                } finally {
                    this.loading = false
                }
            })
        },
        resetPasswordForm() {
            this.passwordForm = {
                oldPassword: '',
                newPassword: '',
                confirmPassword: ''
            }

            this.$nextTick(() => {
                if (this.$refs.passwordForm) {
                    this.$refs.passwordForm.clearValidate()
                }
            })
        }
    }
}
</script>

<style scoped>
.mine-page {
    width: min(560px, 100%);
    margin: 0 auto;
    color: #152033;
}

.profile-card {
    padding: 24px;
    border: 1px solid #dbe7f3;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.92);
    box-shadow: 0 18px 50px rgba(45, 73, 112, 0.08);
}

.profile-header {
    margin-bottom: 22px;
}

.profile-header p {
    margin: 0 0 6px;
    color: #2563eb;
    font-size: 13px;
    font-weight: 700;
}

.profile-header h1 {
    margin: 0;
    color: #101827;
    font-size: 30px;
    line-height: 1.2;
}

.profile-info {
    display: grid;
    grid-template-columns: 1fr;
    gap: 14px;
}

.profile-info div {
    padding: 16px;
    border: 1px solid #eef3f8;
    border-radius: 8px;
    background: #fff;
}

.profile-info span {
    display: block;
    margin-bottom: 8px;
    color: #8090a6;
    font-size: 13px;
}

.profile-info strong {
    color: #253247;
    font-size: 16px;
    word-break: break-all;
}

.change-button {
    width: 100%;
    height: 40px;
    margin-top: 18px;
}

.password-overlay {
    position: fixed;
    inset: 0;
    z-index: 1500;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
    background: rgba(15, 23, 42, 0.52);
}

.password-dialog {
    width: min(460px, 100%);
    padding: 24px;
    border-radius: 8px;
    background: #fff;
    box-shadow: 0 24px 80px rgba(15, 23, 42, 0.24);
}

.dialog-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 18px;
}

.dialog-head h2 {
    margin: 0;
    color: #101827;
    font-size: 24px;
}

.dialog-close {
    width: 34px;
    height: 34px;
    border: 1px solid #d6e1ee;
    border-radius: 8px;
    background: #fff;
    color: #43546b;
    cursor: pointer;
    font-size: 24px;
    line-height: 1;
}

.dialog-close:hover {
    border-color: #2563eb;
    color: #2563eb;
}

.password-form {
    width: 100%;
}

.submit-button {
    width: 100%;
    height: 40px;
}

.password-modal-enter-active,
.password-modal-leave-active {
    transition: opacity 0.24s ease;
}

.password-modal-enter-active .password-dialog {
    animation: password-dialog-in 0.28s cubic-bezier(0.2, 1, 0.22, 1) both;
}

.password-modal-leave-active .password-dialog {
    animation: password-dialog-out 0.18s ease both;
}

.password-modal-enter-from,
.password-modal-leave-to {
    opacity: 0;
}

@keyframes password-dialog-in {
    0% {
        opacity: 0;
        transform: translateY(16px) scale(0.96);
    }

    100% {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@keyframes password-dialog-out {
    0% {
        opacity: 1;
        transform: translateY(0) scale(1);
    }

    100% {
        opacity: 0;
        transform: translateY(10px) scale(0.98);
    }
}

@media (max-width: 640px) {

    .profile-card,
    .password-dialog {
        padding: 20px;
    }

    .profile-info {
        grid-template-columns: 1fr;
    }

    .password-overlay {
        align-items: flex-end;
        padding: 14px;
    }
}
</style>
