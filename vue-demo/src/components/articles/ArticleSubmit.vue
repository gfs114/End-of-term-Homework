<template>
  <section class="submit-page">
    <div class="noise-layer"></div>

    <main class="submit-wrap">
      <router-link to="/hello" class="back-link">
        <el-icon><ArrowLeft /></el-icon>
        返回首页
      </router-link>

      <section class="submit-hero">
        <div>
          <p class="eyebrow">Contribute</p>
          <h1>{{ isEditMode ? '编辑文章' : '投稿' }}</h1>
        </div>
      </section>

      <section class="submit-panel">
        <el-form
          ref="submitForm"
          :model="form"
          :rules="rules"
          label-position="top"
          class="article-form"
        >
          <div class="form-grid">
            <el-form-item label="文章标题" prop="title">
              <el-input v-model.trim="form.title" maxlength="80" placeholder="请输入文章标题" />
            </el-form-item>
          </div>

          <div class="form-grid">
            <el-form-item label="分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择分类">
                <el-option v-for="item in categories" :key="item" :label="item" :value="item" />
              </el-select>
            </el-form-item>
          </div>

          <el-form-item label="文章正文" prop="content">
            <el-input
              v-model.trim="form.content"
              type="textarea"
              :rows="12"
              maxlength="5000"
              show-word-limit
              placeholder="请输入文章正文"
            />
          </el-form-item>

          <div class="form-actions">
            <el-form-item class="status-action" label="发布状态" prop="status">
              <el-segmented v-model="form.status" :options="statusOptions" />
            </el-form-item>
            <div class="submit-buttons">
              <el-button @click="resetForm">重置</el-button>
              <el-button type="primary" :loading="loading" @click="submitArticle">
                {{ isEditMode ? '保存修改' : '提交投稿' }}
              </el-button>
            </div>
          </div>
        </el-form>
      </section>
    </main>
  </section>
</template>

<script>
import http from '@/utils/http'

function pickCreatedId(payload) {
  return payload?.data?.id || payload?.article?.id || payload?.id
}

function pickList(payload) {
  if (Array.isArray(payload)) return payload
  if (Array.isArray(payload?.data)) return payload.data
  if (Array.isArray(payload?.articles)) return payload.articles
  if (Array.isArray(payload?.data?.data)) return payload.data.data
  return []
}

function pickArticle(payload) {
  if (payload?.data && !Array.isArray(payload.data)) return payload.data
  if (payload?.article) return payload.article
  if (payload?.id) return payload
  return null
}

export default {
  name: 'ArticleSubmit',
  data() {
    const loginUsername = localStorage.getItem('loginUsername') || ''

    return {
      loading: false,
      categories: ['业界', '手机', '电脑', '测评', '视频', 'AI', '苹果', '软件'],
      statusOptions: [
        { label: '草稿', value: 'draft' },
        { label: '已发表', value: 'published' }
      ],
      form: {
        title: '',
        author: loginUsername,
        category: '业界',
        status: 'draft',
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
        status: [
          { required: true, message: '请选择发布状态', trigger: 'change' }
        ],
        content: [
          { required: true, message: '请输入文章正文', trigger: 'blur' },
          { min: 10, message: '正文至少 10 个字符', trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    currentUsername() {
      return localStorage.getItem('loginUsername') || localStorage.getItem('adminUsername') || ''
    },
    editArticleId() {
      const queryId = this.$route.query.editId
      return Array.isArray(queryId) ? queryId[0] : queryId
    },
    isEditMode() {
      return Boolean(this.editArticleId)
    }
  },
  watch: {
    editArticleId() {
      if (this.isEditMode) {
        this.loadEditArticle()
      } else {
        this.resetForm()
      }
    }
  },
  created() {
    if (this.requireLogin() && this.isEditMode) {
      this.loadEditArticle()
    }
  },
  methods: {
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
    fillArticleForm(article) {
      this.form = {
        title: article.title || '',
        author: article.author || this.currentUsername,
        category: article.category || '业界',
        status: article.status || 'draft',
        content: article.content || ''
      }
    },
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
    async fetchEditArticleById() {
      try {
        const { data } = await http.get(`/articles/${this.editArticleId}`)
        const article = pickArticle(data)
        if (article) return article
      } catch (error) {
        // Fall back to the list endpoint for APIs that do not expose article detail.
      }

      const { data } = await http.get('/articles')
      const article = pickList(data).find((item) => String(item.id) === String(this.editArticleId))
      if (!article) throw new Error('Article not found')
      return article
    },
    buildArticlePayload() {
      const payload = {
        title: this.form.title,
        author: this.form.author || this.currentUsername,
        category: this.form.category,
        status: this.form.status,
        content: this.form.content
      }

      if (!this.isEditMode) {
        return payload
      }

      return {
        ...payload,
        editor: this.currentUsername,
        updated_by: this.currentUsername,
        updatedBy: this.currentUsername,
        last_editor: this.currentUsername
      }
    },
    submitArticle() {
      if (!this.requireLogin()) return

      this.$refs.submitForm.validate(async (valid) => {
        if (!valid || this.loading) return

        this.loading = true
        try {
          const payload = this.buildArticlePayload()
          const { data } = this.isEditMode
            ? await http.put(`/articles/${this.editArticleId}`, payload)
            : await http.post('/articles', payload)
          const articleId = this.isEditMode ? this.editArticleId : pickCreatedId(data)

          if (this.isEditMode) {
            this.rememberArticleEditor(articleId)
          }

          this.$message.success(this.isEditMode ? '文章修改成功' : '投稿提交成功')
          this.$router.push(articleId ? `/article/${articleId}` : '/hello')
        } catch (error) {
          const data = error.response && error.response.data
          this.$message.error((data && (data.message || data.msg)) || (this.isEditMode ? '文章修改失败，请稍后再试' : '投稿提交失败，请稍后再试'))
        } finally {
          this.loading = false
        }
      })
    },
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
      } catch (error) {
        // Local edit metadata is only a display fallback.
      }
    },
    resetForm() {
      if (this.isEditMode) {
        this.loadEditArticle()
        return
      }

      this.$refs.submitForm.resetFields()
      this.form.author = this.currentUsername
    }
  }
}
</script>
<style scoped>
* {
  box-sizing: border-box;
}

.submit-page {
  position: relative;
  min-height: 100vh;
  margin: -96px -24px -24px;
  overflow: hidden;
  color: #f5f5f7;
  background:
    radial-gradient(circle at 18% 8%, rgba(22, 99, 226, 0.22), transparent 28%),
    radial-gradient(circle at 86% 14%, rgba(255, 69, 58, 0.16), transparent 24%),
    linear-gradient(180deg, #171719 0%, #0b0b0d 44%, #111113 100%);
  font-family: "SF Pro Display", "SF Pro Text", "PingFang SC", "Microsoft YaHei", Arial, sans-serif;
}

.noise-layer {
  position: absolute;
  inset: 0;
  pointer-events: none;
  opacity: 0.45;
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.025) 1px, transparent 1px);
  background-size: 56px 56px;
}

.submit-wrap {
  position: relative;
  z-index: 1;
  width: min(980px, calc(100% - 40px));
  margin: 0 auto;
  padding: 120px 0 72px;
}

.back-link {
  display: inline-flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 28px;
  color: rgba(245, 245, 247, 0.76);
  text-decoration: none;
  font-weight: 700;
}

.back-link:hover {
  color: #fff;
}

.submit-hero,
.submit-panel {
  border: 1px solid rgba(245, 245, 247, 0.09);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.07);
  box-shadow: 0 34px 120px rgba(0, 0, 0, 0.34);
  backdrop-filter: blur(30px) saturate(160%);
  -webkit-backdrop-filter: blur(30px) saturate(160%);
}

.submit-hero {
  margin-bottom: 24px;
  padding: clamp(28px, 5vw, 50px);
}

.eyebrow {
  margin: 0 0 10px;
  color: #2997ff;
  font-size: 15px;
  font-weight: 800;
}

.submit-hero h1 {
  margin: 0;
  color: #fff;
  font-size: clamp(42px, 7vw, 86px);
  line-height: 1;
}

.submit-hero p:last-child {
  max-width: 720px;
  margin: 18px 0 0;
  color: rgba(245, 245, 247, 0.72);
  font-size: 18px;
  line-height: 1.7;
}

.submit-panel {
  padding: clamp(24px, 5vw, 42px);
}

.article-form :deep(.el-form-item__label) {
  color: rgba(245, 245, 247, 0.82);
  font-weight: 700;
}

.article-form :deep(.el-input__wrapper),
.article-form :deep(.el-textarea__inner),
.article-form :deep(.el-select__wrapper) {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(245, 245, 247, 0.14);
  box-shadow: none;
}

.article-form :deep(.el-input__inner),
.article-form :deep(.el-textarea__inner) {
  color: #f5f5f7;
}

.article-form :deep(.el-textarea__inner::placeholder),
.article-form :deep(.el-input__inner::placeholder) {
  color: rgba(245, 245, 247, 0.42);
}

.article-form :deep(.el-input__count) {
  background: transparent;
  color: rgba(245, 245, 247, 0.46);
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 20px;
}

.form-grid > :only-child {
  grid-column: 1 / -1;
}

.form-actions {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 12px;
  margin-top: 8px;
}

.status-action {
  margin-bottom: 0;
}

.status-action :deep(.el-segmented) {
  min-width: 96px;
}

.submit-buttons {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

@media (max-width: 720px) {
  .submit-wrap {
    width: min(100% - 24px, 520px);
    padding-top: 104px;
  }

  .form-grid {
    grid-template-columns: 1fr;
    gap: 0;
  }

  .form-actions {
    align-items: stretch;
    flex-direction: column;
  }

  .submit-buttons {
    justify-content: flex-end;
  }
}
</style>
