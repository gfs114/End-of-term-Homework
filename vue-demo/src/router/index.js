import { createRouter, createWebHashHistory } from "vue-router";
import Hello from "@/components/Hello.vue";
import Login from "@/components/Login.vue";
import Register from "@/components/Register.vue";

const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/hello',
            component: Hello
        },
        {
            path: '/login',
            component: Login
        },
        {
            path: '/register',
            component: Register
        }
    ]
})
export default router
