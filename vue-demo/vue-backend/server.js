const express = require('express')
const cors = require('cors')
const axios = require('axios')
require('dotenv').config()
const db = require('./db')

const app = express()

// =======================
// 解决跨域 CORS
// 必须放在所有接口前面
// =======================
app.use(cors({
  origin: ['http://localhost:8080', 'http://localhost:8081', 'http://localhost:8082'],
  credentials: true
}))

app.use(express.json())

// =======================
// 测试接口
// =======================
app.get('/', (req, res) => {
  res.send('后端服务器运行成功')
})

app.get('/api', (req, res) => {
  res.json({
    code: 200,
    message: 'API 服务运行成功'
  })
})

// =======================
// 用户注册
// POST /api/register
// =======================
app.post('/api/register', async (req, res) => {
  const { username, email, password } = req.body || {}

  if (!username || !email || !password) {
    return res.json({
      code: 400,
      message: '用户名、邮箱和密码不能为空'
    })
  }

  try {
    const [exists] = await db.query(
      'SELECT id FROM users WHERE username = ? OR email = ?',
      [username, email]
    )

    if (exists.length > 0) {
      return res.json({
        code: 400,
        message: '用户名或邮箱已存在'
      })
    }

    const [result] = await db.query(
      'INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)',
      [username, email, password, 'user']
    )

    res.json({
      code: 200,
      message: '注册成功',
      data: {
        id: result.insertId,
        username,
        email,
        role: 'user'
      }
    })
  } catch (err) {
    console.error('注册失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// =======================
// 用户登录
// POST /api/login
// =======================
app.post('/api/login', async (req, res) => {
  const { username, password } = req.body || {}

  if (!username || !password) {
    return res.json({
      code: 400,
      message: '账号和密码不能为空'
    })
  }

  try {
    const [rows] = await db.query(
      `
      SELECT id, username, email, bio, role, created_at
      FROM users
      WHERE (username = ? OR email = ?) AND password = ?
      `,
      [username, username, password]
    )

    if (rows.length === 0) {
      return res.json({
        code: 400,
        message: '账号或密码错误'
      })
    }

    res.json({
      code: 200,
      message: '登录成功',
      data: rows[0]
    })
  } catch (err) {
    console.error('登录失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// =======================
// 用户信息管理
// =======================
app.get('/api/users', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, username, email, bio, role, created_at FROM users ORDER BY id DESC'
    )

    res.json({
      code: 200,
      message: '查询成功',
      data: rows
    })
  } catch (err) {
    console.error('查询用户失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.post('/api/users', async (req, res) => {
  const { username, email, password } = req.body || {}

  if (!username || !email || !password) {
    return res.json({
      code: 400,
      message: '用户名、邮箱和密码不能为空'
    })
  }

  try {
    const [exists] = await db.query(
      'SELECT id FROM users WHERE username = ? OR email = ?',
      [username, email]
    )

    if (exists.length > 0) {
      return res.json({
        code: 400,
        message: '用户名或邮箱已存在'
      })
    }

    const [result] = await db.query(
      'INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)',
      [username, email, password, 'user']
    )

    res.json({
      code: 200,
      message: '新增用户成功',
      data: {
        id: result.insertId
      }
    })
  } catch (err) {
    console.error('新增用户失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.put('/api/users/:id', async (req, res) => {
  const { id } = req.params
  const { username, email, password, bio } = req.body || {}

  if (!username || !email) {
    return res.json({
      code: 400,
      message: '用户名和邮箱不能为空'
    })
  }

  try {
    const [userRows] = await db.query(
      'SELECT id FROM users WHERE id = ?',
      [id]
    )

    if (userRows.length === 0) {
      return res.json({
        code: 404,
        message: '用户不存在'
      })
    }

    const [sameRows] = await db.query(
      'SELECT id FROM users WHERE (username = ? OR email = ?) AND id != ?',
      [username, email, id]
    )

    if (sameRows.length > 0) {
      return res.json({
        code: 400,
        message: '用户名或邮箱已被使用'
      })
    }

    if (password) {
      await db.query(
        'UPDATE users SET username = ?, email = ?, password = ?, bio = ?, role = ? WHERE id = ?',
        [username, email, password, bio || null, 'user', id]
      )
    } else {
      await db.query(
        'UPDATE users SET username = ?, email = ?, bio = ?, role = ? WHERE id = ?',
        [username, email, bio || null, 'user', id]
      )
    }

    res.json({
      code: 200,
      message: '修改用户成功'
    })
  } catch (err) {
    console.error('修改用户失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.delete('/api/users/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM users WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '用户不存在'
      })
    }

    await db.query(
      'DELETE FROM users WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '删除用户成功'
    })
  } catch (err) {
    console.error('删除用户失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// =======================
// 管理员登录
// POST /api/admin/login
// =======================
app.post('/api/admin/login', async (req, res) => {
  const { username, password } = req.body || {}

  if (!username || !password) {
    return res.json({
      code: 400,
      message: '管理员账号和密码不能为空'
    })
  }

  try {
    const [rows] = await db.query(
      `
      SELECT id, username, email, role, created_at
      FROM admins
      WHERE username = ? AND password = ?
      `,
      [username, password]
    )

    if (rows.length === 0) {
      return res.json({
        code: 400,
        message: '管理员账号或密码错误'
      })
    }

    res.json({
      code: 200,
      message: '管理员登录成功',
      data: rows[0]
    })
  } catch (err) {
    console.error('管理员登录失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// =======================
// 管理员信息管理
// =======================
app.get('/api/admins', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, username, email, role, created_at FROM admins ORDER BY id DESC'
    )

    res.json({
      code: 200,
      message: '查询成功',
      data: rows
    })
  } catch (err) {
    console.error('查询管理员失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.post('/api/admins', async (req, res) => {
  const { username, password, email, role } = req.body || {}

  if (!username || !password) {
    return res.json({
      code: 400,
      message: '管理员账号和密码不能为空'
    })
  }

  try {
    const [exists] = await db.query(
      'SELECT id FROM admins WHERE username = ?',
      [username]
    )

    if (exists.length > 0) {
      return res.json({
        code: 400,
        message: '管理员账号已存在'
      })
    }

    const [result] = await db.query(
      'INSERT INTO admins (username, password, email, role) VALUES (?, ?, ?, ?)',
      [username, password, email || null, role || 'ADMIN']
    )

    res.json({
      code: 200,
      message: '新增管理员成功',
      data: {
        id: result.insertId
      }
    })
  } catch (err) {
    console.error('新增管理员失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.put('/api/admins/:id', async (req, res) => {
  const { id } = req.params
  const { username, password, email, role } = req.body || {}

  if (!username) {
    return res.json({
      code: 400,
      message: '管理员账号不能为空'
    })
  }

  try {
    const [adminRows] = await db.query(
      'SELECT id FROM admins WHERE id = ?',
      [id]
    )

    if (adminRows.length === 0) {
      return res.json({
        code: 404,
        message: '管理员不存在'
      })
    }

    const [sameRows] = await db.query(
      'SELECT id FROM admins WHERE username = ? AND id != ?',
      [username, id]
    )

    if (sameRows.length > 0) {
      return res.json({
        code: 400,
        message: '管理员账号已被使用'
      })
    }

    if (password) {
      await db.query(
        'UPDATE admins SET username = ?, password = ?, email = ?, role = ? WHERE id = ?',
        [username, password, email || null, role || 'ADMIN', id]
      )
    } else {
      await db.query(
        'UPDATE admins SET username = ?, email = ?, role = ? WHERE id = ?',
        [username, email || null, role || 'ADMIN', id]
      )
    }

    res.json({
      code: 200,
      message: '修改管理员成功'
    })
  } catch (err) {
    console.error('修改管理员失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.delete('/api/admins/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM admins WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '管理员不存在'
      })
    }

    await db.query(
      'DELETE FROM admins WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '删除管理员成功'
    })
  } catch (err) {
    console.error('删除管理员失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// =======================
// 文章管理模块
// =======================
app.get('/api/articles', async (req, res) => {
  try {
    const [rows] = await db.query(
      `
      SELECT id, title, content, author, category, views, favorites, status, created_at, updated_at
      FROM articles
      ORDER BY id DESC
      `
    )

    res.json({
      code: 200,
      message: '查询成功',
      data: rows
    })
  } catch (err) {
    console.error('查询文章失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.get('/api/articles/published', async (req, res) => {
  try {
    const [rows] = await db.query(
      `
      SELECT id, title, content, author, category, views, favorites, status, created_at, updated_at
      FROM articles
      WHERE status = ?
      ORDER BY id DESC
      `,
      ['published']
    )

    res.json({
      code: 200,
      message: '查询成功',
      data: rows
    })
  } catch (err) {
    console.error('查询已发布文章失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.get('/api/articles/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [exists] = await db.query(
      'SELECT id FROM articles WHERE id = ?',
      [id]
    )

    if (exists.length === 0) {
      return res.json({
        code: 404,
        message: '文章不存在'
      })
    }

    await db.query(
      'UPDATE articles SET views = views + 1 WHERE id = ?',
      [id]
    )

    const [rows] = await db.query(
      `
      SELECT id, title, content, author, category, views, favorites, status, created_at, updated_at
      FROM articles
      WHERE id = ?
      `,
      [id]
    )

    res.json({
      code: 200,
      message: '查询成功',
      data: rows[0]
    })
  } catch (err) {
    console.error('查询文章详情失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.post('/api/articles', async (req, res) => {
  const { title, content, author, category, status } = req.body || {}

  if (!title || !content) {
    return res.json({
      code: 400,
      message: '文章标题和内容不能为空'
    })
  }

  try {
    const [result] = await db.query(
      'INSERT INTO articles (title, content, author, category, status) VALUES (?, ?, ?, ?, ?)',
      [title, content, author || 'admin', category || '默认', status || 'published']
    )

    res.json({
      code: 200,
      message: '新增文章成功',
      data: {
        id: result.insertId
      }
    })
  } catch (err) {
    console.error('新增文章失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.put('/api/articles/:id', async (req, res) => {
  const { id } = req.params
  const { title, content, author, category, status } = req.body || {}

  if (!title || !content) {
    return res.json({
      code: 400,
      message: '文章标题和内容不能为空'
    })
  }

  try {
    const [rows] = await db.query(
      'SELECT id FROM articles WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '文章不存在'
      })
    }

    await db.query(
      'UPDATE articles SET title = ?, content = ?, author = ?, category = ?, status = ? WHERE id = ?',
      [title, content, author || 'admin', category || '默认', status || 'published', id]
    )

    res.json({
      code: 200,
      message: '修改文章成功'
    })
  } catch (err) {
    console.error('修改文章失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.put('/api/articles/:id/favorite', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM articles WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '文章不存在'
      })
    }

    await db.query(
      'UPDATE articles SET favorites = favorites + 1 WHERE id = ?',
      [id]
    )

    const [resultRows] = await db.query(
      'SELECT id, title, favorites FROM articles WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '收藏成功',
      data: resultRows[0]
    })
  } catch (err) {
    console.error('收藏文章失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.put('/api/articles/:id/unfavorite', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM articles WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '文章不存在'
      })
    }

    await db.query(
      'UPDATE articles SET favorites = IF(favorites > 0, favorites - 1, 0) WHERE id = ?',
      [id]
    )

    const [resultRows] = await db.query(
      'SELECT id, title, favorites FROM articles WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '取消收藏成功',
      data: resultRows[0]
    })
  } catch (err) {
    console.error('取消收藏失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.delete('/api/articles/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM articles WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '文章不存在'
      })
    }

    await db.query(
      'DELETE FROM articles WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '删除文章成功'
    })
  } catch (err) {
    console.error('删除文章失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// =======================
// 用户收藏设备模块
// =======================
app.get('/api/user-favorite-devices', async (req, res) => {
  const { username, device_type } = req.query

  if (!username) {
    return res.json({
      code: 400,
      message: '用户名不能为空'
    })
  }

  try {
    let sql = `
      SELECT id, username, device_type, device_brand, device_model, device_price, device_specs
      FROM user_favorite_devices
      WHERE username = ?
    `
    const params = [username]

    if (device_type) {
      sql += ' AND device_type = ?'
      params.push(device_type)
    }

    sql += ' ORDER BY id DESC'

    const [rows] = await db.query(sql, params)

    res.json({
      code: 200,
      message: '查询成功',
      data: rows
    })
  } catch (err) {
    console.error('查询收藏设备失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.get('/api/user-favorite-devices/check', async (req, res) => {
  const { username, device_type, device_model } = req.query

  if (!username || !device_type || !device_model) {
    return res.json({
      code: 400,
      message: 'username、device_type、device_model 不能为空'
    })
  }

  try {
    const [rows] = await db.query(
      'SELECT id FROM user_favorite_devices WHERE username = ? AND device_type = ? AND device_model = ?',
      [username, device_type, device_model]
    )

    res.json({
      code: 200,
      message: '查询成功',
      data: {
        favorited: rows.length > 0,
        id: rows.length > 0 ? rows[0].id : null
      }
    })
  } catch (err) {
    console.error('检查收藏状态失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.post('/api/user-favorite-devices', async (req, res) => {
  const {
    username,
    device_type,
    device_brand,
    device_model,
    device_price,
    device_specs
  } = req.body || {}

  if (!username || !device_type || !device_model) {
    return res.json({
      code: 400,
      message: '用户名、设备类型、设备型号不能为空'
    })
  }

  try {
    const specsValue = typeof device_specs === 'object'
      ? JSON.stringify(device_specs)
      : (device_specs || '')

    const [exists] = await db.query(
      'SELECT id FROM user_favorite_devices WHERE username = ? AND device_type = ? AND device_model = ?',
      [username, device_type, device_model]
    )

    if (exists.length > 0) {
      return res.json({
        code: 400,
        message: '该设备已收藏'
      })
    }

    const [result] = await db.query(
      `
      INSERT INTO user_favorite_devices
      (username, device_type, device_brand, device_model, device_price, device_specs)
      VALUES (?, ?, ?, ?, ?, ?)
      `,
      [
        username,
        device_type,
        device_brand || '',
        device_model,
        device_price || '',
        specsValue
      ]
    )

    res.json({
      code: 200,
      message: '收藏成功',
      data: {
        id: result.insertId
      }
    })
  } catch (err) {
    console.error('新增收藏设备失败：', err)

    if (err.code === 'ER_DUP_ENTRY') {
      return res.json({
        code: 400,
        message: '该设备已收藏'
      })
    }

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.delete('/api/user-favorite-devices/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM user_favorite_devices WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '收藏记录不存在'
      })
    }

    await db.query(
      'DELETE FROM user_favorite_devices WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '取消收藏成功'
    })
  } catch (err) {
    console.error('删除收藏设备失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

app.delete('/api/user-favorite-devices', async (req, res) => {
  const { username, device_type, device_model } = req.query

  if (!username || !device_type || !device_model) {
    return res.json({
      code: 400,
      message: 'username、device_type、device_model 不能为空'
    })
  }

  try {
    const [rows] = await db.query(
      'SELECT id FROM user_favorite_devices WHERE username = ? AND device_type = ? AND device_model = ?',
      [username, device_type, device_model]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '收藏记录不存在'
      })
    }

    await db.query(
      'DELETE FROM user_favorite_devices WHERE username = ? AND device_type = ? AND device_model = ?',
      [username, device_type, device_model]
    )

    res.json({
      code: 200,
      message: '取消收藏成功'
    })
  } catch (err) {
    console.error('取消收藏设备失败：', err)

    res.json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// =======================
// AI 选购助手接口
// POST /api/ai-chat
// =======================
app.post('/api/ai-chat', async (req, res) => {
  const { page, message, context } = req.body || {}

  if (!message) {
    return res.json({
      code: 400,
      message: '请输入问题'
    })
  }

  if (!process.env.AI_API_KEY) {
    return res.json({
      code: 500,
      message: 'AI_API_KEY 未配置'
    })
  }

  try {
    const pageName = page === 'phone'
      ? '手机'
      : page === 'computer'
        ? '电脑'
        : '数码产品'

    const systemPrompt = `
你是一个专业的${pageName}选购助手。
你需要根据用户预算、用途、品牌偏好、配置需求，给出清晰、实用的推荐。
回答要适合普通用户理解，不要太长。
如果前端提供了设备列表 context，请优先基于这些设备推荐。
如果用户的问题信息不足，请主动说明还需要预算、用途、品牌偏好等信息。
`

    const aiResponse = await axios.post(
      process.env.AI_API_URL,
      {
        model: process.env.AI_MODEL,
        messages: [
          {
            role: 'system',
            content: systemPrompt
          },
          {
            role: 'user',
            content: JSON.stringify({
              userQuestion: message,
              page,
              context: context || []
            })
          }
        ],
        temperature: 0.7
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.AI_API_KEY}`,
          'Content-Type': 'application/json'
        },
        timeout: 30000
      }
    )

    const reply = aiResponse.data &&
      aiResponse.data.choices &&
      aiResponse.data.choices[0] &&
      aiResponse.data.choices[0].message &&
      aiResponse.data.choices[0].message.content
      ? aiResponse.data.choices[0].message.content
      : '暂时没有生成回答'

    res.json({
      code: 200,
      message: '请求成功',
      data: {
        reply
      },
      reply
    })
  } catch (error) {
    console.error('AI 接口错误：', error.response ? error.response.data : error.message)

    res.json({
      code: 500,
      message: 'AI 服务暂时不可用'
    })
  }
})

// =======================
// 手机型号模块
// =======================
app.get('/api/phone-models', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        id,
        brand,
        model,
        processor,
        battery,
        battery_value AS batteryValue,
        price,
        price_value AS priceValue,
        image,
        detail,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM phone_models
      ORDER BY id DESC
    `)

    res.json({
      code: 200,
      message: '获取手机型号成功',
      data: rows
    })
  } catch (error) {
    console.error('获取手机型号失败：', error)

    res.json({
      code: 500,
      message: '获取手机型号失败',
      data: []
    })
  }
})

app.get('/api/phone-models/by-name/:name', async (req, res) => {
  const { name } = req.params

  if (!name) {
    return res.json({
      code: 400,
      message: '手机名称不能为空',
      data: []
    })
  }

  try {
    const keyword = `%${name}%`

    const [rows] = await db.query(
      `
      SELECT
        id,
        brand,
        model,
        processor,
        battery,
        battery_value AS batteryValue,
        price,
        price_value AS priceValue,
        image,
        detail,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM phone_models
      WHERE 
        LOWER(REPLACE(model, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        OR LOWER(REPLACE(brand, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        OR LOWER(REPLACE(detail, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
      ORDER BY id DESC
      `,
      [keyword, keyword, keyword]
    )

    res.json({
      code: 200,
      message: '根据手机名称查询成功',
      data: rows
    })
  } catch (error) {
    console.error('根据手机名称查询失败：', error)

    res.json({
      code: 500,
      message: '根据手机名称查询失败',
      data: []
    })
  }
})

app.get('/api/phone-models/search/list', async (req, res) => {
  const { brand, keyword } = req.query

  try {
    let sql = `
      SELECT
        id,
        brand,
        model,
        processor,
        battery,
        battery_value AS batteryValue,
        price,
        price_value AS priceValue,
        image,
        detail,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM phone_models
      WHERE 1 = 1
    `

    const params = []

    if (brand) {
      sql += ' AND brand LIKE ?'
      params.push(`%${brand}%`)
    }

    if (keyword) {
      sql += ' AND (brand LIKE ? OR model LIKE ? OR processor LIKE ? OR detail LIKE ?)'
      params.push(
        `%${keyword}%`,
        `%${keyword}%`,
        `%${keyword}%`,
        `%${keyword}%`
      )
    }

    sql += ' ORDER BY id DESC'

    const [rows] = await db.query(sql, params)

    res.json({
      code: 200,
      message: '搜索手机型号成功',
      data: rows
    })
  } catch (error) {
    console.error('搜索手机型号失败：', error)

    res.json({
      code: 500,
      message: '搜索手机型号失败',
      data: []
    })
  }
})

// 注意：这个接口必须放在 by-name 和 search/list 后面
app.get('/api/phone-models/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      `
      SELECT
        id,
        brand,
        model,
        processor,
        battery,
        battery_value AS batteryValue,
        price,
        price_value AS priceValue,
        image,
        detail,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM phone_models
      WHERE id = ?
      `,
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '手机型号不存在'
      })
    }

    res.json({
      code: 200,
      message: '获取手机详情成功',
      data: rows[0]
    })
  } catch (error) {
    console.error('获取手机详情失败：', error)

    res.json({
      code: 500,
      message: '获取手机详情失败'
    })
  }
})

app.post('/api/phone-models', async (req, res) => {
  const {
    brand,
    model,
    processor,
    battery,
    batteryValue,
    price,
    priceValue,
    image,
    detail
  } = req.body || {}

  if (!brand || !model) {
    return res.json({
      code: 400,
      message: '品牌和型号不能为空'
    })
  }

  try {
    const [exists] = await db.query(
      'SELECT id FROM phone_models WHERE brand = ? AND model = ?',
      [brand, model]
    )

    if (exists.length > 0) {
      return res.json({
        code: 400,
        message: '该手机型号已存在'
      })
    }

    const [result] = await db.query(
      `
      INSERT INTO phone_models
      (
        brand,
        model,
        processor,
        battery,
        battery_value,
        price,
        price_value,
        image,
        detail
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        brand,
        model,
        processor || null,
        battery || null,
        batteryValue || 0,
        price || null,
        priceValue || 0,
        image || null,
        detail || null
      ]
    )

    res.json({
      code: 200,
      message: '新增手机型号成功',
      data: {
        id: result.insertId
      }
    })
  } catch (error) {
    console.error('新增手机型号失败：', error)

    res.json({
      code: 500,
      message: '新增手机型号失败',
      error: error.message
    })
  }
})

app.put('/api/phone-models/:id', async (req, res) => {
  const { id } = req.params

  const {
    brand,
    model,
    processor,
    battery,
    batteryValue,
    price,
    priceValue,
    image,
    detail
  } = req.body || {}

  if (!brand || !model) {
    return res.json({
      code: 400,
      message: '品牌和型号不能为空'
    })
  }

  try {
    const [phoneRows] = await db.query(
      'SELECT id FROM phone_models WHERE id = ?',
      [id]
    )

    if (phoneRows.length === 0) {
      return res.json({
        code: 404,
        message: '手机型号不存在'
      })
    }

    const [sameRows] = await db.query(
      'SELECT id FROM phone_models WHERE brand = ? AND model = ? AND id != ?',
      [brand, model, id]
    )

    if (sameRows.length > 0) {
      return res.json({
        code: 400,
        message: '该手机型号已存在'
      })
    }

    await db.query(
      `
      UPDATE phone_models
      SET
        brand = ?,
        model = ?,
        processor = ?,
        battery = ?,
        battery_value = ?,
        price = ?,
        price_value = ?,
        image = ?,
        detail = ?
      WHERE id = ?
      `,
      [
        brand,
        model,
        processor || null,
        battery || null,
        batteryValue || 0,
        price || null,
        priceValue || 0,
        image || null,
        detail || null,
        id
      ]
    )

    res.json({
      code: 200,
      message: '修改手机型号成功'
    })
  } catch (error) {
    console.error('修改手机型号失败：', error)

    res.json({
      code: 500,
      message: '修改手机型号失败',
      error: error.message
    })
  }
})

app.delete('/api/phone-models/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM phone_models WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '手机型号不存在'
      })
    }

    await db.query(
      'DELETE FROM phone_models WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '删除手机型号成功'
    })
  } catch (error) {
    console.error('删除手机型号失败：', error)

    res.json({
      code: 500,
      message: '删除手机型号失败',
      error: error.message
    })
  }
})

// =======================
// 点击统计接口
// 表：click_logs
// =======================

// 记录点击
// POST /api/clicks
app.post('/api/clicks', async (req, res) => {
  try {
    const { page, userId } = req.body || {}

    const ip =
      req.headers['x-forwarded-for'] ||
      req.socket.remoteAddress ||
      ''

    const userAgent = req.headers['user-agent'] || ''

    await db.query(
      `
      INSERT INTO click_logs
      (page, user_id, ip, user_agent)
      VALUES (?, ?, ?, ?)
      `,
      [
        page || 'unknown',
        userId || null,
        ip,
        userAgent
      ]
    )

    res.json({
      code: 200,
      message: '点击记录成功'
    })
  } catch (err) {
    console.error('记录点击失败：', err)

    res.status(500).json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// 获取每日点击人数
// GET /api/clicks/daily?days=7
app.get('/api/clicks/daily', async (req, res) => {
  try {
    let days = Number(req.query.days) || 7

    if (days < 1) {
      days = 7
    }

    if (days > 365) {
      days = 365
    }

    const [rows] = await db.query(`
      SELECT
        DATE_FORMAT(created_at, '%Y-%m-%d') AS date,
        COUNT(DISTINCT 
          IF(
            user_id IS NOT NULL,
            CONCAT('user_', user_id),
            CONCAT('ip_', ip)
          )
        ) AS count,
        COUNT(*) AS clickCount
      FROM click_logs
      WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ${days} DAY)
      GROUP BY DATE_FORMAT(created_at, '%Y-%m-%d')
      ORDER BY date ASC
    `)

    res.json({
      code: 200,
      message: '获取每日点击人数成功',
      data: rows
    })
  } catch (err) {
    console.error('获取每日点击人数失败：', err)

    res.status(500).json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})

// 获取每日总点击次数
// GET /api/clicks/daily-total?days=7
app.get('/api/clicks/daily-total', async (req, res) => {
  try {
    let days = Number(req.query.days) || 7

    if (days < 1) {
      days = 7
    }

    if (days > 365) {
      days = 365
    }

    const [rows] = await db.query(`
      SELECT
        DATE_FORMAT(created_at, '%Y-%m-%d') AS date,
        COUNT(*) AS count
      FROM click_logs
      WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ${days} DAY)
      GROUP BY DATE_FORMAT(created_at, '%Y-%m-%d')
      ORDER BY date ASC
    `)

    res.json({
      code: 200,
      message: '获取每日点击次数成功',
      data: rows
    })
  } catch (err) {
    console.error('获取每日点击次数失败：', err)

    res.status(500).json({
      code: 500,
      message: '服务器错误',
      error: err.message
    })
  }
})
// 系统日志表：system_logs
app.get('/api/system-logs', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        id,
        operator,
        module,
        action,
        status,
        level,
        ip,
        user_agent,
        detail,
        created_at
      FROM system_logs
      ORDER BY id DESC
      LIMIT 500
    `)

    res.json({
      code: 200,
      message: '查询成功',
      data: rows
    })
  } catch (err) {
    res.json({
      code: 500,
      message: '获取系统日志失败',
      error: err.message
    })
  }
})

async function recordSystemLog(req, log) {
  const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || ''
  const userAgent = req.headers['user-agent'] || ''

  await db.query(
    `
    INSERT INTO system_logs
    (operator, module, action, status, level, ip, user_agent, detail)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `,
    [
      log.operator || 'system',
      log.module || '系统',
      log.action || '系统操作',
      log.status || 'success',
      log.level || 'info',
      ip,
      userAgent,
      log.detail || ''
    ]
  )
}
// =======================
// 电脑型号模块
// 表：computer
// =======================

// 获取所有电脑型号
// GET /api/computer-models
app.get('/api/computer-models', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        id,
        brand,
        model,
        type,
        processor,
        graphics,
        memory,
        storage,
        price,
        price_value AS priceValue,
        accent,
        image,
        screen_size AS screenSize,
        resolution,
        refresh_rate AS refreshRate,
        weight,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM computer
      ORDER BY id DESC
    `)

    res.json({
      code: 200,
      message: '获取电脑型号成功',
      data: rows
    })
  } catch (error) {
    console.error('获取电脑型号失败：', error)

    res.json({
      code: 500,
      message: '获取电脑型号失败',
      data: []
    })
  }
})

// 搜索电脑型号
// GET /api/computer-models/search/list?keyword=MacBook
// GET /api/computer-models/search/list?brand=华为
app.get('/api/computer-models/search/list', async (req, res) => {
  const { brand, keyword, type } = req.query

  try {
    let sql = `
      SELECT
        id,
        brand,
        model,
        type,
        processor,
        graphics,
        memory,
        storage,
        price,
        price_value AS priceValue,
        accent,
        image,
        screen_size AS screenSize,
        resolution,
        refresh_rate AS refreshRate,
        weight,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM computer
      WHERE 1 = 1
    `

    const params = []

    if (brand) {
      sql += ' AND brand LIKE ?'
      params.push(`%${brand}%`)
    }

    if (type) {
      sql += ' AND type LIKE ?'
      params.push(`%${type}%`)
    }

    if (keyword) {
      sql += `
        AND (
          brand LIKE ?
          OR model LIKE ?
          OR type LIKE ?
          OR processor LIKE ?
          OR graphics LIKE ?
          OR memory LIKE ?
          OR storage LIKE ?
        )
      `
      params.push(
        `%${keyword}%`,
        `%${keyword}%`,
        `%${keyword}%`,
        `%${keyword}%`,
        `%${keyword}%`,
        `%${keyword}%`,
        `%${keyword}%`
      )
    }

    sql += ' ORDER BY id DESC'

    const [rows] = await db.query(sql, params)

    res.json({
      code: 200,
      message: '搜索电脑型号成功',
      data: rows
    })
  } catch (error) {
    console.error('搜索电脑型号失败：', error)

    res.json({
      code: 500,
      message: '搜索电脑型号失败',
      data: []
    })
  }
})

// 根据电脑名称查询
// GET /api/computer-models/by-name/:name
app.get('/api/computer-models/by-name/:name', async (req, res) => {
  const { name } = req.params

  if (!name) {
    return res.json({
      code: 400,
      message: '电脑名称不能为空',
      data: []
    })
  }

  try {
    const keyword = `%${name}%`

    const [rows] = await db.query(
      `
      SELECT
        id,
        brand,
        model,
        type,
        processor,
        graphics,
        memory,
        storage,
        price,
        price_value AS priceValue,
        accent,
        image,
        screen_size AS screenSize,
        resolution,
        refresh_rate AS refreshRate,
        weight,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM computer
      WHERE
        LOWER(REPLACE(model, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        OR LOWER(REPLACE(brand, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        OR LOWER(REPLACE(processor, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
        OR LOWER(REPLACE(graphics, ' ', '')) LIKE LOWER(REPLACE(?, ' ', ''))
      ORDER BY id DESC
      `,
      [keyword, keyword, keyword, keyword]
    )

    res.json({
      code: 200,
      message: '根据电脑名称查询成功',
      data: rows
    })
  } catch (error) {
    console.error('根据电脑名称查询失败：', error)

    res.json({
      code: 500,
      message: '根据电脑名称查询失败',
      data: []
    })
  }
})

// 根据 ID 获取电脑详情
// 注意：这个接口必须放在 by-name 和 search/list 后面
// GET /api/computer-models/:id
app.get('/api/computer-models/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      `
      SELECT
        id,
        brand,
        model,
        type,
        processor,
        graphics,
        memory,
        storage,
        price,
        price_value AS priceValue,
        accent,
        image,
        screen_size AS screenSize,
        resolution,
        refresh_rate AS refreshRate,
        weight,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM computer
      WHERE id = ?
      `,
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '电脑型号不存在'
      })
    }

    res.json({
      code: 200,
      message: '获取电脑详情成功',
      data: rows[0]
    })
  } catch (error) {
    console.error('获取电脑详情失败：', error)

    res.json({
      code: 500,
      message: '获取电脑详情失败'
    })
  }
})

// 新增电脑型号
// POST /api/computer-models
app.post('/api/computer-models', async (req, res) => {
  const {
    brand,
    model,
    type,
    processor,
    graphics,
    memory,
    storage,
    price,
    priceValue,
    accent,
    image,
    screenSize,
    resolution,
    refreshRate,
    weight
  } = req.body || {}

  if (!brand || !model) {
    return res.json({
      code: 400,
      message: '品牌和型号不能为空'
    })
  }

  try {
    const [exists] = await db.query(
      'SELECT id FROM computer WHERE brand = ? AND model = ?',
      [brand, model]
    )

    if (exists.length > 0) {
      return res.json({
        code: 400,
        message: '该电脑型号已存在'
      })
    }

    const [result] = await db.query(
      `
      INSERT INTO computer
      (
        brand,
        model,
        type,
        processor,
        graphics,
        memory,
        storage,
        price,
        price_value,
        accent,
        image,
        screen_size,
        resolution,
        refresh_rate,
        weight
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        brand,
        model,
        type || null,
        processor || null,
        graphics || null,
        memory || null,
        storage || null,
        price || null,
        priceValue || null,
        accent || null,
        image || null,
        screenSize || null,
        resolution || null,
        refreshRate || null,
        weight || null
      ]
    )

    res.json({
      code: 200,
      message: '新增电脑型号成功',
      data: {
        id: result.insertId
      }
    })
  } catch (error) {
    console.error('新增电脑型号失败：', error)

    res.json({
      code: 500,
      message: '新增电脑型号失败',
      error: error.message
    })
  }
})

// 修改电脑型号
// PUT /api/computer-models/:id
app.put('/api/computer-models/:id', async (req, res) => {
  const { id } = req.params

  const {
    brand,
    model,
    type,
    processor,
    graphics,
    memory,
    storage,
    price,
    priceValue,
    accent,
    image,
    screenSize,
    resolution,
    refreshRate,
    weight
  } = req.body || {}

  if (!brand || !model) {
    return res.json({
      code: 400,
      message: '品牌和型号不能为空'
    })
  }

  try {
    const [computerRows] = await db.query(
      'SELECT id FROM computer WHERE id = ?',
      [id]
    )

    if (computerRows.length === 0) {
      return res.json({
        code: 404,
        message: '电脑型号不存在'
      })
    }

    const [sameRows] = await db.query(
      'SELECT id FROM computer WHERE brand = ? AND model = ? AND id != ?',
      [brand, model, id]
    )

    if (sameRows.length > 0) {
      return res.json({
        code: 400,
        message: '该电脑型号已存在'
      })
    }

    await db.query(
      `
      UPDATE computer
      SET
        brand = ?,
        model = ?,
        type = ?,
        processor = ?,
        graphics = ?,
        memory = ?,
        storage = ?,
        price = ?,
        price_value = ?,
        accent = ?,
        image = ?,
        screen_size = ?,
        resolution = ?,
        refresh_rate = ?,
        weight = ?
      WHERE id = ?
      `,
      [
        brand,
        model,
        type || null,
        processor || null,
        graphics || null,
        memory || null,
        storage || null,
        price || null,
        priceValue || null,
        accent || null,
        image || null,
        screenSize || null,
        resolution || null,
        refreshRate || null,
        weight || null,
        id
      ]
    )

    res.json({
      code: 200,
      message: '修改电脑型号成功'
    })
  } catch (error) {
    console.error('修改电脑型号失败：', error)

    res.json({
      code: 500,
      message: '修改电脑型号失败',
      error: error.message
    })
  }
})

// 删除电脑型号
// DELETE /api/computer-models/:id
app.delete('/api/computer-models/:id', async (req, res) => {
  const { id } = req.params

  try {
    const [rows] = await db.query(
      'SELECT id FROM computer WHERE id = ?',
      [id]
    )

    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '电脑型号不存在'
      })
    }

    await db.query(
      'DELETE FROM computer WHERE id = ?',
      [id]
    )

    res.json({
      code: 200,
      message: '删除电脑型号成功'
    })
  } catch (error) {
    console.error('删除电脑型号失败：', error)

    res.json({
      code: 500,
      message: '删除电脑型号失败',
      error: error.message
    })
  }
})
// =======================
// 404 处理
// =======================
app.use((req, res) => {
  res.status(404).json({
    code: 404,
    message: '接口不存在',
    path: req.originalUrl
  })
})

// =======================
// 启动服务
// =======================
app.listen(3000, '0.0.0.0', () => {
  console.log('后端运行在 http://0.0.0.0:3000')
})