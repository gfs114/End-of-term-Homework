<template>
    <section class="device-info-page">
        <el-card class="device-info-card" shadow="never">
            <template #header>
                <div class="page-header">
                    <div>
                        <h2>设备信息管理</h2>
                    </div>

                    <div class="header-actions">
                        <el-input v-model.trim="keyword" class="search-input" clearable placeholder="搜索品牌、型号或处理器"
                            @clear="fetchDeviceList" @keyup.enter="handleSearch" />
                        <el-button @click="handleSearch">搜索</el-button>
                        <el-button type="primary" @click="openCreateDialog">新增手机</el-button>
                    </div>
                </div>
            </template>

            <el-table v-loading="tableLoading" :data="paginatedDeviceList" border stripe class="device-table"
                empty-text="暂无设备数据">
                <el-table-column label="图片" width="96" align="center">
                    <template #default="{ row }">
                        <img v-if="row.image" class="device-image" :src="getPhoneImage(row.image)" :alt="row.model" />
                        <span v-else>-</span>
                    </template>
                </el-table-column>
                <el-table-column prop="brand" label="品牌" min-width="110" sortable />
                <el-table-column prop="model" label="型号" min-width="220" show-overflow-tooltip />
                <el-table-column prop="processor" label="处理器" min-width="180" show-overflow-tooltip />
                <el-table-column prop="battery" label="电池" min-width="120" />
                <el-table-column prop="batteryValue" label="电池数值" width="110" sortable />
                <el-table-column prop="price" label="价格" min-width="120" />
                <el-table-column prop="priceValue" label="价格数值" width="110" sortable />
                <el-table-column prop="image" label="图片文件名" min-width="180" show-overflow-tooltip />
                <el-table-column label="操作" width="170" fixed="right" align="center">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="openEditDialog(row)">编辑</el-button>
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

        <el-dialog v-model="dialogVisible" :title="dialogMode === 'create' ? '新增手机' : '编辑手机'" width="620px"
            :close-on-click-modal="false" :before-close="handleDialogBeforeClose">
            <el-form ref="deviceForm" :model="form" :rules="rules" label-width="98px" class="device-form">
                <el-form-item label="品牌" prop="brand">
                    <el-input v-model.trim="form.brand" placeholder="例如：华为、小米、Apple" maxlength="50" />
                </el-form-item>
                <el-form-item label="型号" prop="model">
                    <el-input v-model.trim="form.model" placeholder="例如：HUAWEI Mate 60" maxlength="120" />
                </el-form-item>
                <el-form-item label="处理器" prop="processor">
                    <el-input v-model.trim="form.processor" placeholder="例如：麒麟9000S" maxlength="120" />
                </el-form-item>
                <el-form-item label="电池文本" prop="battery">
                    <el-input v-model.trim="form.battery" placeholder="例如：5000mAh" maxlength="50" />
                </el-form-item>
                <el-form-item label="电池数值" prop="batteryValue">
                    <el-input-number v-model="form.batteryValue" :min="0" :max="99999" controls-position="right" />
                </el-form-item>
                <el-form-item label="价格文本" prop="price">
                    <el-input v-model.trim="form.price" placeholder="例如：¥4999 起" maxlength="50" />
                </el-form-item>
                <el-form-item label="价格数值" prop="priceValue">
                    <el-input-number v-model="form.priceValue" :min="0" :max="999999" controls-position="right" />
                </el-form-item>
                <el-form-item label="图片文件" prop="image">
                    <el-input v-model.trim="form.image" placeholder="例如：Mate60.jpg" maxlength="255" />
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
    name: 'DeviceInfo',
    data() {
        return {
            keyword: '',
            deviceList: [],
            currentPage: 1,
            pageSize: 20,
            tableLoading: false,
            submitLoading: false,
            deleteLoadingId: null,
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
                processor: [
                    { required: true, message: '请输入处理器', trigger: 'blur' }
                ],
                battery: [
                    { required: true, message: '请输入电池文本', trigger: 'blur' }
                ],
                batteryValue: [
                    { required: true, message: '请输入电池数值', trigger: 'change' }
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

            http.get('/phone-models')
                .then((response) => {
                    const list = this.getResponseList(response.data)
                    this.deviceList = this.sortByIdAsc(list.map(this.normalizeDevice))
                    this.currentPage = 1
                })
                .catch(() => {
                    this.$message.error('获取手机列表失败')
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

            http.get('/phone-models/search/list', {
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
                    this.$message.error('搜索手机失败')
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
                processor: row.processor || '',
                battery: row.battery || '',
                batteryValue: Number(row.batteryValue || row.battery_value || 0),
                price: row.price || '',
                priceValue: Number(row.priceValue || row.price_value || 0),
                image: row.image || ''
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
                    ? http.post('/phone-models', requestData)
                    : http.put(`/phone-models/${this.currentId}`, requestData)

                request
                    .then(() => {
                        this.$message.success(this.dialogMode === 'create' ? '新增手机成功' : '修改手机成功')
                        this.closeDialog()
                        this.keyword = ''
                        this.fetchDeviceList()
                    })
                    .catch(() => {
                        this.$message.error(this.dialogMode === 'create' ? '新增手机失败' : '修改手机失败')
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

                    return http.delete(`/phone-models/${row.id}`)
                })
                .then(() => {
                    this.$message.success('删除手机成功')
                    this.fetchDeviceList()
                })
                .catch((error) => {
                    if (error !== 'cancel' && error !== 'close') {
                        this.$message.error('删除手机失败')
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
                processor: this.form.processor,
                battery: this.form.battery,
                batteryValue: Number(this.form.batteryValue || 0),
                price: this.form.price,
                priceValue: Number(this.form.priceValue || 0),
                image: this.form.image
            }
        },
        getResponseList(data) {
            if (Array.isArray(data)) {
                return data
            }

            return data?.data || data?.list || data?.phones || []
        },
        normalizeDevice(device) {
            return {
                ...device,
                batteryValue: Number(device.batteryValue || device.battery_value || 0),
                priceValue: Number(device.priceValue || device.price_value || 0)
            }
        },
        sortByIdAsc(list) {
            return list.slice().sort((prev, next) => {
                return Number(prev.id || 0) - Number(next.id || 0)
            })
        },
        getPhoneImage(imageName) {
            if (!imageName) {
                return ''
            }

            if (this.imageCache[imageName]) {
                return this.imageCache[imageName]
            }

            try {
                const image = require(`@/assets/phone_image/${imageName}`)
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
                processor: '',
                battery: '',
                batteryValue: 0,
                price: '',
                priceValue: 0,
                image: ''
            }
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

.page-header p {
    margin: 6px 0 0;
    color: #64748b;
    font-size: 13px;
}

.header-actions {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 10px;
}

.search-input {
    width: min(320px, 100%);
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
