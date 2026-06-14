const mysql = require('mysql2')

const db = mysql.createPool({
  host: 'localhost',
  user: 'shop_user',
  password: '123456',
  database: 'device_db'
})

module.exports = db.promise()
