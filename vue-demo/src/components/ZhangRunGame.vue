<template>
  <div class="game-wrapper" ref="wrapper" :class="`game-wrapper--${theme}`">
    <canvas
      ref="canvas"
      :width="canvasWidth"
      :height="canvasHeight"
      @click="handleCanvasClick"
    ></canvas>

    <!-- ============ HUD ============ -->
    <div class="hud" v-if="gameState === 'playing'">
      <div class="hud-row"><span class="label">Score</span> <span class="val">{{ displayScore }}</span></div>
      <div class="hud-row"><span class="label">巧乐兹</span> <span class="val">{{ purpleLevel }}/9</span></div>
      <div class="hud-row"><span class="label">跑步机</span> <span class="val">{{ treadmillCount }}/30</span></div>
    </div>

    <!-- ============ Start / Waiting Screen ============ -->
    <div class="overlay" v-if="gameState === 'waiting'" @click="handleStartAction">
      <h1 class="title"> 张雪峰快跑</h1>
      <p class="hint">按 Space / ↑ 或点击屏幕开始</p>
    </div>

    <!-- ============ Game Over Screen ============ -->
    <div class="overlay" v-if="gameState === 'gameOver'">
      <h1 class="title">游戏结束</h1>
      <h2 class="death-msg">{{ deathMessage }}</h2>
      <div class="stats">
        <p>最终得分：<strong>{{ displayScore }}</strong></p>
        <p>巧乐兹数量：<strong>{{ purpleLevel }}</strong></p>
        <p>跑步机次数：<strong>{{ treadmillCount }}</strong></p>
      </div>
      <button class="btn-restart" @click="restartGame">重新开始</button>
      <p class="hint">或按 Space / ↑</p>
    </div>

    <!-- ============ Mobile Touch Controls ============ -->
    <div class="mobile-ctrls" v-if="isMobile && gameState === 'playing'">
      <button
        class="ctrl-btn ctrl-jump"
        @touchstart.prevent="jump"
        @mousedown.prevent="jump"
      >⬆ 跳跃</button>
      <button
        class="ctrl-btn ctrl-duck"
        @touchstart.prevent="startDuck"
        @touchend.prevent="stopDuck"
        @touchcancel.prevent="stopDuck"
        @mousedown.prevent="startDuck"
        @mouseup.prevent="stopDuck"
        @mouseleave.prevent="stopDuck"
      >⬇ 下蹲</button>
    </div>
  </div>
</template>

<script>
// ──────────────────────────────────────
//  Asset imports (模块化引入)
// ──────────────────────────────────────
import runnerImg from '@/assets/images/zhang-runner.png'
import duckImg from '@/assets/images/zhang-duck.png'
import qiaoleziImg from '@/assets/images/qiaolezi.png'
import spriteBottleImg from '@/assets/images/sprite-bottle.png'
import treadmillImg from '@/assets/images/treadmill.jpg'

import bgmMusic from '@/assets/bgm/bgm.m4a'
import meetRunnerMusic from '@/assets/bgm/meet_runner.mp3'
import deathMusic from '@/assets/bgm/death.mp3'

// ──────────────────────────────────────
//  Constants
// ──────────────────────────────────────
const CANVAS_W = 1000
const CANVAS_H = 375
const GROUND_Y = 325
const PLAYER_X = 125
const PLAYER_W = 62
const PLAYER_H_STAND = 88
const PLAYER_H_DUCK = 44
const GRAVITY = 0.55
const JUMP_VEL = -14.4
const BASE_SPEED = 7.5
const MAX_SPEED = 25
const MAX_PURPLE = 9
const MAX_TREADMILL = 30
const OBSTACLE_POOL_SIZE = 30

// ──────────────────────────────────────
//  Component
// ──────────────────────────────────────
export default {
  name: 'ZhangRunGame',

  // ═══════════════════════════════════
  //  Data
  // ═══════════════════════════════════
  data() {
    return {
      // --- Core state ---
      gameState: 'waiting',    // 'waiting' | 'playing' | 'gameOver'
      score: 0,
      purpleLevel: 0,
      treadmillCount: 0,
      speed: BASE_SPEED,
      deathMessage: '',

      // --- Canvas ---
      canvasWidth: CANVAS_W,
      canvasHeight: CANVAS_H,

      // --- Player ---
      playerY: GROUND_Y - PLAYER_H_STAND,
      playerVelocityY: 0,
      isJumping: false,
      isDucking: false,
      playerFrame: 0,

      // --- Theme ---
      theme: 'dark',

      // --- Mobile ---
      isMobile: false,

      // --- Timers (tracked in data so Vue can react if needed) ---
      obstacleTimer: 0,
      obstacleInterval: 2000,
      scoreTimer: 0,
    }
  },

  // ═══════════════════════════════════
  //  Computed
  // ═══════════════════════════════════
  computed: {
    displayScore() {
      return Math.floor(this.score / 4)
    },

    currentPlayerHeight() {
      return this.isDucking ? PLAYER_H_DUCK : PLAYER_H_STAND
    },

    // Draw Y = the top of the sprite, adjusted so feet stay on ground
    playerDrawY() {
      // playerY tracks top of STANDING sprite; feet = playerY + PLAYER_H_STAND
      if (this.isDucking) {
        return this.playerY + PLAYER_H_STAND - PLAYER_H_DUCK
      }
      return this.playerY
    },
  },

  // ═══════════════════════════════════
  //  Watch
  // ═══════════════════════════════════
  watch: {},

  // ═══════════════════════════════════
  //  Methods
  // ═══════════════════════════════════
  methods: {
    // ────────────────────────────────
    //  Bootstrap
    // ────────────────────────────────
    init() {
      // --- Obstacle pool (non-reactive for performance) ---
      this._obs = []
      for (let i = 0; i < OBSTACLE_POOL_SIZE; i++) {
        this._obs.push({
          x: 0, y: 0, w: 0, h: 0,
          type: '',   // 'sprite-ground' | 'sprite-air' | 'qiaolezi' | 'treadmill'
          active: false,
        })
      }

      // --- Image cache ---
      const imgSources = {
        runner:    runnerImg,
        duck:      duckImg,
        qiaolezi:  qiaoleziImg,
        sprite:    spriteBottleImg,
        treadmill: treadmillImg,
      }
      this._img = {}
      this._imgLoaded = 0
      this._imgTotal = Object.keys(imgSources).length
      for (const [key, src] of Object.entries(imgSources)) {
        const img = new Image()
        img.onload = img.onerror = () => {
          this._imgLoaded++
        }
        img.src = src
        this._img[key] = img
      }

      // --- Audio ---
      this.bgmAudio = new Audio(bgmMusic)
      this.bgmAudio.loop = true
      this.bgmAudio.volume = 0.4

      this.deathAudio = new Audio(deathMusic)
      this.deathAudio.volume = 0.7

      // meet_runner 音效资源路径缓存，每次 new Audio 使用
      this._meetRunnerSrc = meetRunnerMusic

      // --- Scrolling offsets ---
      this._groundOff = 0

      // --- Game loop ---
      this._lastTs = 0
      this._rafId = null
      this._animTick = 0

      // --- Bind input handlers (so add/removeEventListener works) ---
      this._onKeyDown = this._onKeyDown.bind(this)
      this._onKeyUp = this._onKeyUp.bind(this)
      this._onVis = this._onVis.bind(this)

      // --- Detect mobile ---
      this.isMobile = /Android|iPhone|iPad|iPod|webOS/i.test(navigator.userAgent)

      // --- Read current theme ---
      this.theme = document.documentElement.getAttribute('data-theme') || 'dark'
    },

    // ────────────────────────────────
    //  Theme watcher (MutationObserver)
    // ────────────────────────────────
    _onThemeChange() {
      this.theme = document.documentElement.getAttribute('data-theme') || 'dark'
    },

    // ────────────────────────────────
    //  Input handling
    // ────────────────────────────────
    _onKeyDown(e) {
      if (e.code === 'Space' || e.code === 'ArrowUp') {
        e.preventDefault()
        if (this.gameState === 'waiting' || this.gameState === 'gameOver') {
          this.startGame()
        } else {
          this.jump()
        }
      }
      if (e.code === 'ArrowDown') {
        e.preventDefault()
        this.startDuck()
      }
    },

    _onKeyUp(e) {
      if (e.code === 'ArrowDown') {
        e.preventDefault()
        this.stopDuck()
      }
    },

    _onVis() {
      // Reset timestamp when tab hidden to avoid dt spike on resume
      if (document.hidden && this.gameState === 'playing') {
        this._lastTs = 0
      }
    },

    handleCanvasClick() {
      if (this.gameState === 'waiting' || this.gameState === 'gameOver') {
        this.startGame()
      } else {
        this.jump()
      }
    },

    handleStartAction() {
      if (this.gameState === 'waiting' || this.gameState === 'gameOver') {
        this.startGame()
      }
    },

    // ────────────────────────────────
    //  Game lifecycle
    // ────────────────────────────────
    startGame() {
      // Stop any running loop
      if (this._rafId) {
        cancelAnimationFrame(this._rafId)
        this._rafId = null
      }

      // Reset state
      this.score = 0
      this.purpleLevel = 0
      this.treadmillCount = 0
      this.speed = BASE_SPEED
      this.deathMessage = ''
      this.gameState = 'playing'

      this.playerY = GROUND_Y - PLAYER_H_STAND
      this.playerVelocityY = 0
      this.isJumping = false
      this.isDucking = false
      this.playerFrame = 0

      this.obstacleTimer = 0
      this.obstacleInterval = 2000
      this.scoreTimer = 0
      this._groundOff = 0
      this._animTick = 0

      // Deactivate all obstacles
      for (const o of this._obs) {
        o.active = false
      }

      // Start BGM
      this.bgmAudio.currentTime = 0
      this.bgmAudio.play().catch(() => {
        // Autoplay may be blocked; user gesture will have triggered startGame
      })

      // Kick off the loop
      this._lastTs = performance.now()
      this._rafId = requestAnimationFrame(this._loop)
    },

    restartGame() {
      this.startGame()
    },

    gameOver() {
      this.gameState = 'gameOver'
      if (this._rafId) {
        cancelAnimationFrame(this._rafId)
        this._rafId = null
      }

      // Stop BGM
      this.bgmAudio.pause()
      this.bgmAudio.currentTime = 0

      // Play death sound
      this.deathAudio.currentTime = 0
      this.deathAudio.play().catch(() => {})
    },

    // ────────────────────────────────
    //  Player actions
    // ────────────────────────────────
    jump() {
      if (this.gameState !== 'playing') return
      if (this.isDucking) return
      if (!this.isJumping) {
        this.playerVelocityY = JUMP_VEL
        this.isJumping = true
      }
    },

    startDuck() {
      if (this.gameState !== 'playing') return
      // Fast-fall when ducking in air
      if (this.isJumping) {
        this.playerVelocityY += 4
      }
      this.isDucking = true
    },

    stopDuck() {
      this.isDucking = false
    },

    // ═══════════════════════════════
    //  Main Game Loop
    // ═══════════════════════════════
    _loop(ts) {
      if (this.gameState !== 'playing') return

      if (!this._lastTs) this._lastTs = ts
      let dt = ts - this._lastTs
      this._lastTs = ts

      // Clamp delta: avoid spiral-of-death after tab switch
      // Also handles 165Hz+ high-refresh-rate displays naturally
      if (dt > 50) dt = 50
      if (dt <= 0) dt = 16.67

      const factor = dt / 16.67   // normalise to ~60 fps baseline

      this._updatePlayer(factor)
      this._updateObstacles(factor)
      this._checkCollisions()
      this._updateScoreAndSpeed(dt)
      this._spawnObstacles(dt)

      this._render()

      this._rafId = requestAnimationFrame(this._loop)
    },

    // ────────────────────────────────
    //  Physics
    // ────────────────────────────────
    _updatePlayer(factor) {
      const feetY = this.playerY + PLAYER_H_STAND
      const inAir = this.isJumping || feetY < GROUND_Y

      if (inAir) {
        this.playerVelocityY += GRAVITY * factor
        this.playerY += this.playerVelocityY * factor

        if (this.playerY + PLAYER_H_STAND >= GROUND_Y) {
          this.playerY = GROUND_Y - PLAYER_H_STAND
          this.playerVelocityY = 0
          this.isJumping = false
        }
      }

      // Running animation frame toggle
      if (!this.isJumping && !this.isDucking) {
        this._animTick++
        if (this._animTick >= 7) {
          this._animTick = 0
          this.playerFrame = this.playerFrame === 0 ? 1 : 0
        }
      }
    },

    _updateObstacles(factor) {
      for (const o of this._obs) {
        if (!o.active) continue
        o.x -= this.speed * factor
        if (o.x + o.w < -60) {
          o.active = false
        }
      }
    },

    // ────────────────────────────────
    //  Spawning
    // ────────────────────────────────
    _spawnObstacles(dt) {
      this.obstacleTimer += dt
      if (this.obstacleTimer >= this.obstacleInterval) {
        this.obstacleTimer = 0
        this.obstacleInterval = 1400 + Math.random() * 2400 - this.speed * 35
        if (this.obstacleInterval < 550) this.obstacleInterval = 550
        this._spawnOne()
      }
    },

    _spawnOne() {
      const o = this._obs.find(ob => !ob.active)
      if (!o) return

      // ── 四种类型各自都可以出现在地面或空中 ──
      const typePicker = Math.random()

      // 地面线以下不可放，空中可放范围
      const airMinY = 50

      if (typePicker < 0.12) {
        // ── 雪碧（地面） ──
        o.type = 'sprite-ground'
        o.w = 38; o.h = 62
        o.y = GROUND_Y - o.h
      } else if (typePicker < 0.24) {
        // ── 雪碧（空中任意高度） ──
        o.type = 'sprite-air'
        o.w = 38; o.h = 62
        const maxY = GROUND_Y - o.h
        o.y = airMinY + Math.random() * (maxY - airMinY)
      } else if (typePicker < 0.48) {
        // ── 跑步机（地面或空中） ──
        o.type = 'treadmill'
        o.w = 78; o.h = 45
        if (Math.random() < 0.45) {
          // 地面
          o.y = GROUND_Y - o.h
        } else {
          // 空中 — 飘在半空挡路
          const maxY = GROUND_Y - o.h
          o.y = airMinY + Math.random() * (maxY - airMinY)
        }
      } else {
        // ── 巧乐兹（地面或空中） ──
        o.type = 'qiaolezi'
        o.w = 40; o.h = 45
        if (Math.random() < 0.4) {
          // 地面附近
          o.y = GROUND_Y - o.h - Math.random() * 25
        } else {
          // 空中散落
          const maxY = GROUND_Y - o.h
          o.y = airMinY + Math.random() * (maxY - airMinY)
        }
      }

      o.x = CANVAS_W + 20 + Math.random() * 160
      o.active = true
    },

    // ────────────────────────────────
    //  AABB Collision Detection
    // ────────────────────────────────
    _checkCollisions() {
      const px = PLAYER_X + 5
      const py = this.playerDrawY + 5
      const pw = PLAYER_W - 10
      const ph = this.currentPlayerHeight - 10

      for (const o of this._obs) {
        if (!o.active) continue

        if (
          px < o.x + o.w &&
          px + pw > o.x &&
          py < o.y + o.h &&
          py + ph > o.y
        ) {
          this._onHit(o)
          o.active = false
        }
      }
    },

    _onHit(o) {
      switch (o.type) {
        // ── 雪碧：碰即死 ──
        case 'sprite-ground':
        case 'sprite-air':
          this.deathMessage = '你跑不过我你信吗！'
          this.gameOver()
          break

        // ── 巧乐兹：收集 ──
        case 'qiaolezi':
          this.purpleLevel++
          // 已经 9 根时再吃一根才死（即第 10 根触发死亡）
          if (this.purpleLevel > MAX_PURPLE) {
            this.deathMessage = '你吃不过我你信吗！'
            this.gameOver()
          }
          break

        // ── 跑步机：加速 / 死亡 ──
        case 'treadmill': {
          // 播放跑步机音效（支持连续触发）
          const sfx = new Audio(this._meetRunnerSrc)
          sfx.volume = 0.6
          sfx.play().catch(() => {})

          // 14:30 死亡检查（最高优先级）
          const now = new Date()
          if (now.getHours() === 14 && now.getMinutes() === 30) {
            this.deathMessage = '下午两点半还跑步？'
            this.gameOver()
            break
          }

          // 巧乐兹 ≥9 后碰到跑步机 → 死亡
          if (this.purpleLevel >= MAX_PURPLE) {
            this.deathMessage = '你跑不过我你信吗'
            this.gameOver()
            break
          }

          this.treadmillCount++
          if (this.treadmillCount >= MAX_TREADMILL) {
            this.deathMessage = '你跑不过我你信吗'
            this.gameOver()
          } else {
            this.speed = Math.min(this.speed + 0.5, MAX_SPEED)
          }
          break
        }
      }
    },

    // ────────────────────────────────
    //  Score & Difficulty
    // ────────────────────────────────
    _updateScoreAndSpeed(dt) {
      this.scoreTimer += dt
      // 分数增长速度随速度提升：跑得越快，分数涨得越快
      const tickInterval = Math.max(22, 120 - this.speed * 10.5)
      if (this.scoreTimer >= tickInterval) {
        this.scoreTimer -= tickInterval
        this.score++

        // 分数驱动速度：每 100 显示分 speed += 0.1
        const scoreBonus = Math.floor(this.score / 1000) * 0.1
        const targetSpeed = BASE_SPEED + scoreBonus
        this.speed = Math.max(this.speed, Math.min(targetSpeed, MAX_SPEED))
      }
    },

    // ═══════════════════════════════
    //  Rendering
    // ═══════════════════════════════
    _render() {
      const canvas = this.$refs.canvas
      if (!canvas) return
      const ctx = canvas.getContext('2d')
      const W = this.canvasWidth
      const H = this.canvasHeight

      ctx.clearRect(0, 0, W, H)

      this._drawBackground(ctx, W)
      this._drawGround(ctx, W)
      this._drawObstacles(ctx)
      this._drawPlayer(ctx)
    },

    // ── Sky background (theme-aware) ──
    _drawBackground(ctx, W) {
      const grad = ctx.createLinearGradient(0, 0, 0, GROUND_Y)
      if (this.theme === 'dark') {
        grad.addColorStop(0, '#1a1a2e')
        grad.addColorStop(0.7, '#161b22')
        grad.addColorStop(1, '#0d1117')
      } else {
        grad.addColorStop(0, '#e8e8e8')
        grad.addColorStop(0.7, '#f2f2f2')
        grad.addColorStop(1, '#fafafa')
      }
      ctx.fillStyle = grad
      ctx.fillRect(0, 0, W, GROUND_Y)
    },

    // ── Ground (Treadmill-style, theme-aware) ───
    _drawGround(ctx, W) {
      const H = this.canvasHeight
      const topY = GROUND_Y
      const bottomY = H
      const beltH = bottomY - topY  // 40 px
      const dark = this.theme === 'dark'

      // --- 1. Frame / chassis background ---
      ctx.fillStyle = dark ? '#21262d' : '#c0c0c0'
      ctx.fillRect(0, topY, W, beltH)

      // --- 2. Rollers (metallic cylinders) ---
      const rollerR = beltH * 0.9
      const rollerCY = bottomY - rollerR * 0.55

      // Draw rollers every 60px along the ground (belt support rollers)
      const rollerSpacing = 60
      this._groundOff = (this._groundOff + this.speed) % rollerSpacing
      const rollerW = 12
      for (let i = 0; i < Math.ceil(W / rollerSpacing) + 2; i++) {
        const rx = i * rollerSpacing - this._groundOff - rollerSpacing / 2
        // Skip if off-screen
        if (rx + rollerW < -10 || rx > W + 10) continue

        ctx.save()
        const rollGrad = ctx.createLinearGradient(0, rollerCY - 5, 0, rollerCY + 5)
        if (dark) {
          rollGrad.addColorStop(0, '#484f58')
          rollGrad.addColorStop(0.3, '#6e7681')
          rollGrad.addColorStop(0.6, '#30363d')
          rollGrad.addColorStop(1, '#21262d')
        } else {
          rollGrad.addColorStop(0, '#ddd')
          rollGrad.addColorStop(0.3, '#fff')
          rollGrad.addColorStop(0.6, '#999')
          rollGrad.addColorStop(1, '#666')
        }
        ctx.fillStyle = rollGrad
        ctx.beginPath()
        ctx.roundRect(rx, rollerCY - 3, rollerW, 8, 3)
        ctx.fill()
        ctx.strokeStyle = dark ? '#8b949e' : '#555'
        ctx.lineWidth = 0.8
        ctx.stroke()
        ctx.restore()
      }

      // --- 3. Belt surface ---
      const beltPad = 2
      ctx.fillStyle = dark ? '#0d1117' : '#2a2a2a'
      ctx.fillRect(0, topY + beltPad, W, beltH - beltPad - 3)

      // --- 4. Moving belt groove lines ---
      const grooveSpacing = 14
      const beltScroll = (this._groundOff * 0.85) % grooveSpacing
      ctx.strokeStyle = dark ? '#21262d' : '#3d3d3d'
      ctx.lineWidth = 1
      for (let i = 0; i < Math.ceil(W / grooveSpacing) + 2; i++) {
        const gx = i * grooveSpacing - beltScroll
        ctx.beginPath()
        ctx.moveTo(gx, topY + beltPad + 1)
        ctx.lineTo(gx, bottomY - 4)
        ctx.stroke()
      }

      // --- 5. Belt highlight & shadow (depth illusion) ---
      ctx.strokeStyle = dark ? '#30363d' : '#555'
      ctx.lineWidth = 1
      ctx.beginPath()
      ctx.moveTo(0, topY + beltPad)
      ctx.lineTo(W, topY + beltPad)
      ctx.stroke()

      ctx.strokeStyle = dark ? '#21262d' : '#444'
      ctx.lineWidth = 1.5
      ctx.beginPath()
      ctx.moveTo(0, bottomY - 4)
      ctx.lineTo(W, bottomY - 4)
      ctx.stroke()

      // --- 6. Side rails (left & right edges of the treadmill frame) ---
      ctx.fillStyle = dark ? '#484f58' : '#999'
      ctx.fillRect(0, topY, 3, beltH)
      ctx.fillRect(W - 3, topY, 3, beltH)

      ctx.fillStyle = dark ? '#6e7681' : '#bbb'
      ctx.fillRect(0, topY, 1, beltH)
      ctx.fillRect(W - 1, topY, 1, beltH)

      // --- 7. Top ground line ---
      ctx.strokeStyle = dark ? '#58a6ff' : '#535353'
      ctx.lineWidth = 2.5
      ctx.beginPath()
      ctx.moveTo(0, topY)
      ctx.lineTo(W, topY)
      ctx.stroke()
    },

    // ── Obstacles ───────────────────
    _drawObstacles(ctx) {
      for (const o of this._obs) {
        if (!o.active) continue

        let img = null
        let fallbackColor = '#888'
        switch (o.type) {
          case 'sprite-ground':
          case 'sprite-air':
            img = this._img.sprite
            fallbackColor = '#4CAF50'
            break
          case 'qiaolezi':
            img = this._img.qiaolezi
            fallbackColor = '#E91E63'
            break
          case 'treadmill':
            img = this._img.treadmill
            fallbackColor = '#FF9800'
            break
        }

        if (img && img.complete && img.naturalWidth > 0) {
          ctx.drawImage(img, o.x, o.y, o.w, o.h)
        } else {
          ctx.fillStyle = fallbackColor
          ctx.fillRect(o.x, o.y, o.w, o.h)
          ctx.strokeStyle = '#333'
          ctx.lineWidth = 1
          ctx.strokeRect(o.x, o.y, o.w, o.h)
        }
      }
    },

    // ── Player sprite ───────────────
    _drawPlayer(ctx) {
      const img = this.isDucking ? this._img.duck : this._img.runner

      // Running bob
      let bobY = 0
      if (!this.isJumping && !this.isDucking) {
        bobY = this.playerFrame === 0 ? 0 : -2
      }

      const drawX = PLAYER_X
      const drawY = this.playerDrawY + bobY
      const drawH = this.currentPlayerHeight

      if (img && img.complete && img.naturalWidth > 0) {
        ctx.drawImage(img, drawX, drawY, PLAYER_W, drawH)
      } else {
        // Placeholder pixel-art character
        ctx.fillStyle = '#333'
        ctx.fillRect(drawX, drawY, PLAYER_W, drawH)
        // Eyes
        ctx.fillStyle = '#fff'
        ctx.fillRect(drawX + 15, drawY + 12, 10, 10)
        ctx.fillRect(drawX + 35, drawY + 12, 10, 10)
        // Mouth
        ctx.fillStyle = '#fff'
        ctx.fillRect(drawX + 20, drawY + 32, 20, 4)
      }

      // ── 发紫效果 ──
      if (this.purpleLevel > 0) {
        const t = this.purpleLevel / MAX_PURPLE
        const alpha = 0.08 + t * 0.62
        ctx.fillStyle = '#9b59b6'
        ctx.globalAlpha = alpha
        ctx.fillRect(drawX, drawY, PLAYER_W, drawH)
        ctx.globalAlpha = 1
      }
    },
  },

  // ═══════════════════════════════════
  //  Lifecycle
  // ═══════════════════════════════════
  mounted() {
    this.init()
    window.addEventListener('keydown', this._onKeyDown)
    window.addEventListener('keyup', this._onKeyUp)
    document.addEventListener('visibilitychange', this._onVis)

    // Watch theme changes (e.g. user toggles dark/light in navbar)
    this._themeObserver = new MutationObserver(() => this._onThemeChange())
    this._themeObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['data-theme']
    })
  },

  beforeUnmount() {
    if (this._rafId) cancelAnimationFrame(this._rafId)
    window.removeEventListener('keydown', this._onKeyDown)
    window.removeEventListener('keyup', this._onKeyUp)
    document.removeEventListener('visibilitychange', this._onVis)
    if (this._themeObserver) {
      this._themeObserver.disconnect()
      this._themeObserver = null
    }
  },
}
</script>

<style scoped>
/* ═══════════════════════════════════
   Game Wrapper
   ═══════════════════════════════════ */
.game-wrapper {
  position: relative;
  width: 100%;
  max-width: 1020px;
  margin: 0 auto;
  aspect-ratio: 1000 / 375;
  min-height: 375px;
  border: 4px solid #535353;
  border-radius: 4px;
  background: #ffffff;
  overflow: hidden;
  box-shadow: 0 0 40px rgba(0, 0, 0, 0.45);
  -webkit-tap-highlight-color: transparent;
}

canvas {
  display: block;
  width: 100%;
  height: 100%;
  image-rendering: auto;
}

/* ═══════════════════════════════════
   HUD
   ═══════════════════════════════════ */
.hud {
  position: absolute;
  top: 10px;
  right: 14px;
  text-align: right;
  font-size: clamp(11px, 1.8vw, 14px);
  color: #535353;
  pointer-events: none;
  line-height: 1.55;
  z-index: 2;
  font-family: 'Courier New', 'Source Code Pro', 'Menlo', monospace;
}
.hud-row .label {
  opacity: 0.6;
  font-size: 0.85em;
}
.hud-row .val {
  font-weight: bold;
  font-size: 1.1em;
}

/* ═══════════════════════════════════
   Overlays (start / game-over)
   ═══════════════════════════════════ */
.overlay {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background: rgba(255, 255, 255, 0.93);
  z-index: 10;
  gap: 6px;
  text-align: center;
  padding: 20px;
  font-family: 'Courier New', 'Source Code Pro', 'Menlo', monospace;
}
.title {
  font-size: clamp(20px, 4vw, 34px);
  color: #333;
  letter-spacing: 2px;
  margin: 0;
}
.subtitle {
  font-size: clamp(13px, 2.2vw, 17px);
  color: #777;
  margin: 0 0 10px 0;
}
.death-msg {
  font-size: clamp(14px, 2.8vw, 22px);
  color: #535353;
  white-space: pre-line;
  margin: 0;
}
.stats {
  margin: 8px 0;
  font-size: clamp(12px, 2vw, 15px);
  color: #666;
  line-height: 1.6;
}
.stats strong {
  color: #333;
}

.hint {
  margin-top: 14px;
  font-size: 12px;
  color: #aaa;
  animation: blink 1.2s step-end infinite;
}
@keyframes blink {
  50% { opacity: 0; }
}

.btn-restart {
  margin-top: 14px;
  padding: 10px 30px;
  font-size: 16px;
  font-family: inherit;
  font-weight: bold;
  background: #333;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  letter-spacing: 1px;
  transition: background 0.15s;
}
.btn-restart:hover {
  background: #555;
}
.btn-restart:active {
  background: #222;
  transform: scale(0.97);
}

/* ═══════════════════════════════════
   Mobile controls
   ═══════════════════════════════════ */
.mobile-ctrls {
  position: absolute;
  bottom: 12px;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  padding: 0 16px;
  z-index: 5;
  pointer-events: none;
}
.ctrl-btn {
  pointer-events: auto;
  width: clamp(64px, 12vw, 90px);
  height: clamp(44px, 8vw, 58px);
  border: 3px solid #535353;
  background: rgba(255, 255, 255, 0.75);
  font-family: 'Courier New', 'Source Code Pro', 'Menlo', monospace;
  font-size: clamp(14px, 2.5vw, 18px);
  font-weight: bold;
  color: #333;
  border-radius: 10px;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
  touch-action: manipulation;
  user-select: none;
  -webkit-user-select: none;
}
.ctrl-btn:active {
  background: rgba(200, 200, 200, 0.9);
  transform: scale(0.94);
}
</style>

<!-- ═══════════════════════════════════════════
   Theme overrides (unscoped — targets html[data-theme])
   ═══════════════════════════════════════════ -->
<style>
/* ── Dark mode ──────────────────────── */
[data-theme="dark"] .game-wrapper--dark {
  border-color: #30363d;
  background: #161b22;
  box-shadow: 0 0 40px rgba(0, 0, 0, 0.65);
}

[data-theme="dark"] .game-wrapper--dark .hud {
  color: #8b949e;
}

[data-theme="dark"] .game-wrapper--dark .hud-row .val {
  color: #e6edf3;
}

[data-theme="dark"] .game-wrapper--dark .overlay {
  background: rgba(13, 17, 23, 0.93);
}

[data-theme="dark"] .game-wrapper--dark .overlay .title {
  color: #e6edf3;
}

[data-theme="dark"] .game-wrapper--dark .overlay .subtitle {
  color: #6e7681;
}

[data-theme="dark"] .game-wrapper--dark .overlay .death-msg {
  color: #8b949e;
}

[data-theme="dark"] .game-wrapper--dark .overlay .stats {
  color: #8b949e;
}

[data-theme="dark"] .game-wrapper--dark .overlay .stats strong {
  color: #e6edf3;
}

[data-theme="dark"] .game-wrapper--dark .overlay .hint {
  color: #484f58;
}

[data-theme="dark"] .game-wrapper--dark .btn-restart {
  background: #238636;
  color: #fff;
}

[data-theme="dark"] .game-wrapper--dark .btn-restart:hover {
  background: #2ea043;
}

[data-theme="dark"] .game-wrapper--dark .btn-restart:active {
  background: #196c2e;
  transform: scale(0.97);
}

[data-theme="dark"] .game-wrapper--dark .ctrl-btn {
  background: rgba(22, 27, 34, 0.85);
  border-color: #30363d;
  color: #e6edf3;
}

[data-theme="dark"] .game-wrapper--dark .ctrl-btn:active {
  background: rgba(48, 54, 61, 0.9);
}

/* ── Light mode (explicit, ensure original look) ── */
[data-theme="light"] .game-wrapper--light {
  border-color: #535353;
  background: #ffffff;
  box-shadow: 0 0 40px rgba(0, 0, 0, 0.15);
}

[data-theme="light"] .game-wrapper--light .hud {
  color: #535353;
}

[data-theme="light"] .game-wrapper--light .overlay {
  background: rgba(255, 255, 255, 0.93);
}

[data-theme="light"] .game-wrapper--light .overlay .title {
  color: #333;
}

[data-theme="light"] .game-wrapper--light .overlay .death-msg {
  color: #535353;
}

[data-theme="light"] .game-wrapper--light .overlay .stats {
  color: #666;
}

[data-theme="light"] .game-wrapper--light .overlay .stats strong {
  color: #333;
}

[data-theme="light"] .game-wrapper--light .overlay .hint {
  color: #aaa;
}

[data-theme="light"] .game-wrapper--light .btn-restart {
  background: #333;
  color: #fff;
}

[data-theme="light"] .game-wrapper--light .btn-restart:hover {
  background: #555;
}

[data-theme="light"] .game-wrapper--light .btn-restart:active {
  background: #222;
}

[data-theme="light"] .game-wrapper--light .ctrl-btn {
  background: rgba(255, 255, 255, 0.75);
  border-color: #535353;
  color: #333;
}

[data-theme="light"] .game-wrapper--light .ctrl-btn:active {
  background: rgba(200, 200, 200, 0.9);
}
</style>
