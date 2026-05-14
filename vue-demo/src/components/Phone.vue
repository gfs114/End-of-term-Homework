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
      <article v-for="brand in filteredBrands" :key="brand.name" class="brand-card">
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
          :style="modelCardAnimationStyle(index)">
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
  </section>
</template>

<script>
export default {
  name: "Phone",
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
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 60 Pro",
          processor: "麒麟9000S",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥5699 起",
          priceValue: 5699,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 60 Pro+",
          processor: "麒麟9000S",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥7999 起",
          priceValue: 7999,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 60 RS 非凡大师",
          processor: "麒麟9000S",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥11999 起",
          priceValue: 11999,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 70",
          processor: "麒麟9010",
          battery: "5300mAh",
          batteryValue: 5300,
          price: "¥5499 起",
          priceValue: 5499,
          img: ""
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
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80",
          processor: "麒麟9020",
          battery: "5750mAh",
          batteryValue: 5750,
          price: "¥4699 起",
          priceValue: 4699,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80 Pro",
          processor: "麒麟9030 / 麒麟9030 Pro",
          battery: "5750mAh",
          batteryValue: 5750,
          price: "¥5999 起",
          priceValue: 5999,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80 Pro Max",
          processor: "麒麟9030 Pro",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥6999 起",
          priceValue: 6999,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Mate 80 RS 非凡大师",
          processor: "麒麟9030 Pro",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥11999 起",
          priceValue: 11999,
          img: ""
        },

        {
          brand: "华为",
          model: "HUAWEI P60",
          processor: "骁龙8+ Gen1",
          battery: "4815mAh",
          batteryValue: 4815,
          price: "¥4488 起",
          priceValue: 4488,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI P60 Pro",
          processor: "骁龙8+ Gen1",
          battery: "4815mAh",
          batteryValue: 4815,
          price: "¥6188 起",
          priceValue: 6188,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI P60 Art",
          processor: "骁龙8+ Gen1",
          battery: "5060mAh",
          batteryValue: 5060,
          price: "¥8988 起",
          priceValue: 8988,
          img: ""
        },

        {
          brand: "华为",
          model: "HUAWEI Pura 70",
          processor: "麒麟9010",
          battery: "4900mAh",
          batteryValue: 4900,
          price: "¥4999 起",
          priceValue: 4999,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 70 Pro",
          processor: "麒麟9020",
          battery: "5050mAh",
          batteryValue: 5050,
          price: "¥5999 起",
          priceValue: 5999,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 70 Pro+",
          processor: "麒麟9020",
          battery: "5050mAh",
          batteryValue: 5050,
          price: "¥7499 起",
          priceValue: 7499,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 70 Ultra",
          processor: "麒麟9020",
          battery: "5200mAh",
          batteryValue: 5200,
          price: "¥9999 起",
          priceValue: 9999,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80",
          processor: "官网未标注",
          battery: "5600mAh",
          batteryValue: 5600,
          price: "¥5299 起",
          priceValue: 5299,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80 Pro",
          processor: "官网未标注",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥6299 起",
          priceValue: 6299,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80 Pro+",
          processor: "官网未标注",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥7699 起",
          priceValue: 7699,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 80 Ultra",
          processor: "官网未标注",
          battery: "5700mAh",
          batteryValue: 5700,
          price: "¥10999 起",
          priceValue: 10999,
          img: ""
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
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 90 Pro",
          processor: "麒麟9030S",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥6599 起",
          priceValue: 6599,
          img: ""
        },
        {
          brand: "华为",
          model: "HUAWEI Pura 90 Pro Max",
          processor: "麒麟9030S",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥7999 起",
          priceValue: 7999,
          img: ""
        },
        {
          brand: "小米",
          model: "小米 15 Pro",
          processor: "骁龙 8 至尊版",
          battery: "6100mAh",
          batteryValue: 6100,
          price: "¥5,299 起",
          priceValue: 5299,
          image: "",
        },
        {
          brand: "小米",
          model: "Redmi K80 Pro",
          processor: "骁龙 8 至尊版",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥3,699 起",
          priceValue: 3699,
          image: "",
        },
        {
          brand: "OPPO",
          model: "OPPO Find X8 Pro",
          processor: "天玑 9400",
          battery: "5910mAh",
          batteryValue: 5910,
          price: "¥5,299 起",
          priceValue: 5299,
          image: "",
        },
        {
          brand: "OPPO",
          model: "一加 13",
          processor: "骁龙 8 至尊版",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥4,499 起",
          priceValue: 4499,
          image: "",
        },
        {
          brand: "vivo",
          model: "vivo X200 Pro",
          processor: "天玑 9400",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥5,299 起",
          priceValue: 5299,
          image: "",
        },
        {
          brand: "vivo",
          model: "iQOO 13",
          processor: "骁龙 8 至尊版",
          battery: "6150mAh",
          batteryValue: 6150,
          price: "¥3,999 起",
          priceValue: 3999,
          image: "",
        },
        {
          brand: "荣耀",
          model: "荣耀 Magic7 Pro",
          processor: "骁龙 8 至尊版",
          battery: "5850mAh",
          batteryValue: 5850,
          price: "¥5,699 起",
          priceValue: 5699,
          image: "",
        },
        {
          brand: "魅族",
          model: "魅族 21 Pro",
          processor: "骁龙 8 Gen 3",
          battery: "5050mAh",
          batteryValue: 5050,
          price: "¥4,999 起",
          priceValue: 4999,
          image: "",
        },
        {
          brand: "中兴",
          model: "中兴 Axon 60 Ultra",
          processor: "骁龙 8 Gen 2",
          battery: "6000mAh",
          batteryValue: 6000,
          price: "¥4,299 起",
          priceValue: 4299,
          image: "",
        },
        {
          brand: "Apple",
          model: "iPhone 16 Pro",
          processor: "A18 Pro",
          battery: "3582mAh",
          batteryValue: 3582,
          price: "¥7,999 起",
          priceValue: 7999,
          image: "",
        },
        {
          brand: "三星",
          model: "Samsung Galaxy S25 Ultra",
          processor: "骁龙 8 至尊版 for Galaxy",
          battery: "5000mAh",
          batteryValue: 5000,
          price: "¥9,699 起",
          priceValue: 9699,
          image: "",
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
  },
  methods: {
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

.brand-card:hover {
  border-color: #bfdbfe;
  box-shadow: 0 20px 44px rgba(45, 73, 112, 0.15);
  transform: translateY(-2px);
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

@media (prefers-reduced-motion: reduce) {

  .model-section--animating .model-control-panel,
  .model-section--animating .model-card {
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

  .model-grid {
    grid-template-columns: 1fr;
  }

  .filter-title {
    flex-basis: 100%;
  }
}
</style>
