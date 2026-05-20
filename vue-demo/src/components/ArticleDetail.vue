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
          <span>浏览：{{ article.views || 0 }}</span>
          <time>{{ articleTime }}</time>
        </div>

        <div class="detail-content" v-html="article.content"></div>
      </article>
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
      errorMessage: ''
    }
  },
  computed: {
    articleTime() {
      const value = this.article?.created_at || this.article?.updated_at
      if (!value) return ''
      const date = new Date(value)
      if (Number.isNaN(date.getTime())) return value
      return date.toLocaleString('zh-CN')
    }
  },
  created() {
    this.fetchArticle()
  },
  methods: {
    async fetchArticle() {
      this.loading = true
      this.errorMessage = ''

      try {
        const article = await this.fetchDetailById()
        this.article = article
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
}
</style>
