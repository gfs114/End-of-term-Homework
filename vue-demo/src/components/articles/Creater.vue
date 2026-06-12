<template>
    <section class="my-articles-card creator-card">
        <div class="articles-head">
            <div>
                <p>创作者中心</p>
                <h2>文章数据</h2>
            </div>
        </div>

        <div v-if="articlesLoading" class="article-state">创作者数据加载中...</div>
        <div v-else-if="articlesError" class="article-state article-state--error">{{ articlesError }}</div>
        <div v-else-if="!myArticles.length" class="article-state">你还没有可统计的文章</div>

        <div v-else class="creator-dashboard">
            <div class="creator-metrics">
                <div v-for="metric in creatorMetrics" :key="metric.label" class="creator-metric">
                    <span>{{ metric.label }}</span>
                    <strong>{{ metric.value }}</strong>
                </div>
            </div>

            <div class="creator-chart-panel">
                <div ref="creatorChart" class="creator-chart"></div>
            </div>

            <div class="creator-article-list">
                <router-link
                    v-for="article in creatorArticleRows"
                    :key="article.id"
                    :to="`/article/${article.id}`"
                    class="creator-article-row"
                >
                    <div>
                        <h3>{{ article.title }}</h3>
                        <p>{{ article.category || '文章' }}</p>
                    </div>
                    <div class="creator-article-stats">
                        <span>文章总浏览次数 {{ article.views }}</span>
                        <span>收藏人数 {{ article.favorites }}</span>
                    </div>
                </router-link>
            </div>
        </div>
    </section>
</template>

<script>
import * as echarts from 'echarts'
import http from '@/utils/http'

function pickList(payload) {
    if (Array.isArray(payload)) return payload
    if (Array.isArray(payload?.data)) return payload.data
    if (Array.isArray(payload?.articles)) return payload.articles
    if (Array.isArray(payload?.data?.data)) return payload.data.data
    return []
}

function toNumber(value) {
    const numberValue = Number(value || 0)
    return Number.isFinite(numberValue) ? numberValue : 0
}

function pickNumber(item, keys) {
    for (let index = 0; index < keys.length; index += 1) {
        const key = keys[index]

        if (item && item[key] !== undefined && item[key] !== null && item[key] !== '') {
            return toNumber(item[key])
        }
    }

    return 0
}

export default {
    name: 'CreaterModule',
    data() {
        return {
            articlesLoading: false,
            articlesError: '',
            username: localStorage.getItem('loginUsername') || localStorage.getItem('adminUsername') || '',
            myArticles: [],
            creatorChart: null,
            creatorResizeHandler: null,
            chartTheme: localStorage.getItem('theme') !== 'light' ? 'dark' : 'light'
        }
    },
    computed: {
        chartColors() {
            const dark = this.chartTheme === 'dark'
            return {
                textColor: dark ? '#8b949e' : '#687386',
                axisColor: dark ? '#30363d' : '#e2e8f0',
                bgColor: dark ? '#161b22' : '#ffffff',
                legendColor: dark ? '#e6edf3' : '#1f2937',
                titleColor: dark ? '#f0f0f0' : '#1f2937'
            }
        },
        creatorTotalViews() {
            return this.myArticles.reduce((total, article) => total + article.views, 0)
        },
        creatorTotalFavorites() {
            return this.myArticles.reduce((total, article) => total + article.favorites, 0)
        },
        creatorMetrics() {
            return [
                { label: '文章数量', value: this.myArticles.length },
                { label: '文章总浏览次数', value: this.creatorTotalViews },
                { label: '收藏人数', value: this.creatorTotalFavorites }
            ]
        },
        creatorArticleRows() {
            return [...this.myArticles].sort((prev, next) => next.views - prev.views)
        },
        creatorTrendData() {
            const articles = this.creatorArticleRows.slice(0, 8)

            return {
                labels: articles.map((article) => article.title),
                views: articles.map((article) => article.views),
                favorites: articles.map((article) => article.favorites)
            }
        }
    },
    mounted() {
        this.creatorResizeHandler = () => this.resizeCreatorChart()
        window.addEventListener('resize', this.creatorResizeHandler)
        this.fetchCreatorArticles()
        this.chartThemeObserver = new MutationObserver(() => {
            this.syncChartTheme()
        })
        this.chartThemeObserver.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ['data-theme']
        })
    },
    beforeUnmount() {
        if (this.creatorResizeHandler) {
            window.removeEventListener('resize', this.creatorResizeHandler)
        }
        if (this.chartThemeObserver) {
            this.chartThemeObserver.disconnect()
        }
        if (this.creatorChart) {
            this.creatorChart.dispose()
            this.creatorChart = null
        }
    },
    methods: {
        normalizeArticle(item) {
            const views = pickNumber(item, ['views', 'view_count', 'viewCount', 'clicks', 'click_count', 'clickCount', 'read_count', 'readCount'])
            const favorites = pickNumber(item, ['favorites', 'favorite_count', 'favoriteCount', 'collects', 'collect_count', 'collectCount'])

            return {
                id: item.id,
                title: item.title || '未命名文章',
                author: item.author,
                category: item.category,
                views,
                favorites
            }
        },
        async fetchCreatorArticles() {
            if (!this.username) {
                this.myArticles = []
                return
            }

            this.articlesLoading = true
            this.articlesError = ''

            try {
                const { data } = await http.get('/articles')
                this.myArticles = pickList(data)
                    .map((item) => this.normalizeArticle(item))
                    .filter((item) => String(item.author || '') === this.username)
            } catch (error) {
                this.articlesError = '创作者数据加载失败，请稍后再试'
            } finally {
                this.articlesLoading = false
                this.$nextTick(() => this.renderCreatorChart())
            }
        },
        renderCreatorChart() {
            if (!this.$refs.creatorChart || !this.myArticles.length) {
                if (this.creatorChart) {
                    this.creatorChart.dispose()
                    this.creatorChart = null
                }
                return
            }

            if (!this.creatorChart) {
                this.creatorChart = echarts.init(this.$refs.creatorChart)
            }

            const colors = this.chartColors
            this.creatorChart.setOption({
                tooltip: {
                    trigger: 'axis',
                    backgroundColor: colors.bgColor,
                    borderColor: colors.axisColor,
                    textStyle: { color: colors.legendColor }
                },
                legend: {
                    top: 0,
                    right: 0,
                    data: ['文章总浏览次数', '收藏人数'],
                    textStyle: { color: colors.legendColor }
                },
                grid: {
                    top: 44,
                    right: 18,
                    bottom: 32,
                    left: 42
                },
                xAxis: {
                    type: 'category',
                    data: this.creatorTrendData.labels,
                    axisLabel: {
                        interval: 0,
                        overflow: 'truncate',
                        width: 88,
                        color: colors.textColor
                    },
                    axisLine: { lineStyle: { color: colors.axisColor } },
                    axisTick: { lineStyle: { color: colors.axisColor } }
                },
                yAxis: {
                    type: 'value',
                    minInterval: 1,
                    axisLabel: { color: colors.textColor },
                    splitLine: { lineStyle: { color: colors.axisColor } }
                },
                series: [
                    {
                        name: '文章总浏览次数',
                        type: 'bar',
                        barMaxWidth: 34,
                        itemStyle: {
                            color: '#2563eb',
                            borderRadius: [8, 8, 0, 0]
                        },
                        data: this.creatorTrendData.views
                    },
                    {
                        name: '收藏人数',
                        type: 'bar',
                        barMaxWidth: 34,
                        itemStyle: {
                            color: '#f59e0b',
                            borderRadius: [8, 8, 0, 0]
                        },
                        data: this.creatorTrendData.favorites
                    }
                ]
            })
        },
        resizeCreatorChart() {
            if (this.creatorChart) {
                this.creatorChart.resize()
            }
        },
        syncChartTheme() {
            const theme = localStorage.getItem('theme') || 'dark'
            const isDark = theme !== 'light'
            this.chartTheme = isDark ? 'dark' : 'light'
            if (this.creatorChart) {
                this.creatorChart.dispose()
                this.creatorChart = null
            }
            this.renderCreatorChart()
        }
    },
}
</script>

<style scoped>
.my-articles-card {
    margin-top: 22px;
    border: 1px solid #dbe7f3;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.92);
    box-shadow: 0 18px 50px rgba(45, 73, 112, 0.08);
}

.creator-card {
    border: 0;
    background: transparent;
    box-shadow: none;
}

.articles-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    margin-bottom: 16px;
}

.articles-head p {
    margin: 0 0 6px;
    color: #687386;
    font-size: 13px;
    font-weight: 700;
}

.articles-head h2 {
    margin: 0;
    color: #101827;
    font-size: 26px;
}

.article-state {
    display: grid;
    min-height: 120px;
    place-items: center;
    color: #64748b;
    border: 1px dashed #cbd5e1;
    border-radius: 8px;
    background: #f8fafc;
}

.article-state--error {
    color: #dc2626;
}

.creator-dashboard {
    display: grid;
    gap: 24px;
}

.creator-metrics {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 24px;
}

.creator-metric {
    position: relative;
    min-width: 0;
    min-height: 168px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 28px 26px;
    border: 0;
    border-radius: 8px;
    background: #f8fbfd;
    box-sizing: border-box;
}

.creator-metric span {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    color: #727d89;
    font-size: 18px;
    line-height: 1;
}

.creator-metric strong {
    color: #253247;
    font-size: 38px;
    font-weight: 700;
    line-height: 1.1;
    letter-spacing: 0;
}

.creator-metric:nth-child(2)::after {
    content: "▲";
    position: absolute;
    top: 30px;
    right: 26px;
    color: #ff3f7f;
    font-size: 18px;
    line-height: 1;
}

.creator-chart-panel {
    overflow: hidden;
    padding: 22px;
    border: 0;
    border-radius: 8px;
    background: #f8fbfd;
}

.creator-chart {
    width: 100%;
    height: 320px;
}

.creator-article-list {
    display: grid;
    gap: 12px;
}

.creator-article-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(280px, 0.92fr);
    gap: 18px;
    align-items: center;
    padding: 16px;
    color: inherit;
    text-decoration: none;
    border: 0;
    border-radius: 8px;
    background: #f8fbfd;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.creator-article-row:hover {
    transform: translateY(-2px);
    box-shadow: 0 14px 34px rgba(37, 99, 235, 0.08);
}

.creator-article-row h3 {
    margin: 0 0 8px;
    overflow: hidden;
    color: #172033;
    font-size: 18px;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.creator-article-row p {
    margin: 0;
    color: #64748b;
    font-size: 14px;
}

.creator-article-stats {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 8px;
}

.creator-article-stats span {
    min-width: 0;
    padding: 8px 10px;
    color: #5f6f86;
    border-radius: 8px;
    background: #fff;
    font-size: 13px;
    font-weight: 700;
    overflow-wrap: anywhere;
}

@media (max-width: 640px) {
    .my-articles-card {
        padding: 20px;
    }

    .creator-metrics {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 14px;
    }

    .creator-metric {
        min-height: 136px;
        padding: 20px;
    }

    .creator-metric span {
        font-size: 15px;
    }

    .creator-metric strong {
        font-size: 30px;
    }

    .creator-chart {
        height: 280px;
    }

    .articles-head,
    .creator-article-row {
        grid-template-columns: 1fr;
    }

    .creator-article-stats {
        grid-template-columns: 1fr;
    }

    .articles-head {
        align-items: flex-start;
        flex-direction: column;
    }
}
</style>
