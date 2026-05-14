import axios from "axios";

const http = axios.create({
    baseURL: 'http://154.12.39.76:3000/api'
})
export default http