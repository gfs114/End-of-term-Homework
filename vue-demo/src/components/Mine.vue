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

        <Creater />

        <section class="my-articles-card">
            <div class="articles-head">
                <div>
                    <p>我的内容</p>
                    <h2>我的文章</h2>
                </div>
                <el-button type="primary" plain @click="goSubmit">去投稿</el-button>
            </div>

            <div v-if="articlesLoading" class="article-state">文章加载中...</div>
            <div v-else-if="articlesError" class="article-state article-state--error">{{ articlesError }}</div>
            <div v-else-if="!myArticles.length" class="article-state">你还没有投稿文章</div>

            <div v-else class="article-list">
                <router-link
                    v-for="article in myArticles"
                    :key="article.id"
                    :to="`/article/${article.id}`"
                    class="article-row"
                >
                    <div>
                        <h3>{{ article.title }}</h3>
                        <p>{{ article.summary }}</p>
                    </div>
                    <div class="article-meta">
                        <span>{{ article.category || '文章' }}</span>
                        <time>{{ article.time }}</time>
                    </div>
                </router-link>
            </div>
        </section>

        <section class="my-articles-card">
            <div class="articles-head">
                <div>
                    <p>我的收藏</p>
                    <h2>收藏文章</h2>
                </div>
            </div>

            <div v-if="articlesLoading" class="article-state">收藏加载中...</div>
            <div v-else-if="articlesError" class="article-state article-state--error">{{ articlesError }}</div>
            <div v-else-if="!favoriteArticles.length" class="article-state">你还没有收藏文章</div>

            <div v-else class="article-list">
                <router-link
                    v-for="article in favoriteArticles"
                    :key="article.id"
                    :to="`/article/${article.id}`"
                    class="article-row"
                >
                    <div>
                        <h3>{{ article.title }}</h3>
                        <p>{{ article.summary }}</p>
                    </div>
                    <div class="article-meta">
                        <span>{{ article.category || '文章' }}</span>
                        <time>{{ article.time }}</time>
                    </div>
                </router-link>
            </div>
        </section>

        <section class="my-articles-card">
            <div class="articles-head">
                <div>
                    <p>我的设备</p>
                    <h2>我喜欢的设备</h2>
                </div>
            </div>

            <div v-if="devicesLoading" class="article-state">设备加载中...</div>
            <div v-else-if="devicesError" class="article-state article-state--error">{{ devicesError }}</div>
            <div v-else-if="!favoriteDevices.length" class="article-state">你还没有喜欢的设备</div>

            <div v-else class="device-list">
                <article v-for="device in favoriteDevices" :key="device.key" class="device-row">
                    <div>
                        <span class="device-type">{{ device.typeLabel }}</span>
                        <h3>{{ device.brand }} {{ device.model }}</h3>
                        <p>{{ device.specs }}</p>
                    </div>
                    <strong>{{ device.price }}</strong>
                </article>
            </div>
        </section>

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
import Creater from '@/components/Creater.vue'
import http from '@/utils/http'

function pickList(payload) {
    if (Array.isArray(payload)) return payload
    if (Array.isArray(payload?.data)) return payload.data
    if (Array.isArray(payload?.articles)) return payload.articles
    if (Array.isArray(payload?.devices)) return payload.devices
    if (Array.isArray(payload?.data?.data)) return payload.data.data
    return []
}

function plainText(value) {
    return String(value || '')
        .replace(/<[^>]+>/g, '')
        .replace(/\s+/g, ' ')
        .trim()
}

function formatTime(value) {
    if (!value) return '刚刚'
    const date = new Date(value)
    if (Number.isNaN(date.getTime())) return String(value)
    return date.toLocaleString('zh-CN', {
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    })
}

export default {
    name: 'MinePage',
    components: {
        Creater
    },
    data() {
        const currentUsername = localStorage.getItem('loginUsername') || localStorage.getItem('adminUsername') || ''

        return {
            loading: false,
            articlesLoading: false,
            devicesLoading: false,
            articlesError: '',
            devicesError: '',
            passwordDialogVisible: false,
            username: currentUsername || '未登录用户',
            email: localStorage.getItem('loginEmail') || '暂未绑定邮箱',
            allArticles: [],
            myArticles: [],
            favoriteArticles: [],
            favoriteDevices: [],
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
        if (!this.getCurrentUsername()) {
            this.$message.warning('请先登录')
            this.$router.push({
                path: '/login',
                query: { redirect: '/mine' }
            })
            return
        }

        this.fetchMyArticles()
        this.fetchFavoriteDevices()
    },
    methods: {
        getCurrentUsername() {
            return localStorage.getItem('loginUsername') || localStorage.getItem('adminUsername') || ''
        },
        goSubmit() {
            this.$router.push('/submit')
        },
        getFavoriteIds() {
            try {
                const ids = JSON.parse(localStorage.getItem(`favoriteArticles:${this.username}`) || '[]')
                return Array.isArray(ids) ? ids.map(String) : []
            } catch (error) {
                return []
            }
        },
        normalizeArticle(item) {
            return {
                id: item.id,
                title: item.title || '未命名文章',
                author: item.author,
                summary: plainText(item.summary || item.description || item.content).slice(0, 96) || '暂无摘要',
                category: item.category,
                time: formatTime(item.created_at || item.updated_at)
            }
        },
        normalizeDevice(item) {
            const type = item.device_type || item.deviceType || ''
            const model = item.device_model || item.deviceModel || '未知设备'

            return {
                key: `${type}:${model}`,
                type,
                typeLabel: type === 'phone' ? '手机' : type === 'computer' ? '电脑' : '设备',
                brand: item.device_brand || item.deviceBrand || '',
                model,
                price: item.device_price || item.devicePrice || '暂无价格',
                specs: item.device_specs || item.deviceSpecs || '暂无配置'
            }
        },
        async fetchMyArticles() {
            this.articlesLoading = true
            this.articlesError = ''

            try {
                const { data } = await http.get('/articles')
                const favoriteIds = this.getFavoriteIds()

                this.allArticles = pickList(data).map((item) => this.normalizeArticle(item))
                this.myArticles = this.allArticles.filter((item) => String(item.author || '') === this.username)
                this.favoriteArticles = this.allArticles.filter((item) => favoriteIds.includes(String(item.id)))
            } catch (error) {
                this.articlesError = '我的文章加载失败，请稍后再试'
            } finally {
                this.articlesLoading = false
            }
        },
        async fetchFavoriteDevices() {
            this.devicesLoading = true
            this.devicesError = ''

            try {
                const { data } = await http.get('/user-favorite-devices', {
                    params: { username: this.username }
                })
                this.favoriteDevices = pickList(data).map((item) => this.normalizeDevice(item))
            } catch (error) {
                this.devicesError = '我喜欢的设备加载失败，请稍后再试'
            } finally {
                this.devicesLoading = false
            }
        },
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
    width: min(1120px, 100%);
    margin: 0 auto;
    color: #152033;
}

.profile-card,
.my-articles-card {
    padding: 24px;
    border: 1px solid #dbe7f3;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.92);
    box-shadow: 0 18px 50px rgba(45, 73, 112, 0.08);
}

.my-articles-card {
    margin-top: 22px;
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

.articles-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    margin-bottom: 18px;
}

.articles-head p {
    margin: 0 0 6px;
    color: #2563eb;
    font-size: 13px;
    font-weight: 700;
}

.articles-head h2 {
    margin: 0;
    color: #101827;
    font-size: 26px;
}

.article-state {
    display: grid;
    min-height: 120px;
    place-items: center;
    color: #64748b;
    border: 1px dashed #cbd5e1;
    border-radius: 8px;
    background: #f8fafc;
}

.article-state--error {
    color: #dc2626;
}

.article-list {
    display: grid;
    gap: 12px;
}

.article-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 150px;
    gap: 18px;
    align-items: center;
    padding: 16px;
    color: inherit;
    text-decoration: none;
    border: 1px solid #eef3f8;
    border-radius: 8px;
    background: #fff;
    transition: border-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
}

.article-row:hover {
    border-color: #93c5fd;
    transform: translateY(-2px);
    box-shadow: 0 14px 34px rgba(37, 99, 235, 0.1);
}

.article-row h3 {
    margin: 0 0 8px;
    overflow: hidden;
    color: #172033;
    font-size: 18px;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.article-row p {
    display: -webkit-box;
    margin: 0;
    overflow: hidden;
    color: #64748b;
    font-size: 14px;
    line-height: 1.6;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
}

.article-meta {
    display: grid;
    justify-items: end;
    gap: 8px;
    color: #64748b;
    font-size: 13px;
}

.article-meta span {
    padding: 4px 10px;
    color: #2563eb;
    border-radius: 999px;
    background: #eff6ff;
    font-weight: 700;
}

.device-list {
    display: grid;
    gap: 12px;
}

.device-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) auto;
    gap: 18px;
    align-items: center;
    padding: 16px;
    border: 1px solid #eef3f8;
    border-radius: 8px;
    background: #fff;
}

.device-type {
    display: inline-flex;
    margin-bottom: 8px;
    padding: 4px 10px;
    color: #2563eb;
    border-radius: 999px;
    background: #eff6ff;
    font-size: 13px;
    font-weight: 700;
}

.device-row h3 {
    margin: 0 0 8px;
    color: #172033;
    font-size: 18px;
}

.device-row p {
    margin: 0;
    color: #64748b;
    font-size: 14px;
    line-height: 1.6;
}

.device-row strong {
    color: #253247;
    white-space: nowrap;
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

    .articles-head,
    .article-row,
    .device-row {
        grid-template-columns: 1fr;
    }

    .articles-head {
        align-items: flex-start;
        flex-direction: column;
    }

    .article-meta {
        justify-items: start;
    }

    .password-overlay {
        align-items: flex-end;
        padding: 14px;
    }
}
</style>
