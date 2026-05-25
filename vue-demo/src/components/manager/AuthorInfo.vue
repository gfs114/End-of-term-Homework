<template>
  <section class="author-info-page">
    <el-card class="author-info-card" shadow="never">
      <template #header>
        <div class="page-header">
          <div>
            <h2>作者信息</h2>
            <p>从文章数据中查询并汇总已有作者</p>
          </div>
          <el-button type="primary" :loading="tableLoading" @click="fetchArticleList">
            刷新
          </el-button>
        </div>
      </template>

      <el-table
        v-loading="tableLoading"
        :data="authorList"
        border
        stripe
        class="author-table"
        empty-text="暂无作者数据"
      >
        <el-table-column prop="name" label="作者" min-width="160">
          <template #default="{ row }">
            <strong>{{ row.name }}</strong>
          </template>
        </el-table-column>
        <el-table-column prop="articleCount" label="文章数" width="120" sortable align="center" />
        <el-table-column prop="totalViews" label="浏览数" width="120" sortable align="center" />
        <el-table-column prop="totalFavorites" label="收藏数" width="120" sortable align="center" />
        <el-table-column prop="categories" label="文章分类" min-width="220">
          <template #default="{ row }">
            <el-tag
              v-for="category in row.categories"
              :key="category"
              class="category-tag"
              effect="plain"
            >
              {{ category }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="latestTitle" label="最近文章" min-width="220">
          <template #default="{ row }">
            <span>{{ row.latestTitle || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="latestTime" label="最近发布时间" min-width="180">
          <template #default="{ row }">
            <span>{{ formatDate(row.latestTime) }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
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

function toNumber(value) {
  const numberValue = Number(value)
  return Number.isFinite(numberValue) ? numberValue : 0
}

export default {
  name: 'AuthorInfo',
  data() {
    return {
      tableLoading: false,
      articleList: []
    }
  },
  computed: {
    authorList() {
      const authorMap = {}

      this.articleList.forEach((article) => {
        const name = String(article.author || '').trim() || '未填写作者'
        const category = article.category || '文章'
        const latestTime = article.updated_at || article.created_at || ''

        if (!authorMap[name]) {
          authorMap[name] = {
            name,
            articleCount: 0,
            totalViews: 0,
            totalFavorites: 0,
            categories: [],
            latestTitle: '',
            latestTime: ''
          }
        }

        authorMap[name].articleCount += 1
        authorMap[name].totalViews += toNumber(article.views)
        authorMap[name].totalFavorites += toNumber(article.favorites)

        if (!authorMap[name].categories.includes(category)) {
          authorMap[name].categories.push(category)
        }

        if (this.isLaterTime(latestTime, authorMap[name].latestTime)) {
          authorMap[name].latestTime = latestTime
          authorMap[name].latestTitle = article.title || '未命名文章'
        }
      })

      return Object.values(authorMap).sort((prev, next) => {
        return next.articleCount - prev.articleCount
      })
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
        this.articleList = pickList(data)
      } catch (error) {
        this.articleList = []
        this.$message.error('获取作者信息失败')
      } finally {
        this.tableLoading = false
      }
    },
    isLaterTime(nextTime, currentTime) {
      if (!currentTime) {
        return true
      }

      const nextDate = new Date(nextTime)
      const currentDate = new Date(currentTime)

      if (Number.isNaN(nextDate.getTime())) {
        return false
      }

      if (Number.isNaN(currentDate.getTime())) {
        return true
      }

      return nextDate.getTime() > currentDate.getTime()
    },
    formatDate(value) {
      if (!value) return '-'

      const date = new Date(value)
      if (Number.isNaN(date.getTime())) return value

      return date.toLocaleString()
    }
  }
}
</script>

<style scoped>
.author-info-page {
  min-height: 100%;
}

.author-info-card {
  min-height: calc(100vh - 36px);
  border: 1px solid #ebeef5;
  border-radius: 8px;
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.page-header h2 {
  margin: 0;
  color: #111827;
  font-size: 18px;
}

.page-header p {
  margin: 6px 0 0;
  color: #64748b;
  font-size: 13px;
}

.author-table {
  width: 100%;
}

.category-tag {
  margin: 2px 6px 2px 0;
}

@media (max-width: 720px) {
  .page-header {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
