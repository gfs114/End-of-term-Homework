import axios from "axios";

// 项目统一的接口请求实例，集中维护后端地址和超时时间。
const http = axios.create({
    baseURL: 'http://localhost:3000/api',
    timeout: 80000
})
export default http
