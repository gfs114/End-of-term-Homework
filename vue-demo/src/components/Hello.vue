<template>
  <section class="apple-news-page">
    <div class="noise-layer"></div>

    <div class="news-wrap">
      <header class="category-bar" aria-label="资讯分类">
        <div class="category-lines">
          <nav class="category-row" aria-label="主分类">
            <a v-for="item in primaryLinks" :key="item" href="#" class="category-link">
              {{ item }}
            </a>
          </nav>

          <nav class="category-row" aria-label="扩展分类">
            <a v-for="item in secondaryLinks" :key="item" href="#" class="category-link">
              {{ item }}
            </a>
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
          <p class="eyebrow">Today in Tech</p>
          <h1>电脑</h1>
          <p>
            聚合最新硬件、AI 与消费电子动态，以更清晰的版面呈现你关心的科技新闻。
          </p>
        </div>

        <div class="hero-device" aria-hidden="true">
          <span class="device-screen"></span>
          <span class="device-base"></span>
          <span class="device-chip"></span>
        </div>
      </section>

      <main class="content-grid">
        <section class="feed-panel" aria-label="电脑资讯列表">
          <div class="section-title">
            <h2>电脑</h2>
            <span></span>
          </div>

          <div v-if="loading" class="article-state">文章加载中...</div>
          <div v-else-if="errorMessage" class="article-state article-state--error">{{ errorMessage }}</div>
          <div v-else-if="!filteredArticles.length" class="article-state">暂无相关文章</div>

          <article v-for="article in filteredArticles" :key="article.id" class="article-card">
            <router-link :to="`/article/${article.id}`" class="article-media" :class="article.imageClass"
              :aria-label="article.title">
              <span class="media-shine"></span>
              <span class="media-device"></span>
              <span class="media-label">{{ article.mediaLabel }}</span>
            </router-link>

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
            <div class="tabs" role="tablist" aria-label="榜单类型">
              <button type="button" class="active">日榜</button>
              <button type="button">周榜</button>
              <button type="button">月榜</button>
            </div>

            <ol class="ranking-list">
              <li v-for="(rank, index) in rankings" :key="rank.id">
                <span :class="{ hot: index < 3 }">{{ index + 1 }}</span>
                <router-link :to="`/article/${rank.id}`">{{ rank.title }}</router-link>
              </li>
            </ol>
          </section>

          <section class="resource-panel">
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
          </section>
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

function pickList(payload) {
  if (Array.isArray(payload)) return payload
  if (Array.isArray(payload?.data)) return payload.data
  if (Array.isArray(payload?.articles)) return payload.articles
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
    filteredArticles() {
      if (!this.keyword) return this.articles
      const keyword = this.keyword.toLowerCase()
      return this.articles.filter((article) => {
        return [article.title, article.summary, article.tags]
          .join(' ')
          .toLowerCase()
          .includes(keyword)
      })
    },
    headlines() {
      return this.articles.slice(0, 2)
    },
    rankings() {
      return [...this.articles]
        .sort((a, b) => b.views - a.views)
        .slice(0, 12)
    }
  },
  created() {
    this.fetchArticles()
  },
  methods: {
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

.apple-news-page {
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
  mask-image: linear-gradient(180deg, transparent, #000 16%, #000 84%, transparent);
}

.news-wrap {
  position: relative;
  z-index: 1;
  width: min(1452px, calc(100% - 48px));
  margin: 0 auto;
  padding: 120px 0 72px;
}

.category-bar {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(320px, 360px);
  gap: 36px;
  align-items: start;
  padding: 0 2px 32px;
}

.category-lines {
  display: grid;
  gap: 22px;
}

.category-row {
  display: flex;
  flex-wrap: wrap;
  gap: 14px 0;
}

.category-link {
  position: relative;
  display: inline-flex;
  align-items: center;
  min-height: 22px;
  padding: 0 22px;
  color: rgba(245, 245, 247, 0.76);
  font-size: 16px;
  font-weight: 600;
  transition: color 0.2s ease, transform 0.2s ease;
}

.category-link:first-child {
  padding-left: 0;
}

.category-link:not(:last-child)::after {
  content: "";
  position: absolute;
  right: 0;
  top: 2px;
  width: 1px;
  height: 18px;
  background: rgba(245, 245, 247, 0.4);
}

.category-link:hover {
  color: #fff;
  transform: translateY(-1px);
}

.search-stack {
  display: grid;
  gap: 12px;
}

.search-box {
  display: grid;
  grid-template-columns: 38px minmax(0, 1fr) 72px;
  align-items: center;
  height: 46px;
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.16);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(22px) saturate(150%);
  -webkit-backdrop-filter: blur(22px) saturate(150%);
}

.search-icon {
  justify-self: center;
  color: rgba(245, 245, 247, 0.55);
}

.search-box input {
  width: 100%;
  min-width: 0;
  border: 0;
  outline: 0;
  color: #f5f5f7;
  background: transparent;
}

.search-box input::placeholder {
  color: rgba(245, 245, 247, 0.45);
}

.search-box button {
  height: 100%;
  border: 0;
  color: #fff;
  cursor: pointer;
  background: #ff3b30;
  font-weight: 700;
  transition: background 0.2s ease;
}

.search-box button:hover {
  background: #ff453a;
}

.hot-words {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin: 0;
  color: rgba(245, 245, 247, 0.5);
  font-size: 14px;
}

.hot-words a {
  color: rgba(245, 245, 247, 0.62);
}

.hot-words a:hover {
  color: #fff;
}

.headline-strip {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1px;
  margin-bottom: 46px;
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.09);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.07);
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.28);
  backdrop-filter: blur(26px) saturate(160%);
  -webkit-backdrop-filter: blur(26px) saturate(160%);
}

.headline-item {
  display: flex;
  align-items: center;
  gap: 14px;
  min-width: 0;
  padding: 18px clamp(20px, 4vw, 56px);
  background: rgba(255, 255, 255, 0.035);
}

.headline-number {
  display: inline-grid;
  flex: 0 0 auto;
  place-items: center;
  width: 34px;
  height: 34px;
  border-radius: 50%;
  color: #fff;
  background: #ff3b30;
  font-weight: 800;
}

.headline-item strong {
  min-width: 0;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.9);
  font-size: clamp(20px, 2vw, 34px);
  font-weight: 700;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.hero-band {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(260px, 420px);
  gap: 34px;
  align-items: center;
  min-height: 260px;
  margin-bottom: 42px;
  padding: clamp(28px, 5vw, 58px);
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.09);
  border-radius: 8px;
  background:
    linear-gradient(120deg, rgba(245, 245, 247, 0.13), rgba(245, 245, 247, 0.04)),
    rgba(29, 29, 31, 0.72);
  box-shadow: 0 34px 120px rgba(0, 0, 0, 0.34);
  backdrop-filter: blur(30px) saturate(160%);
  -webkit-backdrop-filter: blur(30px) saturate(160%);
}

.eyebrow {
  margin: 0 0 10px;
  color: #2997ff;
  font-size: 15px;
  font-weight: 700;
}

.hero-copy h1 {
  margin: 0;
  color: #f5f5f7;
  font-size: clamp(46px, 8vw, 104px);
  font-weight: 800;
  line-height: 1;
}

.hero-copy p:last-child {
  max-width: 650px;
  margin: 18px 0 0;
  color: rgba(245, 245, 247, 0.72);
  font-size: clamp(17px, 1.7vw, 23px);
  line-height: 1.55;
}

.hero-device {
  position: relative;
  min-height: 210px;
}

.device-screen {
  position: absolute;
  right: 14px;
  top: 8px;
  width: min(92%, 360px);
  aspect-ratio: 16 / 10;
  border: 1px solid rgba(245, 245, 247, 0.18);
  border-radius: 8px;
  background:
    radial-gradient(circle at 24% 28%, rgba(52, 199, 89, 0.9), transparent 16%),
    radial-gradient(circle at 72% 28%, rgba(255, 204, 0, 0.86), transparent 18%),
    radial-gradient(circle at 58% 76%, rgba(0, 122, 255, 0.92), transparent 22%),
    linear-gradient(135deg, #1d1d1f, #3a3a3c);
  box-shadow:
    0 30px 70px rgba(0, 0, 0, 0.42),
    inset 0 1px 0 rgba(255, 255, 255, 0.2);
}

.device-screen::after {
  content: "";
  position: absolute;
  inset: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  background:
    linear-gradient(90deg, rgba(255, 255, 255, 0.14) 1px, transparent 1px),
    linear-gradient(rgba(255, 255, 255, 0.14) 1px, transparent 1px);
  background-size: 44px 44px;
}

.device-base {
  position: absolute;
  right: 64px;
  bottom: 24px;
  width: min(62%, 260px);
  height: 20px;
  border-radius: 999px;
  background: linear-gradient(90deg, #8e8e93, #f5f5f7 52%, #636366);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.34);
}

.device-chip {
  position: absolute;
  left: 10%;
  bottom: 20px;
  width: 92px;
  height: 92px;
  border: 1px solid rgba(245, 245, 247, 0.18);
  border-radius: 8px;
  background:
    linear-gradient(135deg, rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0.04)),
    #151517;
  box-shadow: 0 18px 44px rgba(0, 0, 0, 0.38);
}

.device-chip::before {
  content: "AI";
  position: absolute;
  inset: 18px;
  display: grid;
  place-items: center;
  border-radius: 6px;
  color: #f5f5f7;
  background: linear-gradient(135deg, #0071e3, #34c759);
  font-size: 24px;
  font-weight: 800;
}

.content-grid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 412px;
  gap: 48px;
  align-items: start;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 18px;
  margin-bottom: 28px;
}

.section-title h2 {
  position: relative;
  margin: 0;
  color: #f5f5f7;
  font-size: 28px;
  line-height: 1.2;
}

.section-title h2::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -13px;
  width: 68px;
  height: 3px;
  border-radius: 999px;
  background: #ff3b30;
}

.section-title span {
  flex: 1;
  height: 1px;
  background: rgba(245, 245, 247, 0.24);
}

.feed-panel {
  min-width: 0;
}

.article-state {
  display: grid;
  place-items: center;
  min-height: 160px;
  color: rgba(245, 245, 247, 0.68);
  border: 1px solid rgba(245, 245, 247, 0.1);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.05);
  font-size: 16px;
}

.article-state--error {
  color: #ff9f0a;
}

.article-card {
  display: grid;
  grid-template-columns: 218px minmax(0, 1fr);
  gap: 24px;
  align-items: center;
  padding: 24px 0;
  border-bottom: 1px solid rgba(245, 245, 247, 0.1);
}

.article-card:first-of-type {
  padding-top: 20px;
}

.article-media {
  position: relative;
  display: block;
  aspect-ratio: 4 / 3;
  overflow: hidden;
  border-radius: 8px;
  background: #1d1d1f;
  box-shadow: 0 22px 52px rgba(0, 0, 0, 0.32);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.article-media:hover {
  transform: translateY(-3px);
  box-shadow: 0 28px 64px rgba(0, 0, 0, 0.44);
}

.media-shine {
  position: absolute;
  inset: -34%;
  background: linear-gradient(115deg, transparent 26%, rgba(255, 255, 255, 0.24) 48%, transparent 62%);
  transform: translateX(-18%) rotate(8deg);
}

.media-device {
  position: absolute;
  inset: 24px;
  border-radius: 8px;
}

.media-label {
  position: absolute;
  left: 18px;
  bottom: 16px;
  color: #fff;
  font-size: 26px;
  font-weight: 800;
  text-shadow: 0 8px 22px rgba(0, 0, 0, 0.45);
}

.thumb-keyboard {
  background:
    radial-gradient(circle at 70% 78%, rgba(191, 90, 242, 0.9), transparent 18%),
    radial-gradient(circle at 22% 24%, rgba(255, 149, 0, 0.9), transparent 20%),
    linear-gradient(135deg, #101014, #332318 48%, #121214);
}

.thumb-keyboard .media-device {
  top: 30px;
  height: 62px;
  border: 1px solid rgba(255, 255, 255, 0.32);
  background:
    linear-gradient(90deg, rgba(255, 59, 48, 0.9) 0 18%, rgba(255, 149, 0, 0.9) 18% 36%, rgba(255, 204, 0, 0.9) 36% 54%, rgba(52, 199, 89, 0.9) 54% 72%, rgba(0, 122, 255, 0.9) 72% 100%);
  box-shadow: 0 46px 0 -10px rgba(245, 245, 247, 0.86);
}

.thumb-mouse {
  background:
    radial-gradient(circle at 72% 24%, rgba(255, 255, 255, 0.35), transparent 16%),
    linear-gradient(135deg, #e5d8bf, #9a8f7f 52%, #171719);
}

.thumb-mouse .media-device {
  left: 64px;
  right: 64px;
  top: 24px;
  bottom: 24px;
  border: 1px solid rgba(255, 255, 255, 0.16);
  border-radius: 18px;
  background:
    radial-gradient(circle at 50% 31%, #ff3b30 0 8px, transparent 9px),
    linear-gradient(135deg, #2c2c2e, #0f0f11);
  box-shadow:
    inset 0 0 0 10px rgba(255, 255, 255, 0.04),
    0 18px 42px rgba(0, 0, 0, 0.42);
}

.thumb-display {
  background:
    radial-gradient(circle at 18% 20%, rgba(0, 122, 255, 0.9), transparent 12%),
    radial-gradient(circle at 70% 38%, rgba(255, 59, 48, 0.76), transparent 18%),
    radial-gradient(circle at 46% 74%, rgba(52, 199, 89, 0.76), transparent 16%),
    #050506;
}

.thumb-display .media-device {
  inset: 38px 18px;
  border: 1px solid rgba(255, 255, 255, 0.16);
  background:
    linear-gradient(90deg, rgba(255, 255, 255, 0.18) 1px, transparent 1px),
    linear-gradient(rgba(255, 255, 255, 0.18) 1px, transparent 1px);
  background-size: 24px 24px;
}

.thumb-laptop {
  background:
    radial-gradient(circle at 24% 26%, rgba(255, 204, 0, 0.68), transparent 16%),
    radial-gradient(circle at 76% 74%, rgba(0, 122, 255, 0.74), transparent 20%),
    linear-gradient(135deg, #f5f5f7, #a1a1a6 48%, #202024 49%, #121214);
}

.thumb-laptop .media-device {
  top: 28px;
  bottom: 34px;
  left: 36px;
  right: 36px;
  border: 1px solid rgba(255, 255, 255, 0.26);
  background:
    linear-gradient(90deg, rgba(0, 0, 0, 0.16) 1px, transparent 1px),
    linear-gradient(rgba(0, 0, 0, 0.16) 1px, transparent 1px),
    rgba(245, 245, 247, 0.62);
  background-size: 18px 18px;
}

.article-body {
  min-width: 0;
}

.article-title {
  display: block;
  color: rgba(245, 245, 247, 0.92);
  font-size: clamp(20px, 2vw, 26px);
  font-weight: 800;
  line-height: 1.32;
  transition: color 0.2s ease;
}

.article-title:hover {
  color: #fff;
}

.article-body p {
  display: -webkit-box;
  margin: 14px 0 13px;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.56);
  font-size: 16px;
  line-height: 1.75;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.article-meta {
  display: flex;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
  color: rgba(245, 245, 247, 0.78);
  font-size: 15px;
}

.article-meta strong {
  color: #f5f5f7;
}

.article-meta time {
  flex: 0 0 auto;
  color: #ff453a;
  font-weight: 700;
}

.side-column {
  position: sticky;
  top: 96px;
  display: grid;
  gap: 24px;
}

.ranking-panel,
.resource-panel {
  border: 1px solid rgba(245, 245, 247, 0.09);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.07);
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.24);
  backdrop-filter: blur(26px) saturate(160%);
  -webkit-backdrop-filter: blur(26px) saturate(160%);
}

.ranking-panel {
  padding: 20px 18px 18px;
}

.tabs {
  display: flex;
  align-items: center;
  gap: 24px;
  min-height: 34px;
  border-bottom: 1px solid rgba(245, 245, 247, 0.12);
}

.tabs button {
  position: relative;
  height: 34px;
  border: 0;
  color: rgba(245, 245, 247, 0.7);
  cursor: pointer;
  background: transparent;
  font-size: 16px;
  font-weight: 700;
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
  gap: 12px;
  margin: 18px 0 0;
  padding: 0;
  list-style: none;
}

.ranking-list li {
  display: grid;
  grid-template-columns: 26px minmax(0, 1fr);
  align-items: center;
  gap: 8px;
  min-width: 0;
}

.ranking-list span {
  display: grid;
  place-items: center;
  width: 22px;
  height: 22px;
  color: #fff;
  border-radius: 4px;
  background: rgba(245, 245, 247, 0.34);
  font-size: 13px;
  font-weight: 800;
}

.ranking-list span.hot {
  background: #ff3b30;
}

.ranking-list a {
  min-width: 0;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.72);
  font-size: 15px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.ranking-list a:hover {
  color: #fff;
}

.resource-panel {
  padding: 20px 18px;
}

.tabs.compact {
  margin-bottom: 16px;
}

.resource-row {
  display: grid;
  grid-template-columns: 54px minmax(0, 1fr) 28px;
  gap: 12px;
  align-items: center;
  min-height: 54px;
  padding: 8px 0;
  border-bottom: 1px solid rgba(245, 245, 247, 0.08);
}

.resource-row:last-child {
  border-bottom: 0;
}

.resource-badge {
  display: grid;
  place-items: center;
  width: 46px;
  height: 46px;
  border-radius: 8px;
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
  border: 1px solid rgba(245, 245, 247, 0.16);
}

.resource-badge.blue {
  color: #fff;
  background: #0071e3;
}

.resource-row strong {
  min-width: 0;
  overflow: hidden;
  color: rgba(245, 245, 247, 0.82);
  font-size: 16px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.resource-row .el-icon {
  display: grid;
  place-items: center;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  color: #f5f5f7;
  background: rgba(255, 255, 255, 0.1);
}

.floating-tools {
  position: fixed;
  right: 36px;
  top: 52%;
  z-index: 20;
  display: grid;
  overflow: hidden;
  border: 1px solid rgba(245, 245, 247, 0.18);
  border-radius: 8px;
  background: rgba(29, 29, 31, 0.72);
  backdrop-filter: blur(20px) saturate(160%);
  -webkit-backdrop-filter: blur(20px) saturate(160%);
}

.floating-tools button {
  display: grid;
  place-items: center;
  gap: 4px;
  width: 64px;
  height: 62px;
  border: 0;
  border-bottom: 1px solid rgba(245, 245, 247, 0.16);
  color: rgba(245, 245, 247, 0.82);
  cursor: pointer;
  background: transparent;
  font-size: 12px;
}

.floating-tools button:last-child {
  border-bottom: 0;
}

.floating-tools .el-icon {
  font-size: 22px;
}

.floating-tools button:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.08);
}

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

@media (max-width: 820px) {
  .news-wrap {
    width: min(100% - 28px, 720px);
    padding-top: 104px;
  }

  .category-bar {
    gap: 24px;
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
    padding: 0 18px;
  }

  .headline-strip,
  .hero-band,
  .side-column {
    grid-template-columns: 1fr;
  }

  .headline-item strong {
    white-space: normal;
  }

  .hero-band {
    padding: 28px;
  }

  .hero-device {
    min-height: 190px;
  }

  .article-card {
    grid-template-columns: 160px minmax(0, 1fr);
    gap: 18px;
  }

  .article-body p {
    -webkit-line-clamp: 3;
  }
}

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

  .article-card {
    grid-template-columns: 1fr;
    padding: 24px 0 28px;
  }

  .article-media {
    aspect-ratio: 16 / 10;
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
