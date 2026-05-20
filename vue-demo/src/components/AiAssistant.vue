<template>
  <div class="ai-assistant">
    <transition name="assistant-panel">
      <section v-if="opened" class="assistant-panel" aria-label="AI 助手">
        <header class="assistant-head">
          <div>
            <p>{{ eyebrow }}</p>
            <h2>{{ title }}</h2>
          </div>
          <button type="button" class="assistant-icon-button" aria-label="关闭 AI 助手" @click="opened = false">
            <el-icon><Close /></el-icon>
          </button>
        </header>

        <div class="assistant-messages">
          <article
            v-for="message in messages"
            :key="message.id"
            :class="['assistant-message', `assistant-message--${message.role}`]"
          >
            {{ message.content }}
          </article>
        </div>

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

        <form class="assistant-input" @submit.prevent="sendMessage">
          <input
            v-model.trim="draft"
            type="text"
            :placeholder="placeholder"
            :disabled="loading"
          />
          <button type="submit" :disabled="!draft || loading" aria-label="发送">
            <el-icon><Promotion /></el-icon>
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
      <el-icon><Service /></el-icon>
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
      default: '你好，我可以帮你按预算、用途和配置偏好推荐设备。'
    },
    placeholder: {
      type: String,
      default: '输入你的需求...'
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
      messages: [
        {
          id: ++messageId,
          role: 'assistant',
          content: this.welcome
        }
      ]
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
          timeout: 30000
        })
        const reply = this.pickReply(data) || '我已经收到你的问题，但接口暂时没有返回具体回答。'
        this.addMessage('assistant', reply)
      } catch (error) {
        console.error('AI chat request failed:', error)
        const serverMessage = error.response?.data?.message || error.response?.data?.msg
        const status = error.response?.status
        const message = serverMessage ||
          (status ? `AI 接口返回 ${status} 错误。` : 'AI 接口暂时不可用，请稍后再试。')
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
  grid-template-rows: auto minmax(180px, 1fr) auto auto;
  width: min(380px, calc(100vw - 32px));
  max-height: min(620px, calc(100vh - 126px));
  overflow: hidden;
  border: 1px solid rgba(219, 231, 243, 0.9);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.96);
  box-shadow: 0 28px 90px rgba(15, 23, 42, 0.22);
  backdrop-filter: blur(22px) saturate(140%);
  -webkit-backdrop-filter: blur(22px) saturate(140%);
}

.assistant-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 18px 18px 14px;
  border-bottom: 1px solid #eef3f8;
}

.assistant-head p {
  margin: 0 0 5px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 800;
}

.assistant-head h2 {
  margin: 0;
  color: #101827;
  font-size: 20px;
}

.assistant-icon-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  border: 1px solid #d6e1ee;
  border-radius: 8px;
  color: #43546b;
  background: #fff;
  cursor: pointer;
}

.assistant-messages {
  display: grid;
  align-content: start;
  gap: 10px;
  overflow-y: auto;
  padding: 16px;
  background: #f8fafc;
}

.assistant-message {
  max-width: 86%;
  padding: 11px 13px;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.55;
  white-space: pre-wrap;
}

.assistant-message--assistant {
  justify-self: start;
  color: #263447;
  background: #fff;
  border: 1px solid #e6edf5;
}

.assistant-message--user {
  justify-self: end;
  color: #fff;
  background: #2563eb;
}

.assistant-suggestions {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding: 12px 16px;
  border-top: 1px solid #eef3f8;
}

.assistant-suggestions button {
  flex: 0 0 auto;
  height: 32px;
  padding: 0 12px;
  border: 1px solid #d6e1ee;
  border-radius: 999px;
  color: #2563eb;
  background: #fff;
  cursor: pointer;
  font: inherit;
  font-size: 13px;
  font-weight: 700;
}

.assistant-input {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 42px;
  gap: 10px;
  padding: 14px 16px 16px;
  border-top: 1px solid #eef3f8;
  background: #fff;
}

.assistant-input input {
  min-width: 0;
  height: 42px;
  padding: 0 13px;
  border: 1px solid #d6e1ee;
  border-radius: 8px;
  color: #152033;
  font: inherit;
  outline: none;
}

.assistant-input input:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

.assistant-input button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: 0;
  border-radius: 8px;
  color: #fff;
  background: #2563eb;
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
    max-height: calc(100vh - 98px);
  }
}
</style>
