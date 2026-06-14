const { defineConfig } = require('@vue/cli-service')
const path = require('path')

module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  productionSourceMap: false,
  publicPath: '/End-of-term-Homework/',
  configureWebpack: {
    resolve: {
      alias: {
        '/assets/shader-worker-CJN-6C3l.js': path.resolve(__dirname, 'node_modules/@wxperia/liquid-glass-vue/dist/assets/shader-worker-CJN-6C3l.js')
      }
    }
  },
  chainWebpack: config => {
    config.module
      .rule('m4a')
      .test(/\.m4a$/)
      .type('asset/resource')
  },
  devServer: {
    client: {
      overlay: false,
    },
  },
})
