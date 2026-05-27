<template>
  <main class="not-found-page">
    <section class="not-found-shell" aria-label="404 恐龙小游戏">
      <header class="not-found-header">
        <div>
          <p class="not-found-code">404</p>
          <h1>页面跑丢了</h1>
        </div>

        <div class="score-panel" aria-label="游戏分数">
          <span>当前 {{ score }}</span>
          <strong>最高 {{ bestScore }}</strong>
        </div>
      </header>

      <section
        ref="gameStage"
        class="game-stage"
        tabindex="0"
        @click="handleStageClick"
        @touchstart.prevent="handleStageTouch"
      >
        <canvas
          ref="gameCanvas"
          class="dino-canvas"
          aria-label="恐龙跳跃游戏画布"
        ></canvas>

        <div v-if="!isPlaying || gameOver" class="game-overlay">
          <strong>{{ gameOver ? "撞到了" : "DINO RUN" }}</strong>
          <span>{{ gameMessage }}</span>
        </div>
      </section>

      <footer class="game-toolbar">
        <button type="button" @click="startGame">
          {{ isPlaying && !gameOver ? "重新开始" : "开始游戏" }}
        </button>
        <div class="control-hints" aria-label="键盘控制">
          <span><kbd>Space</kbd><kbd>↑</kbd> 跳跃</span>
          <span><kbd>↓</kbd> 低头</span>
        </div>
      </footer>
    </section>
  </main>
</template>

<script>
const BEST_SCORE_KEY = "not-found-dino-best-score"
const GRAVITY = 0.0024
const JUMP_SPEED = -0.82

function getRandomNumber(min, max) {
  return Math.random() * (max - min) + min
}

function boxesOverlap(boxA, boxB) {
  return (
    boxA.x < boxB.x + boxB.width &&
    boxA.x + boxA.width > boxB.x &&
    boxA.y < boxB.y + boxB.height &&
    boxA.y + boxA.height > boxB.y
  )
}

export default {
  name: "NotFoundPage",
  data() {
    return {
      score: 0,
      bestScore: 0,
      isPlaying: false,
      gameOver: false,
      isDucking: false,
      gameMessage: "按空格开始，或点击画面开始"
    }
  },
  mounted() {
    this.animationFrame = null
    this.lastFrameTime = 0
    this.game = this.createGameState()
    this.loadBestScore()
    this.resizeCanvas()
    this.drawScene()

    window.addEventListener("keydown", this.handleKeyDown)
    window.addEventListener("keyup", this.handleKeyUp)
    window.addEventListener("resize", this.handleResize)

    if (this.$refs.gameStage) {
      this.$refs.gameStage.focus()
    }
  },
  beforeUnmount() {
    window.removeEventListener("keydown", this.handleKeyDown)
    window.removeEventListener("keyup", this.handleKeyUp)
    window.removeEventListener("resize", this.handleResize)
    this.stopLoop()
  },
  methods: {
    createGameState() {
      return {
        width: 900,
        height: 320,
        groundY: 236,
        distance: 0,
        speed: 0.38,
        spawnTimer: 0,
        nextSpawn: 900,
        downPressed: false,
        dino: {
          x: 72,
          y: 182,
          width: 44,
          height: 54,
          normalWidth: 44,
          normalHeight: 54,
          duckWidth: 66,
          duckHeight: 32,
          velocityY: 0,
          onGround: true,
          stepTimer: 0
        },
        obstacles: [],
        clouds: [
          { x: 110, y: 66, width: 86, speed: 0.04 },
          { x: 430, y: 42, width: 112, speed: 0.032 },
          { x: 760, y: 82, width: 74, speed: 0.05 }
        ],
        groundMarks: [
          { x: 40, width: 48 },
          { x: 190, width: 20 },
          { x: 360, width: 68 },
          { x: 560, width: 30 },
          { x: 720, width: 92 }
        ]
      }
    },
    loadBestScore() {
      try {
        const savedScore = Number(window.localStorage.getItem(BEST_SCORE_KEY) || 0)
        this.bestScore = Number.isFinite(savedScore) ? savedScore : 0
      } catch {
        this.bestScore = 0
      }
    },
    saveBestScore() {
      if (this.score <= this.bestScore) {
        return
      }

      this.bestScore = this.score

      try {
        window.localStorage.setItem(BEST_SCORE_KEY, String(this.bestScore))
      } catch {
        // localStorage 不可用时只保留本次页面内最高分。
      }
    },
    handleResize() {
      this.resizeCanvas()
      this.drawScene()
    },
    resizeCanvas() {
      const canvas = this.$refs.gameCanvas

      if (!canvas) {
        return
      }

      const parentWidth = canvas.parentElement ? canvas.parentElement.clientWidth : 900
      const width = Math.max(320, Math.min(parentWidth, 980))
      const height = width < 520 ? 260 : 320
      const scale = window.devicePixelRatio || 1

      canvas.style.height = `${height}px`
      canvas.width = Math.round(width * scale)
      canvas.height = Math.round(height * scale)

      const context = canvas.getContext("2d")
      context.setTransform(scale, 0, 0, scale, 0, 0)

      this.game.width = width
      this.game.height = height
      this.game.groundY = height - 84
      this.snapDinoToGround()
    },
    snapDinoToGround() {
      if (!this.game || !this.game.dino) {
        return
      }

      const dino = this.game.dino
      const targetHeight = this.isDucking && dino.onGround ? dino.duckHeight : dino.normalHeight

      dino.height = targetHeight
      dino.width = this.isDucking && dino.onGround ? dino.duckWidth : dino.normalWidth

      if (dino.onGround) {
        dino.y = this.game.groundY - dino.height
      }
    },
    startGame() {
      this.stopLoop()
      this.score = 0
      this.isPlaying = true
      this.gameOver = false
      this.isDucking = false
      this.gameMessage = "空格或上键跳跃，下键低头"
      this.game = this.createGameState()
      this.resizeCanvas()
      this.lastFrameTime = performance.now()
      this.animationFrame = requestAnimationFrame(this.gameLoop)

      if (this.$refs.gameStage) {
        this.$refs.gameStage.focus()
      }
    },
    stopLoop() {
      if (this.animationFrame) {
        cancelAnimationFrame(this.animationFrame)
        this.animationFrame = null
      }
    },
    gameLoop(timestamp) {
      if (!this.isPlaying || this.gameOver) {
        return
      }

      const deltaTime = Math.min(timestamp - this.lastFrameTime, 32)
      this.lastFrameTime = timestamp

      this.updateGame(deltaTime)
      this.drawScene()
      this.animationFrame = requestAnimationFrame(this.gameLoop)
    },
    updateGame(deltaTime) {
      const game = this.game
      const dino = game.dino

      game.distance += game.speed * deltaTime
      game.speed = Math.min(0.78, 0.38 + game.distance / 26000)
      game.spawnTimer += deltaTime
      dino.stepTimer += deltaTime
      this.score = Math.floor(game.distance / 8)

      if (!dino.onGround) {
        dino.velocityY += GRAVITY * deltaTime

        if (game.downPressed) {
          dino.velocityY += GRAVITY * deltaTime * 1.6
        }

        dino.y += dino.velocityY * deltaTime

        if (dino.y >= game.groundY - dino.height) {
          dino.y = game.groundY - dino.height
          dino.velocityY = 0
          dino.onGround = true
          this.setDucking(game.downPressed)
        }
      }

      if (game.spawnTimer >= game.nextSpawn) {
        this.addObstacle()
        game.spawnTimer = 0
        game.nextSpawn = getRandomNumber(780, Math.max(980, 1450 - this.score * 1.5))
      }

      this.updateObstacles(deltaTime)
      this.updateClouds(deltaTime)
      this.updateGround(deltaTime)

      if (this.hasCollision()) {
        this.endGame()
      }
    },
    addObstacle() {
      const game = this.game
      const allowBird = this.score > 180
      const shouldAddBird = allowBird && Math.random() > 0.68

      if (shouldAddBird) {
        const isLowBird = Math.random() > 0.28
        game.obstacles.push({
          type: "bird",
          x: game.width + 24,
          y: isLowBird ? game.groundY - 70 : game.groundY - 112,
          width: 52,
          height: 30,
          flapOffset: Math.random() * 300
        })
        return
      }

      const cactusType = Math.random()
      const width = cactusType > 0.72 ? 58 : cactusType > 0.42 ? 42 : 28
      const height = cactusType > 0.55 ? 58 : 48

      game.obstacles.push({
        type: "cactus",
        x: game.width + 24,
        y: game.groundY - height,
        width,
        height
      })
    },
    updateObstacles(deltaTime) {
      const game = this.game
      const moveBy = game.speed * deltaTime

      game.obstacles.forEach((obstacle) => {
        obstacle.x -= moveBy
      })

      game.obstacles = game.obstacles.filter((obstacle) => {
        return obstacle.x + obstacle.width > -20
      })
    },
    updateClouds(deltaTime) {
      const game = this.game

      game.clouds.forEach((cloud) => {
        cloud.x -= cloud.speed * deltaTime

        if (cloud.x + cloud.width < -20) {
          cloud.x = game.width + getRandomNumber(80, 260)
          cloud.y = getRandomNumber(34, Math.max(62, game.groundY - 160))
          cloud.width = getRandomNumber(72, 118)
        }
      })
    },
    updateGround(deltaTime) {
      const game = this.game
      const moveBy = game.speed * deltaTime

      game.groundMarks.forEach((mark) => {
        mark.x -= moveBy

        if (mark.x + mark.width < -10) {
          mark.x = game.width + getRandomNumber(20, 180)
          mark.width = getRandomNumber(18, 88)
        }
      })
    },
    jump() {
      const dino = this.game.dino

      if (!dino.onGround) {
        return
      }

      this.setDucking(false)
      dino.onGround = false
      dino.velocityY = JUMP_SPEED
      dino.height = dino.normalHeight
      dino.width = dino.normalWidth
    },
    setDucking(value) {
      const dino = this.game.dino

      this.isDucking = Boolean(value)

      if (!dino.onGround) {
        return
      }

      dino.height = this.isDucking ? dino.duckHeight : dino.normalHeight
      dino.width = this.isDucking ? dino.duckWidth : dino.normalWidth
      dino.y = this.game.groundY - dino.height
    },
    handleKeyDown(event) {
      const key = event.key
      const isJumpKey = key === " " || key === "Spacebar" || key === "ArrowUp"
      const isDownKey = key === "ArrowDown"

      if (!isJumpKey && !isDownKey) {
        return
      }

      event.preventDefault()

      if (isJumpKey) {
        if (!this.isPlaying || this.gameOver) {
          this.startGame()
          return
        }

        if (!event.repeat) {
          this.jump()
        }
      }

      if (isDownKey && this.isPlaying && !this.gameOver) {
        this.game.downPressed = true
        this.setDucking(true)
      }
    },
    handleKeyUp(event) {
      if (event.key !== "ArrowDown") {
        return
      }

      event.preventDefault()

      if (!this.game) {
        return
      }

      this.game.downPressed = false

      if (this.isPlaying && !this.gameOver) {
        this.setDucking(false)
      }
    },
    handleStageClick() {
      if (!this.isPlaying || this.gameOver) {
        this.startGame()
        return
      }

      this.jump()
    },
    handleStageTouch() {
      this.handleStageClick()
    },
    hasCollision() {
      const dino = this.game.dino
      const dinoBox = this.isDucking
        ? {
            x: dino.x + 8,
            y: dino.y + 6,
            width: dino.width - 16,
            height: dino.height - 10
          }
        : {
            x: dino.x + 7,
            y: dino.y + 4,
            width: dino.width - 14,
            height: dino.height - 8
          }

      return this.game.obstacles.some((obstacle) => {
        const obstacleBox = {
          x: obstacle.x + 5,
          y: obstacle.y + 5,
          width: obstacle.width - 10,
          height: obstacle.height - 10
        }

        return boxesOverlap(dinoBox, obstacleBox)
      })
    },
    endGame() {
      this.gameOver = true
      this.isPlaying = false
      this.gameMessage = "按空格再跑一次"
      this.saveBestScore()
      this.stopLoop()
      this.drawScene()
    },
    drawScene() {
      const canvas = this.$refs.gameCanvas

      if (!canvas || !this.game) {
        return
      }

      const context = canvas.getContext("2d")
      const game = this.game

      context.clearRect(0, 0, game.width, game.height)
      this.drawBackground(context)
      this.drawClouds(context)
      this.drawGround(context)
      this.drawObstacles(context)
      this.drawDino(context)
    },
    drawBackground(context) {
      const game = this.game
      const skyGradient = context.createLinearGradient(0, 0, 0, game.height)

      skyGradient.addColorStop(0, "#f8fbff")
      skyGradient.addColorStop(0.62, "#ffffff")
      skyGradient.addColorStop(1, "#fff7ed")

      context.fillStyle = skyGradient
      context.fillRect(0, 0, game.width, game.height)

      context.fillStyle = "rgba(255, 214, 102, 0.75)"
      context.beginPath()
      context.arc(game.width - 72, 58, 26, 0, Math.PI * 2)
      context.fill()
    },
    drawClouds(context) {
      context.fillStyle = "rgba(148, 163, 184, 0.28)"

      this.game.clouds.forEach((cloud) => {
        const y = cloud.y

        context.beginPath()
        context.ellipse(cloud.x + 18, y + 18, 18, 11, 0, 0, Math.PI * 2)
        context.ellipse(cloud.x + 42, y + 14, 24, 15, 0, 0, Math.PI * 2)
        context.ellipse(cloud.x + 72, y + 18, 22, 12, 0, 0, Math.PI * 2)
        context.fill()
      })
    },
    drawGround(context) {
      const game = this.game

      context.strokeStyle = "#6b7280"
      context.lineWidth = 2
      context.beginPath()
      context.moveTo(0, game.groundY + 1)
      context.lineTo(game.width, game.groundY + 1)
      context.stroke()

      context.fillStyle = "#9ca3af"
      game.groundMarks.forEach((mark) => {
        context.fillRect(mark.x, game.groundY + 16, mark.width, 3)
      })
    },
    drawObstacles(context) {
      this.game.obstacles.forEach((obstacle) => {
        if (obstacle.type === "bird") {
          this.drawBird(context, obstacle)
          return
        }

        this.drawCactus(context, obstacle)
      })
    },
    drawCactus(context, cactus) {
      const x = cactus.x
      const y = cactus.y

      context.fillStyle = "#1f7a4d"
      context.fillRect(x + cactus.width * 0.38, y, cactus.width * 0.25, cactus.height)

      context.fillRect(x + cactus.width * 0.1, y + cactus.height * 0.42, cactus.width * 0.32, 7)
      context.fillRect(x + cactus.width * 0.1, y + cactus.height * 0.28, 7, cactus.height * 0.22)

      context.fillRect(x + cactus.width * 0.58, y + cactus.height * 0.3, cactus.width * 0.32, 7)
      context.fillRect(x + cactus.width * 0.82, y + cactus.height * 0.16, 7, cactus.height * 0.24)

      if (cactus.width > 40) {
        context.fillRect(x + cactus.width * 0.06, y + 10, cactus.width * 0.18, cactus.height - 10)
      }
    },
    drawBird(context, bird) {
      const wingUp = Math.sin((this.game.distance + bird.flapOffset) / 38) > 0
      const x = bird.x
      const y = bird.y

      context.fillStyle = "#334155"
      context.beginPath()
      context.ellipse(x + 27, y + 17, 20, 11, 0, 0, Math.PI * 2)
      context.fill()

      context.beginPath()
      context.moveTo(x + 45, y + 14)
      context.lineTo(x + 56, y + 18)
      context.lineTo(x + 45, y + 22)
      context.closePath()
      context.fill()

      context.fillStyle = "#0f172a"
      context.beginPath()
      context.arc(x + 18, y + 14, 2, 0, Math.PI * 2)
      context.fill()

      context.strokeStyle = "#334155"
      context.lineWidth = 6
      context.lineCap = "round"
      context.beginPath()
      context.moveTo(x + 28, y + 17)
      context.lineTo(x + 10, wingUp ? y + 4 : y + 29)
      context.stroke()
    },
    drawDino(context) {
      const dino = this.game.dino

      context.save()
      context.fillStyle = this.gameOver ? "#ef4444" : "#1f2937"

      if (this.isDucking && dino.onGround) {
        this.drawDuckingDino(context, dino)
      } else {
        this.drawRunningDino(context, dino)
      }

      context.restore()
    },
    drawRunningDino(context, dino) {
      const x = dino.x
      const y = dino.y
      const step = Math.floor(dino.stepTimer / 120) % 2

      context.fillRect(x + 12, y + 21, 25, 27)
      context.fillRect(x + 25, y + 4, 22, 22)
      context.fillRect(x + 38, y + 10, 9, 5)
      context.fillRect(x + 6, y + 28, 12, 6)

      context.fillStyle = "#f8fafc"
      context.fillRect(x + 39, y + 10, 3, 3)
      context.fillStyle = this.gameOver ? "#ef4444" : "#1f2937"

      if (dino.onGround && step === 0) {
        context.fillRect(x + 14, y + 48, 8, 8)
        context.fillRect(x + 30, y + 46, 8, 10)
      } else {
        context.fillRect(x + 16, y + 46, 8, 10)
        context.fillRect(x + 30, y + 48, 8, 8)
      }
    },
    drawDuckingDino(context, dino) {
      const x = dino.x
      const y = dino.y
      const step = Math.floor(dino.stepTimer / 120) % 2

      context.fillRect(x + 8, y + 11, 42, 20)
      context.fillRect(x + 42, y + 4, 24, 18)
      context.fillRect(x + 2, y + 17, 14, 5)

      context.fillStyle = "#f8fafc"
      context.fillRect(x + 57, y + 10, 3, 3)
      context.fillStyle = "#1f2937"

      if (step === 0) {
        context.fillRect(x + 17, y + 29, 10, 5)
        context.fillRect(x + 39, y + 27, 10, 7)
      } else {
        context.fillRect(x + 17, y + 27, 10, 7)
        context.fillRect(x + 39, y + 29, 10, 5)
      }
    }
  }
}
</script>

<style scoped>
.not-found-page {
  min-height: calc(100vh - 32px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 32px 18px;
  background:
    linear-gradient(135deg, rgba(37, 99, 235, 0.08), transparent 36%),
    linear-gradient(315deg, rgba(249, 115, 22, 0.1), transparent 34%),
    #f8fafc;
  box-sizing: border-box;
}

.not-found-shell {
  width: min(980px, 100%);
}

.not-found-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 16px;
}

.not-found-code {
  margin: 0 0 4px;
  color: #2563eb;
  font-size: 15px;
  font-weight: 900;
  letter-spacing: 0;
}

.not-found-header h1 {
  margin: 0;
  color: #111827;
  font-size: 42px;
  line-height: 1.12;
}

.score-panel {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #475569;
  font-size: 15px;
  font-weight: 700;
  white-space: nowrap;
}

.score-panel strong {
  color: #111827;
}

.game-stage {
  position: relative;
  overflow: hidden;
  border: 1px solid #d9e2ec;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 20px 60px rgba(15, 23, 42, 0.1);
  cursor: pointer;
  outline: none;
}

.game-stage:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.13), 0 20px 60px rgba(15, 23, 42, 0.1);
}

.dino-canvas {
  display: block;
  width: 100%;
  height: 320px;
  touch-action: manipulation;
}

.game-overlay {
  position: absolute;
  inset: 0;
  display: grid;
  place-content: center;
  gap: 10px;
  background: rgba(248, 250, 252, 0.64);
  color: #111827;
  text-align: center;
  pointer-events: none;
}

.game-overlay strong {
  font-size: 24px;
  letter-spacing: 0;
}

.game-overlay span {
  color: #475569;
  font-size: 14px;
  font-weight: 700;
}

.game-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-top: 16px;
}

.game-toolbar button {
  min-width: 108px;
  min-height: 38px;
  padding: 0 18px;
  border: 1px solid #111827;
  border-radius: 8px;
  background: #111827;
  color: #fff;
  cursor: pointer;
  font: inherit;
  font-weight: 800;
}

.game-toolbar button:hover {
  background: #2563eb;
  border-color: #2563eb;
}

.control-hints {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
  color: #475569;
  font-size: 14px;
  font-weight: 700;
}

.control-hints span {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

kbd {
  min-width: 26px;
  padding: 4px 7px;
  border: 1px solid #cbd5e1;
  border-bottom-width: 2px;
  border-radius: 6px;
  background: #fff;
  color: #111827;
  font: inherit;
  font-size: 12px;
  line-height: 1;
  text-align: center;
}

@media (max-width: 640px) {
  .not-found-page {
    align-items: flex-start;
    padding: 22px 12px;
  }

  .not-found-header,
  .game-toolbar {
    align-items: flex-start;
    flex-direction: column;
  }

  .not-found-header h1 {
    font-size: 32px;
  }

  .score-panel {
    width: 100%;
    justify-content: space-between;
  }

  .game-toolbar button {
    width: 100%;
  }

  .control-hints {
    justify-content: flex-start;
  }

  .dino-canvas {
    height: 260px;
  }
}
</style>
