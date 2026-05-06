import { createRouter, createWebHashHistory } from "vue-router";
import Hello from "@/components/Hello.vue";

const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/hello',
            component: Hello
        }
    ]
})
export default router