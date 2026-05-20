import { createRouter, createWebHashHistory } from "vue-router";
import Hello from "@/components/Hello.vue";
import Login from "@/components/Login.vue";
import Register from "@/components/Register.vue";
import AdminLogin from "@/components/manager/AdminLogin.vue";
import ForgetPassword from "@/components/ForgetPassword.vue";
import Phone from "@/components/Phone.vue";
import Computer from "@/components/Computer.vue";
import Admin from "@/components/manager/Admin.vue";
import Mine from "@/components/Mine.vue";

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
        },
        {
            path: '/computer',
            component: Computer
        },
        {
            path: '/mine',
            component: Mine
        },
        {
            path:'/alogin/admin',
            component:Admin
        },
        {
            name:'404',
            path:'/:catchAll(.*)',
            component: () => import('@/components/NotFound.vue')
        },
        {
            path:'/',
            redirect:'/hello'
        }
    ]
})
export default router
