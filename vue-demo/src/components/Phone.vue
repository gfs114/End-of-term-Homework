<!-- 注：img图片放在 src下的assets里面
例子： image: require("@/assets/phone_image/mate70pro.jpg") 
-->
<template>
  <section class="phone-zone">
    <header class="page-heading">
      <h1>手机专区</h1>
    </header>

    <section class="brand-hero" aria-label="手机品牌专区">
      <div>
        <h2>品牌专区</h2>
      </div>

      <label class="search-box">
        <span>搜索品牌</span>
        <input v-model.trim="brandKeyword" type="search" placeholder="例如：华为、小米、Apple、三星" />
      </label>
    </section>

    <section class="brand-grid" aria-label="主流手机品牌列表">
      <article v-for="brand in filteredBrands" :key="brand.name"
        :class="['brand-card', { active: selectedBrand && selectedBrand.name === brand.name }]" tabindex="0"
        role="button" @click="selectBrand(brand)" @keyup.enter="selectBrand(brand)"
        @keyup.space.prevent="selectBrand(brand)">
        <div class="brand-top">
          <span class="brand-mark">
            <img :src="brand.img" :alt="brand.name" class="brand-logo" />
          </span>
        </div>

        <h2>{{ brand.name }}</h2>
      </article>

      <div v-if="filteredBrands.length === 0" class="empty-state">
        暂未找到匹配品牌，请换个关键词试试。
      </div>
    </section>

    <section ref="modelSection" :class="[
      'model-section',
      { 'model-section--animating': modelSectionAnimating },
    ]" aria-label="详细手机型号">
      <div class="model-control-panel">
        <div class="section-head">
          <div>
            <h2>详细手机型号</h2>
          </div>

          <label class="model-search">
            <span>搜索机型或处理器</span>
            <input v-model.trim="modelKeyword" type="search" placeholder="例如：小米 15、A18、骁龙" />
          </label>
        </div>

        <div class="model-filters" aria-label="机型筛选条件">
          <div class="filter-row">
            <span class="filter-title">品牌</span>
            <button v-for="brand in modelBrandOptions" :key="brand" type="button"
              :class="['filter-chip', { active: modelFilters.brand === brand }]"
              @click="setModelFilter('brand', brand)">
              {{ brand }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">处理器</span>
            <button v-for="processor in processorOptions" :key="processor" type="button" :class="[
              'filter-chip',
              { active: modelFilters.processor === processor },
            ]" @click="setModelFilter('processor', processor)">
              {{ processor }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">价格</span>
            <button v-for="price in priceOptions" :key="price.label" type="button" :class="[
              'filter-chip',
              { active: modelFilters.price === price.label },
            ]" @click="setModelFilter('price', price.label)">
              {{ price.label }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">电池</span>
            <button v-for="battery in batteryOptions" :key="battery.label" type="button" :class="[
              'filter-chip',
              { active: modelFilters.battery === battery.label },
            ]" @click="setModelFilter('battery', battery.label)">
              {{ battery.label }}
            </button>
          </div>
        </div>
      </div>

      <div class="model-grid">
        <article v-for="(phone, index) in paginatedPhoneModels" :key="phone.model" class="model-card"
          :style="modelCardAnimationStyle(index)" tabindex="0" role="button" @click="openPhoneDetail(phone, $event)"
          @keyup.enter="openPhoneDetail(phone, $event)" @keyup.space.prevent="openPhoneDetail(phone, $event)">
          <div class="model-image">
            <img :src="phone.image" :alt="phone.model" />
          </div>
          <h3>{{ phone.model }}</h3>
          <div class="model-meta">
            <span>处理器</span>
            <strong>{{ phone.processor }}</strong>
          </div>
          <div class="model-meta">
            <span>电池容量</span>
            <strong>{{ phone.battery }}</strong>
          </div>
          <div class="model-meta">
            <span>价格</span>
            <strong>{{ phone.price }}</strong>
          </div>
        </article>
      </div>

      <div v-if="totalModelPages > 1" class="model-pagination">
        <button type="button" :disabled="currentModelPage === 1" @click="setModelPage(currentModelPage - 1)">
          上一页
        </button>
        <button v-for="page in totalModelPages" :key="page" type="button" :class="{ active: currentModelPage === page }"
          @click="setModelPage(page)">
          {{ page }}
        </button>
        <button type="button" :disabled="currentModelPage === totalModelPages"
          @click="setModelPage(currentModelPage + 1)">
          下一页
        </button>
      </div>

      <div v-if="filteredPhoneModels.length === 0" class="empty-state">
        暂未找到匹配机型，请换个关键词试试。
      </div>
    </section>

    <transition name="phone-detail">
      <div v-if="selectedPhone" class="phone-detail-overlay" :style="phoneDetailVars" @click.self="closePhoneDetail">
        <section class="phone-detail-panel" aria-label="手机详情">
          <button type="button" class="phone-detail-close" aria-label="关闭详情" @click="closePhoneDetail">
            ×
          </button>

          <div class="phone-detail-image">
            <img v-if="selectedPhone.image" :src="selectedPhone.image" :alt="selectedPhone.model" />
            <span v-else>{{ selectedPhone.model }}</span>
          </div>

          <div class="phone-detail-content">
            <p class="phone-detail-brand">{{ selectedPhone.brand }}</p>
            <h2>{{ selectedPhone.model }}</h2>

            <button
              type="button"
              :class="['device-favorite-button', { active: selectedPhoneFavorite }]"
              :disabled="favoriteDeviceLoading"
              @click="toggleFavoritePhone"
            >
              {{ selectedPhoneFavorite ? '已喜欢' : '喜欢设备' }}
            </button>

            <dl class="phone-detail-list">
              <div>
                <dt>处理器</dt>
                <dd>{{ selectedPhone.processor }}</dd>
              </div>
              <div>
                <dt>电池容量</dt>
                <dd>{{ selectedPhone.battery }}</dd>
              </div>
              <div>
                <dt>价格</dt>
                <dd>{{ selectedPhone.price }}</dd>
              </div>
            </dl>
          </div>
        </section>
      </div>
    </transition>

    <transition name="brand-modal">
      <div v-if="selectedBrand" class="brand-modal-overlay" @click.self="clearSelectedBrand">
        <section class="brand-modal-panel" aria-label="品牌手机弹窗">
          <div class="brand-showcase-head">
            <div>
              <p>品牌手机</p>
              <h2>{{ selectedBrand.name }}</h2>
            </div>
            <button type="button" class="brand-showcase-close" @click="clearSelectedBrand">关闭</button>
          </div>

          <div v-if="selectedBrandPhones.length" class="brand-phone-grid">
            <article v-for="phone in selectedBrandPhones" :key="phone.model" class="brand-phone-card" tabindex="0"
              role="button" @click="openPhoneDetail(phone, $event)" @keyup.enter="openPhoneDetail(phone, $event)"
              @keyup.space.prevent="openPhoneDetail(phone, $event)">
              <div class="brand-phone-image">
                <img v-if="phone.image" :src="phone.image" :alt="phone.model" />
                <span v-else>{{ phone.model }}</span>
              </div>
              <div class="brand-phone-body">
                <h3>{{ phone.model }}</h3>
                <p>{{ phone.processor }}</p>
                <strong>{{ phone.price }}</strong>
              </div>
            </article>
          </div>

          <div v-else class="empty-state">
            该品牌暂未收录手机型号。
          </div>
        </section>
      </div>
    </transition>

    <AiAssistant
      page-type="phone"
      title="手机 AI 选购助手"
      eyebrow="手机推荐"
      welcome="你好，我可以按预算、品牌、处理器、电池和使用场景帮你推荐手机。"
      placeholder="例如：预算 5000，想买拍照好的手机"
      :suggestions="phoneAiSuggestions"
      :context="phoneAiContext"
    />
  </section>
</template>

<script>
import http from '@/utils/http'
import AiAssistant from '@/components/AiAssistant.vue'

export default {
  name: "Phone",
  components: {
    AiAssistant
  },
  data() {
    return {
      brandKeyword: "",
      modelKeyword: "",
      currentModelPage: 1,
      modelPageSize: 21,
      modelSectionAnimating: false,
      modelSectionVisible: false,
      modelSectionObserver: null,
      modelSectionTimer: null,
      selectedBrand: null,
      selectedPhone: null,
      favoriteDevices: [],
      favoriteDeviceLoading: false,
      detailOrigin: {
        x: 50,
        y: 50,
      },
      modelFilters: {
        brand: "全部",
        processor: "全部",
        price: "全部",
        battery: "全部",
      },
      priceOptions: [
        { label: "全部", min: 0, max: Infinity },
        { label: "4000 以下", min: 0, max: 3999 },
        { label: "4000-5999", min: 4000, max: 5999 },
        { label: "6000 以上", min: 6000, max: Infinity },
      ],
      batteryOptions: [
        { label: "全部", min: 0 },
        { label: "3000mAh 以上", min: 3000 },
        { label: "4000mAh 以上", min: 4000 },
        { label: "5000mAh 以上", min: 5000 },
        { label: "6000mAh 以上", min: 6000 },
      ],
      brands: [
        {
          name: "华为",
          subBrands: [],
          color: "linear-gradient(135deg, #ef4444, #f97316)",
          img: require("@/assets/brand_icon/HUAWEI.png"),
        },
        {
          name: "小米",
          subBrands: ["红米"],
          color: "linear-gradient(135deg, #f97316, #facc15)",
          img: require("@/assets/brand_icon/Xiaomi.png"),
        },
        {
          name: "OPPO",
          subBrands: ["一加", "realme"],
          color: "linear-gradient(135deg, #16a34a, #22c55e)",
          img: require("@/assets/brand_icon/OPPO.svg"),
        },
        {
          name: "vivo",
          subBrands: ["iQOO"],
          color: "linear-gradient(135deg, #2563eb, #38bdf8)",
          img: require("@/assets/brand_icon/Vivo.png"),
        },
        {
          name: "荣耀",
          subBrands: [],
          color: "linear-gradient(135deg, #0f172a, #64748b)",
          img: require("@/assets/brand_icon/Honor.png"),
        },
        {
          name: "魅族",
          subBrands: [],
          color: "linear-gradient(135deg, #14b8a6, #0ea5e9)",
          img: require("@/assets/brand_icon/MEIZU.png"),
        },
        {
          name: "中兴",
          subBrands: ["努比亚", "红魔"],
          color: "linear-gradient(135deg, #1d4ed8, #4f46e5)",
          img: require("@/assets/brand_icon/ZTE.png"),
        },
        {
          name: "Apple",
          subBrands: [],
          color: "linear-gradient(135deg, #111827, #6b7280)",
          img: require("@/assets/brand_icon/Apple.png"),
        },
        {
          name: "三星",
          subBrands: [],
          color: "linear-gradient(135deg, #1d4ed8, #60a5fa)",
          img: require("@/assets/brand_icon/Samsung.png"),
        },
      ],
      phoneModels: [
        {
          brand: "华为",
          model: "HUAWEI Mate 60",
          processor: "麒麟9000S",
          battery: "4750mAh",
          batteryValue: 4750,
          price: "¥4999 起",
          priceValue: 4999,
          image: require("@/assets/phone_image/Mate60.jpg"),
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 60 Pro",
          processor: "麒麟9000S",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥5699 起",
          priceValue: 5699,
          image: require("@/assets/phone_image/Mate60 Pro.jpg"),
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 60 Pro+",
          processor: "麒麟9000S",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥7999 起",
          priceValue: 7999,
          image: require("@/assets/phone_image/Mate60Pro+.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 60 RS 非凡大师",
          processor: "麒麟9000S",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥11999 起",
          priceValue: 11999,
          image: require("@/assets/phone_image/Mate60RS.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 70",
          processor: "麒麟9010",
          battery: "5300mAh",
          batteryValue: 5300,
          price: "¥5499 起",
          priceValue: 5499,
          image: require("@/assets/phone_image/Mate 70.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 70 Pro",
          processor: "麒麟9020",
          battery: "5500mAh",
          batteryValue: 5500,
          price: "¥6499 起",
          priceValue: 6499,
          image: require("@/assets/phone_image/mate70pro.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 70 RS 非凡大师",
          processor: "麒麟9020",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥11999 起",
          priceValue: 11999,
          image: require("@/assets/phone_image/Mate70RS.png")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80",
          processor: "麒麟9020",
          battery: "5750mAh",
          batteryValue: 5750,
          price: "¥4699 起",
          priceValue: 4699,
          image: require("@/assets/phone_image/Mate 80.png")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80 Pro",
          processor: "麒麟9030 / 麒麟9030 Pro",
          battery: "5750mAh",
          batteryValue: 5750,
          price: "¥5999 起",
          priceValue: 5999,
          image: require("@/assets/phone_image/Mate 80 Pro.png")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80 Pro Max",
          processor: "麒麟9030 Pro",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥6999 起",
          priceValue: 6999,
          image: require("@/assets/phone_image/Mate 80 Pro Max.png")
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80 RS 非凡大师",
          processor: "麒麟9030 Pro",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥11999 起",
          priceValue: 11999,
          image: require("@/assets/phone_image/Mate80RS.png")
        },

        {
          brand: "华为",
          model: "HUAWEI P60",
          processor: "骁龙8+ Gen1",
          battery: "4815mAh",
          batteryValue: 4815,
          price: "¥4488 起",
          priceValue: 4488,
          image: require("@/assets/phone_image/P60.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI P60 Pro",
          processor: "骁龙8+ Gen1",
          battery: "4815mAh",
          batteryValue: 4815,
          price: "¥6188 起",
          priceValue: 6188,
          image: require("@/assets/phone_image/P60Pro.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI P60 Art",
          processor: "骁龙8+ Gen1",
          battery: "5060mAh",
          batteryValue: 5060,
          price: "¥8988 起",
          priceValue: 8988,
          image: require("@/assets/phone_image/P60Art.jpg")
        },

        {
          brand: "华为",
          model: "HUAWEI Pura 70",
          processor: "麒麟9010",
          battery: "4900mAh",
          batteryValue: 4900,
          price: "¥4999 起",
          priceValue: 4999,
          image: require("@/assets/phone_image/Pura70.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 70 Pro",
          processor: "麒麟9020",
          battery: "5050mAh",
          batteryValue: 5050,
          price: "¥5999 起",
          priceValue: 5999,
          image: require("@/assets/phone_image/Pura70Pro.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 70 Pro+",
          processor: "麒麟9020",
          battery: "5050mAh",
          batteryValue: 5050,
          price: "¥7499 起",
          priceValue: 7499,
          image: require("@/assets/phone_image/Pura70Pro+.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 70 Ultra",
          processor: "麒麟9020",
          battery: "5200mAh",
          batteryValue: 5200,
          price: "¥9999 起",
          priceValue: 9999,
          image: require("@/assets/phone_image/Pura70Ultra.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80",
          processor: "官网未标注",
          battery: "5600mAh",
          batteryValue: 5600,
          price: "¥5299 起",
          priceValue: 5299,
          image: require("@/assets/phone_image/Pura80.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80 Pro",
          processor: "麒麟9020",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥6299 起",
          priceValue: 6299,
          image: require("@/assets/phone_image/Pura80Pro.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80 Pro+",
          processor: "麒麟9020",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥7699 起",
          priceValue: 7699,
          image: require("@/assets/phone_image/Pura80Pro+.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80 Ultra",
          processor: "麒麟9020",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥10999 起",
          priceValue: 10999,
          image: require("@/assets/phone_image/Pura80Ultra.jpg")
        },

        // Pura 90 系列
        {
          brand: "华为",
          model: "HUAWEI Pura 90",
          processor: "麒麟9010S",
          battery: "6500mAh",
          batteryValue: 6500,
          price: "¥5599 起",
          priceValue: 5599,
          image: require("@/assets/phone_image/Pura90.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 90 Pro",
          processor: "麒麟9030S",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥6599 起",
          priceValue: 6599,
          image: require("@/assets/phone_image/Pura90Pro.jpg")
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 90 Pro Max",
          processor: "麒麟9030S",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥7999 起",
          priceValue: 7999,
          image: require("@/assets/phone_image/Pura90ProMax.jpg")
        },
        //小米
        {
          brand: "小米",
          model: "小米  17",
          processor: "骁龙 8Elite Gen5",
          battery: "7100mAh",
          batteryValue: 6100,
          price: "¥4,499 起",
          priceValue: 4499,
          image: require("@/assets/phone_image/xm17.jpg"),
        },
        {
          brand: "小米",
          model: "小米 17 Pro",
          processor: "骁龙 8Elite Gen5",
          battery: "6300mAh",
          batteryValue: 6300,
          price: "¥5,299 起",
          priceValue: 5299,
          image: require("@/assets/phone_image/xm17Pro.jpg"),
        },
        {
          brand: "小米",
          model: "小米 17 Pro Max",
          processor: "骁龙 8Elite Gen5",
          battery: "7500mAh",
          batteryValue: 7500,
          price: "¥5,999 起",
          priceValue: 5999,
          image: require("@/assets/phone_image/xm17ProMax.jpg"),
        },
        {
          brand: "小米",
          model: "小米 17 Max",
          processor: "骁龙 8Elite Gen5",
          battery: "8000mAh",
          batteryValue: 8000,
          price: "暂未开售",
          priceValue: null,
          image: require("@/assets/phone_image/xm17Max.jpg"),
        },
        {
          brand: "小米",
          model: "小米 17 Ultra",
          processor: "骁龙 8Elite Gen5",
          battery: "6800mAh",
          batteryValue: 6800,
          price: "¥6,999 起",
          priceValue: 6999,
          image: require("@/assets/phone_image/xm17Ultra.jpg"),
        },
        {
          brand: "小米",
          model: "小米 17 Ultra徕卡版",
          processor: "骁龙 8Elite Gen5",
          battery: "6800mAh",
          batteryValue: 6800,
          price: "¥7,499 起",
          priceValue: 7499,
          image: require("@/assets/phone_image/xm17Ultra For LEICA.png"),
        },
        {
          brand: "小米",
          model: "小米 15s Pro",
          processor: "Xring O1",
          battery: "6100mAh",
          batteryValue: 6100,
          price: "¥5,299 起",
          priceValue: 5299,
          image: require("@/assets/phone_image/xm15sPro.jpg"),
        },
        {
          brand: "小米",
          model: "小米 15 Pro",
          processor: "骁龙 8 至尊版",
          battery: "6100mAh",
          batteryValue: 6100,
          price: "¥5,299 起",
          priceValue: 5299,
          image: require("@/assets/phone_image/xm15Pro.jpg"),
        },
        {
          brand: "小米",
          model: "小米 15",
          processor: "骁龙 8 至尊版",
          battery: "5400mAh",
          batteryValue: 5400,
          price: "¥4,499 起",
          priceValue: 4499,
          image: require("@/assets/phone_image/xm15.jpg"),
        },
        {
          brand: "小米",
          model: "小米 14 Ultra",
          processor: "骁龙 8 Gen3",
          battery: "5300mAh",
          batteryValue: 5300,
          price: "¥6,499 起",
          priceValue: 6499,
          image: require("@/assets/phone_image/xm14Ultra.jpg"),
        },
        {
          brand: "小米",
          model: "小米 14 Pro",
          processor: "骁龙 8 Gen3",
          battery: "5400mAh",
          batteryValue: 5400,
          price: "¥4,999 起",
          priceValue: 4999,
          image: require("@/assets/phone_image/xm14Pro.jpg"),
        },
        {
          brand: "小米",
          model: "小米 14",
          processor: "骁龙 8 Gen3",
          battery: "4610mAh",
          batteryValue: 4610,
          price: "¥3,999 起",
          priceValue: 3999,
          image: require("@/assets/phone_image/xm14.jpg"),
        },
        {
          brand: "小米",
          model: "REDMI K90 Max",
          processor: "天玑9500",
          battery: "8550mAh",
          batteryValue: 8550,
          price: "¥3,499 起",
          priceValue: 3499,
          image: require("@/assets/phone_image/K90Max.jpg"),
        },
        {
          brand: "小米",
          model: "REDMI K90 Pro Max",
          processor: "骁龙 8 Elite Gen5",
          battery: "7500mAh",
          batteryValue: 7500,
          price: "¥3,999 起",
          priceValue: 3999,
          image: require("@/assets/phone_image/K90ProMax.jpg"),
        },
        {
          brand: "小米",
          model: "REDMI K90 ",
          processor: "骁龙 8 至尊版",
          battery: "7100mAh",
          batteryValue: 7100,
          price: "¥2,599 起",
          priceValue: 2599,
          image: require("@/assets/phone_image/K90.jpg"),
        },
        {
          brand: "小米",
          model: "Redmi K80 Ultra",
          processor: "天玑9400+",
          battery: "6500mAh",
          batteryValue: 6500,
          price: "¥2,599 起",
          priceValue: 2599,
          image: require("@/assets/phone_image/K80Ultra.jpg"),
        },
        {
          brand: "小米",
          model: "Redmi K80 Pro",
          processor: "骁龙 8 至尊版",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥3,699 起",
          priceValue: 3699,
          image: require("@/assets/phone_image/K80Pro.jpg"),
        },
        {
          brand: "小米",
          model: "Redmi K80",
          processor: "骁龙 8 Gen3",
          battery: "6550mAh",
          batteryValue: 6550,
          price: "¥2,599 起",
          priceValue: 2599,
          image: require("@/assets/phone_image/K80.jpg"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X9 Ultra",
          processor: "骁龙8 Elite Gen5",
          battery: "7050mAh",
          batteryValue: 7050,
          price: "¥7,499 起",
          priceValue: 7499,
          image: require("@/assets/phone_image/FindX9 Ultra.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X9s Pro",
          processor: "天玑 9500",
          battery: "7025mAh",
          batteryValue: 7025,
          price: "¥5,299 起",
          priceValue: 5299,
          image: require("@/assets/phone_image/FindX9s Pro.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find N6",
          processor: "骁龙8 Elite",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥9,999 起",
          priceValue: 9999,
          image: require("@/assets/phone_image/FindN6.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X9 Pro",
          processor: "天玑 9500",
          battery: "7500mAh",
          batteryValue: 7500,
          price: "¥4,799 起",
          priceValue: 4799,
          image: require("@/assets/phone_image/FindX9 Pro.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X9",
          processor: "天玑 9500",
          battery: "7500mAh",
          batteryValue: 7500,
          price: "¥3,999 起",
          priceValue: 3999,
          image: require("@/assets/phone_image/FindX9.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X8 Ultra",
          processor: "骁龙8 至尊版",
          battery: "6100mAh",
          batteryValue: 6100,
          price: "¥5,999 起",
          priceValue: 5999,
          image: require("@/assets/phone_image/FindX8 Ultra.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X8s+",
          processor: "天玑 9400+",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥3,619 起",
          priceValue: 3619,
          image: require("@/assets/phone_image/FindX8s+.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X8s",
          processor: "天玑 9400+",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥3,399 起",
          priceValue: 3399,
          image: require("@/assets/phone_image/FindX8s.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X8 Pro",
          processor: "天玑 9400",
          battery: "5910mAh",
          batteryValue: 5910,
          price: "¥5,299 起",
          priceValue: 5299,
          image: require("@/assets/phone_image/FindX8 Pro.png"),
        },
        {
          brand: "OPPO",
          model: "OPPO Find X8",
          processor: "天玑 9400",
          battery: "5630mAh",
          batteryValue: 5630,
          price: "¥3,399 起",
          priceValue: 3399,
          image: require("@/assets/phone_image/FindX8.png"),
        },
        {
          brand: "OPPO",
          model: "一加 15",
          processor: "骁龙 8Elite Gen5",
          battery: "7300mAh",
          batteryValue: 7300,
          price: "¥4,499 起",
          priceValue: 4499,
          image: require("@/assets/phone_image/1+15.png"),
        },
        {
          brand: "OPPO",
          model: "一加 13",
          processor: "骁龙 8 至尊版",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥4,499 起",
          priceValue: 4499,
          image: require("@/assets/phone_image/1+13.png"),
        },
        {
          brand: "OPPO",
          model: "一加 12",
          processor: "骁龙 8 Gen3",
          battery: "5400mAh",
          batteryValue: 5400,
          price: "¥4,299 起",
          priceValue: 4299,
          image: require("@/assets/phone_image/1+12.png"),
        },
        {
          brand: "vivo",
          model: "vivo X300 U;tra",
          processor: "骁龙 8Elite Gen5",
          battery: "6600mAh",
          batteryValue: 6600,
          price: "¥6,999 起",
          priceValue: 6999,
          image: require("@/assets/phone_image/X300Ultra.png"),
        },
        {
          brand: "vivo",
          model: "vivo X300 Pro",
          processor: "天玑 9500",
          battery: "6510mAh",
          batteryValue: 6510,
          price: "¥5,599 起",
          priceValue: 5599,
          image: require("@/assets/phone_image/X300Pro.png"),
        },
        {
          brand: "vivo",
          model: "vivo X300s",
          processor: "天玑 9500",
          battery: "7100mAh",
          batteryValue: 7100,
          price: "¥4,999 起",
          priceValue: 4999,
          image: require("@/assets/phone_image/X300s.png"),
        },
        {
          brand: "vivo",
          model: "vivo X300",
          processor: "天玑 9500",
          battery: "6040mAh",
          batteryValue: 6040,
          price: "¥4,599 起",
          priceValue: 4599,
          image: require("@/assets/phone_image/X300.png"),
        },
        {
          brand: "vivo",
          model: "iQOO 15",
          processor: "骁龙 8Elite Gen5",
          battery: "7000mAh",
          batteryValue: 7000,
          price: "¥4,599 起",
          priceValue: 4599,
          image: require("@/assets/phone_image/iQOO15.png"),
        },
        {
          brand: "vivo",
          model: "iQOO 13",
          processor: "骁龙 8 至尊版",
          battery: "6150mAh",
          batteryValue: 6150,
          price: "¥3,999 起",
          priceValue: 3999,
          image: require("@/assets/phone_image/iQOO13.png"),
        },
        {
          brand: "荣耀",
          model: "荣耀 Magic7 Pro",
          processor: "骁龙 8 至尊版",
          battery: "5850mAh",
          batteryValue: 5850,
          price: "¥5,699 起",
          priceValue: 5699,
          image: require("@/assets/phone_image/Magic7Pro.png"),
        },
        {
          brand: "魅族",
          model: "魅族 21 Pro",
          processor: "骁龙 8 Gen 3",
          battery: "5050mAh",
          batteryValue: 5050,
          price: "¥4,999 起",
          priceValue: 4999,
          image: require("@/assets/phone_image/MEIZU 21Pro.jpg"),
        },
        {
          brand: "Apple",
          model: "iPhone 17 Pro Max",
          processor: "A19 Pro",
          battery: "4823mAh",
          batteryValue: 4823,
          price: "¥9,999 起",
          priceValue: 9999,
          image: require("@/assets/phone_image/17ProMax.jpg"),
        },
        {
          brand: "Apple",
          model: "iPhone 17 Pro",
          processor: "A19 Pro",
          battery: "3988mAh",
          batteryValue: 3988,
          price: "¥8,999 起",
          priceValue: 8999,
          image: require("@/assets/phone_image/17Pro.jpg"),
        },
        {
          brand: "Apple",
          model: "iPhone Air",
          processor: "A19 Pro(5核CPU)",
          battery: "3036mAh",
          batteryValue: 3036,
          price: "¥7,999 起",
          priceValue: 7999,
          image: require("@/assets/phone_image/iPhone Air.jpg"),
        },
        {
          brand: "Apple",
          model: "iPhone 17",
          processor: "A19",
          battery: "3692mAh",
          batteryValue: 3692,
          price: "¥5,999 起",
          priceValue: 5999,
          image: require("@/assets/phone_image/17.jpg"),
        },
        {
          brand: "Apple",
          model: "iPhone 17e",
          processor: "A19(4核GPU)",
          battery: "4005mAh",
          batteryValue: 4005,
          price: "¥4,499 起",
          priceValue: 4499,
          image: require("@/assets/phone_image/17e.jpg"),
        },
        {
          brand: "Apple",
          model: "iPhone 16 Pro Max",
          processor: "A18Pro",
          battery: "4685mAh",
          batteryValue: 4685,
          price: "¥9,999 起",
          priceValue: 9999,
          image: require("@/assets/phone_image/16ProMax.png"),
        },
        {
          brand: "Apple",
          model: "iPhone 16 Pro",
          processor: "A18Pro",
          battery: "3582mAh",
          batteryValue: 3582,
          price: "¥8,999 起",
          priceValue: 8999,
          image: require("@/assets/phone_image/16Pro.png"),
        },
        {
          brand: "Apple",
          model: "iPhone 16Plus",
          processor: "A18",
          battery: "4674mAh",
          batteryValue: 4674,
          price: "¥5,999 起",
          priceValue: 5999,
          image: require("@/assets/phone_image/16Plus.png"),
        },
        {
          brand: "Apple",
          model: "iPhone 16",
          processor: "A18",
          battery: "3561mAh",
          batteryValue: 3561,
          price: "¥5,199 起",
          priceValue: 5199,
          image: require("@/assets/phone_image/16.jpg"),
        },
        {
          brand: "Apple",
          model: "iPhone 16e",
          processor: "A18",
          battery: "3561mAh",
          batteryValue: 3561,
          price: "¥4,499 起",
          priceValue: 4499,
          image: require("@/assets/phone_image/16e.png"),
        },
        {
          brand: "Apple",
          model: "iPhone 15 Pro Max",
          processor: "A17Pro",
          battery: "4422mAh",
          batteryValue: 4422,
          price: "¥9,999 起",
          priceValue: 9999,
          image: require("@/assets/phone_image/15ProMax.png"),
        },
        {
          brand: "Apple",
          model: "iPhone 15 Pro",
          processor: "A17Pro",
          battery: "3274mAh",
          batteryValue: 3274,
          price: "¥8,999 起",
          priceValue: 8999,
          image: require("@/assets/phone_image/15Pro.png"),
        },
        {
          brand: "Apple",
          model: "iPhone 15Plus",
          processor: "A16",
          battery: "4383mAh",
          batteryValue: 4383,
          price: "¥5,999 起",
          priceValue: 5999,
          image: require("@/assets/phone_image/15Plus.png"),
        },
        {
          brand: "Apple",
          model: "iPhone 15",
          processor: "A16",
          battery: "3349mAh",
          batteryValue: 3349,
          price: "¥5,199 起",
          priceValue: 5199,
          image: require("@/assets/phone_image/15.png"),
        },
        {
          brand: "三星",
          model: "Samsung Galaxy S26 Ultra",
          processor: "骁龙 8Elite Gen5 for Galaxy",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥9,999 起",
          priceValue: 9999,
          image: require("@/assets/phone_image/Galaxy-S26-Ultra.jpg"),
        },
        {
          brand: "三星",
          model: "Samsung Galaxy S26+",
          processor: "骁龙 8Elite Gen5 for Galaxy",
          battery: "4900mAh",
          batteryValue: 4900,
          price: "¥7,999 起",
          priceValue: 7999,
          image: require("@/assets/phone_image/S26.jpg"),
        },
        {
          brand: "三星",
          model: "Samsung Galaxy S26",
          processor: "骁龙 8Elite Gen5 for Galaxy",
          battery: "4300mAh",
          batteryValue: 4300,
          price: "¥5,999 起",
          priceValue: 5999,
          image:require("@/assets/phone_image/S26.jpg"),
        },
        {
          brand: "三星",
          model: "Samsung Galaxy S25 Ultra",
          processor: "骁龙 8 至尊版 for Galaxy",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥9,699 起",
          priceValue: 9699,
          image: require("@/assets/phone_image/S25Ultra.jpg"),
        },
      ],
    };
  },
  computed: {
    modelBrandOptions() {
      const brands = this.phoneModels.map((phone) => phone.brand);
      return ["全部"].concat(
        brands.filter((brand, index) => brands.indexOf(brand) === index)
      );
    },
    processorOptions() {
      const processors = this.phoneModels.map((phone) => phone.processor);
      return ["全部"].concat(
        processors.filter(
          (processor, index) => processors.indexOf(processor) === index
        )
      );
    },
    filteredBrands() {
      const keyword = this.brandKeyword.toLowerCase();

      return this.brands.filter((brand) => {
        const searchable = [brand.name, brand.subBrands.join(" ")]
          .join(" ")
          .toLowerCase();

        return !keyword || searchable.includes(keyword);
      });
    },
    selectedBrandPhones() {
      if (!this.selectedBrand) {
        return [];
      }

      return this.phoneModels.filter(
        (phone) => phone.brand === this.selectedBrand.name
      );
    },
    filteredPhoneModels() {
      const keyword = this.modelKeyword.toLowerCase();
      const priceRange = this.priceOptions.find(
        (price) => price.label === this.modelFilters.price
      );
      const batteryRange = this.batteryOptions.find(
        (battery) => battery.label === this.modelFilters.battery
      );

      return this.phoneModels.filter((phone) => {
        const searchable = [
          phone.brand,
          phone.model,
          phone.processor,
          phone.battery,
          phone.price,
        ]
          .join(" ")
          .toLowerCase();
        const matchesKeyword = !keyword || searchable.includes(keyword);
        const matchesBrand =
          this.modelFilters.brand === "全部" ||
          phone.brand === this.modelFilters.brand;
        const matchesProcessor =
          this.modelFilters.processor === "全部" ||
          phone.processor === this.modelFilters.processor;
        const matchesPrice =
          !priceRange ||
          (phone.priceValue >= priceRange.min &&
            phone.priceValue <= priceRange.max);
        const matchesBattery =
          !batteryRange || phone.batteryValue >= batteryRange.min;

        return (
          matchesKeyword &&
          matchesBrand &&
          matchesProcessor &&
          matchesPrice &&
          matchesBattery
        );
      });
    },
    totalModelPages() {
      return Math.max(
        1,
        Math.ceil(this.filteredPhoneModels.length / this.modelPageSize)
      );
    },
    paginatedPhoneModels() {
      const start = (this.currentModelPage - 1) * this.modelPageSize;
      return this.filteredPhoneModels.slice(start, start + this.modelPageSize);
    },
    phoneDetailVars() {
      return {
        "--detail-origin-x": `${this.detailOrigin.x}%`,
        "--detail-origin-y": `${this.detailOrigin.y}%`,
      };
    },
    phoneAiSuggestions() {
      return [
        "预算 3000 左右推荐哪几款？",
        "帮我选一台拍照好的手机",
        "游戏手机应该看哪些配置？"
      ];
    },
    phoneAiContext() {
      return {
        page: "phone",
        total: this.phoneModels.length,
        filters: this.modelFilters,
        visibleModels: this.filteredPhoneModels.slice(0, 12).map((phone) => ({
          brand: phone.brand,
          model: phone.model,
          processor: phone.processor,
          battery: phone.battery,
          price: phone.price
        }))
      };
    },
    selectedPhoneFavorite() {
      return this.isFavoriteDevice("phone", this.selectedPhone && this.selectedPhone.model);
    },
  },
  watch: {
    modelKeyword() {
      this.resetModelPage();
    },
    modelFilters: {
      deep: true,
      handler() {
        this.resetModelPage();
      },
    },
    totalModelPages(total) {
      if (this.currentModelPage > total) {
        this.currentModelPage = total;
      }
    },
  },
  mounted() {
    this.$nextTick(() => {
      this.observeModelSection();
    });
    this.fetchFavoriteDevices();
  },
  methods: {
    selectBrand(brand) {
      this.selectedBrand = brand;
    },
    clearSelectedBrand() {
      this.selectedBrand = null;
    },
    setModelFilter(key, value) {
      this.modelFilters[key] = value;
    },
    setModelPage(page) {
      if (page < 1 || page > this.totalModelPages) {
        return;
      }

      this.currentModelPage = page;
    },
    resetModelPage() {
      this.currentModelPage = 1;
    },
    observeModelSection() {
      if (!this.$refs.modelSection) {
        return;
      }

      if (!window.IntersectionObserver) {
        this.playModelSectionAnimation();
        return;
      }

      this.modelSectionObserver = new IntersectionObserver(
        (entries) => {
          const entry = entries[0];

          if (entry.isIntersecting && !this.modelSectionVisible) {
            this.modelSectionVisible = true;
            this.playModelSectionAnimation();
          }

          if (!entry.isIntersecting) {
            this.modelSectionVisible = false;
          }
        },
        {
          root: null,
          threshold: 0.18,
        }
      );

      this.modelSectionObserver.observe(this.$refs.modelSection);
    },
    playModelSectionAnimation() {
      window.clearTimeout(this.modelSectionTimer);

      this.modelSectionAnimating = false;

      this.$nextTick(() => {
        this.modelSectionAnimating = true;
        this.modelSectionTimer = window.setTimeout(() => {
          this.modelSectionAnimating = false;
        }, 900);
      });
    },
    modelCardAnimationStyle(index) {
      return {
        animationDelay: `${Math.min(index * 110, 660)}ms`,
      };
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
    normalizePhoneDevice(phone) {
      return {
        username: this.getUsername(),
        device_type: "phone",
        device_brand: phone.brand,
        device_model: phone.model,
        device_price: phone.price,
        device_specs: `处理器：${phone.processor || "暂无"}；电池：${phone.battery || "暂无"}`
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
    async toggleFavoritePhone() {
      if (!this.selectedPhone || this.favoriteDeviceLoading) {
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

      const payload = this.normalizePhoneDevice(this.selectedPhone);
      const wasFavorite = this.selectedPhoneFavorite;

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
    openPhoneDetail(phone, event) {
      if (event && event.currentTarget) {
        const rect = event.currentTarget.getBoundingClientRect();
        this.detailOrigin = {
          x: ((rect.left + rect.width / 2) / window.innerWidth) * 100,
          y: ((rect.top + rect.height / 2) / window.innerHeight) * 100,
        };
      }
      this.selectedPhone = phone;
    },
    closePhoneDetail() {
      this.selectedPhone = null;
    },
  },
  beforeUnmount() {
    window.clearTimeout(this.modelSectionTimer);

    if (this.modelSectionObserver) {
      this.modelSectionObserver.disconnect();
    }
  },
};
</script>

<style>
.phone-zone {
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

.eyebrow {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0;
  text-transform: uppercase;
}

.brand-hero h2 {
  margin: 0;
  font-size: 24px;
  line-height: 1.2;
}

.search-box {
  flex: 0 0 320px;
  display: grid;
  gap: 8px;
  color: #5f6f86;
  font-size: 13px;
}

.search-box input {
  width: 100%;
  height: 42px;
  padding: 0 14px;
  border: 1px solid #cbd8e6;
  border-radius: 8px;
  color: #152033;
  font-size: 14px;
  outline: none;
  box-sizing: border-box;
}

.search-box input:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

.brand-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
  margin-top: 18px;
}

.brand-card {
  position: relative;
  overflow: hidden;
  min-height: 178px;
  padding: 28px 20px;
  border-radius: 8px;
  box-sizing: border-box;
  cursor: pointer;
  transition: transform 0.18s ease, box-shadow 0.18s ease,
    border-color 0.18s ease;
}

.brand-card::before {
  content: "";
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: linear-gradient(135deg,
      rgba(255, 255, 255, 0.42),
      rgba(255, 255, 255, 0.08) 46%,
      rgba(37, 99, 235, 0.06));
}

.brand-card:hover,
.brand-card:focus,
.brand-card.active {
  border-color: #bfdbfe;
  box-shadow: 0 20px 44px rgba(45, 73, 112, 0.15);
  outline: none;
  transform: translateY(-2px);
}

.brand-card.active {
  border-color: #2563eb;
}

.brand-top {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.brand-mark {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 72px;
  height: 72px;
  border-radius: 8px;
  color: #fff;
  font-size: 20px;
  font-weight: 800;
}

.brand-logo {
  display: block;
  max-width: 56px;
  max-height: 56px;
  object-fit: contain;
}

.brand-card h2 {
  position: relative;
  z-index: 1;
  margin: 18px 0 0;
  font-size: 22px;
  text-align: center;
}

.brand-modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 1450;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgba(15, 23, 42, 0.52);
}

.brand-modal-panel {
  width: min(980px, 100%);
  max-height: calc(100vh - 48px);
  overflow: auto;
  padding: 24px;
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 24px 80px rgba(15, 23, 42, 0.24);
}

.brand-modal-enter-active,
.brand-modal-leave-active {
  transition: opacity 0.28s ease;
}

.brand-modal-enter-active .brand-modal-panel {
  animation: brand-modal-open 0.34s cubic-bezier(0.2, 1, 0.22, 1) both;
}

.brand-modal-leave-active .brand-modal-panel {
  animation: brand-modal-close 0.2s cubic-bezier(0.4, 0, 0.2, 1) both;
}

.brand-modal-enter-from,
.brand-modal-leave-to {
  opacity: 0;
}

.brand-showcase-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}

.brand-showcase-head p {
  margin: 0 0 6px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
}

.brand-showcase-head h2 {
  margin: 0;
  color: #101827;
  font-size: 24px;
}

.brand-showcase-close {
  min-height: 36px;
  padding: 0 14px;
  border: 1px solid #d6e1ee;
  border-radius: 8px;
  background: #fff;
  color: #43546b;
  cursor: pointer;
}

.brand-showcase-close:hover {
  border-color: #2563eb;
  color: #2563eb;
}

.brand-phone-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}

.brand-phone-card {
  min-width: 0;
  overflow: hidden;
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: #fff;
  cursor: pointer;
  box-shadow: 0 10px 24px rgba(45, 73, 112, 0.06);
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}

.brand-phone-card:hover,
.brand-phone-card:focus {
  border-color: #2563eb;
  box-shadow: 0 16px 32px rgba(45, 73, 112, 0.14);
  outline: none;
  transform: translateY(-2px);
}

.brand-phone-card:active {
  transform: scale(0.97);
}

.brand-phone-image {
  width: 100%;
  aspect-ratio: 4 / 3;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: #eef3f8;
}

.brand-phone-image img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.brand-phone-image span {
  padding: 16px;
  color: #5f6f86;
  font-weight: 700;
  text-align: center;
}

.brand-phone-body {
  padding: 12px;
}

.brand-phone-body h3 {
  min-height: 44px;
  margin: 0 0 8px;
  color: #152033;
  font-size: 15px;
  line-height: 1.35;
}

.brand-phone-body p {
  min-height: 38px;
  margin: 0 0 8px;
  color: #8090a6;
  font-size: 13px;
  line-height: 1.45;
}

.brand-phone-body strong {
  color: #253247;
  font-size: 14px;
}

.model-section {
  margin-top: 18px;
  scroll-margin-top: 18px;
}

.model-section--animating .model-control-panel {
  animation: model-section-rise 0.8s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.model-control-panel {
  margin-bottom: 20px;
  padding: 24px;
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 18px 50px rgba(45, 73, 112, 0.08);
}

.section-head h2 {
  margin: 0;
  font-size: 24px;
}

.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 20px;
}

.section-head>div {
  text-align: left;
}

.model-search {
  flex: 0 0 320px;
  display: grid;
  gap: 8px;
  color: #5f6f86;
  font-size: 13px;
}

.model-search input {
  width: 100%;
  height: 42px;
  padding: 0 14px;
  border: 1px solid #cbd8e6;
  border-radius: 8px;
  color: #152033;
  font-size: 14px;
  outline: none;
  box-sizing: border-box;
}

.model-search input:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
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

.model-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

.model-card {
  min-height: 348px;
  padding: 16px;
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: #ffffff;
  box-shadow: 0 12px 28px rgba(45, 73, 112, 0.06);
  box-sizing: border-box;
  cursor: pointer;
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}

.model-card:hover,
.model-card:focus {
  border-color: #2563eb;
  box-shadow: 0 18px 38px rgba(45, 73, 112, 0.14);
  outline: none;
  transform: translateY(-2px);
}

.model-card:active {
  transform: translateY(0) scale(0.96);
  transition-duration: 0.08s;
}

.model-section--animating .model-card {
  animation: model-card-fade-up 0.72s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.model-pagination {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-top: 22px;
}

.model-pagination button {
  min-width: 38px;
  min-height: 36px;
  padding: 0 13px;
  border: 1px solid #d6e1ee;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.9);
  color: #43546b;
  cursor: pointer;
}

.model-pagination button.active,
.model-pagination button:hover:not(:disabled) {
  border-color: #2563eb;
  background: #2563eb;
  color: #fff;
}

.model-pagination button:disabled {
  cursor: not-allowed;
  opacity: 0.48;
}

.model-image {
  width: 100%;
  aspect-ratio: 16 / 10;
  overflow: hidden;
  border-radius: 8px;
  background: #eef3f8;
}

.model-image img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
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
  flex: 0 0 auto;
  color: #8090a6;
  font-size: 13px;
}

.model-meta strong {
  color: #253247;
  font-size: 14px;
  font-weight: 700;
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

.model-section .empty-state {
  margin-top: 16px;
}

.phone-detail-overlay {
  position: fixed;
  inset: 0;
  z-index: 1500;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgba(15, 23, 42, 0.52);
}

.phone-detail-enter-active,
.phone-detail-leave-active {
  transition: background 0.32s ease, opacity 0.32s ease;
}

.phone-detail-enter-active .phone-detail-panel {
  animation: phone-detail-open 0.44s cubic-bezier(0.2, 1, 0.22, 1) both;
}

.phone-detail-leave-active .phone-detail-panel {
  animation: phone-detail-close 0.24s cubic-bezier(0.4, 0, 0.2, 1) both;
}

.phone-detail-enter-from,
.phone-detail-leave-to {
  opacity: 0;
  background: rgba(15, 23, 42, 0);
}

.phone-detail-panel {
  position: relative;
  width: min(820px, 100%);
  max-height: calc(100vh - 48px);
  display: grid;
  grid-template-columns: minmax(260px, 0.9fr) minmax(0, 1fr);
  gap: 28px;
  overflow: auto;
  padding: 28px;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 24px 80px rgba(15, 23, 42, 0.24);
  transform-origin: var(--detail-origin-x) var(--detail-origin-y);
  will-change: transform, opacity;
}

.phone-detail-close {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 34px;
  height: 34px;
  border: 1px solid #dbe7f3;
  border-radius: 8px;
  background: #fff;
  color: #43546b;
  cursor: pointer;
  font-size: 24px;
  line-height: 1;
}

.phone-detail-close:hover {
  border-color: #2563eb;
  color: #2563eb;
}

.phone-detail-image {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 320px;
  overflow: hidden;
  border-radius: 8px;
  background: #eef3f8;
}

.phone-detail-image img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.phone-detail-image span {
  padding: 24px;
  color: #5f6f86;
  font-weight: 700;
  text-align: center;
}

.phone-detail-content {
  min-width: 0;
  padding: 16px 10px 10px 0;
}

.phone-detail-brand {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 14px;
  font-weight: 700;
}

.phone-detail-content h2 {
  margin: 0 36px 24px 0;
  color: #101827;
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

.phone-detail-list {
  display: grid;
  gap: 12px;
  margin: 0;
}

.phone-detail-list div {
  padding: 14px 0;
  border-top: 1px solid #eef3f8;
}

.phone-detail-list dt {
  margin-bottom: 6px;
  color: #8090a6;
  font-size: 13px;
}

.phone-detail-list dd {
  margin: 0;
  color: #253247;
  font-size: 16px;
  font-weight: 700;
}

@keyframes model-section-rise {
  0% {
    opacity: 0;
    transform: translateY(72px) scale(0.96);
  }

  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

@keyframes model-card-fade-up {
  0% {
    opacity: 0;
    transform: translateY(86px) scale(0.92);
  }

  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

@keyframes phone-detail-open {
  0% {
    opacity: 0;
    transform: translate3d(0, 18px, 0) scale(0.78);
  }

  58% {
    opacity: 1;
    transform: translate3d(0, -4px, 0) scale(1.018);
  }

  100% {
    opacity: 1;
    transform: translate3d(0, 0, 0) scale(1);
  }
}

@keyframes phone-detail-close {
  0% {
    opacity: 1;
    transform: translate3d(0, 0, 0) scale(1);
  }

  100% {
    opacity: 0;
    transform: translate3d(0, 12px, 0) scale(0.9);
  }
}

@keyframes brand-modal-open {
  0% {
    opacity: 0;
    transform: translate3d(0, 18px, 0) scale(0.94);
  }

  100% {
    opacity: 1;
    transform: translate3d(0, 0, 0) scale(1);
  }
}

@keyframes brand-modal-close {
  0% {
    opacity: 1;
    transform: translate3d(0, 0, 0) scale(1);
  }

  100% {
    opacity: 0;
    transform: translate3d(0, 10px, 0) scale(0.96);
  }
}

@media (prefers-reduced-motion: reduce) {

  .model-section--animating .model-control-panel,
  .model-section--animating .model-card,
  .phone-detail-enter-active .phone-detail-panel,
  .phone-detail-leave-active .phone-detail-panel,
  .brand-modal-enter-active .brand-modal-panel,
  .brand-modal-leave-active .brand-modal-panel {
    animation: none;
  }
}

@media (max-width: 980px) {
  .brand-hero {
    align-items: stretch;
    flex-direction: column;
  }

  .section-head {
    align-items: stretch;
    flex-direction: column;
  }

  .search-box {
    flex: none;
  }

  .model-search {
    flex: none;
  }

  .brand-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .brand-phone-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .model-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {

  .brand-hero,
  .model-control-panel {
    padding: 24px;
  }

  .brand-hero h2 {
    font-size: 22px;
  }

  .page-heading h1 {
    font-size: 28px;
  }

  .brand-grid {
    grid-template-columns: 1fr;
  }

  .brand-phone-grid {
    grid-template-columns: 1fr;
  }

  .model-grid {
    grid-template-columns: 1fr;
  }

  .filter-title {
    flex-basis: 100%;
  }

  .brand-modal-overlay {
    align-items: flex-end;
    padding: 14px;
  }

  .brand-modal-panel {
    max-height: calc(100vh - 28px);
    padding: 20px;
  }

  .brand-showcase-head {
    align-items: flex-start;
    flex-direction: column;
  }

  .phone-detail-overlay {
    align-items: flex-end;
    padding: 14px;
  }

  .phone-detail-panel {
    grid-template-columns: 1fr;
    gap: 18px;
    max-height: calc(100vh - 28px);
    padding: 20px;
  }

  .phone-detail-image {
    min-height: 240px;
  }

  .phone-detail-content {
    padding: 0;
  }

  .phone-detail-content h2 {
    margin-right: 42px;
    font-size: 22px;
  }
}
</style>
