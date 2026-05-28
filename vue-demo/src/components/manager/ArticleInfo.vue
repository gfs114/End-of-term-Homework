<template>
    <section class="article-info-page">
        <el-card class="article-info-card" shadow="never">
            <template #header>
                <div class="page-header">
                    <div>
                        <h2>文章内容管理</h2>
                    </div>
                    <el-button type="primary" @click="openCreateDialog">
                        新增文章
                    </el-button>
                </div>
            </template>

            <el-table v-loading="tableLoading" :data="articleList" border stripe class="article-table"
                empty-text="暂无文章数据">
                <el-table-column prop="id" label="ID" width="80" />
                <el-table-column prop="title" label="文章标题" min-width="240" show-overflow-tooltip>
                    <template #default="{ row }">
                        <strong>{{ row.title || '未命名文章' }}</strong>
                    </template>
                </el-table-column>
                <el-table-column prop="category" label="分类" min-width="120">
                    <template #default="{ row }">
                        <el-tag effect="plain">{{ row.category || '默认' }}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column prop="author" label="作者" min-width="120">
                    <template #default="{ row }">
                        <span>{{ row.author || '-' }}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="status" label="状态" width="110" align="center">
                    <template #default="{ row }">
                        <el-tag :type="row.status === 'published' ? 'success' : 'info'" effect="light">
                            {{ row.status === 'published' ? '已发布' : '草稿' }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column prop="views" label="浏览" width="90" align="center" />
                <el-table-column prop="favorites" label="收藏" width="90" align="center" />
                <el-table-column prop="created_at" label="创建时间" min-width="180">
                    <template #default="{ row }">
                        <span>{{ formatDate(row.created_at) }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="操作" width="230" fixed="right" align="center">
                    <template #default="{ row }">
                        <el-button v-if="row.status !== 'published'" type="success" link
                            :loading="publishLoadingId === row.id" @click="handlePublish(row)">
                            发布
                        </el-button>
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

        <el-dialog v-model="dialogVisible" :title="dialogMode === 'create' ? '新增文章' : '编辑文章'" width="760px"
            :close-on-click-modal="false" :before-close="handleDialogBeforeClose">
            <el-form ref="articleForm" :model="form" :rules="rules" label-width="86px" class="article-form">
                <el-form-item label="文章标题" prop="title">
                    <el-input v-model.trim="form.title" placeholder="请输入文章标题" maxlength="80" />
                </el-form-item>
                <el-form-item label="文章内容" prop="content">
                    <el-input v-model="form.content" type="textarea" :rows="10" placeholder="请输入文章内容" />
                </el-form-item>
                <div class="form-row">
                    <el-form-item label="作者" prop="author">
                        <el-input v-model.trim="form.author" placeholder="请输入作者" maxlength="32" />
                    </el-form-item>
                    <el-form-item label="分类" prop="category">
                        <el-input v-model.trim="form.category" placeholder="请输入分类" maxlength="32" />
                    </el-form-item>
                    <el-form-item label="状态" prop="status">
                        <el-select v-model="form.status" placeholder="请选择状态">
                            <el-option label="已发布" value="published" />
                            <el-option label="草稿" value="draft" />
                        </el-select>
                    </el-form-item>
                </div>
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

function pickList(payload) {
    if (Array.isArray(payload)) return payload
    if (Array.isArray(payload?.data)) return payload.data
    if (Array.isArray(payload?.articles)) return payload.articles
    if (Array.isArray(payload?.data?.data)) return payload.data.data
    return []
}

function isApiSuccess(payload) {
    const code = payload && payload.code
    return code === undefined || code === 200 || code === '200'
}

function getApiMessage(payload, fallback) {
    return (payload && (payload.message || payload.msg)) || fallback
}

function getDefaultArticleForm() {
    return {
        title: '',
        content: '',
        author: localStorage.getItem('adminUsername') || localStorage.getItem('loginUsername') || 'admin',
        category: '默认',
        status: 'published'
    }
}

export default {
    name: 'ArticleInfo',
    data() {
        return {
            articleList: [],
            tableLoading: false,
            submitLoading: false,
            publishLoadingId: null,
            deleteLoadingId: null,
            dialogVisible: false,
            dialogMode: 'create',
            currentId: null,
            form: getDefaultArticleForm(),
            rules: {
                title: [
                    { required: true, message: '请输入文章标题', trigger: 'blur' }
                ],
                content: [
                    { required: true, message: '请输入文章内容', trigger: 'blur' }
                ],
                author: [
                    { required: true, message: '请输入作者', trigger: 'blur' }
                ],
                category: [
                    { required: true, message: '请输入分类', trigger: 'blur' }
                ],
                status: [
                    { required: true, message: '请选择状态', trigger: 'change' }
                ]
            }
        }
    },
    created() {
        this.fetchArticleList()
    },
    methods: {
        async fetchArticleList() {
            this.tableLoading = true

            try {
                const { data } = await http.get('/articles')
                if (!isApiSuccess(data)) {
                    throw new Error(getApiMessage(data, '获取文章列表失败'))
                }

                this.articleList = pickList(data)
            } catch (error) {
                this.$message.error(error.message || '获取文章列表失败')
            } finally {
                this.tableLoading = false
            }
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
                title: row.title || '',
                content: row.content || '',
                author: row.author || 'admin',
                category: row.category || '默认',
                status: row.status || 'published'
            }
            this.clearFormValidate()
        },
        handleSubmit() {
            this.$refs.articleForm.validate(async (valid) => {
                if (!valid || this.submitLoading) {
                    return
                }

                this.submitLoading = true

                try {
                    const request = this.dialogMode === 'create'
                        ? http.post('/articles', this.form)
                        : http.put(`/articles/${this.currentId}`, this.form)
                    const { data } = await request

                    if (!isApiSuccess(data)) {
                        throw new Error(getApiMessage(data, this.dialogMode === 'create' ? '新增文章失败' : '修改文章失败'))
                    }

                    this.$message.success(getApiMessage(data, this.dialogMode === 'create' ? '新增文章成功' : '修改文章成功'))
                    this.closeDialog()
                    this.fetchArticleList()
                } catch (error) {
                    const data = error.response && error.response.data
                    this.$message.error((data && (data.message || data.msg)) || error.message || '保存文章失败')
                } finally {
                    this.submitLoading = false
                }
            })
        },
        handlePublish(row) {
            this.$confirm(`确认发布文章“${row.title || row.id}”吗？`, '发布确认', {
                confirmButtonText: '确认发布',
                cancelButtonText: '取消',
                type: 'success'
            })
                .then(async () => {
                    this.publishLoadingId = row.id
                    const { data } = await http.put(`/articles/${row.id}`, {
                        title: row.title || '',
                        content: row.content || '',
                        author: row.author || 'admin',
                        category: row.category || '默认',
                        status: 'published'
                    })

                    if (!isApiSuccess(data)) {
                        throw new Error(getApiMessage(data, '发布文章失败'))
                    }

                    this.$message.success(getApiMessage(data, '发布文章成功'))
                    this.fetchArticleList()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error(error.message || '发布文章失败')
                    }
                })
                .finally(() => {
                    this.publishLoadingId = null
                })
        },
        handleDelete(row) {
            this.$confirm(`确认删除文章“${row.title || row.id}”吗？`, '删除确认', {
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                type: 'warning'
            })
                .then(async () => {
                    this.deleteLoadingId = row.id
                    const { data } = await http.delete(`/articles/${row.id}`)

                    if (!isApiSuccess(data)) {
                        throw new Error(getApiMessage(data, '删除文章失败'))
                    }

                    this.$message.success(getApiMessage(data, '删除文章成功'))
                    this.fetchArticleList()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error(error.message || '删除文章失败')
                    }
                })
                .finally(() => {
                    this.deleteLoadingId = null
                })
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
            this.form = getDefaultArticleForm()
            this.clearFormValidate()
        },
        clearFormValidate() {
            this.$nextTick(() => {
                if (this.$refs.articleForm) {
                    this.$refs.articleForm.clearValidate()
                }
            })
        },
        formatDate(value) {
            if (!value) {
                return '-'
            }

            const date = new Date(value)
            if (Number.isNaN(date.getTime())) {
                return String(value).replace('T', ' ').replace(/\.\d+Z?$/, '')
            }

            return date.toLocaleString()
        }
    }
}
</script>

<style scoped>
.article-info-page {
    width: 100%;
}

.article-info-card {
    width: 100%;
    min-height: calc(100vh - 36px);
    border: 1px solid #ebeef5;
    border-radius: 8px;
}

.article-info-card :deep(.el-card__header) {
    padding: 18px 22px;
    border-bottom: 1px solid #eef0f3;
}

.article-info-card :deep(.el-card__body) {
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

.article-table {
    width: 100%;
}

.article-table :deep(.el-table__header th) {
    color: #374151;
    background: #f8fafc;
    font-weight: 600;
}

.article-form {
    padding: 8px 8px 0 0;
}

.form-row {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 12px;
}

.form-row .el-select {
    width: 100%;
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

@media (max-width: 720px) {
    .article-info-card :deep(.el-card__body) {
        padding: 14px;
    }

    .page-header {
        align-items: flex-start;
        flex-direction: column;
    }

    .page-header .el-button {
        width: 100%;
    }

    .form-row {
        grid-template-columns: 1fr;
        gap: 0;
    }
}
</style>
