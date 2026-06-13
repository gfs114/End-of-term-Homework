<template>
  <main class="not-found-page">
    <section class="chrome-offline-page" aria-label="深色恐龙小游戏">
      <section
        ref="gameStage"
        class="chrome-dino-stage"
        tabindex="0"
        aria-label="Chrome dinosaur runner"
        @click="handleStageClick"
        @touchstart.prevent="handleStageTouch"
      >
        <div class="chrome-dino-score" aria-label="game score">
          <span>HI {{ paddedBestScore }}</span>
          <span>{{ paddedScore }}</span>
        </div>

        <canvas
          ref="gameCanvas"
          class="dino-canvas"
          aria-label="Dinosaur runner canvas"
        ></canvas>

        <div v-if="!isPlaying || gameOver" class="game-overlay">
          <strong v-if="gameOver">游戏结束</strong>
          <span>{{ gameMessage }}</span>
        </div>
      </section>

      <header class="offline-copy">
        <h1>点按恐龙开始</h1>
        <p>请试试以下办法：</p>
        <ul>
          <li>检查网络连接线、调制解调器和路由器</li>
          <li>重新连接到 Wi-Fi</li>
          <li>运行 Windows 网络诊断</li>
        </ul>
        <p class="offline-error">ERR_INTERNET_DISCONNECTED</p>
      </header>
    </section>
  </main>
</template>

<script>
const BEST_SCORE_KEY = "not-found-dino-best-score"
const DINO_CANVAS_WIDTH = 600
const DINO_CANVAS_HEIGHT = 190
const GROUND_Y = 136
const GRAVITY = 0.00265
const JUMP_SPEED = -0.72
const DARK_BG = "#202124"
const DINO_FILL = "#bdc1c6"
const DINO_STROKE = "#111315"

// 在指定区间内生成障碍物间距和地面线段宽度。
function getRandomNumber(min, max) {
  return Math.random() * (max - min) + min
}

// 判断两个碰撞盒是否相交。
function boxesOverlap(boxA, boxB) {
  return (
    boxA.x < boxB.x + boxB.width &&
    boxA.x + boxA.width > boxB.x &&
    boxA.y < boxB.y + boxB.height &&
    boxA.y + boxA.height > boxB.y
  )
}

// 将分数格式化为 Chrome 小恐龙风格的五位数字。
function padScore(value) {
  return String(Math.max(0, Math.floor(value))).padStart(5, "0")
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
      gameMessage: "按空格键或点按恐龙开始"
    }
  },
  computed: {
    // 当前分数的五位展示文本。
    paddedScore() {
      return padScore(this.score)
    },
    // 历史最高分的五位展示文本。
    paddedBestScore() {
      return padScore(this.bestScore)
    }
  },
  mounted() {
    // 初始化画布、读取最高分并绑定键盘/窗口事件。
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
    // 离开页面时解除事件监听并停止动画循环。
    window.removeEventListener("keydown", this.handleKeyDown)
    window.removeEventListener("keyup", this.handleKeyUp)
    window.removeEventListener("resize", this.handleResize)
    this.stopLoop()
  },
  methods: {
    // 创建一局游戏所需的基础状态。
    createGameState() {
      return {
        width: DINO_CANVAS_WIDTH,
        height: DINO_CANVAS_HEIGHT,
        groundY: GROUND_Y,
        distance: 0,
        speed: 0.34,
        spawnTimer: 0,
        nextSpawn: 880,
        downPressed: false,
        dino: {
          x: 128,
          y: GROUND_Y - 58,
          width: 58,
          height: 58,
          normalWidth: 58,
          normalHeight: 58,
          duckWidth: 76,
          duckHeight: 34,
          velocityY: 0,
          onGround: true,
          stepTimer: 0
        },
        obstacles: [],
        clouds: [],
        groundMarks: [
          { x: 20, width: 14 },
          { x: 110, width: 3 },
          { x: 154, width: 12 },
          { x: 272, width: 4 },
          { x: 390, width: 18 },
          { x: 516, width: 5 }
        ]
      }
    },
    // 从本地存储读取最高分。
    loadBestScore() {
      try {
        const savedScore = Number(window.localStorage.getItem(BEST_SCORE_KEY) || 0)
        this.bestScore = Number.isFinite(savedScore) ? savedScore : 0
      } catch {
        this.bestScore = 0
      }
    },
    // 当本局分数超过最高分时写入本地存储。
    saveBestScore() {
      if (this.score <= this.bestScore) {
        return
      }

      this.bestScore = this.score

      try {
        window.localStorage.setItem(BEST_SCORE_KEY, String(this.bestScore))
      } catch {
        // Keep the high score only in memory when localStorage is unavailable.
      }
    },
    // 窗口尺寸变化后重设画布并重绘当前画面。
    handleResize() {
      this.resizeCanvas()
      this.drawScene()
    },
    // 按容器宽度适配 canvas，同时保持内部逻辑坐标不变。
    resizeCanvas() {
      const canvas = this.$refs.gameCanvas

      if (!canvas) {
        return
      }

      const parentWidth = canvas.parentElement ? canvas.parentElement.clientWidth : DINO_CANVAS_WIDTH
      const width = Math.max(280, Math.min(parentWidth, DINO_CANVAS_WIDTH))
      const height = Math.round(width * (DINO_CANVAS_HEIGHT / DINO_CANVAS_WIDTH))
      const scale = window.devicePixelRatio || 1

      canvas.style.width = `${width}px`
      canvas.style.height = `${height}px`
      canvas.width = Math.round(DINO_CANVAS_WIDTH * scale)
      canvas.height = Math.round(DINO_CANVAS_HEIGHT * scale)

      const context = canvas.getContext("2d")
      context.setTransform(scale, 0, 0, scale, 0, 0)

      this.game.width = DINO_CANVAS_WIDTH
      this.game.height = DINO_CANVAS_HEIGHT
      this.game.groundY = GROUND_Y
      this.snapDinoToGround()
    },
    // 根据站立/低头状态把恐龙贴回地面。
    snapDinoToGround() {
      if (!this.game || !this.game.dino) {
        return
      }

      const dino = this.game.dino
      const isDuckingOnGround = this.isDucking && dino.onGround

      dino.width = isDuckingOnGround ? dino.duckWidth : dino.normalWidth
      dino.height = isDuckingOnGround ? dino.duckHeight : dino.normalHeight

      if (dino.onGround) {
        dino.y = this.game.groundY - dino.height
      }
    },
    // 重置状态并启动一局新游戏。
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
    // 停止 requestAnimationFrame 循环。
    stopLoop() {
      if (this.animationFrame) {
        cancelAnimationFrame(this.animationFrame)
        this.animationFrame = null
      }
    },
    // 游戏主循环：计算帧间隔、更新状态、绘制画面。
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
    // 根据时间推进分数、速度、跳跃、障碍物和碰撞检测。
    updateGame(deltaTime) {
      const game = this.game
      const dino = game.dino

      game.distance += game.speed * deltaTime
      game.speed = Math.min(0.68, 0.34 + game.distance / 34000)
      game.spawnTimer += deltaTime
      dino.stepTimer += deltaTime
      this.score = Math.floor(game.distance / 10)

      if (!dino.onGround) {
        dino.velocityY += GRAVITY * deltaTime

        if (game.downPressed) {
          dino.velocityY += GRAVITY * deltaTime * 1.8
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
        game.nextSpawn = getRandomNumber(760, Math.max(860, 1350 - this.score * 1.2))
      }

      this.updateObstacles(deltaTime)
      this.updateGround(deltaTime)

      if (this.hasCollision()) {
        this.endGame()
      }
    },
    // 随机生成仙人掌或飞行动物障碍物。
    addObstacle() {
      const game = this.game
      const allowPterosaur = this.score > 180
      const shouldAddPterosaur = allowPterosaur && Math.random() > 0.74

      if (shouldAddPterosaur) {
        const lowFlight = Math.random() > 0.35

        game.obstacles.push({
          type: "pterosaur",
          x: game.width + 18,
          y: lowFlight ? game.groundY - 48 : game.groundY - 82,
          width: 46,
          height: 30,
          flapOffset: Math.random() * 240
        })
        return
      }

      const cactusType = Math.random()
      const width = cactusType > 0.72 ? 34 : cactusType > 0.42 ? 25 : 17
      const height = cactusType > 0.55 ? 48 : 36

      game.obstacles.push({
        type: "cactus",
        x: game.width + 18,
        y: game.groundY - height,
        width,
        height,
        cluster: width > 24
      })
    },
    // 移动障碍物并清理已经离开屏幕的项。
    updateObstacles(deltaTime) {
      const moveBy = this.game.speed * deltaTime

      this.game.obstacles.forEach((obstacle) => {
        obstacle.x -= moveBy
      })

      this.game.obstacles = this.game.obstacles.filter((obstacle) => {
        return obstacle.x + obstacle.width > -20
      })
    },
    // 移动地面装饰线段，形成奔跑视觉效果。
    updateGround(deltaTime) {
      const moveBy = this.game.speed * deltaTime

      this.game.groundMarks.forEach((mark) => {
        mark.x -= moveBy

        if (mark.x + mark.width < -10) {
          mark.x = this.game.width + getRandomNumber(14, 96)
          mark.width = getRandomNumber(2, 18)
        }
      })
    },
    // 让恐龙起跳，空中时不重复跳跃。
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
    // 设置恐龙低头状态，并同步碰撞盒尺寸。
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
    // 处理键盘开始、跳跃和低头操作。
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
    // 松开下方向键后恢复站立状态。
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
    // 点击游戏区域：未开始时开局，进行中则跳跃。
    handleStageClick() {
      if (!this.isPlaying || this.gameOver) {
        this.startGame()
        return
      }

      this.jump()
    },
    // 触屏操作复用点击逻辑。
    handleStageTouch() {
      this.handleStageClick()
    },
    // 使用收缩后的碰撞盒检测恐龙是否撞到障碍物。
    hasCollision() {
      const dino = this.game.dino
      const dinoBox = this.isDucking
        ? {
            x: dino.x + 9,
            y: dino.y + 6,
            width: dino.width - 15,
            height: dino.height - 10
          }
        : {
            x: dino.x + 9,
            y: dino.y + 6,
            width: dino.width - 17,
            height: dino.height - 11
          }

      return this.game.obstacles.some((obstacle) => {
        const obstacleBox = {
          x: obstacle.x + 4,
          y: obstacle.y + 4,
          width: obstacle.width - 8,
          height: obstacle.height - 8
        }

        return boxesOverlap(dinoBox, obstacleBox)
      })
    },
    // 结束游戏、保存最高分并停在当前画面。
    endGame() {
      this.gameOver = true
      this.isPlaying = false
      this.gameMessage = "按空格键再跑一次"
      this.saveBestScore()
      this.stopLoop()
      this.drawScene()
    },
    // 清空画布并按背景、月亮、地面、障碍物、恐龙顺序绘制。
    drawScene() {
      const canvas = this.$refs.gameCanvas

      if (!canvas || !this.game) {
        return
      }

      const context = canvas.getContext("2d")

      context.clearRect(0, 0, this.game.width, this.game.height)
      this.drawBackground(context)
      this.drawDarkMoon(context)
      this.drawGround(context)
      this.drawObstacles(context)
      this.drawPixelDino(context)
    },
    // 绘制深色背景。
    drawBackground(context) {
      context.fillStyle = DARK_BG
      context.fillRect(0, 0, this.game.width, this.game.height)
    },
    // 绘制暗色月亮装饰。
    drawDarkMoon(context) {
      context.fillStyle = "#24272b"
      context.beginPath()
      context.arc(334, 30, 24, 0, Math.PI * 2)
      context.fill()

      context.fillStyle = DARK_BG
      context.beginPath()
      context.arc(320, 22, 27, 0, Math.PI * 2)
      context.fill()
    },
    // 绘制地面基线和移动的地面刻痕。
    drawGround(context) {
      context.fillStyle = DINO_FILL
      context.fillRect(0, this.game.groundY, this.game.width, 2)

      this.game.groundMarks.forEach((mark) => {
        context.fillRect(Math.round(mark.x), this.game.groundY + 11, Math.round(mark.width), 2)
      })
    },
    // 根据障碍物类型选择对应的像素绘制函数。
    drawObstacles(context) {
      this.game.obstacles.forEach((obstacle) => {
        if (obstacle.type === "pterosaur") {
          this.drawPixelPterosaur(context, obstacle)
          return
        }

        this.drawPixelCactus(context, obstacle)
      })
    },
    // 绘制一个带描边的像素块，是所有像素角色的基础单元。
    drawBlock(context, x, y, width, height, fill = DINO_FILL) {
      context.fillStyle = DINO_STROKE
      context.fillRect(Math.round(x), Math.round(y), Math.round(width), Math.round(height))
      context.fillStyle = fill
      context.fillRect(
        Math.round(x + 2),
        Math.round(y + 2),
        Math.max(1, Math.round(width - 4)),
        Math.max(1, Math.round(height - 4))
      )
    },
    // 绘制仙人掌障碍物。
    drawPixelCactus(context, cactus) {
      const x = Math.round(cactus.x)
      const y = Math.round(cactus.y)

      this.drawBlock(context, x + 7, y, 8, cactus.height)
      this.drawBlock(context, x + 2, y + 15, 7, 6)
      this.drawBlock(context, x + 2, y + 8, 5, 14)
      this.drawBlock(context, x + 14, y + 22, 8, 6)
      this.drawBlock(context, x + 20, y + 13, 5, 16)

      if (cactus.cluster) {
        this.drawBlock(context, x + 22, y + 10, 7, cactus.height - 10)
        this.drawBlock(context, x + 29, y + 22, 5, 6)
      }
    },
    // 绘制飞行动物障碍物，并根据距离变化扇动翅膀。
    drawPixelPterosaur(context, bird) {
      const x = Math.round(bird.x)
      const y = Math.round(bird.y)
      const wingUp = Math.sin((this.game.distance + bird.flapOffset) / 34) > 0

      this.drawBlock(context, x + 14, y + 12, 22, 8)
      this.drawBlock(context, x + 34, y + 10, 9, 6)
      this.drawBlock(context, x + 41, y + 12, 5, 4)
      this.drawBlock(context, x + 6, y + 14, 10, 5)

      if (wingUp) {
        this.drawBlock(context, x + 17, y + 2, 16, 7)
        this.drawBlock(context, x + 22, y + 8, 9, 6)
      } else {
        this.drawBlock(context, x + 17, y + 22, 16, 7)
        this.drawBlock(context, x + 22, y + 17, 9, 6)
      }
    },
    // 根据当前姿态选择站立奔跑或低头奔跑形态。
    drawPixelDino(context) {
      const dino = this.game.dino

      context.save()

      if (this.isDucking && dino.onGround) {
        this.drawDuckingDino(context, dino)
      } else {
        this.drawRunningDino(context, dino)
      }

      context.restore()
    },
    // 绘制站立奔跑的恐龙像素图。
    drawRunningDino(context, dino) {
      const x = Math.round(dino.x)
      const y = Math.round(dino.y)
      const step = Math.floor(dino.stepTimer / 115) % 2

      this.drawBlock(context, x + 13, y + 23, 29, 30)
      this.drawBlock(context, x + 31, y + 12, 17, 24)
      this.drawBlock(context, x + 38, y + 1, 28, 24)
      this.drawBlock(context, x + 61, y + 8, 12, 8)
      this.drawBlock(context, x + 5, y + 30, 15, 8)
      this.drawBlock(context, x, y + 20, 8, 18)
      this.drawBlock(context, x + 31, y + 30, 6, 10)

      context.fillStyle = DINO_STROKE
      context.fillRect(x + 55, y + 8, 4, 4)

      if (dino.onGround && step === 0) {
        this.drawBlock(context, x + 15, y + 51, 9, 12)
        this.drawBlock(context, x + 35, y + 48, 9, 15)
        context.fillStyle = DINO_STROKE
        context.fillRect(x + 11, y + 62, 14, 4)
      } else {
        this.drawBlock(context, x + 17, y + 48, 9, 15)
        this.drawBlock(context, x + 36, y + 51, 9, 12)
        context.fillStyle = DINO_STROKE
        context.fillRect(x + 35, y + 62, 14, 4)
      }
    },
    // 绘制低头奔跑的恐龙像素图。
    drawDuckingDino(context, dino) {
      const x = Math.round(dino.x)
      const y = Math.round(dino.y)
      const step = Math.floor(dino.stepTimer / 115) % 2

      this.drawBlock(context, x + 6, y + 11, 45, 20)
      this.drawBlock(context, x + 45, y + 3, 26, 19)
      this.drawBlock(context, x + 66, y + 9, 10, 6)
      this.drawBlock(context, x, y + 17, 12, 6)

      context.fillStyle = DINO_STROKE
      context.fillRect(x + 61, y + 8, 4, 4)

      if (step === 0) {
        this.drawBlock(context, x + 15, y + 29, 11, 6)
        this.drawBlock(context, x + 43, y + 27, 11, 8)
      } else {
        this.drawBlock(context, x + 15, y + 27, 11, 8)
        this.drawBlock(context, x + 43, y + 29, 11, 6)
      }
    }
  }
}
</script>

<style scoped>
.not-found-page {
  min-height: calc(100vh - 120px);
  display: flex;
  justify-content: center;
  padding: 40px 20px 28px;
  color: #bdc1c6;
  background: #202124;
  box-sizing: border-box;
  font-family: "Segoe UI", Tahoma, "Microsoft YaHei", sans-serif;
}

.chrome-offline-page {
  width: min(600px, 100%);
}

.chrome-dino-stage {
  position: relative;
  width: min(600px, 100%);
  overflow: hidden;
  background: #202124;
  cursor: pointer;
  outline: none;
  user-select: none;
}

.chrome-dino-stage:focus {
  outline: none;
}

.chrome-dino-score {
  position: absolute;
  top: 8px;
  right: 0;
  z-index: 2;
  display: flex;
  gap: 12px;
  color: rgba(189, 193, 198, 0.78);
  font-family: "Courier New", monospace;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 1px;
  pointer-events: none;
}

.dino-canvas {
  display: block;
  width: 100%;
  height: 190px;
  image-rendering: pixelated;
  touch-action: manipulation;
}

.game-overlay {
  position: absolute;
  top: 148px;
  left: 0;
  right: 0;
  z-index: 3;
  display: grid;
  justify-items: center;
  gap: 4px;
  color: rgba(189, 193, 198, 0.86);
  font-family: "Courier New", monospace;
  pointer-events: none;
}

.game-overlay strong {
  font-size: 14px;
  letter-spacing: 1px;
}

.game-overlay span {
  font-size: 12px;
  letter-spacing: 0;
}

.offline-copy {
  margin-top: 8px;
}

.offline-copy h1 {
  margin: 0 0 18px;
  color: #bdc1c6;
  font-size: 28px;
  font-weight: 400;
  line-height: 1.25;
}

.offline-copy p {
  margin: 0 0 8px;
  color: #bdc1c6;
  font-size: 15px;
  line-height: 1.65;
}

.offline-copy ul {
  margin: 0 0 14px;
  padding-left: 22px;
  color: #bdc1c6;
  font-size: 15px;
  line-height: 1.65;
}

.offline-error {
  color: #9aa0a6;
  font-size: 12px;
}

@media (max-width: 640px) {
  .not-found-page {
    min-height: calc(100vh - 104px);
    justify-content: flex-start;
    padding: 28px 20px 24px;
  }

  .chrome-dino-score {
    font-size: 11px;
  }

  .offline-copy h1 {
    font-size: 26px;
  }
}
</style>
