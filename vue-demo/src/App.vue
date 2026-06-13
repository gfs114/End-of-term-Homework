<template>
  <div class="app-shell">
    <LiquidGlassNav v-if="!isAdminPage" />

    <main :class="['page-container', { 'page-container--admin': isAdminPage }]">
      <router-view></router-view>
    </main>
  </div>
</template>

<script>
import LiquidGlassNav from './components/LiquidGlassNav.vue'

export default {
  name: 'App',
  components: {
    LiquidGlassNav
  },
  computed: {
    // 判断当前是否进入后台页面，后台页面不显示前台导航并使用专用间距。
    isAdminPage() {
      return this.$route.path.startsWith('/alogin/admin')
    }
  },
  mounted() {
    // 读取用户保存的主题，刷新页面后保持深色/浅色模式一致。
    const theme = localStorage.getItem('theme') || 'dark'
    document.documentElement.setAttribute('data-theme', theme)
  }
}
</script>

<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-height: 100vh;
  font-family: Arial, "Microsoft YaHei", sans-serif;
  background: #0d1117;
  overflow-x: hidden;
}

:root {
  --input-title-color: #ffffff;
  --input-content-color: #e6edf3;
  --input-title-placeholder: #6e7681;
  --input-content-placeholder: #8b949e;
  --input-selection-bg: rgba(88, 166, 255, 0.25);
}

html[data-theme="light"] {
  --input-title-color: #1a1a2e;
  --input-content-color: #374151;
  --input-title-placeholder: #9ca3af;
  --input-content-placeholder: #6b7280;
  --input-selection-bg: rgba(37, 99, 235, 0.2);
}

[data-theme="light"] body {
  background: #f5f5f7;
}

.app-shell {
  min-height: 100vh;
}

.page-container {
  padding: 96px 24px 24px;
  background: #0d1117;
  min-height: 100vh;
}

[data-theme="light"] .page-container {
  background: #f5f5f7;
}

/* ================================================================
   DARK MODE — Phone / Computer / Login / Register / ForgetPassword
   ================================================================ */
[data-theme="dark"] .phone-zone,
[data-theme="dark"] .computer-zone {
  color: #e6edf3 !important;
}

[data-theme="dark"] .phone-zone .page-heading h1,
[data-theme="dark"] .computer-zone .page-heading h1,
[data-theme="dark"] .phone-zone h2,
[data-theme="dark"] .computer-zone h2,
[data-theme="dark"] .phone-zone h3,
[data-theme="dark"] .computer-zone h3 {
  color: #f0f0f0 !important;
}

[data-theme="dark"] .phone-zone .brand-hero,
[data-theme="dark"] .phone-zone .brand-card,
[data-theme="dark"] .computer-zone .brand-hero,
[data-theme="dark"] .computer-zone .brand-card {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.28) !important;
}

[data-theme="dark"] .phone-zone .section-head,
[data-theme="dark"] .computer-zone .section-head,
[data-theme="dark"] .phone-zone .brand-hero h2,
[data-theme="dark"] .computer-zone .brand-hero h2,
[data-theme="dark"] .phone-zone .brand-card h2,
[data-theme="dark"] .computer-zone .brand-card h2 {
  color: #f0f0f0 !important;
}

[data-theme="dark"] .phone-zone .brand-mark,
[data-theme="dark"] .computer-zone .brand-mark {
  background: rgba(255, 255, 255, 0.08) !important;
  border-color: rgba(255, 255, 255, 0.1) !important;
}

[data-theme="dark"] .phone-zone .model-card,
[data-theme="dark"] .computer-zone .model-card {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.22) !important;
  color: #e6edf3 !important;
}

[data-theme="dark"] .phone-zone .model-card:hover,
[data-theme="dark"] .computer-zone .model-card:hover {
  border-color: rgba(88, 166, 255, 0.3) !important;
  box-shadow: 0 8px 28px rgba(0, 0, 0, 0.34) !important;
}

[data-theme="dark"] .phone-zone .model-meta span,
[data-theme="dark"] .computer-zone .model-meta span {
  color: #8b949e !important;
}

[data-theme="dark"] .phone-zone .model-meta strong,
[data-theme="dark"] .computer-zone .model-meta strong {
  color: #e6edf3 !important;
}

[data-theme="dark"] .phone-zone .empty-state,
[data-theme="dark"] .computer-zone .empty-state {
  color: #8b949e !important;
}

[data-theme="dark"] .phone-zone .model-search input,
[data-theme="dark"] .computer-zone .model-search input,
[data-theme="dark"] .phone-zone .search-box input,
[data-theme="dark"] .computer-zone .search-box input {
  color: #e6edf3 !important;
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(255, 255, 255, 0.12) !important;
}

[data-theme="dark"] .phone-zone .model-pagination button,
[data-theme="dark"] .computer-zone .model-pagination button {
  color: #e6edf3 !important;
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(255, 255, 255, 0.12) !important;
}

[data-theme="dark"] .phone-zone .model-pagination button:hover,
[data-theme="dark"] .computer-zone .model-pagination button:hover {
  background: rgba(255, 255, 255, 0.12) !important;
}

[data-theme="dark"] .phone-zone .model-pagination button.active,
[data-theme="dark"] .computer-zone .model-pagination button.active {
  background: #2563eb !important;
  color: #fff !important;
}

[data-theme="dark"] .phone-zone .compare-output,
[data-theme="dark"] .computer-zone .compare-output,
[data-theme="dark"] .phone-zone .compare-head,
[data-theme="dark"] .computer-zone .compare-head {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
  color: #e6edf3 !important;
}

[data-theme="dark"] .phone-zone .compare-table,
[data-theme="dark"] .computer-zone .compare-table,
[data-theme="dark"] .phone-zone .compare-cell,
[data-theme="dark"] .computer-zone .compare-cell {
  color: #e6edf3 !important;
}

[data-theme="dark"] .phone-zone .compare-row,
[data-theme="dark"] .computer-zone .compare-row {
  border-color: rgba(255, 255, 255, 0.08) !important;
}

[data-theme="dark"] .phone-zone .compare-cell--label,
[data-theme="dark"] .computer-zone .compare-cell--label {
  color: #8b949e !important;
}

/* ---- computer-compare-section / phone-compare-section (PK 区) ---- */
[data-theme="dark"] .computer-compare-section,
[data-theme="dark"] .phone-compare-section {
  background: rgba(255, 255, 255, 0.04) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.28) !important;
}

[data-theme="dark"] .computer-compare-section .compare-head p,
[data-theme="dark"] .phone-compare-section .compare-head p {
  color: #8b949e !important;
}

[data-theme="dark"] .computer-compare-section .compare-head h2,
[data-theme="dark"] .phone-compare-section .compare-head h2 {
  color: #f0f0f0 !important;
}

[data-theme="dark"] .computer-compare-section .compare-actions button,
[data-theme="dark"] .phone-compare-section .compare-actions button {
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(255, 255, 255, 0.12) !important;
  color: #8b949e !important;
}

[data-theme="dark"] .computer-compare-section .compare-actions button:hover:not(:disabled),
[data-theme="dark"] .phone-compare-section .compare-actions button:hover:not(:disabled) {
  border-color: #58a6ff !important;
  color: #58a6ff !important;
}

[data-theme="dark"] .computer-compare-section .compare-actions .compare-add-button,
[data-theme="dark"] .phone-compare-section .compare-actions .compare-add-button {
  background: #2563eb !important;
  border-color: #388bfd !important;
  color: #fff !important;
}

[data-theme="dark"] .computer-compare-section .compare-actions .compare-add-button:hover:not(:disabled),
[data-theme="dark"] .phone-compare-section .compare-actions .compare-add-button:hover:not(:disabled) {
  background: #388bfd !important;
  color: #fff !important;
}

[data-theme="dark"] .computer-compare-section .compare-select,
[data-theme="dark"] .phone-compare-section .compare-select {
  color: #8b949e !important;
}

[data-theme="dark"] .computer-compare-section .compare-select select,
[data-theme="dark"] .phone-compare-section .compare-select select {
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(255, 255, 255, 0.12) !important;
  color: #e6edf3 !important;
}

[data-theme="dark"] .computer-compare-section .compare-empty,
[data-theme="dark"] .phone-compare-section .compare-empty {
  color: #8b949e !important;
}

[data-theme="dark"] .computer-compare-section .compare-phone-titles,
[data-theme="dark"] .phone-compare-section .compare-phone-titles {
  color: #e6edf3 !important;
}

/* ---- model-section / control-panel / filters ---- */
[data-theme="dark"] .phone-zone .model-control-panel,
[data-theme="dark"] .computer-zone .model-control-panel {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.28) !important;
}

[data-theme="dark"] .phone-zone .model-search,
[data-theme="dark"] .computer-zone .model-search,
[data-theme="dark"] .phone-zone .model-search span,
[data-theme="dark"] .computer-zone .model-search span,
[data-theme="dark"] .phone-zone .filter-title,
[data-theme="dark"] .computer-zone .filter-title {
  color: #8b949e !important;
}

[data-theme="dark"] .phone-zone .model-search input,
[data-theme="dark"] .computer-zone .model-search input {
  color: #e6edf3 !important;
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(255, 255, 255, 0.12) !important;
}

[data-theme="dark"] .phone-zone .model-search input:focus,
[data-theme="dark"] .computer-zone .model-search input:focus {
  border-color: #58a6ff !important;
  box-shadow: 0 0 0 3px rgba(88, 166, 255, 0.15) !important;
}

[data-theme="dark"] .phone-zone .filter-chip,
[data-theme="dark"] .computer-zone .filter-chip {
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(255, 255, 255, 0.12) !important;
  color: #8b949e !important;
}

[data-theme="dark"] .phone-zone .filter-chip.active,
[data-theme="dark"] .phone-zone .filter-chip:hover,
[data-theme="dark"] .computer-zone .filter-chip.active,
[data-theme="dark"] .computer-zone .filter-chip:hover {
  background: #2563eb !important;
  border-color: #388bfd !important;
  color: #fff !important;
}

[data-theme="dark"] .phone-zone .section-head h2,
[data-theme="dark"] .computer-zone .section-head h2 {
  color: #f0f0f0 !important;
}

[data-theme="dark"] .phone-zone .model-section .empty-state,
[data-theme="dark"] .computer-zone .model-section .empty-state {
  color: #8b949e !important;
  background: rgba(255, 255, 255, 0.04) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
}

[data-theme="dark"] .phone-detail-panel,
[data-theme="dark"] .computer-detail-panel {
  background: #161b22 !important;
  border-color: #30363d !important;
  color: #e6edf3 !important;
}

[data-theme="dark"] .phone-detail-panel h2,
[data-theme="dark"] .computer-detail-panel h2,
[data-theme="dark"] .phone-detail-panel h3,
[data-theme="dark"] .computer-detail-panel h3,
[data-theme="dark"] .phone-detail-brand,
[data-theme="dark"] .computer-detail-brand {
  color: #f0f0f0 !important;
}

[data-theme="dark"] .phone-detail-panel p,
[data-theme="dark"] .computer-detail-panel p,
[data-theme="dark"] .phone-detail-panel dd,
[data-theme="dark"] .computer-detail-panel dd {
  color: #8b949e !important;
}

[data-theme="dark"] .phone-detail-panel dt,
[data-theme="dark"] .computer-detail-panel dt {
  color: #e6edf3 !important;
}

[data-theme="dark"] .phone-detail-close,
[data-theme="dark"] .computer-detail-close {
  color: #8b949e !important;
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(255, 255, 255, 0.12) !important;
}

[data-theme="dark"] .login-page,
[data-theme="dark"] .register-page,
[data-theme="dark"] .forget-page {
  background: #0d1117 !important;
}

[data-theme="dark"] .login-card,
[data-theme="dark"] .register-card,
[data-theme="dark"] .forget-card {
  background: #161b22 !important;
  border-color: #30363d !important;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.35) !important;
}

[data-theme="dark"] .login-card h2,
[data-theme="dark"] .register-card h2,
[data-theme="dark"] .forget-card h2 {
  color: #e6edf3 !important;
}

[data-theme="dark"] .login-link,
[data-theme="dark"] .register-link {
  color: #8b949e !important;
}

/* ---- Creater.vue (Mine child) ---- */
[data-theme="dark"] .creator-metric,
[data-theme="dark"] .creator-chart-panel,
[data-theme="dark"] .creator-article-row {
  background: rgba(255, 255, 255, 0.04) !important;
}

[data-theme="dark"] .creator-metric span,
[data-theme="dark"] .creator-article-stats span {
  color: #8b949e !important;
}

[data-theme="dark"] .creator-metric strong {
  color: #e6edf3 !important;
}

[data-theme="dark"] .creator-article-row h3 {
  color: #e6edf3 !important;
}

[data-theme="dark"] .creator-article-row p {
  color: #8b949e !important;
}

[data-theme="dark"] .articles-head h2 {
  color: #f0f0f0 !important;
}

[data-theme="dark"] .articles-head p {
  color: #8b949e !important;
}

[data-theme="dark"] .article-state {
  color: #8b949e !important;
  border-color: rgba(255, 255, 255, 0.1) !important;
  background: rgba(255, 255, 255, 0.03) !important;
}

[data-theme="dark"] .article-state--error {
  color: #ff7b72 !important;
}

[data-theme="dark"] .creator-article-stats span {
  background: rgba(255, 255, 255, 0.06) !important;
}

[data-theme="dark"] .creator-article-row:hover {
  box-shadow: 0 14px 34px rgba(0, 0, 0, 0.28) !important;
}

/* ================================================================
   LIGHT MODE — Hello / ArticleDetail / ArticleSubmit / NotFound
   ================================================================ */
[data-theme="light"] .apple-news-page {
  background: #f5f5f7 !important;
  color: #1a1a2e;
}

[data-theme="light"] .apple-news-page .category-link {
  color: #374151 !important;
  border-color: rgba(0, 0, 0, 0.12) !important;
  background: rgba(255, 255, 255, 0.65) !important;
}

[data-theme="light"] .apple-news-page .category-link:hover {
  color: #111827 !important;
  background: rgba(255, 255, 255, 0.88) !important;
  border-color: rgba(0, 0, 0, 0.22) !important;
}

[data-theme="light"] .apple-news-page .category-link.active {
  color: #fff !important;
  background: rgba(255, 59, 48, 0.85) !important;
  border-color: rgba(255, 59, 48, 0.6) !important;
}

[data-theme="light"] .apple-news-page .search-box {
  background: rgba(255, 255, 255, 0.75) !important;
  border-color: rgba(0, 0, 0, 0.12) !important;
}

[data-theme="light"] .apple-news-page .search-box input {
  color: #1a1a2e !important;
}

[data-theme="light"] .apple-news-page .search-icon {
  color: #6b7280 !important;
}

[data-theme="light"] .apple-news-page .hot-words,
[data-theme="light"] .apple-news-page .hot-words a {
  color: #6b7280 !important;
}

[data-theme="light"] .apple-news-page .hot-words a:hover {
  color: #2563eb !important;
}

[data-theme="light"] .apple-news-page .headline-strip {
  background: rgba(255, 255, 255, 0.75) !important;
  border-color: rgba(0, 0, 0, 0.08) !important;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .apple-news-page .headline-item strong {
  color: #1a1a2e !important;
}

[data-theme="light"] .apple-news-page .hero-band {
  background: rgba(255, 255, 255, 0.75) !important;
  border-color: rgba(0, 0, 0, 0.08) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1) !important;
}

[data-theme="light"] .apple-news-page .hero-copy h1 {
  color: #111827 !important;
}

[data-theme="light"] .apple-news-page .hero-copy p:last-child {
  color: #4b5563 !important;
}

[data-theme="light"] .apple-news-page .section-title h2 {
  color: #1a1a2e !important;
}

[data-theme="light"] .apple-news-page .section-title span {
  background: rgba(0, 0, 0, 0.12) !important;
}

[data-theme="light"] .apple-news-page .article-title {
  color: #1a1a2e !important;
}

[data-theme="light"] .apple-news-page .article-title:hover {
  color: #2563eb !important;
}

[data-theme="light"] .apple-news-page .article-body p {
  color: #6b7280 !important;
}

[data-theme="light"] .apple-news-page .article-meta {
  color: #374151 !important;
}

[data-theme="light"] .apple-news-page .article-state {
  color: #6b7280 !important;
  background: rgba(255, 255, 255, 0.6) !important;
  border-color: rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .apple-news-page .ranking-panel {
  background: rgba(255, 255, 255, 0.75) !important;
  border-color: rgba(0, 0, 0, 0.08) !important;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .apple-news-page .ranking-list a {
  color: #374151 !important;
}

[data-theme="light"] .apple-news-page .ranking-list a:hover {
  color: #2563eb !important;
}

[data-theme="light"] .apple-news-page .ranking-list span {
  color: #fff !important;
}

[data-theme="light"] .apple-news-page .tabs button {
  color: #6b7280 !important;
}

[data-theme="light"] .apple-news-page .article-meta time {
  color: #2563eb !important;
}

[data-theme="light"] .apple-news-page .article-card {
  border-bottom-color: rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .apple-news-page .ranking-title {
  color: #1a1a2e !important;
}

[data-theme="light"] .apple-news-page .headline-item {
  background: rgba(0, 0, 0, 0.02) !important;
}

[data-theme="light"] .apple-news-page .headline-item:first-child {
  border-right-color: rgba(0, 0, 0, 0.06) !important;
}

[data-theme="light"] .apple-news-page .headline-item:hover {
  background: rgba(0, 0, 0, 0.04) !important;
}

[data-theme="light"] .article-detail-page .detail-content {
  color: #374151 !important;
}

[data-theme="light"] .article-detail-page .detail-meta {
  color: #6b7280 !important;
}

[data-theme="light"] .apple-news-page .tabs button.active::after {
  background: #ff3b30 !important;
}

[data-theme="light"] .article-detail-page {
  background: #f5f5f7 !important;
  color: #1a1a2e !important;
}

[data-theme="light"] .article-detail-page .detail-category {
  color: #2563eb !important;
}

[data-theme="light"] .article-detail-page .detail-state {
  color: #6b7280 !important;
  background: rgba(255, 255, 255, 0.6) !important;
  border-color: rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .article-detail-page .back-link {
  color: #374151 !important;
}

[data-theme="light"] .article-detail-page .back-link:hover {
  color: #111827 !important;
}

[data-theme="light"] .editor-app {
  --bg-primary: #f5f5f7;
  --bg-secondary: #ffffff;
  --bg-tertiary: #e8ecf1;
  --border-default: #d0d7de;
  --border-muted: #e8ecf1;
  --text-primary: #1a1a2e;
  --text-secondary: #374151;
  --text-muted: #6b7280;
  --text-placeholder: #9ca3af;
  --input-title-color: #1a1a2e;
  --input-content-color: #374151;
  --input-title-placeholder: #9ca3af;
  --input-content-placeholder: #6b7280;
  --input-selection-bg: rgba(37, 99, 235, 0.2);
}

[data-theme="light"] .editor-app .title-input {
  color: #1a1a2e !important;
}

[data-theme="light"] .editor-app .content-input {
  color: #374151 !important;
}

[data-theme="light"] .editor-app .title-input::placeholder {
  color: #9ca3af !important;
}

[data-theme="light"] .editor-app .content-input::placeholder {
  color: #6b7280 !important;
}

[data-theme="light"] .editor-app .content-input::selection {
  background: rgba(37, 99, 235, 0.2) !important;
}

[data-theme="light"] .bottom-bar {
  background: rgba(255, 255, 255, 0.92) !important;
  border-top-color: #d0d7de !important;
}

[data-theme="light"] .save-indicator {
  background: #ffffff !important;
  border-color: #d0d7de !important;
  color: #6b7280 !important;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .submit-page {
  background: #f5f5f7 !important;
}

/* ---- ArticleDetail.vue (light mode extras) ---- */
[data-theme="light"] .article-detail-page .detail-article {
  background: rgba(255, 255, 255, 0.85) !important;
  border-color: rgba(0, 0, 0, 0.06) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .article-detail-page .detail-article h1 {
  color: #111827 !important;
}

[data-theme="light"] .article-detail-page .favorite-button {
  color: #374151 !important;
  background: rgba(255, 255, 255, 0.85) !important;
  border-color: rgba(0, 0, 0, 0.12) !important;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1) !important;
}

[data-theme="light"] .article-detail-page .favorite-button:hover {
  color: #111827 !important;
  border-color: rgba(255, 204, 0, 0.6) !important;
}

[data-theme="light"] .article-detail-page .favorite-button.active {
  color: #111113 !important;
  background: #ffd60a !important;
  border-color: #ffd60a !important;
}

[data-theme="light"] .article-detail-page .detail-article,
[data-theme="light"] .article-detail-page .detail-state {
  background: rgba(255, 255, 255, 0.85) !important;
  border-color: rgba(0, 0, 0, 0.06) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08) !important;
}

[data-theme="light"] .noise-layer {
  opacity: 0.2 !important;
}

[data-theme="light"] .not-found-page {
  background: #f5f5f7 !important;
  color: #374151 !important;
}

[data-theme="light"] .offline-copy h1,
[data-theme="light"] .offline-copy p,
[data-theme="light"] .offline-copy ul {
  color: #374151 !important;
}

[data-theme="light"] .offline-error {
  color: #6b7280 !important;
}

.page-container--admin {
  padding-top: 24px;
}
</style>
