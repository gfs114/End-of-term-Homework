<template>
    <section class="admin-page">
        <aside :class="['admin-sidebar', { collapsed: isCollapsed }]">
            <div class="admin-brand">
                <div class="brand-title">
                    <span class="brand-icon">A</span>
                    <strong v-if="!isCollapsed">后台管理系统</strong>
                </div>
                <el-button text class="sidebar-toggle" @click="toggleCollapse">
                    <el-icon>
                        <Fold v-if="!isCollapsed" />
                        <Expand v-else />
                    </el-icon>
                </el-button>
            </div>

            <el-menu class="admin-menu" :collapse="isCollapsed" :default-active="activeMenuKey"
                background-color="#111827" text-color="#cbd5e1" active-text-color="#ffffff" unique-opened
                @select="handleMenuSelect">
                <template v-for="menu in menus" :key="menu.key">
                    <el-sub-menu v-if="menu.children && menu.children.length" :index="menu.key">
                        <template #title>
                            <el-icon>
                                <component :is="menu.icon" />
                            </el-icon>
                            <span>{{ menu.title }}</span>
                        </template>

                        <template v-for="child in menu.children" :key="child.key">
                            <el-sub-menu v-if="child.children && child.children.length" :index="child.key">
                                <template #title>
                                    <el-icon>
                                        <component :is="child.icon" />
                                    </el-icon>
                                    <span>{{ child.title }}</span>
                                </template>

                                <el-menu-item v-for="grandchild in child.children" :key="grandchild.key"
                                    :index="grandchild.key">
                                    <el-icon>
                                        <component :is="grandchild.icon" />
                                    </el-icon>
                                    <span>{{ grandchild.title }}</span>
                                </el-menu-item>
                            </el-sub-menu>

                            <el-menu-item v-else :index="child.key">
                                <el-icon>
                                    <component :is="child.icon" />
                                </el-icon>
                                <span>{{ child.title }}</span>
                            </el-menu-item>
                        </template>
                    </el-sub-menu>

                    <el-menu-item v-else :index="menu.key">
                        <el-icon>
                            <component :is="menu.icon" />
                        </el-icon>
                        <span>{{ menu.title }}</span>
                    </el-menu-item>
                </template>
            </el-menu>

            <div class="sidebar-footer">
                <el-button class="client-button" text @click="goUserClient">
                    <el-icon>
                        <House />
                    </el-icon>
                    <span v-if="!isCollapsed">返回用户端</span>
                </el-button>
            </div>
        </aside>

        <main class="admin-main">
            <section class="admin-content">
                <router-view />
            </section>
        </main>
    </section>
</template>

<script>
export default {
    name: 'AdminPage',
    data() {
        return {
            isCollapsed: false,
            activeMenuKey: 'user-info',
            menuRouteMap: {
                'system-log': '/alogin/admin/system-log',
                'device-category': '/alogin/admin/device-category',
                'device-phone': '/alogin/admin/device-phone',
                'device-computer': '/alogin/admin/device-computer',
                'article-favorite': '/alogin/admin/article-favorite',
                'admin-info': '/alogin/admin/admin-info',
                'author-info': '/alogin/admin/author-info',
                'user-info': '/alogin/admin/user-info'
            },
            menus: [
                {
                    key: 'system-log',
                    title: '系统日志',
                    icon: 'Document'
                },
                {
                    key: 'device-manage',
                    title: '设备信息管理',
                    icon: 'Monitor',
                    children: [
                        {
                            key: 'device-category',
                            title: '设备分类信息',
                            icon: 'Collection'
                        },
                        {
                            key: 'device-info',
                            title: '设备信息',
                            icon: 'Cpu',
                            children: [
                                {
                                    key: 'device-phone',
                                    title: '手机',
                                    icon: 'Iphone'
                                },
                                {
                                    key: 'device-computer',
                                    title: '电脑',
                                    icon: 'Monitor'
                                }
                            ]
                        }
                    ]
                },
                {
                    key: 'article-manage',
                    title: '文章管理',
                    icon: 'Reading',
                    children: [
                        {
                            key: 'article-favorite',
                            title: '文章收藏信息',
                            icon: 'Star'
                        }
                    ]
                },
                {
                    key: 'role-manage',
                    title: '角色管理',
                    icon: 'UserFilled',
                    children: [
                        {
                            key: 'admin-info',
                            title: '管理员信息',
                            icon: 'Avatar'
                        },
                        {
                            key: 'author-info',
                            title: '作者信息',
                            icon: 'EditPen'
                        },
                        {
                            key: 'user-info',
                            title: '用户信息',
                            icon: 'User'
                        }
                    ]
                }
            ]
        }
    },
    watch: {
        '$route'() {
            this.syncActiveMenuByRoute()
        }
    },
    created() {
        this.syncActiveMenuByRoute()
    },
    methods: {
        toggleCollapse() {
            this.isCollapsed = !this.isCollapsed
        },
        handleMenuSelect(key) {
            const routePath = this.menuRouteMap[key]

            if (!routePath) {
                this.activeMenuKey = key
                return
            }

            if (this.$route.path !== routePath) {
                this.$router.push(routePath)
                return
            }

            this.activeMenuKey = key
        },
        goUserClient() {
            this.$router.push('/hello')
        },
        syncActiveMenuByRoute() {
            const activeMenuKey = Object.keys(this.menuRouteMap).find((key) => {
                return this.menuRouteMap[key] === this.$route.path
            })

            if (activeMenuKey) {
                this.activeMenuKey = activeMenuKey
            }
        }
    }
}
</script>

<style scoped>
.admin-page {
    display: flex;
    width: calc(100% + 48px);
    min-height: 100vh;
    margin: -24px;
    overflow: hidden;
    background: #f3f4f6;
}

.admin-sidebar {
    position: sticky;
    top: 0;
    flex: 0 0 232px;
    width: 232px;
    height: 100vh;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
    background: #111827;
    transition: width 0.2s ease, flex-basis 0.2s ease;
}

.admin-sidebar.collapsed {
    flex-basis: 64px;
    width: 64px;
}

.admin-brand {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    height: 60px;
    padding: 0 12px 0 18px;
    color: #fff;
    border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    white-space: nowrap;
}

.brand-title {
    display: flex;
    align-items: center;
    gap: 10px;
    min-width: 0;
}

.brand-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    border-radius: 8px;
    background: #2563eb;
    color: #fff;
    font-weight: 700;
}

.sidebar-toggle {
    width: 32px;
    height: 32px;
    padding: 0;
    color: #cbd5e1;
}

.sidebar-toggle:hover {
    color: #fff;
    background: rgba(255, 255, 255, 0.08);
}

.admin-menu {
    flex: 1;
    border-right: 0;
}

.sidebar-footer {
    padding: 12px;
    border-top: 1px solid rgba(255, 255, 255, 0.06);
}

.client-button {
    width: 100%;
    height: 38px;
    justify-content: flex-start;
    gap: 8px;
    padding: 0 12px;
    color: #cbd5e1;
    border-radius: 6px;
}

.client-button:hover {
    color: #fff;
    background: rgba(255, 255, 255, 0.08);
}

.admin-sidebar.collapsed .client-button {
    justify-content: center;
    padding: 0;
}

.admin-main {
    flex: 1;
    min-width: 0;
    height: 100vh;
    display: flex;
    flex-direction: column;
    overflow: auto;
}

.admin-content {
    flex: 1;
    width: 100%;
    min-width: 0;
    padding: 18px;
    box-sizing: border-box;
}

.overview-card {
    min-height: calc(100vh - 36px);
    border: 1px solid #ebeef5;
    border-radius: 8px;
    background: #fff;
}

.overview-card :deep(.el-card__header) {
    border-bottom: 1px solid #eef0f3;
}

.overview-card :deep(.el-card__body) {
    padding: 24px;
}

.card-header {
    color: #111827;
}

.card-header span {
    font-size: 16px;
    font-weight: 700;
}

.placeholder-body {
    min-height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
}

@media (max-width: 820px) {
    .admin-page {
        width: calc(100% + 48px);
        min-height: 100vh;
    }

    .admin-sidebar {
        flex-basis: 64px;
        width: 64px;
    }

    .admin-brand strong {
        display: none;
    }

    .admin-content {
        padding: 12px;
    }

    .overview-card {
        min-height: calc(100vh - 24px);
    }
}
</style>

