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
        <input
          v-model.trim="brandKeyword"
          type="search"
          placeholder="例如：华为、小米、Apple、三星"
        >
      </label>
    </section>

    <section class="brand-grid" aria-label="主流手机品牌列表">
      <article v-for="brand in filteredBrands" :key="brand.name" class="brand-card">
        <div class="brand-top">
          <span class="brand-mark" :style="{ background: brand.color }">
            {{ brand.shortName }}
          </span>
        </div>

        <h2>{{ brand.name }}</h2>
      </article>

      <div v-if="filteredBrands.length === 0" class="empty-state">
        暂未找到匹配品牌，请换个关键词试试。
      </div>
    </section>

    <section class="model-section" aria-label="详细手机型号">
      <div class="model-control-panel">
        <div class="section-head">
          <div>
            <h2>详细手机型号</h2>
          </div>

          <label class="model-search">
            <span>搜索机型或处理器</span>
            <input
              v-model.trim="modelKeyword"
              type="search"
              placeholder="例如：小米 15、A18、骁龙"
            >
          </label>
        </div>

        <div class="model-filters" aria-label="机型筛选条件">
          <div class="filter-row">
            <span class="filter-title">品牌</span>
            <button
              v-for="brand in modelBrandOptions"
              :key="brand"
              type="button"
              :class="['filter-chip', { active: modelFilters.brand === brand }]"
              @click="setModelFilter('brand', brand)"
            >
              {{ brand }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">处理器</span>
            <button
              v-for="processor in processorOptions"
              :key="processor"
              type="button"
              :class="['filter-chip', { active: modelFilters.processor === processor }]"
              @click="setModelFilter('processor', processor)"
            >
              {{ processor }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">价格</span>
            <button
              v-for="price in priceOptions"
              :key="price.label"
              type="button"
              :class="['filter-chip', { active: modelFilters.price === price.label }]"
              @click="setModelFilter('price', price.label)"
            >
              {{ price.label }}
            </button>
          </div>

          <div class="filter-row">
            <span class="filter-title">电池</span>
            <button
              v-for="battery in batteryOptions"
              :key="battery.label"
              type="button"
              :class="['filter-chip', { active: modelFilters.battery === battery.label }]"
              @click="setModelFilter('battery', battery.label)"
            >
              {{ battery.label }}
            </button>
          </div>
        </div>
      </div>

      <div class="model-grid">
        <article v-for="phone in filteredPhoneModels" :key="phone.model" class="model-card">
          <div class="model-image">
            <img :src="phone.image" :alt="phone.model">
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

      <div v-if="filteredPhoneModels.length === 0" class="empty-state">
        暂未找到匹配机型，请换个关键词试试。
      </div>
    </section>
  </section>
</template>

<script>
export default {
  name: 'Phone',
  data() {
    return {
      brandKeyword: '',
      modelKeyword: '',
      modelFilters: {
        brand: '全部',
        processor: '全部',
        price: '全部',
        battery: '全部'
      },
      priceOptions: [
        { label: '全部', min: 0, max: Infinity },
        { label: '4000 以下', min: 0, max: 3999 },
        { label: '4000-5999', min: 4000, max: 5999 },
        { label: '6000 以上', min: 6000, max: Infinity }
      ],
      batteryOptions: [
        { label: '全部', min: 0 },
        { label: '3000mAh 以上', min: 3000 },
        { label: '4000mAh 以上', min: 4000 },
        { label: '5000mAh 以上', min: 5000 },
        { label: '6000mAh 以上', min: 6000 }
      ],
      brands: [
        {
          name: '华为',
          shortName: 'H',
          subBrands: [],
          color: 'linear-gradient(135deg, #ef4444, #f97316)'
        },
        {
          name: '小米',
          shortName: 'MI',
          subBrands: ['红米'],
          color: 'linear-gradient(135deg, #f97316, #facc15)'
        },
        {
          name: 'OPPO',
          shortName: 'O',
          subBrands: ['一加', 'realme'],
          color: 'linear-gradient(135deg, #16a34a, #22c55e)'
        },
        {
          name: 'vivo',
          shortName: 'V',
          subBrands: ['iQOO'],
          color: 'linear-gradient(135deg, #2563eb, #38bdf8)'
        },
        {
          name: '荣耀',
          shortName: 'HON',
          subBrands: [],
          color: 'linear-gradient(135deg, #0f172a, #64748b)'
        },
        {
          name: '魅族',
          shortName: 'MZ',
          subBrands: [],
          color: 'linear-gradient(135deg, #14b8a6, #0ea5e9)'
        },
        {
          name: '中兴',
          shortName: 'ZTE',
          subBrands: ['努比亚', '红魔'],
          color: 'linear-gradient(135deg, #1d4ed8, #4f46e5)'
        },
        {
          name: 'Apple',
          shortName: 'A',
          subBrands: [],
          color: 'linear-gradient(135deg, #111827, #6b7280)'
        },
        {
          name: '三星',
          shortName: 'S',
          subBrands: [],
          color: 'linear-gradient(135deg, #1d4ed8, #60a5fa)'
        }
      ],
      phoneModels: [
        {
          brand: '华为',
          model: 'HUAWEI Mate 70 Pro',
          processor: '麒麟 9020',
          battery: '5500mAh',
          batteryValue: 5500,
          price: '¥6,499 起',
          priceValue: 6499,
          image: require('@/assets/mate70pro.jpg')
        },
        {
          brand: '小米',
          model: '小米 15 Pro',
          processor: '骁龙 8 至尊版',
          battery: '6100mAh',
          batteryValue: 6100,
          price: '¥5,299 起',
          priceValue: 5299,
          image: 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: '小米',
          model: 'Redmi K80 Pro',
          processor: '骁龙 8 至尊版',
          battery: '6000mAh',
          batteryValue: 6000,
          price: '¥3,699 起',
          priceValue: 3699,
          image: 'https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: 'OPPO',
          model: 'OPPO Find X8 Pro',
          processor: '天玑 9400',
          battery: '5910mAh',
          batteryValue: 5910,
          price: '¥5,299 起',
          priceValue: 5299,
          image: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: 'OPPO',
          model: '一加 13',
          processor: '骁龙 8 至尊版',
          battery: '6000mAh',
          batteryValue: 6000,
          price: '¥4,499 起',
          priceValue: 4499,
          image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: 'vivo',
          model: 'vivo X200 Pro',
          processor: '天玑 9400',
          battery: '6000mAh',
          batteryValue: 6000,
          price: '¥5,299 起',
          priceValue: 5299,
          image: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: 'vivo',
          model: 'iQOO 13',
          processor: '骁龙 8 至尊版',
          battery: '6150mAh',
          batteryValue: 6150,
          price: '¥3,999 起',
          priceValue: 3999,
          image: 'https://images.unsplash.com/photo-1601972602288-3be527b4f18a?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: '荣耀',
          model: '荣耀 Magic7 Pro',
          processor: '骁龙 8 至尊版',
          battery: '5850mAh',
          batteryValue: 5850,
          price: '¥5,699 起',
          priceValue: 5699,
          image: 'https://images.unsplash.com/photo-1496346236646-50e985b31ea4?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: '魅族',
          model: '魅族 21 Pro',
          processor: '骁龙 8 Gen 3',
          battery: '5050mAh',
          batteryValue: 5050,
          price: '¥4,999 起',
          priceValue: 4999,
          image: 'https://images.unsplash.com/photo-1512428559087-560fa5ceab42?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: '中兴',
          model: '中兴 Axon 60 Ultra',
          processor: '骁龙 8 Gen 2',
          battery: '6000mAh',
          batteryValue: 6000,
          price: '¥4,299 起',
          priceValue: 4299,
          image: 'https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: 'Apple',
          model: 'iPhone 16 Pro',
          processor: 'A18 Pro',
          battery: '3582mAh',
          batteryValue: 3582,
          price: '¥7,999 起',
          priceValue: 7999,
          image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=640&q=80'
        },
        {
          brand: '三星',
          model: 'Samsung Galaxy S25 Ultra',
          processor: '骁龙 8 至尊版 for Galaxy',
          battery: '5000mAh',
          batteryValue: 5000,
          price: '¥9,699 起',
          priceValue: 9699,
          image: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=640&q=80'
        }
      ]
    }
  },
  computed: {
    modelBrandOptions() {
      const brands = this.phoneModels.map((phone) => phone.brand)
      return ['全部'].concat(brands.filter((brand, index) => brands.indexOf(brand) === index))
    },
    processorOptions() {
      const processors = this.phoneModels.map((phone) => phone.processor)
      return ['全部'].concat(processors.filter((processor, index) => processors.indexOf(processor) === index))
    },
    filteredBrands() {
      const keyword = this.brandKeyword.toLowerCase()

      return this.brands.filter((brand) => {
        const searchable = [
          brand.name,
          brand.subBrands.join(' ')
        ].join(' ').toLowerCase()

        return !keyword || searchable.includes(keyword)
      })
    },
    filteredPhoneModels() {
      const keyword = this.modelKeyword.toLowerCase()
      const priceRange = this.priceOptions.find((price) => price.label === this.modelFilters.price)
      const batteryRange = this.batteryOptions.find((battery) => battery.label === this.modelFilters.battery)

      return this.phoneModels.filter((phone) => {
        const searchable = [
          phone.brand,
          phone.model,
          phone.processor,
          phone.battery,
          phone.price
        ].join(' ').toLowerCase()
        const matchesKeyword = !keyword || searchable.includes(keyword)
        const matchesBrand = this.modelFilters.brand === '全部' || phone.brand === this.modelFilters.brand
        const matchesProcessor = this.modelFilters.processor === '全部' || phone.processor === this.modelFilters.processor
        const matchesPrice = !priceRange || (phone.priceValue >= priceRange.min && phone.priceValue <= priceRange.max)
        const matchesBattery = !batteryRange || phone.batteryValue >= batteryRange.min

        return matchesKeyword && matchesBrand && matchesProcessor && matchesPrice && matchesBattery
      })
    }
  },
  methods: {
    setModelFilter(key, value) {
      this.modelFilters[key] = value
    }
  }
}
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
  border: 1px solid #dbe7f3;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 18px 50px rgba(45, 73, 112, 0.08);
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
  min-height: 178px;
  padding: 28px 20px;
  border-radius: 8px;
  box-sizing: border-box;
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}

.brand-card:hover {
  border-color: #bfdbfe;
  box-shadow: 0 18px 40px rgba(45, 73, 112, 0.12);
  transform: translateY(-2px);
}

.brand-top {
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

.section-head > div {
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
