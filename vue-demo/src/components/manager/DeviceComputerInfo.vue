<template>
    <section class="device-info-page">
        <el-card class="device-info-card" shadow="never">
            <template #header>
                <div class="page-header">
                    <div>
                        <h2>电脑设备信息管理</h2>
                    </div>

                    <div class="header-actions">
                        <el-input v-model.trim="keyword" class="search-input" clearable placeholder="搜索品牌、型号、处理器或显卡"
                            @clear="fetchDeviceList" @keyup.enter="handleSearch" />
                        <el-button @click="handleSearch">搜索</el-button>
                        <el-button type="primary" @click="openCreateDialog">新增电脑</el-button>
                    </div>
                </div>
            </template>

            <el-table v-loading="tableLoading" :data="paginatedDeviceList" border stripe class="device-table"
                empty-text="暂无电脑设备数据">
                <el-table-column label="图片" width="96" align="center">
                    <template #default="{ row }">
                        <img v-if="row.image" class="device-image" :src="getComputerImage(row.image)"
                            :alt="row.model" />
                        <span v-else>-</span>
                    </template>
                </el-table-column>
                <el-table-column prop="brand" label="品牌" min-width="110" sortable />
                <el-table-column prop="model" label="型号" min-width="220" show-overflow-tooltip />
                <el-table-column prop="type" label="类型" min-width="100" sortable />
                <el-table-column prop="processor" label="处理器" min-width="180" show-overflow-tooltip />
                <el-table-column prop="graphics" label="显卡" min-width="160" show-overflow-tooltip />
                <el-table-column prop="memory" label="内存" min-width="100" />
                <el-table-column prop="storage" label="硬盘" min-width="120" />
                <el-table-column prop="price" label="价格" min-width="120" />
                <el-table-column prop="priceValue" label="价格数值" width="110" sortable />
                <el-table-column prop="screenSize" label="屏幕尺寸" min-width="120" />
                <el-table-column prop="resolution" label="分辨率" min-width="160" show-overflow-tooltip />
                <el-table-column prop="refreshRate" label="刷新率" min-width="100" />
                <el-table-column prop="weight" label="重量" min-width="110" />
                <el-table-column prop="status" label="状态" width="100" align="center">
                    <template #default="{ row }">
                        <el-tag :type="getStatusTagType(row.status)" effect="light">
                            {{ getStatusLabel(row.status) }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column prop="image" label="图片文件名" min-width="190" show-overflow-tooltip />
                <el-table-column label="操作" width="220" fixed="right" align="center">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="openEditDialog(row)">编辑</el-button>
                        <el-button :type="isDeviceUnlisted(row.status) ? 'success' : 'warning'" link
                            :loading="statusLoadingId === row.id" @click="handleToggleStatus(row)">
                            {{ isDeviceUnlisted(row.status) ? '上架' : '下架' }}
                        </el-button>
                        <el-button type="danger" link :loading="deleteLoadingId === row.id" @click="handleDelete(row)">
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>

            <div v-if="deviceList.length > pageSize" class="pagination-bar">
                <el-pagination background layout="total, prev, pager, next, jumper" :current-page="currentPage"
                    :page-size="pageSize" :total="deviceList.length" @current-change="handleCurrentPageChange" />
            </div>
        </el-card>

        <el-dialog v-model="dialogVisible" :title="dialogMode === 'create' ? '新增电脑' : '编辑电脑'" width="720px"
            :close-on-click-modal="false" :before-close="handleDialogBeforeClose">
            <el-form ref="deviceForm" :model="form" :rules="rules" label-width="108px" class="device-form">
                <el-form-item label="品牌" prop="brand">
                    <el-input v-model.trim="form.brand" placeholder="例如：联想、华为、Apple" maxlength="50" />
                </el-form-item>
                <el-form-item label="型号" prop="model">
                    <el-input v-model.trim="form.model" placeholder="例如：ThinkPad X1 Carbon" maxlength="120" />
                </el-form-item>
                <el-form-item label="类型" prop="type">
                    <el-input v-model.trim="form.type" placeholder="例如：轻薄本、游戏本、商务本" maxlength="50" />
                </el-form-item>
                <el-form-item label="处理器" prop="processor">
                    <el-input v-model.trim="form.processor" placeholder="例如：酷睿 Ultra 7-255H" maxlength="120" />
                </el-form-item>
                <el-form-item label="显卡" prop="graphics">
                    <el-input v-model.trim="form.graphics" placeholder="例如：RTX 4060、Intel Arc 核显" maxlength="120" />
                </el-form-item>
                <el-form-item label="内存" prop="memory">
                    <el-input v-model.trim="form.memory" placeholder="例如：16GB" maxlength="50" />
                </el-form-item>
                <el-form-item label="硬盘" prop="storage">
                    <el-input v-model.trim="form.storage" placeholder="例如：1TB SSD" maxlength="80" />
                </el-form-item>
                <el-form-item label="价格文本" prop="price">
                    <el-input v-model.trim="form.price" placeholder="例如：¥8999 起" maxlength="50" />
                </el-form-item>
                <el-form-item label="价格数值" prop="priceValue">
                    <el-input-number v-model="form.priceValue" :min="0" :max="999999" controls-position="right" />
                </el-form-item>
                <el-form-item label="主题色" prop="accent">
                    <el-input v-model.trim="form.accent" placeholder="例如：#2563eb" maxlength="30" />
                </el-form-item>
                <el-form-item label="图片文件" prop="image">
                    <el-input v-model.trim="form.image" placeholder="例如：MacBook Air M3.png" maxlength="255" />
                </el-form-item>
                <el-form-item label="屏幕尺寸" prop="screenSize">
                    <el-input v-model.trim="form.screenSize" placeholder="例如：14英寸" maxlength="50" />
                </el-form-item>
                <el-form-item label="分辨率" prop="resolution">
                    <el-input v-model.trim="form.resolution" placeholder="例如：2880x1800" maxlength="80" />
                </el-form-item>
                <el-form-item label="刷新率" prop="refreshRate">
                    <el-input v-model.trim="form.refreshRate" placeholder="例如：120Hz" maxlength="50" />
                </el-form-item>
                <el-form-item label="重量" prop="weight">
                    <el-input v-model.trim="form.weight" placeholder="例如：约1.3Kg" maxlength="50" />
                </el-form-item>
            </el-form>

            <template #footer>
                <div class="dialog-footer">
                    <el-button :disabled="submitLoading" @click="closeDialog">取消</el-button>
                    <el-button type="primary" :loading="submitLoading" @click="handleSubmit">保存</el-button>
                </div>
            </template>
        </el-dialog>
    </section>
</template>

<script>
import http from '@/utils/http'

export default {
    name: 'DeviceComputerInfo',
    data() {
        return {
            keyword: '',
            deviceList: [],
            currentPage: 1,
            pageSize: 20,
            tableLoading: false,
            submitLoading: false,
            deleteLoadingId: null,
            statusLoadingId: null,
            dialogVisible: false,
            dialogMode: 'create',
            currentId: null,
            imageCache: {},
            form: this.getEmptyForm(),
            rules: {
                brand: [
                    { required: true, message: '请输入品牌', trigger: 'blur' }
                ],
                model: [
                    { required: true, message: '请输入型号', trigger: 'blur' }
                ],
                type: [
                    { required: true, message: '请输入类型', trigger: 'blur' }
                ],
                processor: [
                    { required: true, message: '请输入处理器', trigger: 'blur' }
                ],
                graphics: [
                    { required: true, message: '请输入显卡', trigger: 'blur' }
                ],
                memory: [
                    { required: true, message: '请输入内存', trigger: 'blur' }
                ],
                storage: [
                    { required: true, message: '请输入硬盘', trigger: 'blur' }
                ],
                price: [
                    { required: true, message: '请输入价格文本', trigger: 'blur' }
                ],
                priceValue: [
                    { required: true, message: '请输入价格数值', trigger: 'change' }
                ],
                image: [
                    { required: true, message: '请输入图片文件名', trigger: 'blur' }
                ]
            }
        }
    },
    created() {
        this.fetchDeviceList()
    },
    computed: {
        paginatedDeviceList() {
            const start = (this.currentPage - 1) * this.pageSize
            const end = start + this.pageSize

            return this.deviceList.slice(start, end)
        }
    },
    methods: {
        fetchDeviceList() {
            this.tableLoading = true

            http.get('/computer-models/search/list')
                .then((response) => {
                    const list = this.getResponseList(response.data)
                    this.deviceList = this.sortByIdAsc(list.map(this.normalizeDevice))
                    this.currentPage = 1
                })
                .catch(() => {
                    this.$message.error('获取电脑列表失败')
                })
                .finally(() => {
                    this.tableLoading = false
                })
        },
        handleSearch() {
            if (!this.keyword) {
                this.fetchDeviceList()
                return
            }

            this.tableLoading = true

            http.get('/computer-models/search/list', {
                params: {
                    keyword: this.keyword
                }
            })
                .then((response) => {
                    const list = this.getResponseList(response.data)
                    this.deviceList = this.sortByIdAsc(list.map(this.normalizeDevice))
                    this.currentPage = 1
                })
                .catch(() => {
                    this.$message.error('搜索电脑失败')
                })
                .finally(() => {
                    this.tableLoading = false
                })
        },
        handleCurrentPageChange(page) {
            this.currentPage = page
        },
        openCreateDialog() {
            this.dialogMode = 'create'
            this.currentId = null
            this.dialogVisible = true
            this.resetForm()
        },
        openEditDialog(row) {
            this.dialogMode = 'edit'
            this.currentId = row.id
            this.dialogVisible = true
            this.form = {
                brand: row.brand || '',
                model: row.model || '',
                type: row.type || '',
                processor: row.processor || '',
                graphics: row.graphics || '',
                memory: row.memory || '',
                storage: row.storage || '',
                price: row.price || '',
                priceValue: Number(row.priceValue || row.price_value || 0),
                accent: row.accent || '',
                image: row.image || '',
                screenSize: row.screenSize || row.screen_size || '',
                resolution: row.resolution || '',
                refreshRate: row.refreshRate || row.refresh_rate || '',
                weight: row.weight || '',
                status: this.normalizeStatus(row.status)
            }
            this.clearFormValidate()
        },
        handleSubmit() {
            this.$refs.deviceForm.validate((valid) => {
                if (!valid) {
                    return
                }

                this.submitLoading = true

                const requestData = this.buildRequestData()
                const request = this.dialogMode === 'create'
                    ? http.post('/computer-models', requestData)
                    : http.put(`/computer-models/${this.currentId}`, requestData)

                request
                    .then(() => {
                        this.$message.success(this.dialogMode === 'create' ? '新增电脑成功' : '修改电脑成功')
                        this.closeDialog()
                        this.keyword = ''
                        this.fetchDeviceList()
                    })
                    .catch(() => {
                        this.$message.error(this.dialogMode === 'create' ? '新增电脑失败' : '修改电脑失败')
                    })
                    .finally(() => {
                        this.submitLoading = false
                    })
            })
        },
        handleDelete(row) {
            this.$confirm(`确认删除“${row.model}”吗？`, '删除确认', {
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                type: 'warning'
            })
                .then(() => {
                    this.deleteLoadingId = row.id

                    return http.delete(`/computer-models/${row.id}`)
                })
                .then(() => {
                    this.$message.success('删除电脑成功')
                    this.fetchDeviceList()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error('删除电脑失败')
                    }
                })
                .finally(() => {
                    this.deleteLoadingId = null
                })
        },
        buildRequestData() {
            return {
                brand: this.form.brand,
                model: this.form.model,
                type: this.form.type,
                processor: this.form.processor,
                graphics: this.form.graphics,
                memory: this.form.memory,
                storage: this.form.storage,
                price: this.form.price,
                priceValue: Number(this.form.priceValue || 0),
                accent: this.form.accent,
                image: this.form.image,
                screenSize: this.form.screenSize,
                resolution: this.form.resolution,
                refreshRate: this.form.refreshRate,
                weight: this.form.weight,
                status: this.normalizeStatus(this.form.status)
            }
        },
        getResponseList(data) {
            if (Array.isArray(data)) {
                return data
            }

            return data?.data || data?.list || data?.computers || data?.computerModels || []
        },
        normalizeDevice(device) {
            const normalizedDevice = {
                ...device,
                priceValue: Number(device.priceValue || device.price_value || 0),
                screenSize: device.screenSize || device.screen_size || '',
                refreshRate: device.refreshRate || device.refresh_rate || '',
                status: this.normalizeStatus(device.status)
            }
            const savedStatus = localStorage.getItem(this.getDeviceStatusStorageKey(normalizedDevice))

            return {
                ...normalizedDevice,
                status: savedStatus || normalizedDevice.status
            }
        },
        sortByIdAsc(list) {
            return list.slice().sort((prev, next) => {
                return Number(prev.id || 0) - Number(next.id || 0)
            })
        },
        getComputerImage(imageName) {
            if (!imageName) {
                return ''
            }

            if (this.imageCache[imageName]) {
                return this.imageCache[imageName]
            }

            try {
                const image = require(`@/assets/computer_image/${imageName}`)
                this.imageCache[imageName] = image
                return image
            } catch (error) {
                return ''
            }
        },
        getEmptyForm() {
            return {
                brand: '',
                model: '',
                type: '',
                processor: '',
                graphics: '',
                memory: '',
                storage: '',
                price: '',
                priceValue: 0,
                accent: '#2563eb',
                image: '',
                screenSize: '',
                resolution: '',
                refreshRate: '',
                weight: '',
                status: 'listed'
            }
        },
        handleToggleStatus(row) {
            const nextStatus = this.isDeviceUnlisted(row.status) ? 'listed' : 'unlisted'
            const requestData = {
                brand: row.brand,
                model: row.model,
                type: row.type,
                processor: row.processor,
                graphics: row.graphics,
                memory: row.memory,
                storage: row.storage,
                price: row.price,
                priceValue: Number(row.priceValue || 0),
                accent: row.accent,
                image: row.image,
                screenSize: row.screenSize,
                resolution: row.resolution,
                refreshRate: row.refreshRate,
                weight: row.weight,
                status: nextStatus
            }

            this.statusLoadingId = row.id

            http.put(`/computer-models/${row.id}`, requestData)
                .then(() => {
                    row.status = nextStatus
                    localStorage.setItem(this.getDeviceStatusStorageKey(row), nextStatus)
                    this.$message.success(nextStatus === 'listed' ? '电脑已上架' : '电脑已下架')
                })
                .catch(() => {
                    this.$message.error('切换电脑上下架状态失败')
                })
                .finally(() => {
                    this.statusLoadingId = null
                })
        },
        getDeviceStatusStorageKey(device) {
            return `device_status_computer_${device.id || device.model}`
        },
        normalizeStatus(status) {
            return ['stopped', 'unlisted', 'off'].includes(String(status || '').toLowerCase()) ? 'unlisted' : 'listed'
        },
        isDeviceUnlisted(status) {
            return this.normalizeStatus(status) === 'unlisted'
        },
        getStatusLabel(status) {
            return this.isDeviceUnlisted(status) ? '下架' : '上架'
        },
        getStatusTagType(status) {
            return this.isDeviceUnlisted(status) ? 'danger' : 'success'
        },
        closeDialog() {
            if (this.submitLoading) {
                return
            }

            this.dialogVisible = false
            this.resetForm()
        },
        handleDialogBeforeClose(done) {
            if (this.submitLoading) {
                return
            }

            done()
            this.resetForm()
        },
        resetForm() {
            this.form = this.getEmptyForm()
            this.clearFormValidate()
        },
        clearFormValidate() {
            this.$nextTick(() => {
                if (this.$refs.deviceForm) {
                    this.$refs.deviceForm.clearValidate()
                }
            })
        }
    }
}
</script>

<style scoped>
.device-info-page {
    width: 100%;
}

.device-info-card {
    width: 100%;
    min-height: calc(100vh - 36px);
    border: 1px solid #ebeef5;
    border-radius: 8px;
}

.device-info-card :deep(.el-card__header) {
    padding: 18px 22px;
    border-bottom: 1px solid #eef0f3;
}

.device-info-card :deep(.el-card__body) {
    padding: 22px;
}

.page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
}

.page-header h2 {
    margin: 0;
    color: #1f2937;
    font-size: 20px;
    font-weight: 700;
    line-height: 1.3;
}

.header-actions {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 10px;
}

.search-input {
    width: min(340px, 100%);
}

.device-table {
    width: 100%;
}

.device-table :deep(.el-table__header th) {
    color: #374151;
    background: #f8fafc;
    font-weight: 600;
}

.device-image {
    display: block;
    width: 58px;
    height: 58px;
    object-fit: contain;
    margin: 0 auto;
}

.pagination-bar {
    display: flex;
    justify-content: flex-end;
    margin-top: 18px;
}

.device-form {
    padding: 8px 8px 0 0;
}

.device-form :deep(.el-input-number) {
    width: 100%;
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

@media (max-width: 820px) {
    .device-info-card :deep(.el-card__body) {
        padding: 14px;
    }

    .page-header,
    .header-actions {
        align-items: stretch;
        flex-direction: column;
    }

    .search-input,
    .header-actions .el-button {
        width: 100%;
    }

    .pagination-bar {
        justify-content: center;
        overflow-x: auto;
    }
}
</style>
