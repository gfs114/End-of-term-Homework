<template>
  <section class="apple-news-page">
    <div class="noise-layer"></div>

    <div class="news-wrap">
      <header class="category-bar" aria-label="资讯分类">
        <div class="category-lines">
          <nav class="category-row" aria-label="主分类">
            <router-link v-for="item in primaryLinks" :key="item" :to="getCategoryRoute(item)"
              :class="['category-link', { active: activeCategory === item }]">
              {{ item }}
            </router-link>
          </nav>

          <nav class="category-row" aria-label="扩展分类">
            <router-link v-for="item in secondaryLinks" :key="item" :to="getCategoryRoute(item)"
              :class="['category-link', { active: activeCategory === item }]">
              {{ item }}
            </router-link>
          </nav>
        </div>

        <div class="search-stack">
          <label class="search-box">
            <el-icon class="search-icon">
              <Search />
            </el-icon>
            <input v-model.trim="keyword" type="search" placeholder="请输入关键词" />
            <button type="button">搜索</button>
          </label>

          <p class="hot-words">
            <span>热搜：</span>
            <a v-for="word in hotWords" :key="word" href="#">{{ word }}</a>
          </p>
        </div>
      </header>

      <section v-if="headlines.length" class="headline-strip" aria-label="今日头条">
        <router-link v-for="headline in headlines" :key="headline.id" :to="`/article/${headline.id}`"
          class="headline-item">
          <span class="headline-number">{{ headline.id }}</span>
          <strong>{{ headline.title }}</strong>
        </router-link>
      </section>

      <section class="hero-band">
        <div class="hero-copy">
          <h1>{{ pageCategoryTitle }}</h1>
          <p>
            聚合{{ pageCategoryTitle }}相关科技动态，以更清晰的版面呈现你关心的资讯。
          </p>
        </div>

        <div class="hero-device" aria-hidden="true">
          <span class="device-screen"></span>
          <span class="device-base"></span>
          <span class="device-chip"></span>
        </div>
      </section>

      <main class="content-grid">
        <section class="feed-panel" :aria-label="`${pageCategoryTitle}资讯列表`">
          <div class="section-title">
            <h2>{{ pageCategoryTitle }}</h2>
            <span></span>
          </div>

          <div v-if="loading" class="article-state">文章加载中...</div>
          <div v-else-if="errorMessage" class="article-state article-state--error">{{ errorMessage }}</div>
          <div v-else-if="!filteredArticles.length" class="article-state">暂无相关文章</div>

          <article v-for="article in filteredArticles" :key="article.id" class="article-card">
            <div class="article-body">
              <router-link :to="`/article/${article.id}`" class="article-title">{{ article.title }}</router-link>
              <p>{{ article.summary }}</p>
              <div class="article-meta">
                <span><strong>Tags:</strong> {{ article.tags }}</span>
                <time>{{ article.time }}</time>
              </div>
            </div>
          </article>
        </section>

        <aside class="side-column" aria-label="侧边资讯">
          <section class="ranking-panel">
            <h3 class="ranking-title">阅读榜单</h3>
            <h3>————————————————</h3>
            <ol class="ranking-list">
              <li v-for="(rank, index) in rankings" :key="rank.id">
                <span :class="{ hot: index < 3 }">{{ index + 1 }}</span>
                <router-link :to="`/article/${rank.id}`">{{ rank.title }}</router-link>
              </li>
            </ol>
          </section>

          <!-- <section class="resource-panel">
            <div class="tabs compact" role="tablist" aria-label="资源类型">
              <button type="button" class="active">软媒产品</button>
              <button type="button">常用资源</button>
            </div>

            <a v-for="resource in resources" :key="resource.name" href="#" class="resource-row">
              <span :class="['resource-badge', resource.tone]">{{ resource.badge }}</span>
              <strong>{{ resource.name }}</strong>
              <el-icon>
                <ArrowRight />
              </el-icon>
            </a>
          </section> -->
        </aside>
      </main>
    </div>

    <div class="floating-tools" aria-label="快捷入口">
      <!-- <button type="button" aria-label="打开 App">
        <el-icon><Grid /></el-icon>
        <span>App</span>
      </button> -->
      <!-- <button type="button" aria-label="公众号">
        <el-icon>
          <Promotion />
        </el-icon>
        <span>公众号</span>
      </button> -->
      <button type="button" aria-label="投稿" @click="goSubmit">
        <el-icon>
          <EditPen />
        </el-icon>
        <span>投稿</span>
      </button>
    </div>
  </section>
</template>

<script>
import http from '@/utils/http'

const imageClasses = ['thumb-keyboard', 'thumb-mouse', 'thumb-display', 'thumb-laptop']

// 兼容后端不同返回结构，统一提取文章数组。
function pickList(payload) {
  if (Array.isArray(payload)) return payload
  if (Array.isArray(payload?.data)) return payload.data
  if (Array.isArray(payload?.articles)) return payload.articles
  if (Array.isArray(payload?.data?.data)) return payload.data.data
  return []
}

// 去掉 HTML 标签和多余空白，用于生成文章摘要。
function plainText(value) {
  return String(value || '')
    .replace(/<[^>]+>/g, '')
    .replace(/\s+/g, ' ')
    .trim()
}

// 将接口时间格式化成列表上更短的展示时间。
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
  name: 'HelloPage',
  data() {
    return {
      keyword: '',
      loading: false,
      errorMessage: '',
      primaryLinks: ['业界', '手机', '电脑', '测评', '视频', 'AI', '苹果', 'iPhone', '鸿蒙', '软件'],
      secondaryLinks: ['智车', '数码', '学院', '游戏', '直播', '5G', '微软', 'Win10', 'Win11', '专题'],
      hotWords: ['三星', '微信', '小米', '华为', '大疆'],
      articles: [],
      resources: [
        { badge: '最会买', name: '最会买App（返利+神券）', tone: 'yellow' },
        { badge: '要知', name: '要知（多平台）', tone: 'black' },
        { badge: '软媒', name: '软媒魔方工具箱', tone: 'blue' }
      ]
    }
  },
  computed: {
    // 当前分类来自路由 query，空值表示全部文章。
    activeCategory() {
      return this.$route.query.category || ''
    },
    // 根据当前分类生成页面主标题。
    pageCategoryTitle() {
      return this.activeCategory || '全部文章'
    },
    // 按分类和搜索关键词筛选资讯列表。
    filteredArticles() {
      const category = this.activeCategory.toLowerCase()
      const keyword = this.keyword.toLowerCase()

      return this.articles.filter((article) => {
        const articleText = [article.title, article.summary, article.tags]
          .join(' ')
          .toLowerCase()

        const matchedCategory = !category || articleText.includes(category)
        const matchedKeyword = !keyword || articleText.includes(keyword)

        return matchedCategory && matchedKeyword
      })
    },
    // 首页顶部展示最新两条文章作为头条。
    headlines() {
      return this.articles.slice(0, 2)
    },
    // 阅读榜按浏览量倒序取前 12 条。
    rankings() {
      return [...this.articles]//扩展运算符，创建this.articles的浅拷贝，避免直接修改原数组
        .sort((a, b) => b.views - a.views)//判断谁在前
        .slice(0, 12)//取前12位
    }
  },
  created() {
    // 页面创建后立即加载文章列表。
    this.fetchArticles()
  },
  methods: {
    // 进入投稿页前先检查登录状态，未登录则跳到登录页并携带回跳地址。
    goSubmit() {
      if (!localStorage.getItem('loginUsername')) {
        this.$message.warning('请先登录后再投稿')
        this.$router.push({
          path: '/login',
          query: { redirect: '/submit' }
        })
        return
      }

      this.$router.push('/submit')
    },
    // 生成分类链接，通过 query 保持在首页内筛选。
    getCategoryRoute(category) {
      return {
        path: '/hello',
        query: {
          category
        }
      }
    },
    // 从接口获取已发布文章并标准化为首页列表结构。
    async fetchArticles() {
      this.loading = true
      this.errorMessage = ''

      try {
        const { data } = await http.get('/articles')
        this.articles = pickList(data)
          .filter((item) => !item.status || item.status === 'published')
          .map((item, index) => this.normalizeArticle(item, index))
      } catch (error) {
        this.errorMessage = '文章加载失败，请稍后再试'
      } finally {
        this.loading = false
      }
    },
    // 将接口文章字段整理成列表、榜单和头条都能直接使用的字段。
    normalizeArticle(item, index) {
      const title = item.title || '未命名文章'
      const summary = plainText(item.summary || item.description || item.content).slice(0, 110)
      const label = title.replace(/[^\u4e00-\u9fa5A-Za-z0-9]/g, '').slice(0, 8) || 'Article'

      return {
        id: item.id,
        title,
        summary: summary || '这篇文章暂时没有摘要，点击查看完整内容。',
        tags: item.category || item.author || '文章',
        time: formatTime(item.created_at || item.updated_at),
        views: Number(item.views) || 0,
        mediaLabel: label,
        imageClass: imageClasses[index % imageClasses.length]
      }
    }
  }
}
</script>

<style scoped>
/* ===== RESET & BASE ===== */
* {
  box-sizing: border-box;
}

a {
  color: inherit;
  text-decoration: none;
}

button,
input {
  font: inherit;
}

/* ===== PAGE SHELL ===== */
.apple-news-page {
  position: relative;
  min-height: 100vh;
  margin: -96px -24px -24px;
  overflow: hidden;
  color: #f5f5f7;
  background: #0a0a0e;
  font-family: "SF Pro Display", "SF Pro Text", "PingFang SC", "Microsoft YaHei", system-ui, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* ===== NOISE TEXTURE ===== */
.noise-layer {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  opacity: 0.38;
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.028) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.022) 1px, transparent 1px);
  background-size: 48px 48px;
}

/* ===== MAIN WRAPPER ===== */
.news-wrap {
  position: relative;
  z-index: 1;
  width: min(1452px, calc(100% - 48px));
  margin: 0 auto;
  padding: 120px 0 80px;
}

/* ===== CATEGORY BAR ===== */
.category-bar {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(320px, 380px);
  gap: 40px;
  align-items: start;
  padding: 0 2px 36px;
}

.category-lines {
  display: grid;
  gap: 18px;
}

.category-row {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.category-link {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 36px;
  padding: 0 18px;
  border: 1px solid rgba(245, 245, 247, 0.18);
  border-radius: 999px;
  color: rgba(245, 245, 247, 0.78);
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.03)),
    rgba(19, 20, 24, 0.44);
  box-shadow:
    0 4px 16px rgba(0, 0, 0, 0.18),
    inset 0 1px 0 rgba(255, 255, 255, 0.18);
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 0.01em;
  backdrop-filter: blur(16px) saturate(150%) contrast(1.06);
  -webkit-backdrop-filter: blur(16px) saturate(150%) contrast(1.06);
  transition: all 0.24s cubic-bezier(0.2, 0, 0, 1);
}

.category-link:hover {
  color: #fff;
  border-color: rgba(245, 245, 247, 0.44);
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0.05)),
    rgba(19, 20, 24, 0.58);
  box-shadow:
    0 6px 24px rgba(0, 0, 0, 0.28),
    inset 0 1px 0 rgba(255, 255, 255, 0.32);
  transform: translateY(-1px);
}

.category-link.active {
  color: #fff;
  border-color: rgba(255, 59, 48, 0.55);
  background:
    linear-gradient(180deg, rgba(255, 59, 48, 0.2), rgba(255, 59, 48, 0.06)),
    rgba(19, 20, 24, 0.58);
  box-shadow:
    0 0 18px rgba(255, 59, 48, 0.18),
    inset 0 1px 0 rgba(255, 255, 255, 0.22);
}

/* ===== SEARCH ===== */
.search-stack {
  display: grid;
  gap: 10px;
}

.search-box {
  display: grid;
  grid-template-columns: 42px minmax(0, 1fr) 76px;
  align-items: center;
  height: 48px;
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.14);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.06);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06), 0 2px 12px rgba(0, 0, 0, 0.16);
  backdrop-filter: blur(20px) saturate(150%);
  -webkit-backdrop-filter: blur(20px) saturate(150%);
  transition: border-color 0.24s ease, box-shadow 0.24s ease;
}

.search-box:focus-within {
  border-color: rgba(245, 245, 247, 0.28);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.08), 0 0 0 4px rgba(255, 59, 48, 0.08);
}

.search-icon {
  justify-self: center;
  color: rgba(245, 245, 247, 0.48);
}

.search-box input {
  width: 100%;
  min-width: 0;
  border: 0;
  outline: 0;
  color: #f5f5f7;
  background: transparent;
  font-size: 15px;
}

.search-box input::placeholder {
  color: rgba(245, 245, 247, 0.38);
}

.search-box button {
  height: 100%;
  border: 0;
  color: #fff;
  cursor: pointer;
  background: #ff3b30;
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0.02em;
  transition: background 0.2s ease, box-shadow 0.2s ease;
}

.search-box button:hover {
  background: #ff453a;
  box-shadow: inset 0 0 0 2px rgba(255, 255, 255, 0.12);
}

.hot-words {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 0;
  padding: 0 4px;
  color: rgba(245, 245, 247, 0.46);
  font-size: 13px;
}

.hot-words a {
  color: rgba(245, 245, 247, 0.58);
  transition: color 0.2s ease;
}

.hot-words a:hover {
  color: #ff9f0a;
}

/* ===== HEADLINE STRIP ===== */
.headline-strip {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0;
  margin-bottom: 48px;
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.08);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.05);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.32), inset 0 1px 0 rgba(255, 255, 255, 0.04);
  backdrop-filter: blur(24px) saturate(155%);
  -webkit-backdrop-filter: blur(24px) saturate(155%);
}

.headline-item {
  display: flex;
  align-items: center;
  gap: 16px;
  min-width: 0;
  padding: 20px clamp(22px, 4vw, 56px);
  background: rgba(255, 255, 255, 0.03);
  transition: background 0.24s ease;
}

.headline-item:first-child {
  border-right: 1px solid rgba(245, 245, 247, 0.06);
}

.headline-item:hover {
  background: rgba(255, 255, 255, 0.07);
}

.headline-number {
  display: inline-grid;
  flex: 0 0 auto;
  place-items: center;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  color: #fff;
  background: #ff3b30;
  font-size: 14px;
  font-weight: 800;
  box-shadow: 0 4px 18px rgba(255, 59, 48, 0.32);
  flex-shrink: 0;
}

.headline-item strong {
  min-width: 0;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.92);
  font-size: clamp(20px, 2vw, 34px);
  font-weight: 700;
  letter-spacing: -0.01em;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* ===== HERO BAND ===== */
.hero-band {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(260px, 420px);
  gap: 40px;
  align-items: center;
  min-height: 260px;
  margin-bottom: 46px;
  padding: clamp(32px, 5vw, 60px);
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.08);
  border-radius: 10px;
  background: rgba(22, 22, 26, 0.78);
  box-shadow: 0 30px 90px rgba(0, 0, 0, 0.38), inset 0 1px 0 rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(28px) saturate(155%);
  -webkit-backdrop-filter: blur(28px) saturate(155%);
}

.eyebrow {
  margin: 0 0 8px;
  color: #2997ff;
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.hero-copy h1 {
  margin: 0;
  color: #f5f5f7;
  font-size: clamp(48px, 8vw, 104px);
  font-weight: 800;
  line-height: 0.96;
  letter-spacing: -0.025em;
}

.hero-copy p:last-child {
  max-width: 650px;
  margin: 16px 0 0;
  color: rgba(245, 245, 247, 0.66);
  font-size: clamp(17px, 1.7vw, 23px);
  line-height: 1.5;
  letter-spacing: 0.005em;
}

/* ===== HERO DEVICE ===== */
.hero-device {
  position: relative;
  min-height: 220px;
}

.device-screen {
  position: absolute;
  right: 10px;
  top: 6px;
  width: min(92%, 370px);
  aspect-ratio: 16 / 10;
  border: 1px solid rgba(245, 245, 247, 0.2);
  border-radius: 10px;
  background: #1a1a1e;
  box-shadow:
    0 28px 64px rgba(0, 0, 0, 0.48),
    inset 0 1px 0 rgba(255, 255, 255, 0.18),
    0 0 0 1px rgba(255, 255, 255, 0.06);
}

.device-screen::after {
  content: "";
  position: absolute;
  inset: 14px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 6px;
  background-size: 42px 42px;
}

.device-base {
  position: absolute;
  right: 58px;
  bottom: 20px;
  width: min(62%, 270px);
  height: 22px;
  border-radius: 999px;
  background: #8e8e93;
  box-shadow: 0 10px 26px rgba(0, 0, 0, 0.38);
}

.device-chip {
  position: absolute;
  left: 8%;
  bottom: 16px;
  width: 96px;
  height: 96px;
  border: 1px solid rgba(245, 245, 247, 0.16);
  border-radius: 10px;
  background: #141418;
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.44), inset 0 1px 0 rgba(255, 255, 255, 0.04);
}

.device-chip::before {
  content: "AI";
  position: absolute;
  inset: 18px;
  display: grid;
  place-items: center;
  border-radius: 6px;
  color: #f5f5f7;
  background: #0071e3;
  font-size: 26px;
  font-weight: 800;
  letter-spacing: 0.04em;
  box-shadow: inset 0 0 0 2px rgba(255, 255, 255, 0.12);
}

/* ===== CONTENT GRID ===== */
.content-grid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 412px;
  gap: 52px;
  align-items: start;
}

/* ===== SECTION TITLE ===== */
.section-title {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 30px;
}

.section-title h2 {
  position: relative;
  margin: 0;
  color: #f5f5f7;
  font-size: 26px;
  font-weight: 800;
  letter-spacing: -0.015em;
  line-height: 1.15;
}

.section-title h2::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -12px;
  width: 52px;
  height: 3px;
  border-radius: 999px;
  background: #ff3b30;
}

.section-title span {
  flex: 1;
  height: 1px;
  background: rgba(245, 245, 247, 0.2);
}

/* ===== FEED PANEL ===== */
.feed-panel {
  min-width: 0;
}

.article-state {
  display: grid;
  place-items: center;
  min-height: 180px;
  color: rgba(245, 245, 247, 0.6);
  border: 1px solid rgba(245, 245, 247, 0.08);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.04);
  font-size: 16px;
  letter-spacing: 0.02em;
}

.article-state--error {
  color: #ff9f0a;
  border-color: rgba(255, 159, 10, 0.22);
  background: rgba(255, 159, 10, 0.06);
}

/* ===== ARTICLE CARD ===== */
.article-card {
  padding: 26px 0;
  border-bottom: 1px solid rgba(245, 245, 247, 0.07);
  transition: border-color 0.28s ease;
}

.article-card:first-of-type {
  padding-top: 18px;
}

.article-card:hover {
  border-bottom-color: rgba(245, 245, 247, 0.14);
}

/* ===== ARTICLE BODY ===== */
.article-body {
  min-width: 0;
}

.article-title {
  display: block;
  color: rgba(245, 245, 247, 0.94);
  font-size: clamp(20px, 2.2vw, 26px);
  font-weight: 800;
  letter-spacing: -0.015em;
  line-height: 1.3;
  transition: color 0.22s ease;
}

.article-title:hover {
  color: #2997ff;
}

.article-body p {
  display: -webkit-box;
  margin: 12px 0 14px;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.5);
  font-size: 15px;
  line-height: 1.7;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.article-meta {
  display: flex;
  gap: 18px;
  align-items: center;
  justify-content: space-between;
  color: rgba(245, 245, 247, 0.72);
  font-size: 14px;
}

.article-meta strong {
  color: #f5f5f7;
  font-weight: 700;
}

.article-meta time {
  flex: 0 0 auto;
  color: #ff453a;
  font-weight: 700;
  letter-spacing: 0.02em;
}

/* ===== SIDEBAR ===== */
.side-column {
  position: sticky;
  top: 100px;
  display: grid;
  gap: 22px;
}

.ranking-panel,
.resource-panel {
  border: 1px solid rgba(245, 245, 247, 0.08);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.055);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.28), inset 0 1px 0 rgba(255, 255, 255, 0.04);
  backdrop-filter: blur(24px) saturate(155%);
  -webkit-backdrop-filter: blur(24px) saturate(155%);
}

.ranking-panel {
  padding: 22px 20px 20px;
}

.tabs {
  display: flex;
  align-items: center;
  gap: 28px;
  min-height: 36px;
  border-bottom: 1px solid rgba(245, 245, 247, 0.1);
}

.tabs button {
  position: relative;
  height: 36px;
  border: 0;
  color: rgba(245, 245, 247, 0.64);
  cursor: pointer;
  background: transparent;
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 0.01em;
  transition: color 0.2s ease;
}

.tabs button:hover {
  color: rgba(245, 245, 247, 0.84);
}

.tabs button.active {
  color: #f5f5f7;
}

.tabs button.active::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  bottom: -1px;
  height: 2px;
  border-radius: 999px;
  background: #ff3b30;
}

.ranking-list {
  display: grid;
  gap: 10px;
  margin: 20px 0 0;
  padding: 0;
  list-style: none;
}

.ranking-list li {
  display: grid;
  grid-template-columns: 28px minmax(0, 1fr);
  align-items: center;
  gap: 10px;
  min-width: 0;
  padding: 6px 4px;
  border-radius: 6px;
  transition: background 0.2s ease;
}

.ranking-title {
  margin: 0 0 16px;
  color: #f5f5f7;
  font-size: 18px;
  font-weight: 800;
  letter-spacing: 0.01em;
}

.ranking-list li:hover {
  background: rgba(255, 255, 255, 0.04);
}

.ranking-list span {
  display: grid;
  place-items: center;
  width: 24px;
  height: 24px;
  color: #fff;
  border-radius: 5px;
  background: rgba(245, 245, 247, 0.28);
  font-size: 13px;
  font-weight: 800;
}

.ranking-list span.hot {
  background: #ff3b30;
  box-shadow: 0 2px 10px rgba(255, 59, 48, 0.28);
}

.ranking-list a {
  min-width: 0;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.68);
  font-size: 14px;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: color 0.2s ease;
}

.ranking-list a:hover {
  color: #f5f5f7;
}

/* ---- Resource panel (kept for future use) ---- */
.resource-panel {
  padding: 22px 20px;
}

.tabs.compact {
  margin-bottom: 18px;
}

.resource-row {
  display: grid;
  grid-template-columns: 54px minmax(0, 1fr) 28px;
  gap: 14px;
  align-items: center;
  min-height: 56px;
  padding: 10px 0;
  border-bottom: 1px solid rgba(245, 245, 247, 0.06);
  border-radius: 6px;
  transition: background 0.2s ease;
}

.resource-row:last-child {
  border-bottom: 0;
}

.resource-row:hover {
  background: rgba(255, 255, 255, 0.04);
}

.resource-badge {
  display: grid;
  place-items: center;
  width: 48px;
  height: 48px;
  border-radius: 10px;
  color: #111113;
  font-size: 13px;
  font-weight: 900;
}

.resource-badge.yellow {
  background: #ffd60a;
}

.resource-badge.black {
  color: #f5f5f7;
  background: #101014;
  border: 1px solid rgba(245, 245, 247, 0.14);
}

.resource-badge.blue {
  color: #fff;
  background: #0071e3;
}

.resource-row strong {
  min-width: 0;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.8);
  font-size: 15px;
  font-weight: 600;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.resource-row .el-icon {
  display: grid;
  place-items: center;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  color: #f5f5f7;
  background: rgba(255, 255, 255, 0.08);
  transition: background 0.2s ease;
}

.resource-row:hover .el-icon {
  background: rgba(255, 255, 255, 0.14);
}

/* ===== FLOATING TOOLS ===== */
.floating-tools {
  position: fixed;
  right: 36px;
  top: 52%;
  transform: translateY(-50%);
  z-index: 20;
  display: grid;
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.14);
  border-radius: 12px;
  background: rgba(24, 24, 28, 0.78);
  box-shadow: 0 16px 48px rgba(0, 0, 0, 0.36);
  backdrop-filter: blur(20px) saturate(160%);
  -webkit-backdrop-filter: blur(20px) saturate(160%);
}

.floating-tools button {
  display: grid;
  place-items: center;
  gap: 2px;
  width: 66px;
  height: 64px;
  border: 0;
  border-bottom: 1px solid rgba(245, 245, 247, 0.12);
  color: rgba(245, 245, 247, 0.78);
  cursor: pointer;
  background: transparent;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.03em;
  transition: all 0.2s ease;
}

.floating-tools button:last-child {
  border-bottom: 0;
}

.floating-tools .el-icon {
  font-size: 22px;
  transition: transform 0.2s ease;
}

.floating-tools button:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.08);
}

.floating-tools button:hover .el-icon {
  transform: scale(1.1);
}

/* ===== RESPONSIVE: ≤ 1180px ===== */
@media (max-width: 1180px) {

  .category-bar,
  .content-grid {
    grid-template-columns: 1fr;
  }

  .side-column {
    position: static;
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .floating-tools {
    display: none;
  }
}

/* ===== RESPONSIVE: ≤ 820px ===== */
@media (max-width: 820px) {
  .news-wrap {
    width: min(100% - 28px, 720px);
    padding-top: 104px;
    padding-bottom: 56px;
  }

  .category-bar {
    gap: 22px;
  }

  .category-row {
    flex-wrap: nowrap;
    overflow-x: auto;
    scrollbar-width: none;
  }

  .category-row::-webkit-scrollbar {
    display: none;
  }

  .category-link {
    flex: 0 0 auto;
  }

  .headline-strip,
  .hero-band,
  .side-column {
    grid-template-columns: 1fr;
  }

  .headline-item:first-child {
    border-right: 0;
    border-bottom: 1px solid rgba(245, 245, 247, 0.06);
  }

  .headline-item strong {
    white-space: normal;
  }

  .hero-band {
    padding: 28px;
    gap: 28px;
  }

  .hero-device {
    min-height: 180px;
  }

  .article-body p {
    -webkit-line-clamp: 3;
  }
}

/* ===== RESPONSIVE: ≤ 620px ===== */
@media (max-width: 620px) {
  .apple-news-page {
    margin: -96px -24px -24px;
  }

  .news-wrap {
    width: min(100% - 24px, 480px);
  }

  .search-box {
    grid-template-columns: 36px minmax(0, 1fr) 64px;
  }

  .hero-copy h1 {
    font-size: clamp(36px, 10vw, 60px);
  }

  .article-card {
    padding: 24px 0 28px;
  }

  .article-meta {
    align-items: flex-start;
    flex-direction: column;
    gap: 8px;
  }

  .resource-row {
    grid-template-columns: 50px minmax(0, 1fr) 28px;
  }
}
</style>
