<template>
  <section class="article-favorite-page">
    <el-card class="article-favorite-card" shadow="never">
      <template #header>
        <div class="page-header">
          <div>
            <h2>文章收藏信息</h2>
            <p>查看各文章当前收藏数量</p>
          </div>
          <el-button type="primary" :loading="tableLoading" @click="fetchFavoriteList">
            刷新
          </el-button>
        </div>
      </template>

      <el-table
        v-loading="tableLoading"
        :data="favoriteList"
        border
        stripe
        class="favorite-table"
        empty-text="暂无文章收藏数据"
      >
        <el-table-column prop="id" label="文章ID" width="100" />
        <el-table-column prop="title" label="文章标题" min-width="240">
          <template #default="{ row }">
            <span>{{ row.title || '未命名文章' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="category" label="分类" min-width="120">
          <template #default="{ row }">
            <el-tag effect="plain">{{ row.category || '文章' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="author" label="作者" min-width="140">
          <template #default="{ row }">
            <span>{{ row.author || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="favorites" label="收藏数" width="120" sortable align="center">
          <template #default="{ row }">
            <strong>{{ row.favorites }}</strong>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" min-width="180">
          <template #default="{ row }">
            <span>{{ formatDate(row.created_at) }}</span>
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

export default {
  name: 'ArticleFavoriteInfo',
  data() {
    return {
      tableLoading: false,
      favoriteList: []
    }
  },
  created() {
    this.fetchFavoriteList()
  },
  methods: {
    async fetchFavoriteList() {
      this.tableLoading = true

      try {
        const { data } = await http.get('/articles')
        this.favoriteList = pickList(data)
          .map((item) => ({
            ...item,
            favorites: Number(item.favorites) || 0
          }))
          .sort((prev, next) => next.favorites - prev.favorites)
      } catch (error) {
        this.$message.error('获取文章收藏信息失败')
      } finally {
        this.tableLoading = false
      }
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
.article-favorite-page {
  min-height: 100%;
}

.article-favorite-card {
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

.favorite-table {
  width: 100%;
}

@media (max-width: 720px) {
  .page-header {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
