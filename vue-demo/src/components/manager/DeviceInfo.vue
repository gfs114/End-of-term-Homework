<template>
    <section class="device-info-page">
        <el-card class="device-info-card" shadow="never">
            <template #header>
                <div class="page-header">
                    <div>
                        <h2>设备信息</h2>
                        <p>数据来源：手机专区 Phone.vue</p>
                    </div>
                    <el-input
                        v-model.trim="keyword"
                        class="search-input"
                        clearable
                        placeholder="搜索品牌、型号或处理器"
                    />
                </div>
            </template>

            <el-table
                :data="filteredDevices"
                border
                stripe
                class="device-table"
                empty-text="暂无设备数据"
            >
                <el-table-column label="图片" width="96" align="center">
                    <template #default="{ row }">
                        <img v-if="row.image" class="device-image" :src="row.image" :alt="row.model" />
                        <span v-else>-</span>
                    </template>
                </el-table-column>
                <el-table-column prop="brand" label="品牌" min-width="120" sortable />
                <el-table-column prop="model" label="型号" min-width="220" />
                <el-table-column prop="processor" label="处理器" min-width="180" />
                <el-table-column prop="battery" label="电池" min-width="120" />
                <el-table-column prop="price" label="价格" min-width="120" sortable />
            </el-table>
        </el-card>
    </section>
</template>

<script>
import PhonePage from '@/components/Phone.vue'

export default {
    name: 'DeviceInfo',
    data() {
        const phoneData = typeof PhonePage.data === 'function' ? PhonePage.data() : {}

        return {
            keyword: '',
            devices: Array.isArray(phoneData.phoneModels) ? phoneData.phoneModels : []
        }
    },
    computed: {
        filteredDevices() {
            const keyword = this.keyword.toLowerCase()

            if (!keyword) {
                return this.devices
            }

            return this.devices.filter((device) => {
                return [
                    device.brand,
                    device.model,
                    device.processor,
                    device.battery,
                    device.price
                ].some((value) => String(value || '').toLowerCase().includes(keyword))
            })
        }
    }
}
</script>

<style scoped>
.device-info-page {
    min-height: 100%;
}

.device-info-card {
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

.page-header p {
    margin: 6px 0 0;
    color: #64748b;
    font-size: 13px;
}

.search-input {
    width: min(320px, 100%);
}

.device-table {
    width: 100%;
}

.device-image {
    display: block;
    width: 58px;
    height: 58px;
    object-fit: contain;
    margin: 0 auto;
}

@media (max-width: 720px) {
    .page-header {
        align-items: stretch;
        flex-direction: column;
    }

    .search-input {
        width: 100%;
    }
}
</style>
