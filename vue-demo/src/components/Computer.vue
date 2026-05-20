<template>
  <section class="computer-zone">
    <header class="page-heading">
      <h1>电脑专区</h1>
    </header>

    <section class="brand-hero" aria-label="电脑品牌专区">
      <div>
        <h2>品牌专区</h2>
      </div>

      <label class="search-box">
        <span>搜索品牌</span>
        <input v-model.trim="brandKeyword" type="search" placeholder="例如：Apple、联想、华为、戴尔" />
      </label>
    </section>

    <section class="brand-grid" aria-label="主流电脑品牌列表">
      <article v-for="brand in filteredBrands" :key="brand.name"
        :class="['brand-card', { active: selectedBrand && selectedBrand.name === brand.name }]" tabindex="0"
        role="button" @click="selectBrand(brand)" @keyup.enter="selectBrand(brand)"
        @keyup.space.prevent="selectBrand(brand)">
        <div class="brand-mark" :style="{ background: brand.color }">{{ brand.shortName }}</div>
        <h2>{{ brand.name }}</h2>
      </article>

      <div v-if="filteredBrands.length === 0" class="empty-state">
        暂未找到匹配品牌，请换个关键词试试。
      </div>
    </section>

    <section class="model-section" aria-label="详细电脑型号">
      <div class="model-control-panel">
        <div class="section-head">
          <div>
            <h2>详细电脑型号</h2>
          </div>

          <label class="model-search">
            <span>搜索型号或配置</span>
            <input v-model.trim="modelKeyword" type="search" placeholder="例如：MacBook、酷睿 Ultra、RTX" />
          </label>
        </div>

        <div class="model-filters" aria-label="电脑型号筛选条件">
          <div class="filter-row">
            <span class="filter-title">品牌</span>
            <button v-for="brand in modelBrandOptions" :key="brand" type="button"
              :class="['filter-chip', { active: modelFilters.brand === brand }]"
              @click="setModelFilter('brand', brand)">
              {{ brand }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">类型</span>
            <button v-for="type in typeOptions" :key="type" type="button"
              :class="['filter-chip', { active: modelFilters.type === type }]" @click="setModelFilter('type', type)">
              {{ type }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">显卡</span>
            <button v-for="graphics in graphicsOptions" :key="graphics" type="button"
              :class="['filter-chip', { active: modelFilters.graphics === graphics }]"
              @click="setModelFilter('graphics', graphics)">
              {{ graphics }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">价格</span>
            <button v-for="price in priceOptions" :key="price.label" type="button"
              :class="['filter-chip', { active: modelFilters.price === price.label }]"
              @click="setModelFilter('price', price.label)">
              {{ price.label }}
            </button>
          </div>
        </div>
      </div>

      <div class="model-grid">
        <article v-for="computer in filteredComputers" :key="computer.model" class="model-card" tabindex="0"
          role="button" @click="openComputerDetail(computer, $event)"
          @keyup.enter="openComputerDetail(computer, $event)"
          @keyup.space.prevent="openComputerDetail(computer, $event)">
          <div class="computer-visual" :style="{ '--accent-color': computer.accent }">
            <div class="screen"></div>
            <div class="base"></div>
          </div>
          <h3>{{ computer.model }}</h3>
          <div class="model-meta">
            <span>处理器</span>
            <strong>{{ computer.processor }}</strong>
          </div>
          <div class="model-meta">
            <span>显卡</span>
            <strong>{{ computer.graphics }}</strong>
          </div>
          <div class="model-meta">
            <span>价格</span>
            <strong>{{ computer.price }}</strong>
          </div>
        </article>
      </div>

      <div v-if="filteredComputers.length === 0" class="empty-state">
        暂未找到匹配电脑，请换个关键词或筛选条件试试。
      </div>
    </section>

    <transition name="brand-modal">
      <div v-if="selectedBrand" class="brand-modal-overlay" @click.self="clearSelectedBrand">
        <section class="brand-modal-panel" aria-label="品牌电脑弹窗">
          <div class="modal-head">
            <div>
              <p>品牌电脑</p>
              <h2>{{ selectedBrand.name }}</h2>
            </div>
            <button type="button" class="modal-close" @click="clearSelectedBrand">关闭</button>
          </div>

          <div v-if="selectedBrandComputers.length" class="brand-computer-grid">
            <article v-for="computer in selectedBrandComputers" :key="computer.model" class="brand-computer-card"
              tabindex="0" role="button" @click="openComputerDetail(computer, $event)"
              @keyup.enter="openComputerDetail(computer, $event)"
              @keyup.space.prevent="openComputerDetail(computer, $event)">
              <div class="computer-visual computer-visual--compact" :style="{ '--accent-color': computer.accent }">
                <div class="screen"></div>
                <div class="base"></div>
              </div>
              <div class="brand-computer-body">
                <h3>{{ computer.model }}</h3>
                <p>{{ computer.processor }}</p>
                <strong>{{ computer.price }}</strong>
              </div>
            </article>
          </div>

          <div v-else class="empty-state">
            该品牌暂未收录电脑型号。
          </div>
        </section>
      </div>
    </transition>

    <transition name="computer-detail">
      <div v-if="selectedComputer" class="detail-overlay" :style="detailVars" @click.self="closeComputerDetail">
        <section class="detail-panel" aria-label="电脑详情">
          <button type="button" class="detail-close" aria-label="关闭详情" @click="closeComputerDetail">×</button>

          <div class="computer-visual detail-visual" :style="{ '--accent-color': selectedComputer.img }">
            <div class="screen"></div>
            <div class="base"></div>
          </div>

          <div class="detail-content">
            <p class="detail-brand">{{ selectedComputer.brand }} / {{ selectedComputer.type }}</p>
            <h2>{{ selectedComputer.model }}</h2>

            <button
              type="button"
              :class="['device-favorite-button', { active: selectedComputerFavorite }]"
              :disabled="favoriteDeviceLoading"
              @click="toggleFavoriteComputer"
            >
              {{ selectedComputerFavorite ? '已喜欢' : '喜欢设备' }}
            </button>

            <dl class="detail-list">
              <div v-for="item in selectedComputerSpecs" :key="item.label">
                <dt>{{ item.label }}</dt>
                <dd>{{ item.value }}</dd>
              </div>
            </dl>
          </div>
        </section>
      </div>
    </transition>
  </section>
</template>

<script>
import http from '@/utils/http'

export default {
  name: "Computer",
  data() {
    return {
      brandKeyword: "",
      modelKeyword: "",
      selectedBrand: null,
      selectedComputer: null,
      favoriteDevices: [],
      favoriteDeviceLoading: false,
      detailOrigin: {
        x: 50,
        y: 50,
      },
      modelFilters: {
        brand: "全部",
        type: "全部",
        graphics: "全部",
        price: "全部",
      },
      brands: [
        { name: "Apple", shortName: "Apple", color: "linear-gradient(135deg, #111827, #6b7280)" },
        { name: "联想", shortName: "Lenovo", color: "linear-gradient(135deg, #dc2626, #f97316)" },
        { name: "华为", shortName: "HUAWEI", color: "linear-gradient(135deg, #ef4444, #f97316)" },
        { name: "戴尔", shortName: "DELL", color: "linear-gradient(135deg, #2563eb, #38bdf8)" },
        { name: "惠普", shortName: "HP", color: "linear-gradient(135deg, #1d4ed8, #0ea5e9)" },
        { name: "华硕", shortName: "ASUS", color: "linear-gradient(135deg, #0f172a, #64748b)" },
        { name: "宏碁", shortName: "Acer", color: "linear-gradient(135deg, #16a34a, #84cc16)" },
        { name: "机械革命", shortName: "MECHrevo", color: "linear-gradient(135deg, #7c3aed, #2563eb)" },
        { name: "七彩虹", shortName: "COLORFUL", color: "linear-gradient(135deg, #ec4899, #f97316)" },
        { name: "火影", shortName: "Hasee", color: "linear-gradient(135deg, #dc2626, #111827)" },
        { name: "荣耀", shortName: "HONOR", color: "linear-gradient(135deg, #0f172a, #38bdf8)" },
        { name: "小米", shortName: "Xiaomi", color: "linear-gradient(135deg, #FF7E00, #38bdf8)" },
      ],
      priceOptions: [
        { label: "全部", min: 0, max: Infinity },
        { label: "5000 以下", min: 0, max: 4999 },
        { label: "5000-7999", min: 5000, max: 7999 },
        { label: "8000 以上", min: 8000, max: Infinity },
      ],
      displaySpecs: {
        "MacBook Air 13inch M3": {
          screenSize: "13.6英寸",
          resolution: "2560x1664",
          refreshRate: "60Hz",
          weight: "约1.24Kg",
        },
        "MacBook Pro 14inch M4 Pro": {
          screenSize: "14.2英寸",
          resolution: "3024x1964",
          refreshRate: "最高120Hz",
          weight: "约1.55Kg",
        },
        "ThinkPad X1 Carbon": {
          screenSize: "14英寸",
          resolution: "2880x1800",
          refreshRate: "120Hz",
          weight: "约1.12Kg",
        },
        "拯救者 Y7000P": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "165Hz",
          weight: "约2.35Kg",
        },
        "MateBook X Pro": {
          screenSize: "14.2英寸",
          resolution: "3120x2080",
          refreshRate: "120Hz",
          weight: "约980g",
        },
        "MateBook 14": {
          screenSize: "14.2英寸",
          resolution: "2880x1920",
          refreshRate: "120Hz",
          weight: "约1.31Kg",
        },
        "XPS 13": {
          screenSize: "13.4英寸",
          resolution: "1920x1200",
          refreshRate: "60Hz",
          weight: "约1.19Kg",
        },
        "Alienware m16 R2": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "240Hz",
          weight: "约2.61Kg",
        },
        "星 Book Pro 14": {
          screenSize: "14英寸",
          resolution: "2880x1800",
          refreshRate: "120Hz",
          weight: "约1.45Kg",
        },
        "暗影精灵 10": {
          screenSize: "16.1英寸",
          resolution: "2560x1440",
          refreshRate: "240Hz",
          weight: "约2.4Kg",
        },
        "灵耀 14": {
          screenSize: "14英寸",
          resolution: "2880x1800",
          refreshRate: "120Hz",
          weight: "约1.2Kg",
        },
        "ROG 魔霸新锐": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "240Hz",
          weight: "约2.5Kg",
        },
        "掠夺者 Neo 16": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "165Hz",
          weight: "约2.6Kg",
        },
        "非凡 Go Pro": {
          screenSize: "14英寸",
          resolution: "2880x1800",
          refreshRate: "90Hz",
          weight: "约1.3Kg",
        },
        "蛟龙 16 Pro": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "240Hz",
          weight: "约2.3Kg",
        },
        "无界 14 Pro": {
          screenSize: "14英寸",
          resolution: "2880x1800",
          refreshRate: "120Hz",
          weight: "约1.45Kg",
        },
        "将星 X15 AT": {
          screenSize: "15.6英寸",
          resolution: "1920x1080",
          refreshRate: "144Hz",
          weight: "约2.1Kg",
        },
        "隐星 P16 TA": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "165Hz",
          weight: "约2.4Kg",
        },
        "众颜 U6": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "120Hz",
          weight: "约1.8Kg",
        },
        "T9 Plus": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "165Hz",
          weight: "约2.3Kg",
        },
        "MagicBook Pro 16": {
          screenSize: "16英寸",
          resolution: "3072x1920",
          refreshRate: "165Hz",
          weight: "约1.86Kg",
        },
        "MagicBook 14 Pro": {
          screenSize: "14.6英寸",
          resolution: "3120x2080",
          refreshRate: "120Hz",
          weight: "约1.37Kg",
        },
        "MacBook Air 13 2025款": {
          screenSize: "13.6英寸",
          resolution: "2560x1664",
          refreshRate: "60Hz",
          weight: "约1.24Kg",
        },
        "MacBook Pro 13 M2": {
          screenSize: "13.3英寸",
          resolution: "2560x1600",
          refreshRate: "60Hz",
          weight: "约1.4Kg",
        },
        "拯救者R9000P 2025 AI元启": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "240Hz",
          weight: "约2Kg",
        },
        "拯救者Y7000P 2025 AI元启": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "165Hz",
          weight: "约2.35Kg",
        },
        "小新Pro16GT AI元启版": {
          screenSize: "16英寸",
          resolution: "3200x2000",
          refreshRate: "165Hz",
          weight: "约1.9Kg",
        },
        "MateBook Fold 非凡大师": {
          screenSize: "折叠屏",
          resolution: "展开态3296x2472 / 半屏2472x1648",
          refreshRate: "暂无数据",
          weight: "暂无数据",
        },
        "MateBook Pro": {
          screenSize: "14.2英寸",
          resolution: "3120x2080",
          refreshRate: "120Hz",
          weight: "约970g",
        },
        "Latitude 5440": {
          screenSize: "14英寸",
          resolution: "1920x1080",
          refreshRate: "60Hz",
          weight: "约1.39Kg",
        },
        "Latitude 5530": {
          screenSize: "15.6英寸",
          resolution: "1920x1080",
          refreshRate: "60Hz",
          weight: "约1.59Kg",
        },
        "暗影精灵11": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "240Hz",
          weight: "2.43Kg",
        },
        "战66 2025 酷睿Ultra版 16英寸": {
          screenSize: "16英寸",
          resolution: "1920x1200",
          refreshRate: "60Hz",
          weight: "约1.75Kg",
        },
        "ProArt创13 2026": {
          screenSize: "13.3英寸",
          resolution: "2880x1800",
          refreshRate: "120Hz",
          weight: "约1.2Kg",
        },
        "无畏14 2024": {
          screenSize: "14英寸",
          resolution: "2880x1800",
          refreshRate: "120Hz",
          weight: "约1.4Kg",
        },
        "天选4 13代酷睿版": {
          screenSize: "15.6英寸",
          resolution: "2560x1440",
          refreshRate: "165Hz",
          weight: "约2.1Kg",
        },
        "掠夺者·刀锋8": {
          screenSize: "8英寸",
          resolution: "1920x1200",
          refreshRate: "暂无数据",
          weight: "暂无数据",
        },
        "非凡 X14": {
          screenSize: "14.5英寸",
          resolution: "2560x1600",
          refreshRate: "120Hz",
          weight: "约1.5Kg",
        },
        "蛟龙15K": {
          screenSize: "15.6英寸",
          resolution: "1920x1080",
          refreshRate: "165Hz",
          weight: "约2.1Kg",
        },
        "无界15X 酷睿版 2024": {
          screenSize: "15.6英寸",
          resolution: "2560x1440",
          refreshRate: "120Hz",
          weight: "约1.7Kg",
        },
        "隐星 P16": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "165Hz",
          weight: "约2.3Kg",
        },
        "E14": {
          screenSize: "14英寸",
          resolution: "2240x1400",
          refreshRate: "60Hz",
          weight: "约1.4Kg",
        },
        "众颜U6 2024": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "120Hz",
          weight: "约1.8Kg",
        },
        "T9 系列": {
          screenSize: "16英寸",
          resolution: "2560x1600",
          refreshRate: "165Hz",
          weight: "约2.3Kg",
        },
        "MagicBook Pro 16 2026": {
          screenSize: "16英寸",
          resolution: "3072x1920",
          refreshRate: "165Hz",
          weight: "约1.86Kg",
        },
        "MagicBook Pro 16 HUNTER版": {
          screenSize: "16英寸",
          resolution: "3072x1920",
          refreshRate: "165Hz",
          weight: "约1.86Kg",
        },
      },
      computers: [
        {
          brand: "Apple",
          model: "MacBook Air 13inch M3",
          type: "轻薄本",
          processor: "Apple M3",
          graphics: "至高 8 核 GPU",
          memory: "16GB",
          storage: "512GB SSD",
          price: "¥8999 起",
          priceValue: 8999,
          accent: "#111827",
        },
        {
          brand: "Apple",
          model: "MacBook Pro 14 M4 Pro",
          type: "创作本",
          processor: "Apple M4 Pro",
          graphics: "至高 16 核 GPU",
          memory: "24GB",
          storage: "1TB SSD",
          price: "¥16999 起",
          priceValue: 16999,
          accent: "#374151",
        },
        {
          brand: "联想",
          model: "ThinkPad X1 Carbon",
          type: "商务本",
          processor: "酷睿 Ultra 7",
          graphics: "Intel Arc 核显",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥12999 起",
          priceValue: 12999,
          accent: "#dc2626",
        },
        {
          brand: "联想",
          model: "拯救者 Y7000P",
          type: "游戏本",
          processor: "酷睿 i7-14700HX",
          graphics: "RTX 4070",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥7999 起",
          priceValue: 7999,
          accent: "#ef4444",
        },
        {
          brand: "华为",
          model: "MateBook X Pro",
          type: "轻薄本",
          processor: "酷睿 Ultra 9 185H",
          graphics: "Intel Arc 核显",
          memory: "32GB",
          storage: "2TB SSD",
          price: "¥11199 起",
          priceValue: 11199,
          accent: "#ef4444",
        },
        {
          brand: "华为",
          model: "MateBook 14",
          type: "全能本",
          processor: "酷睿 Ultra 5 125H",
          graphics: "Intel Arc 核显",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥6499 起",
          priceValue: 6499,
          accent: "#f97316",
        },
        {
          brand: "戴尔",
          model: "XPS 13",
          type: "轻薄本",
          processor: "酷睿 Ultra 7",
          graphics: "Intel Arc 核显",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥9999 起",
          priceValue: 9999,
          accent: "#2563eb",
        },
        {
          brand: "戴尔",
          model: "Alienware m16 R2",
          type: "游戏本",
          processor: "酷睿 Ultra 9",
          graphics: "RTX 4070",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥17999 起",
          priceValue: 17999,
          accent: "#0ea5e9",
        },
        {
          brand: "惠普",
          model: "星 Book Pro 14",
          type: "轻薄本",
          processor: "酷睿 Ultra 5 225H",
          graphics: "Intel Arc 核显",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥5999 起",
          priceValue: 5999,
          accent: "#1d4ed8",
        },
        {
          brand: "惠普",
          model: "暗影精灵 10",
          type: "游戏本",
          processor: "酷睿 i7-14650HX",
          graphics: "RTX 4060",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥8299 起",
          priceValue: 8299,
          accent: "#2563eb",
        },
        {
          brand: "华硕",
          model: "灵耀 14",
          type: "轻薄本",
          processor: "酷睿 Ultra 7 155H",
          graphics: "Intel Arc 核显",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥7999 起",
          priceValue: 7999,
          accent: "#475569",
        },
        {
          brand: "华硕",
          model: "ROG 魔霸新锐",
          type: "游戏本",
          processor: "锐龙 9",
          graphics: "RTX 4070",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥12999 起",
          priceValue: 12999,
          accent: "#0f172a",
        },
        {
          brand: "宏碁",
          model: "掠夺者 Neo 16",
          type: "游戏本",
          processor: "酷睿 i9-14900HX",
          graphics: "RTX 4070",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥11999 起",
          priceValue: 11999,
          accent: "#16a34a",
        },
        {
          brand: "宏碁",
          model: "非凡 Go Pro",
          type: "轻薄本",
          processor: "酷睿 Ultra 7 155H",
          graphics: "Intel Arc 核显",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥6999 起",
          priceValue: 6999,
          accent: "#65a30d",
        },
        {
          brand: "机械革命",
          model: "蛟龙 16 Pro",
          type: "游戏本",
          processor: "锐龙 9 7945HX",
          graphics: "RTX 4070",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥8999 起",
          priceValue: 8999,
          accent: "#7c3aed",
        },
        {
          brand: "机械革命",
          model: "无界 14 Pro",
          type: "全能本",
          processor: "酷睿 Ultra 5",
          graphics: "Intel Arc 核显",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥4999 起",
          priceValue: 4999,
          accent: "#2563eb",
        },
        {
          brand: "七彩虹",
          model: "将星 X15 AT",
          type: "游戏本",
          processor: "酷睿 i7-14650HX",
          graphics: "RTX 4060",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥6999 起",
          priceValue: 6999,
          accent: "#ec4899",
        },
        {
          brand: "七彩虹",
          model: "隐星 P16 TA",
          type: "游戏本",
          processor: "酷睿 i9-14900HX",
          graphics: "RTX 4070",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥9999 起",
          priceValue: 9999,
          accent: "#f97316",
        },
        {
          brand: "火影",
          model: "众颜 U6",
          type: "轻薄本",
          processor: "酷睿 i5-12500H",
          graphics: "Intel Iris Xe",
          memory: "16GB",
          storage: "512GB SSD",
          price: "¥3999 起",
          priceValue: 3999,
          accent: "#dc2626",
        },
        {
          brand: "火影",
          model: "T9 Plus",
          type: "游戏本",
          processor: "酷睿 i7-14650HX",
          graphics: "RTX 4060",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥6499 起",
          priceValue: 6499,
          accent: "#111827",
        },
        {
          brand: "荣耀",
          model: "MagicBook Pro 16",
          type: "全能本",
          processor: "酷睿 Ultra 7 155H",
          graphics: "RTX 4060",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥8999 起",
          priceValue: 8999,
          accent: "#0ea5e9",
        },
        {
          brand: "荣耀",
          model: "MagicBook 14 Pro",
          type: "轻薄本",
          processor: "酷睿 Ultra 5 125H",
          graphics: "Intel Arc 核显",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥5999 起",
          priceValue: 5999,
          accent: "#38bdf8",
        },
        {
          brand: "Apple",
          model: "MacBook Air 13 2025款",
          type: "轻薄本",
          processor: "Apple M4",
          graphics: "10核图形处理器",
          memory: "24GB",
          storage: "512GB SSD",
          price: "¥10999 起",
          priceValue: 10999,
          accent: "#111827",
        },
        {
          brand: "Apple",
          model: "MacBook Pro 13 M2",
          type: "轻薄本",
          processor: "Apple M2",
          graphics: "10核图形处理器",
          memory: "8GB",
          storage: "256GB SSD",
          price: "¥9999 起",
          priceValue: 9999,
          accent: "#4b5563",
        },
        {
          brand: "联想",
          model: "拯救者R9000P 2025 AI元启",
          type: "游戏本",
          processor: "AMD Ryzen 9 8945HX",
          graphics: "RTX 5070",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥11149 起",
          priceValue: 11149,
          accent: "#dc2626",
        },
        {
          brand: "联想",
          model: "拯救者Y7000P 2025 AI元启",
          type: "游戏本",
          processor: "酷睿 i9 14900HX",
          graphics: "RTX 5060",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥9499 起",
          priceValue: 9499,
          accent: "#ef4444",
        },
        {
          brand: "联想",
          model: "小新Pro16GT 2026 AI元启版",
          type: "轻薄本",
          processor: "酷睿 Ultra X9 388H",
          graphics: "Intel Arc B390",
          memory: "32GB",
          storage: "1TB SSD",
          price: "价格面议",
          priceValue: null,
          accent: "#f97316",
        },
        {
          brand: "华为",
          model: "MateBook Fold 非凡大师",
          type: "轻薄本",
          processor: "麒麟X90",
          graphics: "集成显卡",
          memory: "32GB",
          storage: "2TB SSD",
          price: "¥19999 起",
          priceValue: 19999,
          accent: "#ef4444",
        },
        {
          brand: "华为",
          model: "MateBook Pro",
          type: "轻薄本",
          processor: "麒麟X90",
          graphics: "集成显卡",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥7999 起",
          priceValue: 7999,
          accent: "#f43f5e",
        },
        {
          brand: "戴尔",
          model: "Latitude 5440",
          type: "商务本",
          processor: "酷睿 i7 1355U",
          graphics: "集成显卡",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥7299 起",
          priceValue: 7299,
          accent: "#2563eb",
        },
        {
          brand: "戴尔",
          model: "Latitude 5530",
          type: "商务本",
          processor: "酷睿 i7 1255U",
          graphics: "集成显卡",
          memory: "32GB",
          storage: "512GB SSD",
          price: "¥5699 起",
          priceValue: 5699,
          accent: "#0ea5e9",
        },
        {
          brand: "戴尔",
          model: "XPS14",
          type: "商务本",
          processor: "酷睿 UltraX7 358H",
          graphics: "ARC B390",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥25999 起",
          priceValue: 25999,
          accent: "#0ea5e9",
        },
        {
          brand: "戴尔",
          model: "XPS16",
          type: "商务本",
          processor: "酷睿 UltraX7 358H",
          graphics: "ARC B390",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥26999 起",
          priceValue: 25999,
          accent: "#0ea5e9",
        },
        {
          brand: "惠普",
          model: "暗影精灵11",
          type: "游戏本",
          processor: "酷睿 i9 14900HX",
          graphics: "RTX 5070",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥9999 起",
          priceValue: 9999,
          accent: "#1d4ed8",
        },
        {
          brand: "惠普",
          model: "战66 2025 酷睿Ultra版 16英寸",
          type: "商务本",
          processor: "酷睿 Ultra 7 155H",
          graphics: "集成显卡",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥6199 起",
          priceValue: 6199,
          accent: "#2563eb",
        },
        {
          brand: "华硕",
          model: "ProArt创13 2026",
          type: "创作本",
          processor: "锐龙 AI Max+ 395",
          graphics: "Radeon 8060S",
          memory: "64GB",
          storage: "1TB SSD",
          price: "¥14999 起",
          priceValue: 14999,
          accent: "#0f172a",
        },
        {
          brand: "华硕",
          model: "无畏14 2024",
          type: "轻薄本",
          processor: "酷睿 i5 13500H",
          graphics: "集成显卡",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥3799 起",
          priceValue: 3799,
          accent: "#475569",
        },
        {
          brand: "华硕",
          model: "天选4 13代酷睿版",
          type: "游戏本",
          processor: "酷睿 i9 13900H",
          graphics: "RTX 4060",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥10499 起",
          priceValue: 10499,
          accent: "#64748b",
        },
        {
          brand: "华硕",
          model: "ROG 幻16Air 酷睿版",
          type: "游戏本",
          processor: "酷睿 Ultra 9 185H",
          graphics: "RTX 4060",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥13499 起",
          priceValue: 13499,
          img: "https://www.asus.com/media/ROG/ROG-Zephyrus-G14-GA401UQ/image/ROG-Zephyrus-G14-GA401UQ-1.png",
        },
        {
          brand: "华硕",
          model: "ROG 幻16Air 锐龙AI版",
          type: "游戏本",
          processor: "Ryzen AI9 HX370",
          graphics: "RTX 4060",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥14999 起",
          priceValue: 14999,
          accent: "#64748b",
        },
        {
          brand: "宏碁",
          model: "掠夺者·刀锋8",
          type: "游戏本",
          processor: "酷睿 Ultra 9 288V",
          graphics: "RTX 5070",
          memory: "32GB",
          storage: "2TB SSD",
          price: "价格面议",
          priceValue: null,
          accent: "#16a34a",
        },
        {
          brand: "宏碁",
          model: "非凡 X14",
          type: "全能本",
          processor: "酷睿 i5 13500H",
          graphics: "RTX 4050",
          memory: "16GB",
          storage: "1TB SSD",
          price: "¥7299 起",
          priceValue: 7299,
          accent: "#65a30d",
        },
        {
          brand: "机械革命",
          model: "蛟龙15K",
          type: "游戏本",
          processor: "Ryzen 7 7735H",
          graphics: "RTX 3050",
          memory: "16GB",
          storage: "512GB SSD",
          price: "¥5699 起",
          priceValue: 5699,
          accent: "#7c3aed",
        },
        {
          brand: "机械革命",
          model: "无界15X 酷睿版 2024",
          type: "轻薄本",
          processor: "酷睿 Ultra 7 155H",
          graphics: "集成显卡",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥6999 起",
          priceValue: 6999,
          accent: "#2563eb",
        },
        {
          brand: "七彩虹",
          model: "隐星 P16",
          type: "游戏本",
          processor: "酷睿 i7 12650H",
          graphics: "RTX 4060",
          memory: "16GB",
          storage: "512GB SSD",
          price: "¥5999 起",
          priceValue: 5999,
          accent: "#ec4899",
        },
        {
          brand: "七彩虹",
          model: "E14",
          type: "轻薄本",
          processor: "Ryzen 7 7735HS",
          graphics: "Radeon 680M",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥3799 起",
          priceValue: 3799,
          accent: "#f97316",
        },
        {
          brand: "火影",
          model: "众颜U6 2024",
          type: "轻薄本",
          processor: "Ryzen 7 8845HS",
          graphics: "集成显卡",
          memory: "32GB",
          storage: "1TB SSD",
          price: "价格面议",
          priceValue: null,
          accent: "#dc2626",
        },
        {
          brand: "火影",
          model: "T9 系列",
          type: "游戏本",
          processor: "酷睿 i7",
          graphics: "RTX 系列独显",
          memory: "16GB",
          storage: "1TB SSD",
          price: "价格面议",
          priceValue: null,
          accent: "#111827",
        },
        {
          brand: "荣耀",
          model: "MagicBook Pro 16 2026",
          type: "轻薄本",
          processor: "酷睿 Ultra X9 388H",
          graphics: "集成显卡",
          memory: "32GB",
          storage: "1TB SSD",
          price: "¥10999 起",
          priceValue: 10999,
          accent: "#0ea5e9",
        },
        {
          brand: "荣耀",
          model: "MagicBook Pro 16 HUNTER版",
          type: "全能本",
          processor: "酷睿 Ultra 7 155H",
          graphics: "RTX 4060",
          memory: "32GB",
          storage: "1TB SSD",
          price: "价格面议",
          priceValue: null,
          accent: "#38bdf8",
        },
      ],
    };
  },
  computed: {
    filteredBrands() {
      const keyword = this.brandKeyword.toLowerCase();

      return this.brands.filter((brand) =>
        !keyword || brand.name.toLowerCase().includes(keyword)
      );
    },
    modelBrandOptions() {
      return ["全部"].concat(
        this.uniqueValues(this.computers.map((computer) => computer.brand))
      );
    },
    typeOptions() {
      return ["全部"].concat(
        this.uniqueValues(this.computers.map((computer) => computer.type))
      );
    },
    graphicsOptions() {
      const graphicsList = this.computers.map((computer) =>
        this.normalizeGraphicsFilter(computer.graphics)
      );
      return ["全部"].concat(this.uniqueValues(graphicsList));
    },
    selectedBrandComputers() {
      if (!this.selectedBrand) {
        return [];
      }

      return this.computers.filter(
        (computer) => computer.brand === this.selectedBrand.name
      );
    },
    selectedComputerSpecs() {
      if (!this.selectedComputer) {
        return [];
      }

      const displaySpec = this.getDisplaySpec(this.selectedComputer);

      return [
        { label: "品牌", value: this.selectedComputer.brand },
        { label: "型号", value: this.selectedComputer.model },
        { label: "类型", value: this.selectedComputer.type },
        { label: "屏幕尺寸", value: displaySpec.screenSize },
        { label: "分辨率", value: displaySpec.resolution },
        { label: "刷新率", value: displaySpec.refreshRate },
        { label: "处理器", value: this.selectedComputer.processor },
        { label: "显卡", value: this.selectedComputer.graphics },
        { label: "内存", value: this.selectedComputer.memory },
        { label: "硬盘", value: this.selectedComputer.storage },
        { label: "重量", value: displaySpec.weight },
        { label: "价格", value: this.selectedComputer.price },
      ].map((item) => ({
        label: item.label,
        value: this.formatSpecValue(item.value),
      }));
    },
    filteredComputers() {
      const keyword = this.modelKeyword.toLowerCase();
      const priceRange = this.getSelectedPriceRange();

      return this.computers.filter((computer) => {
        const matchesKeyword =
          !keyword || this.getComputerSearchText(computer).includes(keyword);
        const matchesBrand =
          this.modelFilters.brand === "全部" ||
          computer.brand === this.modelFilters.brand;
        const matchesType =
          this.modelFilters.type === "全部" ||
          computer.type === this.modelFilters.type;
        const matchesGraphics = this.matchesSelectedGraphics(computer);
        const matchesPrice =
          !priceRange ||
          (computer.priceValue >= priceRange.min &&
            computer.priceValue <= priceRange.max);

        return (
          matchesKeyword &&
          matchesBrand &&
          matchesType &&
          matchesGraphics &&
          matchesPrice
        );
      });
    },
    detailVars() {
      return {
        "--detail-origin-x": `${this.detailOrigin.x}%`,
        "--detail-origin-y": `${this.detailOrigin.y}%`,
      };
    },
    selectedComputerFavorite() {
      return this.isFavoriteDevice("computer", this.selectedComputer && this.selectedComputer.model);
    },
  },
  mounted() {
    this.fetchFavoriteDevices();
  },
  methods: {
    uniqueValues(values) {
      return values.filter((value, index) => values.indexOf(value) === index);
    },
    getSelectedPriceRange() {
      return this.priceOptions.find(
        (price) => price.label === this.modelFilters.price
      );
    },
    getDisplaySpec(computer) {
      if (!computer) {
        return {};
      }

      return this.displaySpecs[computer.model] || {};
    },
    formatSpecValue(value) {
      return value || "暂无数据";
    },
    getComputerSearchText(computer) {
      return [
        computer.brand,
        computer.model,
        computer.type,
        computer.processor,
        computer.graphics,
        computer.memory,
        computer.storage,
        computer.price,
      ]
        .join(" ")
        .toLowerCase();
    },
    matchesSelectedGraphics(computer) {
      return (
        this.modelFilters.graphics === "全部" ||
        this.normalizeGraphicsFilter(computer.graphics) ===
          this.modelFilters.graphics
      );
    },
    selectBrand(brand) {
      this.selectedBrand = brand;
    },
    clearSelectedBrand() {
      this.selectedBrand = null;
    },
    setModelFilter(key, value) {
      this.modelFilters[key] = value;
    },
    normalizeGraphicsFilter(graphics) {
      const graphicsName = graphics || "";

      if (
        graphicsName.includes("集成") ||
        graphicsName.includes("核显") ||
        graphicsName.includes("图形处理器") ||
        graphicsName.includes("Intel Arc") ||
        graphicsName.includes("Iris Xe") ||
        graphicsName.includes("Radeon 680M") ||
        graphicsName.includes("Radeon 8060S")
      ) {
        return "核显";
      }

      return graphicsName;
    },
    getUsername() {
      return localStorage.getItem("loginUsername") || "";
    },
    getFavoriteDeviceKey(device) {
      return `${device.device_type || device.deviceType}:${device.device_model || device.deviceModel}`;
    },
    isFavoriteDevice(type, model) {
      if (!model) {
        return false;
      }

      return this.favoriteDevices.some((device) => (
        (device.device_type || device.deviceType) === type &&
        String(device.device_model || device.deviceModel) === String(model)
      ));
    },
    normalizeComputerDevice(computer) {
      return {
        username: this.getUsername(),
        device_type: "computer",
        device_brand: computer.brand,
        device_model: computer.model,
        device_price: computer.price,
        device_specs: `处理器：${computer.processor || "暂无"}；显卡：${computer.graphics || "暂无"}；内存：${computer.memory || "暂无"}；硬盘：${computer.storage || "暂无"}`
      };
    },
    async fetchFavoriteDevices() {
      const username = this.getUsername();
      if (!username) {
        this.favoriteDevices = [];
        return;
      }

      try {
        const { data } = await http.get("/user-favorite-devices", {
          params: { username }
        });
        const list = Array.isArray(data) ? data : data?.data || data?.devices || [];
        this.favoriteDevices = Array.isArray(list) ? list : [];
      } catch (error) {
        this.favoriteDevices = [];
      }
    },
    async toggleFavoriteComputer() {
      if (!this.selectedComputer || this.favoriteDeviceLoading) {
        return;
      }

      if (!this.getUsername()) {
        this.$message.warning("请先登录后再喜欢设备");
        this.$router.push({
          path: "/login",
          query: { redirect: this.$route.fullPath }
        });
        return;
      }

      const payload = this.normalizeComputerDevice(this.selectedComputer);
      const wasFavorite = this.selectedComputerFavorite;

      this.favoriteDeviceLoading = true;
      try {
        if (wasFavorite) {
          await http.delete("/user-favorite-devices", { data: payload });
          this.favoriteDevices = this.favoriteDevices.filter(
            (device) => this.getFavoriteDeviceKey(device) !== this.getFavoriteDeviceKey(payload)
          );
          this.$message.success("已取消喜欢");
        } else {
          await http.post("/user-favorite-devices", payload);
          this.favoriteDevices = [
            ...this.favoriteDevices.filter(
              (device) => this.getFavoriteDeviceKey(device) !== this.getFavoriteDeviceKey(payload)
            ),
            payload
          ];
          this.$message.success("已加入我喜欢的设备");
        }
      } catch (error) {
        this.$message.error(wasFavorite ? "取消喜欢失败" : "喜欢设备失败");
      } finally {
        this.favoriteDeviceLoading = false;
      }
    },
    openComputerDetail(computer, event) {
      if (event && event.currentTarget) {
        const rect = event.currentTarget.getBoundingClientRect();
        this.detailOrigin = {
          x: ((rect.left + rect.width / 2) / window.innerWidth) * 100,
          y: ((rect.top + rect.height / 2) / window.innerHeight) * 100,
        };
      }

      this.selectedComputer = computer;
    },
    closeComputerDetail() {
      this.selectedComputer = null;
    },
  },
};
</script>

<style scoped>
.computer-zone {
  width: min(1180px, 100%);
  margin: 0 auto;
  padding-top: 8px;
  color: #152033;
}

.page-heading {
  margin-bottom: 18px;
}

.page-heading h1 {
  margin: 0;
  color: #101827;
  font-size: 42px;
  line-height: 1.15;
  font-weight: 800;
}

.brand-hero,
.brand-card {
  border: 1px solid rgba(219, 231, 243, 0.72);
  background: rgba(255, 255, 255, 0.58);
  box-shadow: 0 18px 50px rgba(45, 73, 112, 0.1);
  backdrop-filter: blur(18px) saturate(150%);
  -webkit-backdrop-filter: blur(18px) saturate(150%);
}

.brand-hero {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 28px;
  padding: 24px;
  border-radius: 8px;
}

.brand-hero h2,
.section-head h2 {
  margin: 0;
  font-size: 24px;
  line-height: 1.2;
}

.search-box,
.model-search {
  flex: 0 0 320px;
  display: grid;
  gap: 8px;
  color: #5f6f86;
  font-size: 13px;
}

.search-box input,
.model-search input {
  width: 100%;
  height: 42px;
  padding: 0 14px;
  border: 1px solid #cbd8e6;
  border-radius: 8px;
  color: #152033;
  font-size: 14px;
  outline: none;
}

.search-box input:focus,
.model-search input:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

.brand-grid,
.model-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
  margin-top: 18px;
}

.brand-card {
  position: relative;
  min-height: 178px;
  padding: 28px 20px;
  border-radius: 8px;
  cursor: pointer;
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}

.brand-card:hover,
.brand-card:focus,
.brand-card.active {
  border-color: #2563eb;
  box-shadow: 0 20px 44px rgba(45, 73, 112, 0.15);
  outline: none;
  transform: translateY(-2px);
}

.brand-mark {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 84px;
  height: 72px;
  margin: 0 auto;
  border-radius: 8px;
  color: #fff;
  font-size: 16px;
  font-weight: 800;
}

.brand-card h2 {
  margin: 18px 0 0;
  font-size: 22px;
  text-align: center;
}

.model-section {
  margin-top: 18px;
}

.model-control-panel {
  margin-bottom: 20px;
  padding: 24px;
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 18px 50px rgba(45, 73, 112, 0.08);
}

.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 20px;
}

.model-filters {
  display: grid;
  gap: 14px;
}

.filter-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.filter-title {
  flex: 0 0 54px;
  color: #5f6f86;
  font-size: 13px;
  font-weight: 700;
}

.filter-chip {
  min-height: 34px;
  padding: 0 13px;
  border: 1px solid #d6e1ee;
  border-radius: 8px;
  background: #fff;
  color: #43546b;
  cursor: pointer;
}

.filter-chip.active,
.filter-chip:hover {
  border-color: #2563eb;
  background: #2563eb;
  color: #fff;
}

.model-card,
.brand-computer-card {
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 12px 28px rgba(45, 73, 112, 0.06);
  cursor: pointer;
  overflow: hidden;
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}

.model-card {
  min-height: 364px;
  padding: 16px;
}

.model-card:hover,
.model-card:focus,
.brand-computer-card:hover,
.brand-computer-card:focus {
  border-color: #2563eb;
  box-shadow: 0 18px 38px rgba(45, 73, 112, 0.14);
  outline: none;
  transform: translateY(-2px);
}

.model-card:active,
.brand-computer-card:active {
  transform: scale(0.97);
}

.computer-visual {
  --accent-color: #2563eb;
  display: grid;
  place-items: center;
  min-height: 170px;
  border-radius: 8px;
  background: linear-gradient(135deg, rgba(37, 99, 235, 0.08), rgba(15, 23, 42, 0.08));
}

.screen {
  width: 78%;
  aspect-ratio: 16 / 10;
  border: 8px solid #172033;
  border-radius: 8px;
  background:
    linear-gradient(135deg, color-mix(in srgb, var(--accent-color) 74%, #fff), #0f172a);
  box-shadow: 0 18px 28px rgba(15, 23, 42, 0.18);
}

.base {
  width: 52%;
  height: 10px;
  border-radius: 0 0 12px 12px;
  background: #94a3b8;
}

.computer-visual--compact {
  min-height: 128px;
}

.model-card h3 {
  min-height: 48px;
  margin: 16px 0 14px;
  color: #152033;
  font-size: 18px;
  line-height: 1.35;
}

.model-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  padding: 10px 0;
  border-top: 1px solid #eef3f8;
}

.model-meta span {
  color: #8090a6;
  font-size: 13px;
}

.model-meta strong {
  color: #253247;
  font-size: 14px;
  text-align: right;
}

.empty-state {
  grid-column: 1 / -1;
  padding: 42px;
  border: 1px dashed #b9c8da;
  border-radius: 8px;
  background: #f8fbff;
  color: #6b7a90;
  text-align: center;
}

.brand-modal-overlay,
.detail-overlay {
  position: fixed;
  inset: 0;
  z-index: 1450;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgba(15, 23, 42, 0.52);
}

.detail-overlay {
  z-index: 1500;
}

.brand-modal-panel,
.detail-panel {
  width: min(980px, 100%);
  max-height: calc(100vh - 48px);
  overflow: auto;
  padding: 24px;
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 24px 80px rgba(15, 23, 42, 0.24);
}

.detail-panel {
  width: min(820px, 100%);
  display: grid;
  grid-template-columns: minmax(260px, 0.9fr) minmax(0, 1fr);
  gap: 28px;
  transform-origin: var(--detail-origin-x) var(--detail-origin-y);
}

.modal-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}

.modal-head p,
.detail-brand {
  margin: 0 0 6px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
}

.modal-head h2,
.detail-content h2 {
  margin: 0;
  color: #101827;
  font-size: 24px;
}

.modal-close,
.detail-close {
  min-height: 36px;
  padding: 0 14px;
  border: 1px solid #d6e1ee;
  border-radius: 8px;
  background: #fff;
  color: #43546b;
  cursor: pointer;
}

.detail-close {
  position: absolute;
  right: 14px;
  top: 14px;
  width: 34px;
  padding: 0;
  font-size: 24px;
  line-height: 1;
}

.modal-close:hover,
.detail-close:hover {
  border-color: #2563eb;
  color: #2563eb;
}

.brand-computer-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}

.brand-computer-body {
  padding: 12px;
}

.brand-computer-body h3 {
  min-height: 44px;
  margin: 0 0 8px;
  color: #152033;
  font-size: 15px;
  line-height: 1.35;
}

.brand-computer-body p {
  min-height: 38px;
  margin: 0 0 8px;
  color: #8090a6;
  font-size: 13px;
  line-height: 1.45;
}

.brand-computer-body strong {
  color: #253247;
  font-size: 14px;
}

.detail-visual {
  min-height: 320px;
}

.detail-content {
  min-width: 0;
  padding: 16px 10px 10px 0;
}

.detail-content h2 {
  margin: 0 40px 24px 0;
  font-size: 28px;
  line-height: 1.25;
}

.device-favorite-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 112px;
  height: 38px;
  margin-bottom: 18px;
  padding: 0 16px;
  border: 1px solid #d6e1ee;
  border-radius: 8px;
  color: #2563eb;
  background: #fff;
  cursor: pointer;
  font: inherit;
  font-weight: 800;
  transition: border-color 0.2s ease, color 0.2s ease, background 0.2s ease, transform 0.2s ease;
}

.device-favorite-button:hover:not(:disabled) {
  border-color: #2563eb;
  transform: translateY(-1px);
}

.device-favorite-button.active {
  color: #111827;
  border-color: #ffd60a;
  background: #ffd60a;
}

.device-favorite-button:disabled {
  cursor: not-allowed;
  opacity: 0.65;
}

.detail-list {
  display: grid;
  gap: 12px;
  margin: 0;
}

.detail-list div {
  padding: 14px 0;
  border-top: 1px solid #eef3f8;
}

.detail-list dt {
  margin-bottom: 6px;
  color: #8090a6;
  font-size: 13px;
}

.detail-list dd {
  margin: 0;
  color: #253247;
  font-size: 16px;
  font-weight: 700;
}

.brand-modal-enter-active,
.brand-modal-leave-active,
.computer-detail-enter-active,
.computer-detail-leave-active {
  transition: opacity 0.28s ease;
}

.brand-modal-enter-active .brand-modal-panel,
.computer-detail-enter-active .detail-panel {
  animation: modal-open 0.34s cubic-bezier(0.2, 1, 0.22, 1) both;
}

.brand-modal-leave-active .brand-modal-panel,
.computer-detail-leave-active .detail-panel {
  animation: modal-close 0.2s cubic-bezier(0.4, 0, 0.2, 1) both;
}

.brand-modal-enter-from,
.brand-modal-leave-to,
.computer-detail-enter-from,
.computer-detail-leave-to {
  opacity: 0;
}

@keyframes modal-open {
  0% {
    opacity: 0;
    transform: translate3d(0, 18px, 0) scale(0.94);
  }

  100% {
    opacity: 1;
    transform: translate3d(0, 0, 0) scale(1);
  }
}

@keyframes modal-close {
  0% {
    opacity: 1;
    transform: translate3d(0, 0, 0) scale(1);
  }

  100% {
    opacity: 0;
    transform: translate3d(0, 10px, 0) scale(0.96);
  }
}

@media (max-width: 980px) {
  .brand-hero,
  .section-head {
    align-items: stretch;
    flex-direction: column;
  }

  .search-box,
  .model-search {
    flex: none;
  }

  .brand-grid,
  .model-grid,
  .brand-computer-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .page-heading h1 {
    font-size: 28px;
  }

  .brand-hero,
  .model-control-panel {
    padding: 24px;
  }

  .brand-grid,
  .model-grid,
  .brand-computer-grid {
    grid-template-columns: 1fr;
  }

  .filter-title {
    flex-basis: 100%;
  }

  .brand-modal-overlay,
  .detail-overlay {
    align-items: flex-end;
    padding: 14px;
  }

  .brand-modal-panel,
  .detail-panel {
    max-height: calc(100vh - 28px);
    padding: 20px;
  }

  .detail-panel {
    grid-template-columns: 1fr;
    gap: 18px;
  }

  .modal-head {
    align-items: flex-start;
    flex-direction: column;
  }

  .detail-visual {
    min-height: 240px;
  }

  .detail-content {
    padding: 0;
  }

  .detail-content h2 {
    font-size: 22px;
  }
}
</style>
