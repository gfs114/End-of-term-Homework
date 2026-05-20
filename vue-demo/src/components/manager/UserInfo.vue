<template>
    <section class="user-info-page">
        <el-card class="user-info-card" shadow="never">
            <template #header>
                <div class="page-header">
                    <div>
                        <h2>用户信息管理</h2>
                    </div>
                    <el-button type="primary" @click="openCreateDialog">
                        新增用户
                    </el-button>
                </div>
            </template>

            <el-table v-loading="tableLoading" :data="userList" border stripe class="user-table" empty-text="暂无用户数据">
                <el-table-column prop="username" label="用户账号" min-width="150" />
                <el-table-column prop="email" label="邮箱" min-width="200">
                    <template #default="{ row }">
                        <span>{{ row.email || '-' }}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="created_at" label="创建时间" min-width="180">
                    <template #default="{ row }">
                        <span>{{ formatDate(row.created_at) }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="操作" width="180" fixed="right" align="center">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="openEditDialog(row)">
                            编辑
                        </el-button>
                        <el-button type="danger" link :loading="deleteLoadingId === row.id" @click="handleDelete(row)">
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-card>

        <el-dialog v-model="dialogVisible" :title="dialogMode === 'create' ? '新增用户' : '编辑用户'" width="520px"
            :close-on-click-modal="false" :before-close="handleDialogBeforeClose">
            <el-form ref="userForm" :model="form" :rules="rules" label-width="90px" class="user-form">
                <el-form-item label="用户账号" prop="username">
                    <el-input v-model.trim="form.username" placeholder="请输入用户账号" maxlength="16" />
                </el-form-item>
                <el-form-item label="用户密码" prop="password">
                    <el-input v-model.trim="form.password" type="password" show-password
                        :placeholder="dialogMode === 'create' ? '请输入用户密码' : '留空表示不修改密码'" maxlength="32" />
                </el-form-item>
                <el-form-item label="邮箱" prop="email">
                    <el-input v-model.trim="form.email" placeholder="请输入用户邮箱，可为空" maxlength="80" />
                </el-form-item>
            </el-form>

            <template #footer>
                <div class="dialog-footer">
                    <el-button :disabled="submitLoading" @click="closeDialog">取消</el-button>
                    <el-button type="primary" :loading="submitLoading" @click="handleSubmit">
                        保存
                    </el-button>
                </div>
            </template>
        </el-dialog>
    </section>
</template>

<script>
import http from '@/utils/http'

export default {
    name: 'UserInfo',
    data() {
        const validatePassword = (rule, value, callback) => {
            if (this.dialogMode === 'create' && !value) {
                callback(new Error('请输入用户密码'))
                return
            }

            if (value && value.length < 6) {
                callback(new Error('密码长度至少 6 位'))
                return
            }

            callback()
        }

        const validateEmail = (rule, value, callback) => {
            if (!value) {
                callback()
                return
            }

            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

            if (!emailPattern.test(value)) {
                callback(new Error('请输入正确的邮箱格式'))
                return
            }

            callback()
        }

        return {
            userList: [],
            tableLoading: false,
            submitLoading: false,
            deleteLoadingId: null,
            dialogVisible: false,
            dialogMode: 'create',
            currentId: null,
            form: {
                username: '',
                password: '',
                email: ''
            },
            rules: {
                username: [
                    { required: true, message: '请输入用户账号', trigger: 'blur' },
                    { min: 2, max: 16, message: '账号长度为 2 到 16 位', trigger: 'blur' }
                ],
                password: [
                    { validator: validatePassword, trigger: 'blur' }
                ],
                email: [
                    { validator: validateEmail, trigger: 'blur' }
                ]
            }
        }
    },
    created() {
        this.fetchUserList()
    },
    methods: {
        fetchUserList() {
            this.tableLoading = true

            http.get('/users')
                .then((response) => {
                    const result = response.data || {}
                    this.userList = Array.isArray(result.data) ? this.sortByIdAsc(result.data) : []
                })
                .catch(() => {
                    this.$message.error('获取用户列表失败')
                })
                .finally(() => {
                    this.tableLoading = false
                })
        },
        sortByIdAsc(list) {
            return list.slice().sort((prev, next) => {
                return Number(prev.id) - Number(next.id)
            })
        },
        openCreateDialog() {
            this.dialogMode = 'create'
            this.currentId = null
            this.dialogVisible = true
            this.resetForm()
        },
        openEditDialog(row) {
            this.dialogMode = 'edit'
            this.currentId = row.id
            this.dialogVisible = true
            this.form = {
                username: row.username || '',
                password: '',
                email: row.email || ''
            }
            this.clearFormValidate()
        },
        handleSubmit() {
            this.$refs.userForm.validate((valid) => {
                if (!valid) {
                    return
                }

                const requestData = this.buildRequestData()
                this.submitLoading = true

                const request = this.dialogMode === 'create'
                    ? http.post('/users', requestData)
                    : http.put(`/users/${this.currentId}`, requestData)

                request
                    .then(() => {
                        this.$message.success(this.dialogMode === 'create' ? '新增用户成功' : '修改用户成功')
                        this.closeDialog()
                        this.fetchUserList()
                    })
                    .catch(() => {
                        this.$message.error(this.dialogMode === 'create' ? '新增用户失败' : '修改用户失败')
                    })
                    .finally(() => {
                        this.submitLoading = false
                    })
            })
        },
        handleDelete(row) {
            this.$confirm(`确认删除用户“${row.username}”吗？`, '删除确认', {
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                type: 'warning'
            })
                .then(() => {
                    this.deleteLoadingId = row.id

                    return http.delete(`/users/${row.id}`)
                })
                .then(() => {
                    this.$message.success('删除用户成功')
                    this.fetchUserList()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error('删除用户失败')
                    }
                })
                .finally(() => {
                    this.deleteLoadingId = null
                })
        },
        buildRequestData() {
            const requestData = {
                username: this.form.username,
                email: this.form.email
            }

            if (this.dialogMode === 'create' || this.form.password) {
                requestData.password = this.form.password
            }

            return requestData
        },
        closeDialog() {
            if (this.submitLoading) {
                return
            }

            this.dialogVisible = false
            this.resetForm()
        },
        handleDialogBeforeClose(done) {
            if (this.submitLoading) {
                return
            }

            done()
            this.resetForm()
        },
        resetForm() {
            this.form = {
                username: '',
                password: '',
                email: ''
            }
            this.clearFormValidate()
        },
        clearFormValidate() {
            this.$nextTick(() => {
                if (this.$refs.userForm) {
                    this.$refs.userForm.clearValidate()
                }
            })
        },
        formatDate(value) {
            if (!value) {
                return '-'
            }

            return String(value).replace('T', ' ').replace(/\.\d+Z?$/, '')
        }
    }
}
</script>

<style scoped>
.user-info-page {
    width: 100%;
}

.user-info-card {
    width: 100%;
    min-height: calc(100vh - 36px);
    border: 1px solid #ebeef5;
    border-radius: 8px;
}

.user-info-card :deep(.el-card__header) {
    padding: 18px 22px;
    border-bottom: 1px solid #eef0f3;
}

.user-info-card :deep(.el-card__body) {
    padding: 22px;
}

.page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
}

.page-header h2 {
    margin: 0;
    color: #1f2937;
    font-size: 20px;
    font-weight: 700;
    line-height: 1.3;
}

.user-table {
    width: 100%;
}

.user-table :deep(.el-table__header th) {
    color: #374151;
    background: #f8fafc;
    font-weight: 600;
}

.user-form {
    padding: 8px 8px 0 0;
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

@media (max-width: 720px) {
    .user-info-card :deep(.el-card__body) {
        padding: 14px;
    }

    .page-header {
        align-items: flex-start;
        flex-direction: column;
    }

    .page-header .el-button {
        width: 100%;
    }
}
</style>
