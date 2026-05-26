import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

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

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(router)
app.use(ElementPlus)
app.mount('#app')
