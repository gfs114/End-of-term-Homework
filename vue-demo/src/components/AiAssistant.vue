<template>
  <div class="ai-assistant">
    <transition name="assistant-panel">
      <section v-if="opened" class="assistant-panel" style="border-radius: 10px;" aria-label="AI 助手">
        <header class="assistant-head">
          <h2>AI 助手</h2>
          <div class="assistant-head-actions">
            <button type="button" class="assistant-icon-button" aria-label="刷新对话" @click="resetConversation">
              <el-icon>
                <RefreshRight />
              </el-icon>
            </button>
            <button type="button" class="assistant-icon-button" aria-label="关闭 AI 助手" @click="opened = false">
              <el-icon>
                <Close />
              </el-icon>
            </button>
          </div>
        </header>

        <div class="assistant-messages">
          <div v-if="!messages.length" class="assistant-welcome">
            <h3>你好，我是你的 AI 助手</h3>
            <p>您可以尝试点击下方的快捷入口开启体验！</p>
            <div class="assistant-suggestions" v-if="suggestions.length">
              <button
                v-for="suggestion in suggestions"
                :key="suggestion"
                type="button"
                @click="sendSuggestion(suggestion)"
              >
                {{ suggestion }}
              </button>
            </div>
          </div>

          <template v-else>
            <article
              v-for="message in messages"
              :key="message.id"
              :class="['assistant-message', `assistant-message--${message.role}`]"
            >
              {{ message.content }}
            </article>
            <article
              v-if="loading"
              class="assistant-message assistant-message--assistant assistant-message--loading"
              aria-label="AI loading"
              aria-live="polite"
            >
              <span class="assistant-typing-dots" aria-hidden="true">
                <i></i>
                <i></i>
                <i></i>
              </span>
            </article>
          </template>
        </div>

        <form class="assistant-input" @submit.prevent="sendMessage">
          <input
            v-model.trim="draft"
            type="text"
            :placeholder="placeholder"
            :disabled="loading"
          />
          <button type="submit" :disabled="!draft || loading" aria-label="发送">
            <el-icon>
              <Promotion />
            </el-icon>
          </button>
        </form>
      </section>
    </transition>

    <button
      type="button"
      :class="['assistant-trigger', { active: opened }]"
      aria-label="打开 AI 助手"
      @click="opened = !opened"
    >
      <el-icon>
        <Service />
      </el-icon>
      <span>AI</span>
    </button>
  </div>
</template>

<script>
import http from '@/utils/http'

let messageId = 0

export default {
  name: 'AiAssistant',
  props: {
    pageType: {
      type: String,
      required: true
    },
    title: {
      type: String,
      default: 'AI 选购助手'
    },
    eyebrow: {
      type: String,
      default: '智能推荐'
    },
    welcome: {
      type: String,
      default: '您可以尝试点击下方的快捷入口开启体验！'
    },
    placeholder: {
      type: String,
      default: '请输入您的问题，使用 Shift + Enter 换行。'
    },
    suggestions: {
      type: Array,
      default: () => []
    },
    context: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      opened: false,
      draft: '',
      loading: false,
      messages: []
    }
  },
  methods: {
    addMessage(role, content) {
      this.messages.push({
        id: ++messageId,
        role,
        content
      })
    },
    resetConversation() {
      this.draft = ''
      this.messages = []
    },
    pickReply(payload) {
      return payload?.reply ||
        payload?.answer ||
        payload?.message ||
        payload?.data?.reply ||
        payload?.data?.answer ||
        payload?.data?.message ||
        ''
    },
    async sendSuggestion(suggestion) {
      if (this.loading) return
      this.draft = suggestion
      await this.sendMessage()
    },
    async sendMessage() {
      const content = this.draft
      if (!content || this.loading) return

      this.draft = ''
      this.addMessage('user', content)
      this.loading = true

      try {
        const { data } = await http.post('/ai-chat', {
          page: this.pageType,
          message: content,
          context: this.context
        }, {
          timeout: 9999999
        })
        const reply = this.pickReply(data) || '我已经收到你的问题，但接口暂时没有返回具体回答。'
        this.addMessage('assistant', reply)
      } catch (error) {
        console.error('AI chat request failed:', error)
        const serverMessage = error.response?.data?.message || error.response?.data?.msg
        const status = error.response?.status
        const message = serverMessage ||
          (error.code === 'ECONNABORTED'
            ? 'AI 回复超时，请稍后再试。'
            : (status ? `AI 接口返回 ${status} 错误。` : 'AI 接口暂时不可用，请稍后再试。'))
        this.addMessage('assistant', message)
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.ai-assistant {
  position: fixed;
  right: 24px;
  bottom: 24px;
  z-index: 1400;
  font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
}

.assistant-trigger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  width: 62px;
  height: 62px;
  border: 1px solid rgba(37, 99, 235, 0.18);
  border-radius: 50%;
  color: #fff;
  background: #2563eb;
  box-shadow: 0 20px 50px rgba(37, 99, 235, 0.28);
  cursor: pointer;
  font: inherit;
  font-weight: 900;
  transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
}

.assistant-trigger:hover,
.assistant-trigger.active {
  background: #1d4ed8;
  transform: translateY(-2px);
  box-shadow: 0 24px 58px rgba(37, 99, 235, 0.34);
}

.assistant-panel {
  position: absolute;
  right: 0;
  bottom: 78px;
  display: grid;
  grid-template-rows: 40px minmax(0, 1fr) 48px;
  width: min(312px, calc(100vw - 28px));
  height: min(560px, calc(100vh - 112px));
  overflow: hidden;
  border: 1px solid #dfe7f2;
  border-radius: 2px;
  background: #fff;
  box-shadow: 0 18px 60px rgba(15, 23, 42, 0.18);
}

.assistant-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-width: 0;
  padding: 0 9px 0 20px;
  color: #fff;
  background: #1f6feb;
}

.assistant-head h2 {
  margin: 0;
  font-size: 13px;
  font-weight: 700;
}

.assistant-head-actions {
  display: inline-flex;
  align-items: center;
  gap: 2px;
}

.assistant-icon-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border: 0;
  border-radius: 4px;
  color: #fff;
  background: transparent;
  cursor: pointer;
}

.assistant-icon-button:hover {
  background: rgba(255, 255, 255, 0.16);
}

.assistant-messages {
  display: grid;
  align-content: start;
  gap: 10px;
  overflow-y: auto;
  padding: 16px 20px;
  background: #fff;
}

.assistant-welcome {
  padding-top: 78px;
}

.assistant-welcome h3 {
  margin: 0;
  color: #2563eb;
  font-size: 20px;
  line-height: 1.35;
  font-weight: 800;
}

.assistant-welcome p {
  margin: 14px 0 0;
  color: #777;
  font-size: 12px;
  line-height: 1.7;
}

.assistant-message {
  max-width: 86%;
  padding: 10px 12px;
  border-radius: 8px;
  font-size: 13px;
  line-height: 1.55;
  white-space: pre-wrap;
}

.assistant-message--assistant {
  justify-self: start;
  color: #263447;
  background: #f5f7fc;
  border: 1px solid #edf1f8;
}

.assistant-message--user {
  justify-self: end;
  color: #fff;
  background: #2563eb;
}

.assistant-message--loading {
  display: inline-flex;
  align-items: center;
  gap: 7px;
}

.assistant-typing-dots {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  height: 1em;
}

.assistant-typing-dots i {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: #64748b;
  animation: assistant-typing-dot 1s ease-in-out infinite;
}

.assistant-typing-dots i:nth-child(2) {
  animation-delay: 0.16s;
}

.assistant-typing-dots i:nth-child(3) {
  animation-delay: 0.32s;
}

.assistant-suggestions {
  display: grid;
  justify-items: start;
  gap: 11px;
  margin-top: 54px;
}

.assistant-suggestions button {
  min-height: 32px;
  max-width: 100%;
  padding: 0 12px;
  border: 0;
  border-radius: 0;
  color: #596173;
  background: #f3f6fc;
  cursor: pointer;
  font: inherit;
  font-size: 12px;
  line-height: 1.4;
  text-align: left;
}

.assistant-suggestions button:hover {
  color: #2563eb;
  background: #edf3ff;
}

.assistant-input {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 34px;
  align-items: center;
  gap: 8px;
  padding: 6px 11px 6px 16px;
  border-top: 1px solid #edf0f5;
  background: #fff;
}

.assistant-input input {
  min-width: 0;
  height: 34px;
  padding: 0;
  border: 0;
  color: #222;
  font: inherit;
  font-size: 12px;
  outline: none;
}

.assistant-input input::placeholder {
  color: #9aa3b2;
}

.assistant-input button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  justify-self: end;
  border: 0;
  border-radius: 50%;
  color: #fff;
  background: #727684;
  cursor: pointer;
}

.assistant-input button:disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

.assistant-panel-enter-active,
.assistant-panel-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.assistant-panel-enter-from,
.assistant-panel-leave-to {
  opacity: 0;
  transform: translateY(10px) scale(0.98);
}

@keyframes assistant-typing-dot {
  0%,
  80%,
  100% {
    opacity: 0.35;
    transform: translateY(0);
  }

  40% {
    opacity: 1;
    transform: translateY(-3px);
  }
}

@media (max-width: 640px) {
  .ai-assistant {
    right: 14px;
    bottom: 14px;
  }

  .assistant-trigger {
    width: 56px;
    height: 56px;
  }

  .assistant-panel {
    bottom: 70px;
    height: min(560px, calc(100vh - 98px));
  }
}
</style>
