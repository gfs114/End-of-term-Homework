<template>
    <section :class="['mine-page', { 'dark-mode': isDarkMode }]">
        <header class="profile-card" aria-label="个人资料">
            <div class="profile-main">
                <div class="profile-avatar" aria-hidden="true">
                    <span>{{ username.slice(0, 1) }}</span>
                </div>
                <div class="profile-copy">
                    <h1>{{ username }}</h1>
                    <div class="profile-info">
                        <div v-for="field in profileFields" :key="field.label" class="profile-info-row">
                            <span>{{ field.label }}</span>
                            <div class="profile-value-line">
                                <strong>{{ field.value }}</strong>
                                <el-button v-if="field.action === 'email' || field.action === 'edit-email'"
                                    type="primary" plain size="small" @click="openEmailDialog">
                                    {{ field.action === 'edit-email' ? '修改邮箱' : '添加邮箱' }}
                                </el-button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="profile-art" aria-hidden="true">
                <span></span>
                <span></span>
            </div>

            <div class="profile-actions">
                <!-- <button type="button" class="theme-toggle" @click="toggleMineTheme">
                    {{ themeButtonText }}
                </button> -->
                <el-button type="primary" class="change-button" @click="openPasswordDialog">
                    编辑资料
                </el-button>
            </div>
        </header>

        <div class="mine-layout">
            <main class="mine-feed">
                <nav class="mine-tabs" aria-label="个人内容导航">
                    <a href="#my-articles" :class="{ active: currentTab === 'articles' }"
                        @click.prevent="scrollToSection('my-articles', 'articles')">我的文章管理</a>
                    <a href="#favorite-articles" :class="{ active: currentTab === 'favorites' }"
                        @click.prevent="scrollToSection('favorite-articles', 'favorites')">收藏文章</a>
                    <a href="#favorite-devices" :class="{ active: currentTab === 'devices' }"
                        @click.prevent="scrollToSection('favorite-devices', 'devices')">我的设备</a>
                </nav>

                <Creater />

                <section id="my-articles" class="my-articles-card">
                    <div class="articles-head">
                        <div>
                            <p>我的内容</p>
                            <h2>我的文章管理</h2>
                        </div>
                        <el-button type="primary" plain @click="openArticleDialog('create')">新增文章</el-button>
                    </div>

                    <div v-if="articlesLoading" class="article-state">文章加载中...</div>
                    <div v-else-if="articlesError" class="article-state article-state--error">{{ articlesError }}</div>
                    <div v-else-if="!myArticles.length" class="article-state">你还没有自己的文章</div>

                    <div v-else class="article-manage-list">
                        <article v-for="article in myArticles" :key="article.id" class="article-manage-row">
                            <div class="post-avatar" aria-hidden="true">
                                <span>{{ username.slice(0, 1) }}</span>
                            </div>
                            <div class="post-body">
                                <div class="post-author">
                                    <strong>{{ username }}</strong>
                                    <time>{{ article.time }}</time>
                                </div>
                                <div class="article-title-line">
                                    <h3>{{ article.title }}</h3>
                                    <el-tag :type="isArticlePublished(article) ? 'success' : 'info'" effect="light">
                                        {{ getArticleStatusLabel(article.status) }}
                                    </el-tag>
                                </div>
                                <p>{{ article.summary }}</p>
                                <div class="article-meta-inline">
                                    <span>{{ article.category || '文章' }}</span>
                                </div>
                                <div class="article-actions">
                                    <el-button type="primary" link @click="goArticleDetail(article)">查看</el-button>
                                    <el-button type="primary" link @click="goArticleEdit(article)">编辑</el-button>
                                    <el-button v-if="!isArticlePublished(article)" type="success" link
                                        :loading="publishArticleLoadingId === article.id"
                                        @click="handlePublishArticle(article)">
                                        发表
                                    </el-button>
                                    <el-button type="danger" link :loading="deleteArticleLoadingId === article.id"
                                        @click="handleDeleteArticle(article)">
                                        删除
                                    </el-button>
                                </div>
                            </div>
                        </article>
                    </div>
                </section>

                <section id="favorite-articles" class="my-articles-card">
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
                        <router-link v-for="article in favoriteArticles" :key="article.id"
                            :to="`/article/${article.id}`" class="article-row">
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

                <section id="favorite-devices" class="my-articles-card">
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
                            <div class="device-row-actions">
                                <strong>{{ device.price }}</strong>
                                <el-button type="primary" plain @click.stop="goFavoriteDeviceDetail(device)">
                                    查看详情
                                </el-button>
                            </div>
                        </article>
                    </div>
                </section>
            </main>

            <aside class="mine-sidebar" aria-label="个人侧栏">
                <section class="side-card">
                    <h2>我的简介</h2>
                    <p>生动有趣的个人简介更容易受到关注</p>
                </section>

                <section class="side-card">
                    <h2>我的印记</h2>
                    <p>你暂时还没有获得印记</p>
                </section>

                <section class="side-card utility-card">
                    <h2>常用功能</h2>
                    <button type="button" @click="goSubmit">
                        <span class="utility-icon blue">帖</span>
                        <strong>帖子管理</strong>
                        <small>发布和管理我的文章</small>
                    </button>
                    <button type="button" @click="openPasswordDialog">
                        <span class="utility-icon violet">锁</span>
                        <strong>隐私设置</strong>
                        <small>管理账号密码</small>
                    </button>
                    <button type="button" @click="openEmailDialog">
                        <span class="utility-icon cyan">邮</span>
                        <strong>账号设置</strong>
                        <small>管理我的账号信息</small>
                    </button>
                </section>
            </aside>
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

        <transition name="password-modal">
            <div v-if="emailDialogVisible" class="password-overlay" @click.self="closeEmailDialog">
                <div class="password-dialog">
                    <div class="dialog-head">
                        <h2>{{ hasEmail ? '修改邮箱' : '添加邮箱' }}</h2>
                        <button type="button" class="dialog-close" @click="closeEmailDialog">×</button>
                    </div>

                    <el-form ref="emailFormRef" :model="emailForm" :rules="emailRules" label-position="top"
                        class="password-form">
                        <el-form-item label="邮箱" prop="email">
                            <el-input v-model.trim="emailForm.email" placeholder="请输入邮箱" />
                        </el-form-item>

                        <el-button type="primary" class="submit-button" :loading="emailLoading" @click="handleAddEmail">
                            保存邮箱
                        </el-button>
                    </el-form>
                </div>
            </div>
        </transition>

        <transition name="password-modal">
            <div v-if="articleDialogVisible" class="password-overlay" @click.self="closeArticleDialog">
                <div class="password-dialog article-dialog">
                    <div class="dialog-head">
                        <h2>{{ articleDialogMode === 'create' ? '新增文章' : '编辑文章' }}</h2>
                        <button type="button" class="dialog-close" @click="closeArticleDialog">×</button>
                    </div>

                    <el-form ref="articleFormRef" :model="articleForm" :rules="articleRules" label-position="top"
                        class="password-form article-edit-form">
                        <el-form-item label="文章标题" prop="title">
                            <el-input v-model.trim="articleForm.title" placeholder="请输入文章标题" maxlength="80" />
                        </el-form-item>

                        <el-form-item label="文章正文" prop="content">
                            <el-input v-model="articleForm.content" type="textarea" :rows="9" placeholder="请输入文章正文" />
                        </el-form-item>

                        <div class="article-form-grid">
                            <el-form-item label="分类" prop="category">
                                <el-input v-model.trim="articleForm.category" placeholder="请输入分类" maxlength="32" />
                            </el-form-item>
                            <el-form-item label="发表状态" prop="status">
                                <el-select v-model="articleForm.status" placeholder="请选择状态">
                                    <el-option label="草稿" value="draft" />
                                    <el-option label="已发表" value="published" />
                                </el-select>
                            </el-form-item>
                        </div>

                        <el-button type="primary" class="submit-button" :loading="articleSubmitLoading"
                            @click="handleSaveArticle">
                            保存文章
                        </el-button>
                    </el-form>
                </div>
            </div>
        </transition>
    </section>
</template>

<script>
import Creater from '@/components/articles/Creater.vue'
import http from '@/utils/http'

function pickList(payload) {
    if (Array.isArray(payload)) return payload
    if (Array.isArray(payload?.data)) return payload.data
    if (Array.isArray(payload?.articles)) return payload.articles
    if (Array.isArray(payload?.devices)) return payload.devices
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

function getDeviceOwner(item) {
    return item.username || item.userName || item.user_name || ''
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

function getDefaultArticleForm(username) {
    return {
        title: '',
        content: '',
        category: '默认',
        status: 'draft',
        author: username || ''
    }
}

export default {
    name: 'MinePage',
    components: {
        Creater
    },
    data() {
        const currentUsername = localStorage.getItem('loginUsername') || localStorage.getItem('adminUsername') || ''
        const validateEmail = (rule, value, callback) => {
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

            if (!value) {
                callback(new Error('请输入邮箱'))
            } else if (!emailPattern.test(value)) {
                callback(new Error('请输入正确的邮箱格式'))
            } else {
                callback()
            }
        }

        return {
            loading: false,
            emailLoading: false,
            articlesLoading: false,
            devicesLoading: false,
            articlesError: '',
            devicesError: '',
            passwordDialogVisible: false,
            emailDialogVisible: false,
            articleDialogVisible: false,
            articleDialogMode: 'create',
            articleSubmitLoading: false,
            publishArticleLoadingId: null,
            deleteArticleLoadingId: null,
            editingArticleId: null,
            mineTheme: localStorage.getItem('mineTheme') || 'light',
            theme: localStorage.getItem('theme') || 'dark',
            username: currentUsername || '未登录用户',
            email: '',
            currentTab: 'articles',
            allArticles: [],
            myArticles: [],
            favoriteArticles: [],
            favoriteDevices: [],
            articleForm: getDefaultArticleForm(currentUsername),
            emailForm: {
                email: ''
            },
            passwordForm: {
                oldPassword: '',
                newPassword: '',
                confirmPassword: ''
            },
            emailRules: {
                email: [
                    { required: true, validator: validateEmail, trigger: 'blur' }
                ]
            },
            articleRules: {
                title: [
                    { required: true, message: '请输入文章标题', trigger: 'blur' }
                ],
                content: [
                    { required: true, message: '请输入文章正文', trigger: 'blur' }
                ],
                category: [
                    { required: true, message: '请输入文章分类', trigger: 'blur' }
                ],
                status: [
                    { required: true, message: '请选择发表状态', trigger: 'change' }
                ]
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
        hasEmail() {
            return Boolean(String(this.email || '').trim())
        },
        profileFields() {
            return [
                { label: '用户名', value: this.username },
                {
                    label: '邮箱',
                    value: this.hasEmail ? this.email : '暂未绑定邮箱',
                    action: this.hasEmail ? 'edit-email' : 'email'
                }
            ]
        },
        passwordPayload() {
            return {
                username: this.username,
                oldPassword: this.passwordForm.oldPassword,
                newPassword: this.passwordForm.newPassword
            }
        },
        isDarkMode() {
            return this.theme !== 'light'
        },
        themeButtonText() {
            return this.isDarkMode ? '白天模式' : '夜间模式'
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

        this.username = this.getCurrentUsername()
        this.syncTheme()
        this.observeThemeChanges()
        this.fetchCurrentUserProfile()
        this.fetchMyArticles()
        this.fetchFavoriteDevices()
    },
    beforeUnmount() {
        if (this.themeObserver) {
            this.themeObserver.disconnect()
        }
    },
    methods: {
        getCurrentUsername() {
            return localStorage.getItem('loginUsername') || localStorage.getItem('adminUsername') || ''
        },
        scrollToSection(id, tab) {
            this.currentTab = tab
            const el = document.getElementById(id)
            if (el) {
                el.scrollIntoView({ behavior: 'smooth', block: 'start' })
            }
        },
        toggleMineTheme() {
            this.mineTheme = this.isDarkMode ? 'light' : 'dark'
            localStorage.setItem('mineTheme', this.mineTheme)
        },
        syncTheme() {
            this.theme = localStorage.getItem('theme') || 'dark'
        },
        observeThemeChanges() {
            this.themeObserver = new MutationObserver(() => {
                this.syncTheme()
            })
            this.themeObserver.observe(document.documentElement, {
                attributes: true,
                attributeFilter: ['data-theme']
            })
        },
        goSubmit() {
            this.$router.push('/submit')
        },
        goArticleDetail(article) {
            this.$router.push(`/article/${article.id}`)
        },
        goArticleEdit(article) {
            if (!article || !article.id) {
                this.$message.warning('文章信息不完整，无法编辑')
                return
            }

            try {
                sessionStorage.setItem('articleEditDraft', JSON.stringify({
                    articleId: String(article.id),
                    article
                }))
            } catch (error) {
                // The submit page can still load by id if session storage is unavailable.
            }

            this.$router.push({
                path: '/submit',
                query: { editId: article.id }
            })
        },
        isArticlePublished(article) {
            return String((article && article.status) || '') === 'published'
        },
        getArticleStatusLabel(status) {
            return String(status || '') === 'published' ? '已发表' : '草稿'
        },
        openArticleDialog(mode, article) {
            this.articleDialogMode = mode
            this.editingArticleId = article ? article.id : null
            this.articleDialogVisible = true

            if (mode === 'edit' && article) {
                this.articleForm = {
                    title: article.title || '',
                    content: article.content || '',
                    category: article.category || '默认',
                    status: article.status || 'draft',
                    author: article.author || this.getCurrentUsername()
                }
            } else {
                this.resetArticleForm()
            }

            this.clearArticleFormValidate()
        },
        closeArticleDialog() {
            if (this.articleSubmitLoading) {
                return
            }

            this.articleDialogVisible = false
            this.editingArticleId = null
            this.resetArticleForm()
        },
        buildArticlePayload(status) {
            return {
                title: this.articleForm.title,
                content: this.articleForm.content,
                author: this.getCurrentUsername(),
                category: this.articleForm.category,
                status: status || this.articleForm.status
            }
        },
        handleSaveArticle() {
            this.$refs.articleFormRef.validate(async (valid) => {
                if (!valid || this.articleSubmitLoading) {
                    return
                }

                this.articleSubmitLoading = true

                try {
                    const payload = this.buildArticlePayload()
                    const request = this.articleDialogMode === 'create'
                        ? http.post('/articles', payload)
                        : http.put(`/articles/${this.editingArticleId}`, payload)
                    const { data } = await request

                    if (!isApiSuccess(data)) {
                        throw new Error(getApiMessage(data, this.articleDialogMode === 'create' ? '新增文章失败' : '修改文章失败'))
                    }

                    this.$message.success(getApiMessage(data, this.articleDialogMode === 'create' ? '新增文章成功' : '修改文章成功'))
                    this.articleDialogVisible = false
                    this.editingArticleId = null
                    this.resetArticleForm()
                    this.fetchMyArticles()
                } catch (error) {
                    const data = error.response && error.response.data
                    this.$message.error((data && (data.message || data.msg)) || error.message || '保存文章失败')
                } finally {
                    this.articleSubmitLoading = false
                }
            })
        },
        handlePublishArticle(article) {
            this.$confirm(`确认发表文章“${article.title || article.id}”吗？`, '发表确认', {
                confirmButtonText: '确认发表',
                cancelButtonText: '取消',
                type: 'success'
            })
                .then(async () => {
                    this.publishArticleLoadingId = article.id
                    const { data } = await http.put(`/articles/${article.id}`, {
                        title: article.title || '',
                        content: article.content || '',
                        author: article.author || this.getCurrentUsername(),
                        category: article.category || '默认',
                        status: 'published'
                    })

                    if (!isApiSuccess(data)) {
                        throw new Error(getApiMessage(data, '发表文章失败'))
                    }

                    this.$message.success(getApiMessage(data, '发表文章成功'))
                    this.fetchMyArticles()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error(error.message || '发表文章失败')
                    }
                })
                .finally(() => {
                    this.publishArticleLoadingId = null
                })
        },
        handleDeleteArticle(article) {
            this.$confirm(`确认删除文章“${article.title || article.id}”吗？`, '删除确认', {
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                type: 'warning'
            })
                .then(async () => {
                    this.deleteArticleLoadingId = article.id
                    const { data } = await http.delete(`/articles/${article.id}`)

                    if (!isApiSuccess(data)) {
                        throw new Error(getApiMessage(data, '删除文章失败'))
                    }

                    this.$message.success(getApiMessage(data, '删除文章成功'))
                    this.fetchMyArticles()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error(error.message || '删除文章失败')
                    }
                })
                .finally(() => {
                    this.deleteArticleLoadingId = null
                })
        },
        async fetchCurrentUserProfile() {
            try {
                const user = await this.findCurrentUser()
                this.syncEmailFromProfile(user)
            } catch (error) {
                console.log(error)
            }
        },
        syncEmailFromProfile(user) {
            const email = String((user && user.email) || '').trim()
            this.email = email

            if (email) {
                localStorage.setItem('loginEmail', email)
                return
            }

            localStorage.removeItem('loginEmail')
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
                content: item.content || '',
                summary: plainText(item.summary || item.description || item.content).slice(0, 96) || '暂无摘要',
                category: item.category,
                status: item.status || 'draft',
                views: Number(item.views) || 0,
                favorites: Number(item.favorites) || 0,
                createdAt: item.created_at,
                updatedAt: item.updated_at,
                time: formatTime(item.created_at || item.updated_at)
            }
        },
        normalizeDevice(item) {
            const type = item.device_type || item.deviceType || ''
            const model = item.device_model || item.deviceModel || '未知设备'

            return {
                key: `${type}:${model}`,
                username: getDeviceOwner(item),
                type,
                typeLabel: type === 'phone' ? '手机' : type === 'computer' ? '电脑' : '设备',
                brand: item.device_brand || item.deviceBrand || '',
                model,
                price: item.device_price || item.devicePrice || '暂无价格',
                specs: item.device_specs || item.deviceSpecs || '暂无配置'
            }
        },
        goFavoriteDeviceDetail(device) {
            if (!device || !device.model) {
                this.$message.warning('设备信息不完整，无法查看详情')
                return
            }

            if (device.type === 'phone') {
                this.$router.push({
                    path: '/phone',
                    query: { phoneModel: device.model }
                })
                return
            }

            if (device.type === 'computer') {
                this.$router.push({
                    path: '/computer',
                    query: { computerModel: device.model }
                })
                return
            }

            this.$message.warning('暂不支持查看该设备详情')
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
                const username = this.getCurrentUsername()
                if (!username) {
                    this.favoriteDevices = []
                    return
                }

                const { data } = await http.get('/user-favorite-devices', {
                    params: { username }
                })
                if (!isApiSuccess(data)) {
                    throw new Error(getApiMessage(data, '我喜欢的设备加载失败，请稍后再试'))
                }

                this.favoriteDevices = pickList(data)
                    .filter((item) => {
                        const owner = getDeviceOwner(item)
                        return !owner || String(owner) === String(username)
                    })
                    .map((item) => this.normalizeDevice(item))
            } catch (error) {
                this.devicesError = error.message || '我喜欢的设备加载失败，请稍后再试'
            } finally {
                this.devicesLoading = false
            }
        },
        openPasswordDialog() {
            this.passwordDialogVisible = true
        },
        openEmailDialog() {
            this.emailForm.email = this.hasEmail ? this.email : ''
            this.emailDialogVisible = true
        },
        closePasswordDialog() {
            if (this.loading) {
                return
            }

            this.passwordDialogVisible = false
            this.resetPasswordForm()
        },
        closeEmailDialog() {
            if (this.emailLoading) {
                return
            }

            this.emailDialogVisible = false
            this.resetEmailForm()
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
        async findCurrentUser() {
            const username = this.getCurrentUsername()
            const response = await http.get('/users')
            const users = pickList(response.data)

            return users.find((user) => (
                String(user.username || '') === String(username) ||
                String(user.email || '') === String(username)
            ))
        },
        handleAddEmail() {
            this.$refs.emailFormRef.validate(async (valid) => {
                if (!valid || this.emailLoading) {
                    return
                }

                this.emailLoading = true

                try {
                    const email = this.emailForm.email
                    const user = await this.findCurrentUser()

                    if (!user) {
                        this.$message.error('未找到当前用户')
                        return
                    }

                    const response = await http.put(`/users/${user.id}`, {
                        username: user.username || this.getCurrentUsername(),
                        email
                    })
                    const result = response.data || response

                    if (!isApiSuccess(result)) {
                        throw new Error('邮箱保存失败')
                    }

                    this.syncEmailFromProfile({ email })
                    this.$message.success(this.hasEmail ? '邮箱修改成功' : '邮箱添加成功')
                    this.closeEmailDialog()
                } catch (error) {
                    const data = error.response && error.response.data
                    this.$message.error((data && (data.message || data.msg)) || error.message || '邮箱保存失败')
                } finally {
                    this.emailLoading = false
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
        },
        resetEmailForm() {
            this.emailForm = {
                email: ''
            }

            this.$nextTick(() => {
                if (this.$refs.emailFormRef) {
                    this.$refs.emailFormRef.clearValidate()
                }
            })
        },
        resetArticleForm() {
            this.articleForm = getDefaultArticleForm(this.getCurrentUsername())
            this.clearArticleFormValidate()
        },
        clearArticleFormValidate() {
            this.$nextTick(() => {
                if (this.$refs.articleFormRef) {
                    this.$refs.articleFormRef.clearValidate()
                }
            })
        }
    }
}
</script>

<style scoped>
.mine-page {
    width: min(1250px, calc(100% - 32px));
    min-height: calc(100vh - 96px);
    margin: -24px auto;
    padding: 16px 0 56px;
    color: #cfd3dc;
    font-family: "PingFang SC", "Microsoft YaHei", "Noto Sans SC", sans-serif;
}

.mine-page::before {
    content: "";
    position: fixed;
    inset: 0;
    z-index: -1;
}

.profile-card {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 140px;
    padding: 24px 30px;
    overflow: hidden;
    border: 1px solid rgba(255, 255, 255, 0.04);
    border-radius: 16px;
}

.profile-main {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: center;
    gap: 22px;
    min-width: 0;
}

.profile-avatar,
.post-avatar {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    color: #fff;
    border-radius: 50%;
    font-weight: 900;
    box-shadow: inset 0 0 0 2px rgba(255, 255, 255, 0.18), 0 10px 28px rgba(0, 0, 0, 0.35);
}

.profile-avatar {
    width: 96px;
    height: 96px;
    font-size: 34px;
}

.post-avatar {
    width: 48px;
    height: 48px;
    font-size: 17px;
}

.profile-copy {
    min-width: 0;
}

.profile-copy h1 {
    margin: 0 0 10px;
    color: #e9edf4;
    font-size: 26px;
    font-weight: 800;
    line-height: 1.2;
}

.profile-info {
    display: flex;
    flex-wrap: wrap;
    gap: 12px 18px;
}

.profile-info-row {
    display: flex;
    align-items: center;
    gap: 8px;
    min-width: 0;
}

.profile-info span {
    color: #8d929c;
    font-size: 14px;
    font-weight: 700;
}

.profile-info strong {
    color: #b8bec9;
    font-size: 14px;
    font-weight: 700;
    word-break: break-all;
}

.profile-value-line {
    display: flex;
    align-items: center;
    gap: 8px;
}

.profile-value-line .el-button {
    height: 24px;
    padding: 0 8px;
}

.profile-art {
    position: absolute;
    right: -18px;
    top: -12px;
    width: 260px;
    height: 160px;
    opacity: 0.82;
}

.profile-art span {
    position: absolute;
    display: block;
    border-radius: 48px;
    filter: drop-shadow(0 18px 20px rgba(0, 0, 0, 0.28));
}

.profile-art span:first-child {
    right: 36px;
    top: 20px;
    width: 160px;
    height: 102px;
    transform: rotate(-7deg);
}

.profile-art span:last-child {
    right: -4px;
    top: 4px;
    width: 120px;
    height: 122px;
    border: 3px solid rgba(255, 255, 255, 0.2);
    transform: rotate(15deg);
}

.change-button {
    position: relative;
    z-index: 3;
    width: auto;
    height: 40px;
    padding: 0 20px;
    border: 0;
    border-radius: 999px;
    color: #fff;
    font-weight: 800;
}

.mine-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 372px;
    gap: 60px;
    align-items: start;
    margin-top: 26px;
    padding: 0 12px;
}

.mine-feed {
    min-width: 0;
}

.mine-tabs {
    display: flex;
    align-items: center;
    gap: 34px;
    min-height: 42px;
    margin-bottom: 18px;
    padding-left: 2px;
}

.mine-tabs a {
    position: relative;
    color: #c8cdd7;
    text-decoration: none;
    font-size: 18px;
    font-weight: 800;
}

.mine-tabs a.active {
    color: #f4f7fb;
}

.mine-tabs a.active::after {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    bottom: -9px;
    height: 3px;
    border-radius: 999px;
}

.mine-sidebar {
    position: sticky;
    top: 24px;
    display: grid;
    gap: 24px;
}

.side-card {
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.07);
    border-radius: 10px;
}

.side-card h2 {
    margin: 0 0 16px;
    color: #d8dce5;
    font-size: 20px;
    font-weight: 900;
}

.side-card p {
    margin: 0;
    color: #8d929c;
    font-size: 15px;
    font-weight: 700;
    line-height: 1.6;
}

.utility-card {
    display: grid;
    gap: 18px;
}

.utility-card button {
    display: grid;
    grid-template-columns: 46px minmax(0, 1fr);
    grid-template-rows: auto auto;
    column-gap: 12px;
    align-items: center;
    min-height: 52px;
    padding: 0;
    border: 0;
    color: inherit;
    cursor: pointer;
    background: transparent;
    text-align: left;
}

.utility-icon {
    grid-row: 1 / span 2;
    display: grid;
    place-items: center;
    width: 46px;
    height: 46px;
    color: #fff;
    border-radius: 50%;
    font-size: 15px;
    font-weight: 900;
}

.utility-icon.blue {}

.utility-icon.violet {}

.utility-icon.cyan {}

.utility-card strong {
    color: #d8dce5;
    font-size: 17px;
    font-weight: 900;
}

.utility-card small {
    color: #7f858f;
    font-size: 13px;
    font-weight: 700;
}

.my-articles-card {
    margin-top: 26px;
}

.articles-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    margin-bottom: 14px;
}

.articles-head p {
    margin: 0 0 6px;
    color: #7f858f;
    font-size: 13px;
    font-weight: 800;
}

.articles-head h2 {
    margin: 0;
    color: #e3e7ef;
    font-size: 19px;
    font-weight: 900;
}

.article-state {
    display: grid;
    min-height: 126px;
    place-items: center;
    color: #8d929c;
    border: 1px solid rgba(255, 255, 255, 0.07);
    border-radius: 10px;
    font-weight: 800;
}

.article-state--error {
    color: #ff7b72;
}

.article-manage-list,
.article-list,
.device-list {
    display: grid;
    gap: 20px;
}

.article-manage-row {
    display: grid;
    grid-template-columns: 48px minmax(0, 1fr);
    gap: 14px;
    align-items: start;
    padding: 14px 0 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.post-body {
    min-width: 0;
}

.post-author {
    display: flex;
    flex-wrap: wrap;
    align-items: baseline;
    gap: 8px;
    margin-bottom: 10px;
}

.post-author strong {
    color: #dce1ea;
    font-size: 16px;
    font-weight: 900;
}

.post-author time,
.article-meta {
    color: #787f8a;
    font-size: 13px;
    font-weight: 700;
}

.article-title-line {
    display: flex;
    align-items: center;
    gap: 10px;
    min-width: 0;
    margin-bottom: 8px;
}

.article-title-line h3,
.article-row h3,
.device-row h3 {
    margin: 0;
    overflow: hidden;
    color: #d9dee8;
    font-size: 17px;
    font-weight: 900;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.article-manage-row p,
.article-row p,
.device-row p {
    display: -webkit-box;
    margin: 8px 0 0;
    overflow: hidden;
    color: #b8bec9;
    font-size: 15px;
    font-weight: 700;
    line-height: 1.65;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
}

.article-meta-inline {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 8px;
}

.article-meta-inline span,
.article-meta span,
.device-type {
    display: inline-flex;
    padding: 3px 9px;
    color: #64a5ff;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 800;
}

.article-actions {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    gap: 26px;
    margin-top: 12px;
}

.article-actions .el-button {
    margin-left: 0;
    color: #9aa1ad;
    font-size: 15px;
    font-weight: 800;
}

.article-row,
.device-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) auto;
    gap: 18px;
    align-items: center;
    padding: 16px 0 18px;
    color: inherit;
    text-decoration: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.article-meta {
    display: grid;
    justify-items: end;
    gap: 8px;
}

.device-row strong {
    color: #e0e5ee;
    white-space: nowrap;
}

.device-row-actions {
    display: grid;
    justify-items: end;
    gap: 10px;
}

.password-overlay {
    position: fixed;
    inset: 0;
    z-index: 1500;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
    backdrop-filter: blur(12px);
}

.password-dialog {
    width: min(460px, 100%);
    padding: 24px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 14px;
    box-shadow: 0 24px 90px rgba(0, 0, 0, 0.42);
}

.article-dialog {
    width: min(720px, 100%);
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
    color: #eef2f8;
    font-size: 24px;
}

.dialog-close {
    width: 34px;
    height: 34px;
    color: #aab1bd;
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 8px;
    cursor: pointer;
    background: rgba(255, 255, 255, 0.04);
    font-size: 24px;
    line-height: 1;
}

.dialog-close:hover {
    color: #fff;
    border-color: #2b74ff;
}

.password-form {
    width: 100%;
}

.password-form :deep(.el-form-item__label) {
    color: #cfd3dc;
    font-weight: 800;
}

.submit-button {
    width: 100%;
    height: 40px;
}

.article-form-grid {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(0, 180px);
    gap: 14px;
}

.article-form-grid .el-select {
    width: 100%;
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

@media (max-width: 980px) {
    .mine-layout {
        grid-template-columns: 1fr;
        gap: 28px;
    }

    .mine-sidebar {
        position: static;
    }
}

@media (max-width: 640px) {
    .mine-page {
        width: min(100% - 20px, 560px);
        margin: -18px auto;
        padding-bottom: 34px;
    }

    .profile-card {
        align-items: flex-start;
        flex-direction: column;
        gap: 18px;
        padding: 20px;
    }

    .profile-main {
        align-items: flex-start;
    }

    .profile-avatar {
        width: 70px;
        height: 70px;
        font-size: 24px;
    }

    .profile-art {
        opacity: 0.3;
    }

    .change-button {
        width: 100%;
    }

    .mine-layout {
        padding: 0;
    }

    .mine-tabs {
        gap: 22px;
        overflow-x: auto;
        scrollbar-width: none;
    }

    .mine-tabs::-webkit-scrollbar {
        display: none;
    }

    .articles-head,
    .article-row,
    .device-row {
        grid-template-columns: 1fr;
        align-items: flex-start;
    }

    .article-manage-row {
        grid-template-columns: 1fr;
    }

    .post-avatar {
        display: none;
    }

    .article-meta,
    .device-row-actions {
        justify-items: start;
    }

    .article-form-grid {
        grid-template-columns: 1fr;
        gap: 0;
    }

    .password-overlay {
        align-items: flex-end;
        padding: 14px;
    }

    .password-dialog {
        padding: 20px;
    }
}

.mine-page {
    color: #202938;
}

.mine-page::before {}

.profile-card {
    border-color: #e4e9f2;
    box-shadow: 0 22px 70px rgba(31, 45, 71, 0.1);
}

.profile-copy h1 {
    color: #172033;
}

.profile-info span,
.side-card p,
.utility-card small,
.articles-head p,
.article-state,
.post-author time,
.article-meta {
    color: #687386;
}

.profile-info strong,
.article-manage-row p,
.article-row p,
.device-row p {
    color: #3f4b5f;
}

.profile-art span {}

.profile-actions {
    position: relative;
    z-index: 3;
    display: flex;
    align-items: center;
    gap: 12px;
}

.theme-toggle {
    height: 40px;
    padding: 0 18px;
    border: 1px solid #d7dfeb;
    border-radius: 999px;
    color: #263244;
    cursor: pointer;
    background: rgba(255, 255, 255, 0.78);
    font-weight: 800;
}

.theme-toggle:hover {
    border-color: #2b74ff;
    color: #2b74ff;
}

.change-button {
    color: #fff;
    background: #2563eb;
}

.mine-tabs a {
    color: #5d687b;
}

.mine-tabs a.active,
.side-card h2,
.articles-head h2,
.article-title-line h3,
.article-row h3,
.device-row h3,
.utility-card strong,
.post-author strong,
.device-row strong {
    color: #1f2937;
}

.side-card {
    border-color: #e2e8f0;
    background: rgba(255, 255, 255, 0.86);
    box-shadow: 0 18px 48px rgba(31, 45, 71, 0.08);
}

.article-state {
    border-color: #dbe3ef;
    background: rgba(255, 255, 255, 0.72);
}

.article-manage-row,
.article-row,
.device-row {
    border-bottom-color: #e0e7f0;
}

.article-actions .el-button {
    color: #4b5563;
}

.password-overlay {
    background: rgba(15, 23, 42, 0.42);
}

.password-dialog {
    border-color: #dbe3ef;
    background: #ffffff;
}

.dialog-head h2,
.password-form :deep(.el-form-item__label) {
    color: #1f2937;
}

.dialog-close {
    color: #5f6b7c;
    border-color: #d7dfeb;
    background: #fff;
}

.mine-page.dark-mode {
    color: #cfd3dc;
    background: #0d0f11;
}

.mine-page.dark-mode::before {
    background: #0a0b0d;
}

.mine-page.dark-mode .profile-card {
    border-color: rgba(255, 255, 255, 0.04);
    background: #141922;
    box-shadow: none;
}

.mine-page.dark-mode .profile-copy h1,
.mine-page.dark-mode .mine-tabs a.active,
.mine-page.dark-mode .side-card h2,
.mine-page.dark-mode .articles-head h2,
.mine-page.dark-mode .article-title-line h3,
.mine-page.dark-mode .article-row h3,
.mine-page.dark-mode .device-row h3,
.mine-page.dark-mode .utility-card strong,
.mine-page.dark-mode .post-author strong,
.mine-page.dark-mode .device-row strong {
    color: #e9edf4;
}

.mine-page.dark-mode .profile-info span,
.mine-page.dark-mode .side-card p,
.mine-page.dark-mode .utility-card small,
.mine-page.dark-mode .articles-head p,
.mine-page.dark-mode .article-state,
.mine-page.dark-mode .post-author time,
.mine-page.dark-mode .article-meta {
    color: #8d929c;
}

.mine-page.dark-mode .profile-info strong,
.mine-page.dark-mode .article-manage-row p,
.mine-page.dark-mode .article-row p,
.mine-page.dark-mode .device-row p {
    color: #b8bec9;
}

.mine-page.dark-mode .profile-art span {
    background: rgba(148, 163, 184, 0.9);
}

.mine-page.dark-mode .theme-toggle {
    color: #e5e7eb;
    border-color: rgba(255, 255, 255, 0.12);
    background: rgba(255, 255, 255, 0.06);
}

.mine-page.dark-mode .change-button {
    color: #fff;
    background: #0b0c0f;
}

.mine-page.dark-mode .mine-tabs a {
    color: #c8cdd7;
}

.mine-page.dark-mode .side-card {
    border-color: rgba(255, 255, 255, 0.07);
    background: rgba(13, 15, 17, 0.78);
    box-shadow: none;
}

.mine-page.dark-mode .article-state {
    border-color: rgba(255, 255, 255, 0.07);
    background: rgba(255, 255, 255, 0.025);
}

.mine-page.dark-mode .article-manage-row,
.mine-page.dark-mode .article-row,
.mine-page.dark-mode .device-row {
    border-bottom-color: rgba(255, 255, 255, 0.08);
}

.mine-page.dark-mode .article-actions .el-button {
    color: #9aa1ad;
}

.mine-page.dark-mode .password-overlay {
    background: rgba(0, 0, 0, 0.72);
}

.mine-page.dark-mode .password-dialog {
    border-color: rgba(255, 255, 255, 0.1);
    background: #161a20;
}

.mine-page.dark-mode .dialog-head h2,
.mine-page.dark-mode .password-form :deep(.el-form-item__label) {
    color: #eef2f8;
}

.mine-page.dark-mode .dialog-close {
    color: #aab1bd;
    border-color: rgba(255, 255, 255, 0.12);
    background: rgba(255, 255, 255, 0.04);
}

@media (max-width: 640px) {
    .profile-actions {
        width: 100%;
        align-items: stretch;
        flex-direction: column;
    }

    .theme-toggle {
        width: 100%;
    }
}
</style>
