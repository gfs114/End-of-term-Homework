<template>
    <section class="device-category-page">
        <el-card class="device-category-card" shadow="never">
            <template #header>
                <div class="page-header">
                    <div>
                        <h2>设备分类信息</h2>
                    </div>
                </div>
            </template>

            <el-table
                :data="categoryList"
                border
                stripe
                class="category-table"
                empty-text="暂无设备分类"
            >
                <el-table-column prop="name" label="分类名称" min-width="160">
                    <template #default="{ row }">
                        <strong>{{ row.name }}</strong>
                    </template>
                </el-table-column>
                <el-table-column prop="type" label="分类标识" min-width="140" />
                <el-table-column prop="description" label="分类说明" min-width="260" />
                <el-table-column prop="status" label="状态" width="120" align="center">
                    <template #default="{ row }">
                        <el-tag type="success" effect="plain">{{ row.status }}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="操作" width="130" fixed="right" align="center">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="goCategory(row.path)">
                            查看
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-card>
    </section>
</template>

<script>
export default {
    name: 'DeviceCategoryInfo',
    data() {
        return {
            categoryList: [
                {
                    name: '手机',
                    type: 'phone',
                    description: '手机专区设备分类',
                    status: '启用',
                    path: '/phone'
                },
                {
                    name: '电脑',
                    type: 'computer',
                    description: '电脑专区设备分类',
                    status: '启用',
                    path: '/computer'
                }
            ]
        }
    },
    methods: {
        goCategory(path) {
            this.$router.push(path)
        }
    }
}
</script>

<style scoped>
.device-category-page {
    min-height: 100%;
}

.device-category-card {
    min-height: calc(100vh - 36px);
    border: 1px solid #ebeef5;
    border-radius: 8px;
}

.page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
}

.page-header h2 {
    margin: 0;
    color: #111827;
    font-size: 18px;
}

.category-table {
    width: 100%;
}
</style>
