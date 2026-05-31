import { createRouter, createWebHashHistory } from "vue-router";
import Hello from "@/components/Hello.vue";
import Login from "@/components/Login.vue";
import Register from "@/components/Register.vue";
import AdminLogin from "@/components/manager/AdminLogin.vue";
import ForgetPassword from "@/components/ForgetPassword.vue";
import Phone from "@/components/Phone.vue";
import Computer from "@/components/Computer.vue";
import Admin from "@/components/manager/Admin.vue";
import AdminInfo from "@/components/manager/AdminInfo.vue";
import UserInfo from "@/components/manager/UserInfo.vue";
import ArticleFavoriteInfo from "@/components/articles/ArticleFavoriteInfo.vue";
import ArticleInfo from "@/components/manager/ArticleInfo.vue";
import DeviceInfo from "@/components/manager/DeviceInfo.vue";
import DeviceComputerInfo from "@/components/manager/DeviceComputerInfo.vue";
import SystemLog from "@/components/manager/SystemLog.vue";
import AuthorInfo from "@/components/manager/AuthorInfo.vue";
import DeviceCategoryInfo from "@/components/manager/DeviceCategoryInfo.vue";
import Mine from "@/components/Mine.vue";
import ArticleDetail from "@/components/articles/ArticleDetail.vue";
import ArticleSubmit from "@/components/articles/ArticleSubmit.vue";

const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/',
            redirect: '/hello'
        },
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
            path: '/submit',
            component: ArticleSubmit
        },
        {
            path: '/alogin/admin',
            component: Admin,
            redirect: '/alogin/admin/user-info',
            children: [
                {
                    path: 'system-log',
                    name: 'admin-system-log',
                    component: SystemLog
                },
                {
                    path: 'device-category',
                    name: 'admin-device-category',
                    component: DeviceCategoryInfo
                },
                {
                    path: 'device-phone',
                    name: 'admin-device-phone',
                    component: DeviceInfo
                },
                {
                    path: 'device-computer',
                    name: 'admin-device-computer',
                    component: DeviceComputerInfo
                },
                {
                    path: 'article-info',
                    name: 'admin-article-info',
                    component: ArticleInfo
                },
                {
                    path: 'article-favorite',
                    name: 'admin-article-favorite',
                    component: ArticleFavoriteInfo
                },
                {
                    path: 'admin-info',
                    name: 'admin-admin-info',
                    component: AdminInfo
                },
                {
                    path: 'author-info',
                    name: 'admin-author-info',
                    component: AuthorInfo
                },
                {
                    path: 'user-info',
                    name: 'admin-user-info',
                    component: UserInfo
                }
            ]
        },
        {
            path: '/article/:id',
            component: ArticleDetail
        },
        {
            name:'404',
            path:'/:catchAll(.*)',
            component: () => import('@/components/NotFound.vue')
        }
    ]
})
export default router
