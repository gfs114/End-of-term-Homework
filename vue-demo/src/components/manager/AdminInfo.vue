<template>
    <section class="admin-info-page">
        <el-card class="admin-info-card" shadow="never">
            <template #header>
                <div class="page-header">
                    <div>
                        <h2>管理员信息管理</h2>
                    </div>
                    <el-button type="primary" @click="openCreateDialog">
                        新增管理员
                    </el-button>
                </div>
            </template>

            <el-table
                v-loading="tableLoading"
                :data="adminList"
                border
                stripe
                class="admin-table"
                empty-text="暂无管理员数据"
            >
                <el-table-column prop="username" label="管理员账号" min-width="140" />
                <el-table-column prop="email" label="邮箱" min-width="180">
                    <template #default="{ row }">
                        <span>{{ row.email || '-' }}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="role" label="角色" min-width="140">
                    <template #default="{ row }">
                        <el-tag :type="row.role === 'SUPER_ADMIN' ? 'danger' : 'primary'" effect="plain">
                            {{ getRoleLabel(row.role) }}
                        </el-tag>
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
                        <el-button
                            type="danger"
                            link
                            :loading="deleteLoadingId === row.id"
                            @click="handleDelete(row)"
                        >
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-card>

        <el-dialog
            v-model="dialogVisible"
            :title="dialogMode === 'create' ? '新增管理员' : '编辑管理员'"
            width="520px"
            :close-on-click-modal="false"
            :before-close="handleDialogBeforeClose"
        >
            <el-form
                ref="adminForm"
                :model="form"
                :rules="rules"
                label-width="100px"
                class="admin-form"
            >
                <el-form-item label="管理员账号" prop="username">
                    <el-input v-model.trim="form.username" placeholder="请输入管理员账号" maxlength="16" />
                </el-form-item>
                <el-form-item label="管理员密码" prop="password">
                    <el-input
                        v-model.trim="form.password"
                        type="password"
                        show-password
                        :placeholder="dialogMode === 'create' ? '请输入管理员密码' : '留空表示不修改密码'"
                        maxlength="32"
                    />
                </el-form-item>
                <el-form-item label="邮箱" prop="email">
                    <el-input v-model.trim="form.email" placeholder="请输入管理员邮箱，可为空" maxlength="80" />
                </el-form-item>
                <el-form-item label="角色" prop="role">
                    <el-select v-model="form.role" placeholder="请选择管理员角色" class="full-width">
                        <el-option label="管理员" value="ADMIN" />
                        <el-option label="超级管理员" value="SUPER_ADMIN" />
                    </el-select>
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
    name: 'AdminInfo',
    data() {
        const validatePassword = (rule, value, callback) => {
            if (this.dialogMode === 'create' && !value) {
                callback(new Error('请输入管理员密码'))
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
            adminList: [],
            tableLoading: false,
            submitLoading: false,
            deleteLoadingId: null,
            dialogVisible: false,
            dialogMode: 'create',
            currentId: null,
            form: {
                username: '',
                password: '',
                email: '',
                role: ''
            },
            rules: {
                username: [
                    { required: true, message: '请输入管理员账号', trigger: 'blur' },
                    { min: 2, max: 16, message: '账号长度为 2 到 16 位', trigger: 'blur' }
                ],
                password: [
                    { validator: validatePassword, trigger: 'blur' }
                ],
                email: [
                    { validator: validateEmail, trigger: 'blur' }
                ],
                role: [
                    { required: true, message: '请选择管理员角色', trigger: 'change' }
                ]
            }
        }
    },
    created() {
        this.fetchAdminList()
    },
    methods: {
        fetchAdminList() {
            this.tableLoading = true

            http.get('/admins')
                .then((response) => {
                    const result = response.data || {}
                    this.adminList = Array.isArray(result.data) ? this.sortByIdAsc(result.data) : []
                })
                .catch(() => {
                    this.$message.error('获取管理员列表失败')
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
                email: row.email || '',
                role: row.role || ''
            }
            this.clearFormValidate()
        },
        handleSubmit() {
            this.$refs.adminForm.validate((valid) => {
                if (!valid) {
                    return
                }

                const requestData = this.buildRequestData()
                this.submitLoading = true

                const request = this.dialogMode === 'create'
                    ? http.post('/admins', requestData)
                    : http.put(`/admins/${this.currentId}`, requestData)

                request
                    .then(() => {
                        this.$message.success(this.dialogMode === 'create' ? '新增管理员成功' : '修改管理员成功')
                        this.closeDialog()
                        this.fetchAdminList()
                    })
                    .catch(() => {
                        this.$message.error(this.dialogMode === 'create' ? '新增管理员失败' : '修改管理员失败')
                    })
                    .finally(() => {
                        this.submitLoading = false
                    })
            })
        },
        handleDelete(row) {
            this.$confirm(`确认删除管理员“${row.username}”吗？`, '删除确认', {
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                type: 'warning'
            })
                .then(() => {
                    this.deleteLoadingId = row.id

                    return http.delete(`/admins/${row.id}`)
                })
                .then(() => {
                    this.$message.success('删除管理员成功')
                    this.fetchAdminList()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error('删除管理员失败')
                    }
                })
                .finally(() => {
                    this.deleteLoadingId = null
                })
        },
        buildRequestData() {
            const requestData = {
                username: this.form.username,
                email: this.form.email,
                role: this.form.role
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
                email: '',
                role: ''
            }
            this.clearFormValidate()
        },
        clearFormValidate() {
            this.$nextTick(() => {
                if (this.$refs.adminForm) {
                    this.$refs.adminForm.clearValidate()
                }
            })
        },
        getRoleLabel(role) {
            if (role === 'SUPER_ADMIN') {
                return '超级管理员'
            }

            if (role === 'ADMIN') {
                return '管理员'
            }

            return role || '-'
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
.admin-info-page {
    width: 100%;
}

.admin-info-card {
    width: 100%;
    min-height: calc(100vh - 36px);
    border: 1px solid #ebeef5;
    border-radius: 8px;
}

.admin-info-card :deep(.el-card__header) {
    padding: 18px 22px;
    border-bottom: 1px solid #eef0f3;
}

.admin-info-card :deep(.el-card__body) {
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

.admin-table {
    width: 100%;
}

.admin-table :deep(.el-table__header th) {
    color: #374151;
    background: #f8fafc;
    font-weight: 600;
}

.admin-form {
    padding: 8px 8px 0 0;
}

.full-width {
    width: 100%;
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

@media (max-width: 720px) {
    .admin-info-card :deep(.el-card__body) {
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
