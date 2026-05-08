import axios from "axios";

const http = axios.create({
    baseURL: 'http://8.145.39.9:8080/takeouts'
})
export default http