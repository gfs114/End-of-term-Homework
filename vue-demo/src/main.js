import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

// 过滤 Element Plus/浏览器 ResizeObserver 的已知无害告警，避免影响页面提示。
window.addEventListener('error', (event) => {
  const message = event.message || ''

  if (
    message.includes('ResizeObserver loop completed with undelivered notifications') ||
    message.includes('ResizeObserver loop limit exceeded')
  ) {
    event.stopImmediatePropagation()
  }
})

const app = createApp(App)

// 全局注册 Element Plus 图标，模板里可以直接通过组件名使用。
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// 挂载路由和 UI 组件库，最后启动 Vue 应用。
app.use(router)
app.use(ElementPlus)
app.mount('#app')
