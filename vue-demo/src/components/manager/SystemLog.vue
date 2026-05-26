<template>
  <section class="system-log-page">
    <el-card class="system-log-card" shadow="never">
      <template #header>
        <div class="page-header">
          <div>
            <h2>系统日志</h2>
            <p>查看后台操作记录、访问状态和异常信息</p>
          </div>

          <div class="header-actions">
            <el-tag v-if="usingFallback" type="warning" effect="plain">前端示例数据</el-tag>
            <el-button type="primary" :loading="tableLoading" @click="fetchLogList">
              刷新
            </el-button>
          </div>
        </div>
      </template>

      <div class="stat-grid">
        <article v-for="item in logStats" :key="item.label" class="stat-card">
          <span>{{ item.label }}</span>
          <strong>{{ item.value }}</strong>
        </article>
      </div>

      <div class="filter-panel">
        <el-input
          v-model.trim="keyword"
          class="keyword-input"
          clearable
          placeholder="搜索操作人、模块、内容或 IP"
        />

        <el-select v-model="moduleFilter" class="filter-select" placeholder="模块">
          <el-option label="全部模块" value="全部" />
          <el-option v-for="moduleName in moduleOptions" :key="moduleName" :label="moduleName" :value="moduleName" />
        </el-select>

        <el-select v-model="statusFilter" class="filter-select" placeholder="状态">
          <el-option label="全部状态" value="全部" />
          <el-option label="成功" value="success" />
          <el-option label="失败" value="fail" />
          <el-option label="警告" value="warning" />
        </el-select>

        <el-select v-model="levelFilter" class="filter-select" placeholder="级别">
          <el-option label="全部级别" value="全部" />
          <el-option label="信息" value="info" />
          <el-option label="警告" value="warning" />
          <el-option label="错误" value="error" />
        </el-select>

        <el-date-picker
          v-model="dateRange"
          class="date-range"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="YYYY-MM-DD"
        />

        <el-button plain @click="resetFilters">重置</el-button>
      </div>

      <el-table
        v-loading="tableLoading"
        :data="pagedLogs"
        border
        stripe
        class="log-table"
        empty-text="暂无系统日志"
      >
        <el-table-column prop="createdAt" label="时间" min-width="180">
          <template #default="{ row }">
            <span>{{ formatDate(row.createdAt) }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="operator" label="操作人" min-width="130">
          <template #default="{ row }">
            <span>{{ row.operator || '-' }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="module" label="模块" min-width="130">
          <template #default="{ row }">
            <el-tag effect="plain">{{ row.module || '系统' }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="action" label="操作内容" min-width="260" show-overflow-tooltip />

        <el-table-column prop="status" label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getStatusTagType(row.status)" effect="light">
              {{ getStatusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="level" label="级别" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getLevelTagType(row.level)" effect="plain">
              {{ getLevelLabel(row.level) }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="ip" label="IP 地址" min-width="150">
          <template #default="{ row }">
            <span>{{ row.ip || '-' }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="110" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link @click="openDetail(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrap">
        <el-pagination
          v-if="filteredLogList.length > pageSize"
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 30, 50]"
          :total="filteredLogList.length"
          layout="total, sizes, prev, pager, next, jumper"
        />
      </div>
    </el-card>

    <el-dialog v-model="detailVisible" title="日志详情" width="620px">
      <dl v-if="selectedLog" class="detail-list">
        <div>
          <dt>时间</dt>
          <dd>{{ formatDate(selectedLog.createdAt) }}</dd>
        </div>
        <div>
          <dt>操作人</dt>
          <dd>{{ selectedLog.operator || '-' }}</dd>
        </div>
        <div>
          <dt>模块</dt>
          <dd>{{ selectedLog.module || '系统' }}</dd>
        </div>
        <div>
          <dt>操作内容</dt>
          <dd>{{ selectedLog.action || '-' }}</dd>
        </div>
        <div>
          <dt>状态</dt>
          <dd>{{ getStatusLabel(selectedLog.status) }}</dd>
        </div>
        <div>
          <dt>级别</dt>
          <dd>{{ getLevelLabel(selectedLog.level) }}</dd>
        </div>
        <div>
          <dt>IP 地址</dt>
          <dd>{{ selectedLog.ip || '-' }}</dd>
        </div>
        <div>
          <dt>浏览器信息</dt>
          <dd>{{ selectedLog.userAgent || '-' }}</dd>
        </div>
        <div>
          <dt>详细说明</dt>
          <dd>{{ selectedLog.detail || selectedLog.action || '-' }}</dd>
        </div>
      </dl>
    </el-dialog>
  </section>
</template>

<script>
import http from '@/utils/http'

export default {
  name: 'SystemLog',
  data() {
    return {
      tableLoading: false,
      usingFallback: false,
      logList: [],
      keyword: '',
      moduleFilter: '全部',
      statusFilter: '全部',
      levelFilter: '全部',
      dateRange: [],
      currentPage: 1,
      pageSize: 10,
      detailVisible: false,
      selectedLog: null
    }
  },
  computed: {
    moduleOptions() {
      const modules = this.logList.map((item) => item.module || '系统')

      return modules.filter((moduleName, index) => modules.indexOf(moduleName) === index)
    },
    filteredLogList() {
      const keyword = this.keyword.toLowerCase()

      return this.logList.filter((item) => {
        const searchable = [
          item.operator,
          item.module,
          item.action,
          item.status,
          item.level,
          item.ip,
          item.detail
        ].join(' ').toLowerCase()
        const matchesKeyword = !keyword || searchable.includes(keyword)
        const matchesModule = this.moduleFilter === '全部' || item.module === this.moduleFilter
        const matchesStatus = this.statusFilter === '全部' || item.status === this.statusFilter
        const matchesLevel = this.levelFilter === '全部' || item.level === this.levelFilter
        const matchesDate = this.isInDateRange(item.createdAt)

        return matchesKeyword && matchesModule && matchesStatus && matchesLevel && matchesDate
      })
    },
    pagedLogs() {
      const start = (this.currentPage - 1) * this.pageSize

      return this.filteredLogList.slice(start, start + this.pageSize)
    },
    logStats() {
      return [
        { label: '日志总数', value: this.logList.length },
        { label: '成功操作', value: this.countByStatus('success') },
        { label: '警告记录', value: this.countByLevel('warning') },
        { label: '异常记录', value: this.countByLevel('error') }
      ]
    }
  },
  watch: {
    keyword() {
      this.resetPage()
    },
    moduleFilter() {
      this.resetPage()
    },
    statusFilter() {
      this.resetPage()
    },
    levelFilter() {
      this.resetPage()
    },
    pageSize() {
      this.resetPage()
    },
    dateRange() {
      this.resetPage()
    },
    filteredLogList() {
      const totalPage = Math.max(1, Math.ceil(this.filteredLogList.length / this.pageSize))

      if (this.currentPage > totalPage) {
        this.currentPage = totalPage
      }
    }
  },
  created() {
    this.fetchLogList()
  },
  methods: {
    async fetchLogList() {
      this.tableLoading = true

      try {
        const response = await http.get('/system-logs')
        const list = this.pickLogList(response.data)

        this.logList = this.normalizeLogList(list)
        this.usingFallback = false
      } catch (error) {
        this.useFallbackLogs()
      } finally {
        this.tableLoading = false
      }
    },
    pickLogList(payload) {
      if (Array.isArray(payload)) {
        return payload
      }

      if (!payload || typeof payload !== 'object') {
        return []
      }

      if (Array.isArray(payload.data)) {
        return payload.data
      }

      if (Array.isArray(payload.logs)) {
        return payload.logs
      }

      if (payload.data && Array.isArray(payload.data.logs)) {
        return payload.data.logs
      }

      return []
    },
    normalizeLogList(list) {
      return list.map((item, index) => this.normalizeLogItem(item, index))
        .sort((prev, next) => new Date(next.createdAt).getTime() - new Date(prev.createdAt).getTime())
    },
    normalizeLogItem(item, index) {
      const status = this.normalizeStatus(item.status)
      const level = this.normalizeLevel(item.level, status)

      return {
        id: item.id || index + 1,
        operator: item.operator || item.username || item.admin_name || item.adminName || '系统',
        module: item.module || item.module_name || item.moduleName || '系统',
        action: item.action || item.operation || item.content || item.message || '系统操作',
        status,
        level,
        ip: item.ip || item.ip_address || item.ipAddress || '-',
        userAgent: item.user_agent || item.userAgent || '-',
        detail: item.detail || item.description || item.remark || '',
        createdAt: item.created_at || item.createdAt || item.time || item.created_time || new Date()
      }
    },
    normalizeStatus(status) {
      const value = String(status || 'success').toLowerCase()

      if (['fail', 'failed', 'error'].includes(value)) {
        return 'fail'
      }

      if (['warning', 'warn'].includes(value)) {
        return 'warning'
      }

      return 'success'
    },
    normalizeLevel(level, status) {
      const value = String(level || '').toLowerCase()

      if (['error', 'danger'].includes(value) || status === 'fail') {
        return 'error'
      }

      if (['warning', 'warn'].includes(value) || status === 'warning') {
        return 'warning'
      }

      return 'info'
    },
    useFallbackLogs() {
      this.logList = this.normalizeLogList(this.buildFallbackLogs())
      this.usingFallback = true
    },
    buildFallbackLogs() {
      return [
        {
          id: 1,
          operator: 'admin',
          module: '管理员信息',
          action: '查看管理员列表',
          status: 'success',
          level: 'info',
          ip: '127.0.0.1',
          user_agent: 'Chrome',
          detail: '管理员进入管理员信息管理模块',
          created_at: this.getMinutesAgoTime(5)
        },
        {
          id: 2,
          operator: 'admin',
          module: '用户信息',
          action: '新增用户信息',
          status: 'success',
          level: 'info',
          ip: '127.0.0.1',
          user_agent: 'Chrome',
          detail: '管理员新增用户后刷新用户列表',
          created_at: this.getMinutesAgoTime(18)
        },
        {
          id: 3,
          operator: 'admin',
          module: '设备信息',
          action: '修改手机型号信息',
          status: 'success',
          level: 'info',
          ip: '127.0.0.1',
          user_agent: 'Chrome',
          detail: '管理员更新设备配置展示字段',
          created_at: this.getMinutesAgoTime(42)
        },
        {
          id: 4,
          operator: 'system',
          module: '系统接口',
          action: '访问不存在的日志接口',
          status: 'warning',
          level: 'warning',
          ip: '127.0.0.1',
          user_agent: 'Chrome',
          detail: '后端未接入 /api/system-logs 时显示前端示例数据',
          created_at: this.getMinutesAgoTime(60)
        },
        {
          id: 5,
          operator: 'admin',
          module: '文章管理',
          action: '获取文章收藏信息',
          status: 'success',
          level: 'info',
          ip: '127.0.0.1',
          user_agent: 'Chrome',
          detail: '管理员查看文章收藏统计列表',
          created_at: this.getMinutesAgoTime(95)
        },
        {
          id: 6,
          operator: 'system',
          module: '登录认证',
          action: '管理员登录失败',
          status: 'fail',
          level: 'error',
          ip: '127.0.0.1',
          user_agent: 'Chrome',
          detail: '账号或密码错误，登录请求被拒绝',
          created_at: this.getMinutesAgoTime(130)
        }
      ]
    },
    getMinutesAgoTime(minutes) {
      return new Date(Date.now() - minutes * 60 * 1000)
    },
    countByStatus(status) {
      return this.logList.filter((item) => item.status === status).length
    },
    countByLevel(level) {
      return this.logList.filter((item) => item.level === level).length
    },
    isInDateRange(value) {
      if (!this.dateRange || this.dateRange.length !== 2) {
        return true
      }

      const date = new Date(value)

      if (Number.isNaN(date.getTime())) {
        return false
      }

      const start = new Date(`${this.dateRange[0]} 00:00:00`)
      const end = new Date(`${this.dateRange[1]} 23:59:59`)

      return date >= start && date <= end
    },
    resetPage() {
      this.currentPage = 1
    },
    resetFilters() {
      this.keyword = ''
      this.moduleFilter = '全部'
      this.statusFilter = '全部'
      this.levelFilter = '全部'
      this.dateRange = []
      this.resetPage()
    },
    openDetail(row) {
      this.selectedLog = row
      this.detailVisible = true
    },
    getStatusLabel(status) {
      const labels = {
        success: '成功',
        fail: '失败',
        warning: '警告'
      }

      return labels[status] || '成功'
    },
    getStatusTagType(status) {
      const types = {
        success: 'success',
        fail: 'danger',
        warning: 'warning'
      }

      return types[status] || 'success'
    },
    getLevelLabel(level) {
      const labels = {
        info: '信息',
        warning: '警告',
        error: '错误'
      }

      return labels[level] || '信息'
    },
    getLevelTagType(level) {
      const types = {
        info: 'primary',
        warning: 'warning',
        error: 'danger'
      }

      return types[level] || 'primary'
    },
    formatDate(value) {
      if (!value) {
        return '-'
      }

      const date = new Date(value)

      if (Number.isNaN(date.getTime())) {
        return value
      }

      return date.toLocaleString()
    }
  }
}
</script>

<style scoped>
.system-log-page {
  min-height: 100%;
}

.system-log-card {
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

.header-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 18px;
}

.stat-card {
  min-width: 0;
  padding: 18px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #f8fafc;
}

.stat-card span {
  display: block;
  margin-bottom: 10px;
  color: #64748b;
  font-size: 13px;
}

.stat-card strong {
  display: block;
  color: #0f172a;
  font-size: 28px;
  line-height: 1;
}

.filter-panel {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.keyword-input {
  width: 280px;
}

.filter-select {
  width: 132px;
}

.date-range {
  width: 260px;
}

.log-table {
  width: 100%;
}

.pagination-wrap {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

.detail-list {
  display: grid;
  gap: 12px;
  margin: 0;
}

.detail-list div {
  display: grid;
  grid-template-columns: 96px minmax(0, 1fr);
  gap: 14px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eef0f3;
}

.detail-list div:last-child {
  border-bottom: 0;
}

.detail-list dt {
  color: #64748b;
}

.detail-list dd {
  min-width: 0;
  margin: 0;
  color: #111827;
  overflow-wrap: anywhere;
}

@media (max-width: 1024px) {
  .stat-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .page-header {
    align-items: flex-start;
    flex-direction: column;
  }

  .header-actions,
  .keyword-input,
  .filter-select,
  .date-range {
    width: 100%;
  }

  .stat-grid {
    grid-template-columns: 1fr;
  }

  .filter-panel {
    align-items: stretch;
    flex-direction: column;
  }

  .pagination-wrap {
    justify-content: flex-start;
    overflow-x: auto;
  }

  .detail-list div {
    grid-template-columns: 1fr;
    gap: 6px;
  }
}
</style>
