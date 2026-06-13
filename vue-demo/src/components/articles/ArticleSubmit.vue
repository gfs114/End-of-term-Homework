<template>
  <div class="editor-app">
    <main class="editor-body">
      <div class="editor-container">
        <el-form ref="submitForm" :model="form" :rules="rules" class="editor-form">
          <el-form-item prop="title" class="title-group">
            <textarea ref="titleInput" v-model="form.title" class="title-input" placeholder="请输入标题（建议 30 字以内）"
              maxlength="80" rows="1" @input="autoResizeTitle"></textarea>
          </el-form-item>

          <el-form-item prop="content" class="content-group">
            <div class="content-wrapper">
              <textarea ref="contentInput" v-model="form.content" class="content-input" placeholder="开始书写..."
                maxlength="100000"></textarea>
            </div>
          </el-form-item>
        </el-form>
      </div>
    </main>

    <div v-if="lastSaveTime" class="save-indicator">
      <el-icon class="save-icon"><CircleCheck /></el-icon>
      <span>{{ lastSaveTime }} 已自动保存</span>
      <span class="save-divider">·</span>
      <span>{{ contentCharCount }} / 100000 字</span>
    </div>

    <footer class="bottom-bar">
      <div class="bottom-bar-inner">
        <div class="bottom-left">
          <router-link to="/hello" class="bottom-back-link">
            <el-icon><ArrowLeft /></el-icon>
          </router-link>
          <el-select v-model="form.category" class="category-select" placeholder="选择分类">
            <el-option v-for="item in categories" :key="item" :label="item" :value="item" />
          </el-select>
        </div>
        <div class="bottom-right">
          <button type="button" class="btn btn-draft" :disabled="draftLoading || publishLoading" @click="submitAsDraft">
            <span v-if="draftLoading" class="btn-spinner"></span>
            保存草稿
          </button>
          <button type="button" class="btn btn-publish" :disabled="draftLoading || publishLoading"
            @click="submitAsPublished">
            <span v-if="publishLoading" class="btn-spinner"></span>
            {{ isEditMode ? '保存修改' : '发布文章' }}
          </button>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
import http from '@/utils/http'

// 从新建文章接口返回中提取文章 id。
function pickCreatedId(payload) {
  return payload?.data?.id || payload?.article?.id || payload?.id
}

// 兼容列表接口的多种返回结构。
function pickList(payload) {
  if (Array.isArray(payload)) return payload
  if (Array.isArray(payload?.data)) return payload.data
  if (Array.isArray(payload?.articles)) return payload.articles
  if (Array.isArray(payload?.data?.data)) return payload.data.data
  return []
}

// 兼容详情接口的多种返回结构。
function pickArticle(payload) {
  if (payload?.data && !Array.isArray(payload.data)) return payload.data
  if (payload?.article) return payload.article
  if (payload?.id) return payload
  return null
}

// 生成底部自动保存提示展示的时间。
function formatSaveTime() {
  const now = new Date()
  return now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
}

export default {
  name: 'ArticleSubmit',
  data() {
    const loginUsername = localStorage.getItem('loginUsername') || ''
    return {
      loading: false,
      draftLoading: false,
      publishLoading: false,
      categories: ['业界', '手机', '电脑', '测评', '视频', 'AI', '苹果', '软件'],
      lastSaveTime: '',
      autoSaveTimer: null,
      form: {
        title: '',
        author: loginUsername,
        category: '业界',
        content: ''
      },
      rules: {
        title: [
          { required: true, message: '请输入文章标题', trigger: 'blur' },
          { min: 2, max: 80, message: '标题长度为 2-80 个字符', trigger: 'blur' }
        ],
        category: [
          { required: true, message: '请选择分类', trigger: 'change' }
        ],
        content: []
      }
    }
  },
  computed: {
    // 当前投稿人，普通用户和管理员都可复用投稿页。
    currentUsername() {
      return localStorage.getItem('loginUsername') || localStorage.getItem('adminUsername') || ''
    },
    // 编辑模式下从路由 query 读取文章 id。
    editArticleId() {
      const queryId = this.$route.query.editId
      return Array.isArray(queryId) ? queryId[0] : queryId
    },
    // 是否正在编辑已有文章。
    isEditMode() {
      return Boolean(this.editArticleId)
    },
    // 正文实时字数统计。
    contentCharCount() {
      return String(this.form.content || '').length
    }
  },
  watch: {
    // 切换编辑 id 时重新加载对应文章，清空 id 则恢复新建表单。
    editArticleId() {
      if (this.isEditMode) {
        this.loadEditArticle()
      } else {
        this.resetForm()
      }
    }
  },
  created() {
    // 编辑文章前需要先确认登录态。
    if (this.requireLogin() && this.isEditMode) {
      this.loadEditArticle()
    }
  },
  mounted() {
    // 初始化标题输入高度并启动自动保存。
    this.autoResizeTitle()
    this.startAutoSave()
  },
  beforeUnmount() {
    // 离开投稿页时停止自动保存计时器。
    this.stopAutoSave()
  },
  methods: {
    // 检查登录状态，未登录则带回跳地址进入登录页。
    requireLogin() {
      if (this.currentUsername) {
        this.form.author = this.currentUsername
        return true
      }
      this.$message.warning('请先登录后再投稿')
      this.$router.replace({
        path: '/login',
        query: { redirect: '/submit' }
      })
      return false
    },
    // 加载要编辑的文章，优先用会话缓存填充，再用接口数据覆盖。
    async loadEditArticle() {
      if (!this.editArticleId) return
      const cachedArticle = this.readCachedEditArticle()
      if (cachedArticle) {
        this.fillArticleForm(cachedArticle)
      }
      this.loading = true
      try {
        const article = await this.fetchEditArticleById()
        this.fillArticleForm(article)
      } catch (error) {
        if (!cachedArticle) {
          this.$message.error('文章加载失败，无法编辑')
          this.$router.push('/mine')
        }
      } finally {
        this.loading = false
      }
    },
    // 将文章对象写入表单。
    fillArticleForm(article) {
      this.form = {
        title: article.title || '',
        author: article.author || this.currentUsername,
        category: article.category || '业界',
        content: article.content || ''
      }
      this.$nextTick(() => this.autoResizeTitle())
    },
    // 读取个人中心跳转编辑时缓存的文章草稿。
    readCachedEditArticle() {
      try {
        const cached = JSON.parse(sessionStorage.getItem('articleEditDraft') || 'null')
        if (String(cached?.articleId) !== String(this.editArticleId)) {
          return null
        }
        return cached.article || null
      } catch (error) {
        return null
      }
    },
    // 通过详情接口或列表接口获取编辑目标文章。
    async fetchEditArticleById() {
      try {
        const { data } = await http.get(`/articles/${this.editArticleId}`)
        const article = pickArticle(data)
        if (article) return article
      } catch (error) {}
      const { data } = await http.get('/articles')
      const article = pickList(data).find((item) => String(item.id) === String(this.editArticleId))
      if (!article) throw new Error('Article not found')
      return article
    },
    // 根据保存状态构造新建/编辑文章的请求体。
    buildArticlePayload(status) {
      const payload = {
        title: this.form.title,
        author: this.form.author || this.currentUsername,
        category: this.form.category,
        status,
        content: this.form.content
      }
      if (!this.isEditMode) return payload
      return {
        ...payload,
        editor: this.currentUsername,
        updated_by: this.currentUsername,
        updatedBy: this.currentUsername,
        last_editor: this.currentUsername
      }
    },
    // 以草稿状态提交当前文章。
    submitAsDraft() {
      if (!this.requireLogin()) return
      this.doSubmit('draft', 'draftLoading', '草稿保存成功', '草稿保存失败，请稍后再试')
    },
    // 以发布状态提交当前文章。
    submitAsPublished() {
      if (!this.requireLogin()) return
      this.doSubmit('published', 'publishLoading', '投稿提交成功', '投稿提交失败，请稍后再试')
    },
    // 执行文章保存请求，新建走 POST，编辑走 PUT。
    doSubmit(status, loadingRef, successMsg, failMsg) {
      if (!this.form.title || !this.form.title.trim()) {
        this.$message.warning({ message: '请输入标题', center: true })
        return
      }
      this.$refs.submitForm.validate(async (valid) => {
        if (!valid || this.loading) return
        this.loading = true
        this[loadingRef] = true
        try {
          const payload = this.buildArticlePayload(status)
          const { data } = this.isEditMode
            ? await http.put(`/articles/${this.editArticleId}`, payload)
            : await http.post('/articles', payload)
          const articleId = this.isEditMode ? this.editArticleId : pickCreatedId(data)
          if (this.isEditMode) {
            this.rememberArticleEditor(articleId)
          }
          this.$message.success(this.isEditMode ? '文章修改成功' : successMsg)
          this.$router.push(articleId ? `/article/${articleId}` : '/hello')
        } catch (error) {
          const data = error.response && error.response.data
          this.$message.error((data && (data.message || data.msg)) || (this.isEditMode ? '文章修改失败，请稍后再试' : failMsg))
        } finally {
          this.loading = false
          this[loadingRef] = false
        }
      })
    },
    // 编辑文章后记录本地编辑人，详情页可用于兜底展示。
    rememberArticleEditor(articleId) {
      if (!articleId || !this.currentUsername) return
      try {
        const storageKey = 'articleEditorMeta'
        const meta = JSON.parse(localStorage.getItem(storageKey) || '{}')
        meta[String(articleId)] = {
          editor: this.currentUsername,
          updatedAt: new Date().toISOString()
        }
        localStorage.setItem(storageKey, JSON.stringify(meta))
      } catch (error) {}
    },
    // 重置表单，新建时清空，编辑时重新加载原文章。
    resetForm() {
      if (this.isEditMode) {
        this.loadEditArticle()
        return
      }
      this.$refs.submitForm.resetFields()
      this.form.author = this.currentUsername
    },
    // 开启固定间隔自动保存到 sessionStorage。
    startAutoSave() {
      this.autoSaveTimer = setInterval(() => {
        this.autoSaveDraft()
      }, 8000)
    },
    // 停止自动保存计时器。
    stopAutoSave() {
      if (this.autoSaveTimer) {
        clearInterval(this.autoSaveTimer)
        this.autoSaveTimer = null
      }
    },
    // 将当前草稿保存到 sessionStorage 并刷新保存时间。
    autoSaveDraft() {
      if (!this.form.title && !this.form.content) return
      try {
        const draft = {
          title: this.form.title,
          author: this.form.author,
          category: this.form.category,
          content: this.form.content
        }
        sessionStorage.setItem('articleAutoDraft', JSON.stringify(draft))
        this.lastSaveTime = formatSaveTime()
      } catch (error) {}
    },
    // 根据标题内容自动调整标题输入框高度。
    autoResizeTitle() {
      this.$nextTick(() => {
        const el = this.$refs.titleInput
        if (!el) return
        el.style.height = 'auto'
        el.style.height = el.scrollHeight + 'px'
      })
    }
  }
}
</script>

<style>
/* ===== THEME CSS VARIABLES — global (non-scoped), survives scoped boundaries ===== */
:root {
  --edit-bg-primary: #0d1117;
  --edit-bg-secondary: #161b22;
  --edit-bg-tertiary: #21262d;
  --edit-border-default: #30363d;
  --edit-text-primary: #e6edf3;
  --edit-text-secondary: #c9d1d9;
  --edit-text-muted: #8b949e;
  --edit-text-placeholder: #6e7681;
  --edit-input-title-color: #ffffff;
  --edit-input-content-color: #e6edf3;
  --edit-input-title-placeholder: #6e7681;
  --edit-input-content-placeholder: #8b949e;
  --edit-input-selection-bg: rgba(88, 166, 255, 0.25);
  --edit-accent: #58a6ff;
  --edit-accent-emphasis: #388bfd;
  --edit-green: #238636;
  --edit-green-hover: #2ea043;
  --edit-red: #da3633;
  --edit-bottom-bar-bg: rgba(22, 27, 34, 0.92);
}

html[data-theme="light"] {
  --edit-bg-primary: #f5f5f7;
  --edit-bg-secondary: #ffffff;
  --edit-bg-tertiary: #e8ecf1;
  --edit-border-default: #d0d7de;
  --edit-text-primary: #1a1a2e;
  --edit-text-secondary: #374151;
  --edit-text-muted: #6b7280;
  --edit-text-placeholder: #9ca3af;
  --edit-input-title-color: #1a1a2e;
  --edit-input-content-color: #374151;
  --edit-input-title-placeholder: #9ca3af;
  --edit-input-content-placeholder: #6b7280;
  --edit-input-selection-bg: rgba(37, 99, 235, 0.2);
  --edit-accent: #2563eb;
  --edit-accent-emphasis: #1d4ed8;
  --edit-green: #238636;
  --edit-green-hover: #2ea043;
  --edit-red: #da3633;
  --edit-bottom-bar-bg: rgba(255, 255, 255, 0.92);
}
</style>

<style scoped>
/* ===== RESET & LAYOUT ===== */
.editor-app {
  position: fixed;
  inset: 0;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: var(--edit-bg-primary);
  color: var(--edit-text-primary);
  font-family: "SF Pro Display", "SF Pro Text", "PingFang SC", "Microsoft YaHei", system-ui, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.back-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  color: var(--edit-text-muted);
  border-radius: 8px;
  text-decoration: none;
  transition: all 0.2s ease;
}

.back-link:hover {
  color: var(--edit-text-primary);
  background: rgba(128, 128, 128, 0.1);
}

.category-select {
  width: 140px;
}

.editor-body {
  flex: 1;
  overflow-y: auto;
  padding-bottom: 160px;
}

.editor-container {
  max-width: 860px;
  margin: 0 auto;
  padding: 120px 40px 0;
}

.editor-form {
  width: 100%;
}

.editor-form :deep(.el-form-item) {
  margin-bottom: 0;
}

.editor-form :deep(.el-form-item__error) {
  color: var(--edit-red);
  font-size: 13px;
  padding-left: 4px;
}

/* ===== TITLE INPUT ===== */
.title-group {
  margin-bottom: 48px !important;
}

.title-input {
  display: block;
  width: 100%;
  padding: 0;
  background: transparent;
  border: none;
  outline: none;
  color: var(--edit-input-title-color);
  font-size: 42px;
  font-weight: 700;
  font-family: inherit;
  line-height: 1.25;
  letter-spacing: -0.025em;
  resize: none;
  overflow: hidden;
  caret-color: var(--edit-accent);
}

.title-input::placeholder {
  color: var(--edit-input-title-placeholder);
}

/* ===== CONTENT INPUT ===== */
.content-group {
  margin-bottom: 0 !important;
}

.content-wrapper {
  position: relative;
}

.content-input {
  display: block;
  width: 100%;
  min-height: 640px;
  padding: 0;
  background: transparent;
  border: none;
  outline: none;
  color: var(--edit-input-content-color);
  font-size: 18px;
  font-family: inherit;
  line-height: 2;
  letter-spacing: 0.01em;
  resize: none;
  caret-color: var(--edit-accent);
}

.content-input::placeholder {
  color: var(--edit-input-content-placeholder);
}

.content-input::selection {
  background: var(--edit-input-selection-bg);
}

/* ===== FLOATING SAVE INDICATOR ===== */
.save-indicator {
  position: fixed;
  right: 28px;
  bottom: 104px;
  z-index: 80;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background: var(--edit-bg-secondary);
  border: 1px solid var(--edit-border-default);
  border-radius: 999px;
  color: var(--edit-text-muted);
  font-size: 12px;
  font-weight: 500;
  pointer-events: none;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.28);
  transition: opacity 0.3s ease;
}

.save-icon {
  color: var(--edit-green);
  font-size: 14px;
}

.save-divider {
  color: var(--edit-border-default);
}

/* ===== FIXED BOTTOM BAR ===== */
.bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 90;
  height: 80px;
  background: var(--edit-bottom-bar-bg);
  border-top: 1px solid var(--edit-border-default);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
}

.bottom-bar-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 860px;
  height: 100%;
  margin: 0 auto;
  padding: 0 40px;
}

.bottom-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.bottom-back-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  color: var(--edit-text-muted);
  border-radius: 8px;
  text-decoration: none;
  transition: all 0.2s ease;
}

.bottom-back-link:hover {
  color: var(--edit-text-primary);
  background: rgba(128, 128, 128, 0.1);
}

.bottom-right {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-left: auto;
}

/* ===== BUTTONS ===== */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: 48px;
  padding: 0 28px;
  border: none;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 600;
  font-family: inherit;
  cursor: pointer;
  transition: all 0.25s ease;
  letter-spacing: 0.01em;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-draft {
  background: var(--edit-bg-tertiary);
  border: 1px solid var(--edit-border-default);
  color: var(--edit-text-secondary);
}

.btn-draft:hover:not(:disabled) {
  background: var(--edit-border-default);
}

.btn-publish {
  background: var(--edit-accent);
  color: #ffffff;
  border: 1px solid rgba(240, 246, 252, 0.1);
}

.btn-publish:hover:not(:disabled) {
  background: var(--edit-accent-emphasis);
  transform: translateY(-1px);
  box-shadow: 0 4px 14px rgba(88, 166, 255, 0.25);
}

.btn-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ===== ELEMENT PLUS OVERRIDES ===== */
:deep(.el-select) {
  --el-fill-color-blank: transparent;
}

:deep(.el-select .el-input__wrapper) {
  background: var(--edit-bg-tertiary);
  border: 1px solid var(--edit-border-default);
  border-radius: 8px;
  box-shadow: none;
  transition: all 0.2s ease;
}

:deep(.el-select .el-input__wrapper:hover) {
  border-color: var(--edit-text-muted);
}

:deep(.el-select .el-input__inner) {
  color: var(--edit-text-secondary);
}

:deep(.el-select .el-input.is-focus .el-input__wrapper) {
  border-color: var(--edit-accent);
  box-shadow: 0 0 0 2px rgba(88, 166, 255, 0.15);
}

/* ===== RESPONSIVE ===== */
@media (max-width: 768px) {
  .editor-container {
    padding: 80px 20px 0;
  }

  .bottom-bar-inner {
    padding: 0 20px;
  }

  .title-input {
    font-size: 30px;
  }

  .content-input {
    font-size: 16px;
    min-height: 480px;
  }

  .save-indicator {
    right: 16px;
    bottom: 96px;
  }

  .category-select {
    width: 110px;
  }
}
</style>
