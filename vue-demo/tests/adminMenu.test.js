const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const { test } = require('node:test')

const adminSource = fs.readFileSync(
  path.join(__dirname, '../src/components/manager/Admin.vue'),
  'utf8'
)

test('admin sidebar exposes phone and computer under a third-level device info menu without tablet', () => {
  assert.match(adminSource, /v-if="child\.children && child\.children\.length"/)
  assert.match(adminSource, /key:\s*'device-info'/)
  assert.match(adminSource, /key:\s*'device-phone'/)
  assert.match(adminSource, /key:\s*'device-computer'/)
  assert.doesNotMatch(adminSource, /key:\s*'device-tablet'|key:\s*'tablet'|平板/)
})
