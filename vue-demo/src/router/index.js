import { createRouter, createWebHashHistory } from "vue-router";
import Hello from "@/components/Hello.vue";
import Login from "@/components/Login.vue";
import Register from "@/components/Register.vue";
import AdminLogin from "@/components/AdminLogin.vue";
import ForgetPassword from "@/components/ForgetPassword.vue";
import Phone from "@/components/Phone.vue";

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
        },
        {
            path: '/alogin',
            component: AdminLogin
        },
        {
            path: '/forget',
            component: ForgetPassword
        },
        {
            path: '/phone',
            component: Phone
        }
    ]
})
export default router
