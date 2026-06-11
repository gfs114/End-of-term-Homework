<template>
  <section class="article-detail-page">
    <div class="noise-layer"></div>

    <main class="detail-wrap">
      <router-link to="/hello" class="back-link">
        <el-icon><ArrowLeft /></el-icon>
        返回首页
      </router-link>

      <div v-if="loading" class="detail-state">文章加载中...</div>
      <div v-else-if="errorMessage" class="detail-state detail-state--error">{{ errorMessage }}</div>

      <article v-else class="detail-article">
        <p class="detail-category">{{ article.category || '文章详情' }}</p>
        <h1>{{ article.title }}</h1>

        <div class="detail-meta">
          <span>作者：{{ article.author || '未知作者' }}</span>
          <span v-if="editedBy">编辑：{{ editedBy }}</span>
          <span>浏览：{{ article.views || 0 }}</span>
          <time>{{ articleTime }}</time>
        </div>

        <div class="detail-content" v-html="article.content"></div>
      </article>

      <button
        v-if="article && !loading && !errorMessage"
        type="button"
        :class="['favorite-button', { active: isFavorite }]"
        @click="toggleFavorite"
      >
        <el-icon><StarFilled /></el-icon>
        <span>{{ isFavorite ? '已收藏' : '收藏' }} {{ favoriteCount }}</span>
      </button>
    </main>
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

function pickArticle(payload) {
  if (payload?.data && !Array.isArray(payload.data)) return payload.data
  if (payload?.article) return payload.article
  if (payload?.id) return payload
  return null
}

export default {
  name: 'ArticleDetail',
  data() {
    return {
      article: null,
      loading: false,
      favoriteLoading: false,
      errorMessage: '',
      favoriteIds: [],
      favoriteCount: 0
    }
  },
  computed: {
    favoriteStorageKey() {
      const username = localStorage.getItem('loginUsername') || ''
      return username ? `favoriteArticles:${username}` : ''
    },
    isFavorite() {
      return this.article && this.favoriteIds.includes(String(this.article.id))
    },
    articleTime() {
      const value = this.article?.created_at || this.article?.updated_at
      if (!value) return ''
      const date = new Date(value)
      if (Number.isNaN(date.getTime())) return value
      return date.toLocaleString('zh-CN')
    },
    editedBy() {
      if (!this.article) return ''
      return this.getArticleEditor(this.article)
    }
  },
  created() {
    this.loadFavorites()
    this.fetchArticle()
  },
  methods: {
    loadFavorites() {
      if (!this.favoriteStorageKey) {
        this.favoriteIds = []
        return
      }

      try {
        const ids = JSON.parse(localStorage.getItem(this.favoriteStorageKey) || '[]')
        this.favoriteIds = Array.isArray(ids) ? ids.map(String) : []
      } catch (error) {
        this.favoriteIds = []
      }
    },
    getArticleEditor(article) {
      return String(
        article?.editor ||
        article?.updated_by ||
        article?.updatedBy ||
        article?.last_editor ||
        article?.edited_by ||
        ''
      ).trim()
    },
    mergeLocalEditor(article) {
      if (!article || !article.id || this.getArticleEditor(article)) {
        return article
      }

      try {
        const articleEditorMeta = JSON.parse(localStorage.getItem('articleEditorMeta') || '{}')
        const localMeta = articleEditorMeta[String(article.id)]
        const editor = String(localMeta?.editor || '').trim()

        if (!editor) {
          return article
        }

        return {
          ...article,
          editor,
          updated_by: editor,
          localEditedAt: localMeta.updatedAt || ''
        }
      } catch (error) {
        return article
      }
    },
    toggleFavorite() {
      if (!localStorage.getItem('loginUsername')) {
        this.$message.warning('请先登录后再收藏')
        this.$router.push({
          path: '/login',
          query: { redirect: this.$route.fullPath }
        })
        return
      }

      if (this.favoriteLoading) return

      const articleId = String(this.article.id)
      const wasFavorite = this.isFavorite
      const favoriteUrl = wasFavorite
        ? `/articles/${articleId}/unfavorite`
        : `/articles/${articleId}/favorite`

      if (this.isFavorite) {
        this.favoriteIds = this.favoriteIds.filter((id) => id !== articleId)
        this.favoriteCount = Math.max(this.favoriteCount - 1, 0)
      } else {
        this.favoriteIds = [...this.favoriteIds, articleId]
        this.favoriteCount += 1
      }

      localStorage.setItem(this.favoriteStorageKey, JSON.stringify(this.favoriteIds))

      this.favoriteLoading = true
      http.put(favoriteUrl)
        .then(({ data }) => {
          const result = data?.data || data
          if (typeof result?.favorites !== 'undefined') {
            this.favoriteCount = Number(result.favorites) || 0
          }
          this.$message.success(wasFavorite ? '已取消收藏' : '收藏成功')
        })
        .catch((error) => {
          if (wasFavorite) {
            this.favoriteIds = [...this.favoriteIds, articleId]
            this.favoriteCount += 1
          } else {
            this.favoriteIds = this.favoriteIds.filter((id) => id !== articleId)
            this.favoriteCount = Math.max(this.favoriteCount - 1, 0)
          }
          localStorage.setItem(this.favoriteStorageKey, JSON.stringify(this.favoriteIds))
          const data = error.response && error.response.data
          this.$message.error((data && (data.message || data.msg)) || '收藏数同步失败')
        })
        .finally(() => {
          this.favoriteLoading = false
        })
    },
    async fetchArticle() {
      this.loading = true
      this.errorMessage = ''

      try {
        const article = await this.fetchDetailById()
        this.article = this.mergeLocalEditor(article)
        this.favoriteCount = Number(article.favorites) || 0
      } catch (error) {
        this.errorMessage = '文章不存在或加载失败'
      } finally {
        this.loading = false
      }
    },
    async fetchDetailById() {
      const id = String(this.$route.params.id)

      try {
        const { data } = await http.get(`/articles/${id}`)
        const article = pickArticle(data)
        if (article) return article
      } catch (error) {
        // Some backends expose only /articles. Fall back to the list endpoint below.
      }

      const { data } = await http.get('/articles')
      const article = pickList(data).find((item) => String(item.id) === id)
      if (!article) throw new Error('Article not found')
      return article
    }
  }
}
</script>

<style scoped>
* {
  box-sizing: border-box;
}

.article-detail-page {
  position: relative;
  min-height: 100vh;
  margin: -96px -24px -24px;
  overflow: hidden;
  color: #f5f5f7;
  background: #0b0b0d;
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

.detail-wrap {
  position: relative;
  z-index: 1;
  width: min(940px, calc(100% - 40px));
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

.detail-article,
.detail-state {
  border: 1px solid rgba(245, 245, 247, 0.09);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.07);
  box-shadow: 0 34px 120px rgba(0, 0, 0, 0.34);
  backdrop-filter: blur(30px) saturate(160%);
  -webkit-backdrop-filter: blur(30px) saturate(160%);
}

.detail-article {
  padding: clamp(28px, 6vw, 58px);
}

.detail-state {
  display: grid;
  min-height: 260px;
  place-items: center;
  color: rgba(245, 245, 247, 0.7);
}

.detail-state--error {
  color: #ff9f0a;
}

.detail-category {
  margin: 0 0 14px;
  color: #2997ff;
  font-size: 15px;
  font-weight: 800;
}

.favorite-button {
  position: fixed;
  top: 50%;
  right: clamp(16px, 3vw, 42px);
  z-index: 20;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-width: 104px;
  height: 42px;
  justify-content: center;
  border: 1px solid rgba(245, 245, 247, 0.18);
  border-radius: 8px;
  color: rgba(245, 245, 247, 0.84);
  cursor: pointer;
  background: rgba(255, 255, 255, 0.08);
  font: inherit;
  font-weight: 800;
  transform: translateY(-50%);
  box-shadow: 0 16px 46px rgba(0, 0, 0, 0.28);
  backdrop-filter: blur(18px) saturate(150%);
  -webkit-backdrop-filter: blur(18px) saturate(150%);
  transition: color 0.2s ease, border-color 0.2s ease, background 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
}

.favorite-button:hover {
  color: #fff;
  border-color: rgba(255, 204, 0, 0.56);
  transform: translateY(calc(-50% - 2px));
  box-shadow: 0 20px 54px rgba(0, 0, 0, 0.34);
}

.favorite-button.active {
  color: #111113;
  border-color: #ffd60a;
  background: #ffd60a;
}

.detail-article h1 {
  margin: 0;
  color: #fff;
  font-size: clamp(34px, 5vw, 58px);
  line-height: 1.15;
}

.detail-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 12px 22px;
  margin: 22px 0 34px;
  color: rgba(245, 245, 247, 0.62);
  font-size: 15px;
}

.detail-content {
  color: rgba(245, 245, 247, 0.82);
  font-size: 18px;
  line-height: 1.9;
  white-space: pre-wrap;
  word-break: break-word;
}

.detail-content :deep(p) {
  margin: 0 0 18px;
}

.detail-content :deep(img) {
  max-width: 100%;
  border-radius: 8px;
}

@media (max-width: 620px) {
  .detail-wrap {
    width: min(100% - 24px, 480px);
    padding-top: 104px;
  }

  .favorite-button {
    right: 14px;
    min-width: 48px;
    width: 48px;
    height: 48px;
    padding: 0;
    border-radius: 50%;
  }

  .favorite-button span {
    display: none;
  }
}
</style>
