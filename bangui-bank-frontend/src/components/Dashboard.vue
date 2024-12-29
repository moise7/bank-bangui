<template>
  <div>
    <nav class="bg-goldColor text-black shadow-md relative z-50">
      <!-- Desktop Navigation -->
      <div class="hidden sm:flex justify-between items-center max-w-7xl mx-auto px-4 py-3">
        <div class="flex flex-wrap gap-6">
          <div v-for="(category, index) in navItems" :key="index" class="relative group">
            <button class="flex items-center gap-2 hover:text-white transition-colors duration-200 font-medium">
              {{ category.category }}
              <i class="fas fa-chevron-down text-xs transition-transform group-hover:rotate-180"></i>
            </button>
            <div class="absolute left-0 mt-2 w-64 bg-white rounded-lg shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-50">
              <div class="py-2">
                <a v-for="item in category.items"
                   :key="item.label"
                   @click.prevent="handleNavClick(item)"
                   class="flex items-center gap-3 px-4 py-2 hover:bg-gray-100 transition-colors duration-200 cursor-pointer">
                  <i :class="[item.icon, 'w-5 text-goldColor']"></i>
                  {{ item.label }}
                </a>
              </div>
            </div>
          </div>
          <button @click="handleLogout" class="flex items-center gap-2 hover:text-white transition-colors duration-200" title="Déconnexion">
            <i class="fas fa-sign-out-alt text-white text-xl"></i>
          </button>
        </div>
      </div>

      <!-- Mobile Navigation -->
      <div class="block sm:hidden">
        <div class="bg-goldColor p-4 flex justify-between items-center">
          <div class="flex items-center gap-2">
            <span class="text-xl font-semibold text-black">{{ t('menu') }}</span>
          </div>
          <div class="flex items-center gap-4">
            <button @click="handleLogout" class="text-black hover:text-white transition-colors duration-200" title="Déconnexion">
              <i class="fas fa-sign-out-alt text-black text-xl"></i>
            </button>
            <button @click="toggleMobileMenu" class="group h-8 w-8 rounded-lg border-2 border-black" aria-label="Toggle menu">
              <div class="grid justify-items-center gap-1">
                <span class="h-0.5 w-4 rounded-full bg-black transition-all duration-300" :class="{ 'rotate-45 translate-y-1.5': isMobileMenuOpen }"></span>
                <span class="h-0.5 w-4 rounded-full bg-black transition-all duration-300" :class="{ 'opacity-0': isMobileMenuOpen }"></span>
                <span class="h-0.5 w-4 rounded-full bg-black transition-all duration-300" :class="{ '-rotate-45 -translate-y-1.5': isMobileMenuOpen }"></span>
              </div>
            </button>
          </div>
        </div>
        <div v-if="isMobileMenuOpen" class="bg-white border-b shadow-lg">
          <div v-for="(category, index) in navItems" :key="index">
            <div class="bg-gray-100 px-4 py-3 font-semibold text-black border-b">
              {{ category.category }}
            </div>
            <div v-for="item in category.items" :key="item.label" @click="handleMobileNavClick(item)" class="px-4 py-4 border-b flex items-center gap-3 hover:bg-gray-50 active:bg-gray-100 transition-colors duration-200 cursor-pointer">
              <i :class="[item.icon, 'text-goldColor w-6 text-center text-xl']"></i>
              <span class="text-black">{{ item.label }}</span>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <div class="title text-3xl text-center mt-6" v-if="userStore.user && userStore.user.username">
      <h1><strong>{{ t('welcome_message') }}</strong> {{ userStore.user.first_name }}</h1>
    </div>

    <div class="accounts-section bg-white p-6 mt-4 rounded-lg shadow-lg mx-4" v-if="userStore.user && userStore.user.username">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-2xl font-bold">{{ t('main_account') }}</h2>
        <select v-model="userStore.selectedCurrency" class="p-2 border border-gray-300 rounded-lg bg-gray-50 focus:ring-2 focus:ring-goldColor" :disabled="userStore.isLoadingRates">
          <option value="€">{{ t('euro') }}</option>
          <option value="$">{{ t('dollar') }}</option>
          <option value="CFA">{{ t('cfa') }}</option>
        </select>
      </div>
      <!-- Account Number Display -->
      <div class="flex items-center justify-between mb-4">
        <span class="text-lg font-semibold">Account Number:</span>
        <div class="relative flex items-center">
          <span v-if="!showFullAccountNumber" class="text-gray-500 account-number">{{ maskedAccountNumber }}</span>
          <span v-else class="text-gray-800 account-number">{{ userStore.user.account_number }}</span>
          <button @click="toggleAccountNumber" class="ml-2 text-sm text-goldColor hover:underline">
            {{ showFullAccountNumber ? 'Hide' : 'Show' }}
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="bg-gradient-to-r from-goldColor to-yellow-600 p-6 rounded-lg text-white">
          <p class="text-sm opacity-80">{{ t('available_balance') }}</p>
          <p class="text-3xl font-bold mt-1">{{ userStore.formattedAmount(userStore.user.balance) }}</p>
        </div>
        <div class="bg-gray-50 p-6 rounded-lg">
          <p class="text-sm text-gray-600">{{ t('account_info') }}</p>
          <p class="mt-1"><i class="far fa-calendar-alt mr-2"></i> {{ t('created_on') }}: {{ new Date(userStore.user.created_at).toLocaleDateString('fr-FR') }}</p>
        </div>
      </div>

      <div class="bg-gray-50 p-3 mt-4 rounded-lg border border-gray-200">
        <div class="flex items-center justify-between mb-1">
          <span class="text-xs text-gray-600">{{ t('current_exchange_rates') }}</span>
          <span class="text-xs text-gray-400">{{ userStore.lastRatesUpdate ? new Date(userStore.lastRatesUpdate).toLocaleTimeString() : t('never') }}</span>
        </div>

        <div v-if="userStore.currentExchangeRates" class="flex flex-col gap-2 text-sm">
          <div class="flex items-center gap-2">
            <span class="text-gray-500">1 EUR =</span>
            <span class="font-medium">${{ userStore.currentExchangeRates.USD }} {{ t('usd') }}</span>
            <span class="mx-2">|</span>
            <span class="font-medium">{{ userStore.currentExchangeRates.XAF }} {{ t('cfa') }}</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-gray-500">1 USD =</span>
            <span class="font-medium">{{ (userStore.currentExchangeRates.XAF / userStore.currentExchangeRates.USD).toFixed(2) }} {{ t('cfa') }}</span>
          </div>
          <div v-if="userStore.isLoadingRates" class="animate-spin text-goldColor">
            <i class="fas fa-sync-alt text-xs"></i>
          </div>
        </div>
      </div>
    </div>

    <div class="dashboard-content grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 p-4">
      <div class="payment-history bg-gray-100 p-6 rounded-xl shadow-lg">
        <h3 class="text-2xl font-bold text-gray-800 mb-4">{{ t('payment_history') }}</h3>
        <div v-if="userStore.isLoadingPayments" class="flex justify-center">
          <span class="spinner"></span>
        </div>
        <div v-if="userStore.error" class="text-red-500 mb-4">
          {{ userStore.error }}
        </div>
        <div v-if="!userStore.isLoadingPayments && !userStore.error" class="flex font-semibold text-gray-700 border-b-2 border-gray-800 mb-2">
          <div class="flex-1 text-left py-2">{{ t('date') }}</div>
          <div class="flex-1 text-left py-2">{{ t('name') }}</div>
          <div class="flex-1 text-left py-2">{{ t('description') }}</div>
          <div class="flex-1 text-left py-2">{{ t('amount') }}</div>
        </div>
        <ul v-if="!userStore.isLoadingPayments && !userStore.error && userStore.payments.length" class="list-none p-0">
          <li v-for="(payment, index) in userStore.payments" :key="payment.id" :class="{'bg-gray-100': index % 2 === 0, 'bg-white': index % 2 !== 0}" class="flex py-4 border-b border-gray-300">
            <div class="flex-1 text-sm text-gray-800">{{ new Date(payment.created_at).toLocaleDateString('fr-FR') }}</div>
            <div class="flex-1 text-sm text-gray-800">{{ payment.recipient_first_name }}</div>
            <div class="flex-1 text-sm text-gray-800">{{ payment.description }}</div>
            <div class="flex-1 text-sm text-gray-800">{{ userStore.formattedAmount(payment.amount) }}</div>
          </li>
        </ul>
        <div v-if="!userStore.isLoadingPayments && !userStore.error && userStore.payments.length === 0" class="text-gray-500 text-center py-4">
          {{ t('no_payments_found') }}
        </div>
      </div>

      <div class="budget-progress bg-gray-100 p-4 rounded-md shadow-md">
        <h3 class="text-xl font-bold mb-4">{{ t('budget_progress') }}</h3>
        <div class="progress-bar mb-4">
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">{{ t('current_budget') }}</span>
            <span class="text-sm font-medium text-gray-600">{{ budgetProgress }}%</span>
          </div>
          <div class="relative pt-1">
            <div class="flex mb-2 items-center justify-between">
              <div class="w-full bg-gray-200 rounded-full">
                <div :style="`width: ${budgetProgress}%`" class="bg-goldColor text-xs font-medium text-center p-0.5 leading-none rounded-full"></div>
              </div>
            </div>
          </div>
        </div>
        <router-link to="/education/budget-tracker" class="text-sm text-goldColor hover:text-black transition-colors">{{ t('view_full_budget') }}</router-link>
      </div>

      <div class="calculator-and-calendar space-y-4">
        <div class="calendar bg-gray-100 p-4 rounded-md shadow-md">
          <div class="calendar-header flex justify-between items-center mb-4">
            <button @click="previousMonth" class="bg-goldColor text-white py-1 px-2 rounded hover:bg-black transition">&lt;</button>
            <h3 class="text-lg font-bold">{{ currentMonthYear }}</h3>
            <button @click="nextMonth" class="bg-goldColor text-white py-1 px-2 rounded hover:bg-black transition">&gt;</button>
          </div>
          <div class="calendar-grid grid grid-cols-7">
            <div v-for="day in daysOfWeek" :key="day" class="calendar-day-header font-bold text-center">{{ day }}</div>
            <div v-for="date in calendarDates" :key="date.getTime()" :class="['calendar-day border text-center p-2', { 'bg-blue-100': isCurrentMonth(date), 'bg-blue-300': isToday(date) }]">
              {{ date.getDate() }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import { useUserStore } from '@/stores/user';
import { useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';

export default {
  name: 'BankingDashboard',
  setup() {
    const userStore = useUserStore();
    const router = useRouter();
    const { t, locale } = useI18n();

    // State to manage account number visibility
    const showFullAccountNumber = ref(false);
    // Computed property to mask the account number
    const maskedAccountNumber = computed(() => {
      if (userStore.user && userStore.user.account_number) {
        const accountNumber = userStore.user.account_number;
        return '****' + accountNumber.slice(-4); // Show only the last 4 digits
      }
      return '';
    });
    // Method to toggle account number visibility
    const toggleAccountNumber = () => {
      showFullAccountNumber.value = !showFullAccountNumber.value;
    };
    // Initialize currentDate with the current date
    const currentDate = ref(new Date());

    const currentMonthYear = computed(() => {
      return currentDate.value.toLocaleString(locale.value, { month: 'long', year: 'numeric' }); // Use dynamic locale
    });

    const calendarDates = computed(() => {
      const year = currentDate.value.getFullYear();
      const month = currentDate.value.getMonth();
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);

      const dates = [];
      const daysToIncludeBefore = firstDay.getDay();
      const daysToIncludeAfter = 6 - lastDay.getDay();

      for (let i = -daysToIncludeBefore; i < lastDay.getDate() + daysToIncludeAfter; i++) {
        dates.push(new Date(year, month, i + 1));
      }

      return dates;
    });

    const navItems = computed(() => [
      {
        category: t('account_management'),
        items: [
          { label: t('accounts'), icon: 'fas fa-wallet' },
          { label: t('transfer_money'), icon: 'fas fa-exchange-alt' },
        ]
      },
      {
        category: t('services'),
        items: [
          { label: t('financial_tools'), icon: 'fas fa-tools' },
          { label: t('card_control'), icon: 'fas fa-credit-card' },
          { label: t('send_money'), icon: 'fas fa-paper-plane' },
          {
            label: t('budget_tracker'),
            icon: 'fas fa-chart-pie',
            route: '/education/budget-tracker'
          }
        ]
      },
      {
        category: t('learning_center'),
        items: [
          {
            label: t('banking_benefits'),
            icon: 'fas fa-piggy-bank',
            route: '/education/account-benefits'
          },
          {
            label: t('financial_education'),
            icon: 'fas fa-graduation-cap',
            route: '/education/financial-literacy'
          },
          {
            label: t('banking_security'),
            icon: 'fas fa-shield-alt',
            route: '/education/security'
          },
          {
            label: t('digital_services'),
            icon: 'fas fa-mobile-alt',
            route: '/education/digital-banking'
          },
          {
            label: t('financial_education'),
            icon: 'fas fa-graduation-cap',
            route: '/education/financial-literacy'
          },
        ]
      },
      {
        category: t('others'),
        items: [
          { label: t('additional_services'), icon: 'fas fa-plus-circle' },
          { label: t('logout'), icon: 'fas fa-sign-out-alt' },
        ]
      }
    ]);

    function handleNavClick(item) {
      if (item.label === t('logout')) {
        userStore.logout();
        router.push('/');
      } else if (item.label === t('send_money')) {
        router.push('/payment-form');
      } else if (item.route) {
        router.push(item.route);
      }
    }

    onMounted(async () => {
      const userId = userStore.user.id;

      if (!userId) {
        console.error('No user ID found, please login');
        return;
      }

      await userStore.fetchUserData();
      await userStore.fetchPayments();
      await userStore.fetchExchangeRates();
      console.log(userStore.fetchUserData())
    });

    return {
      userStore,
      navItems,
      handleNavClick,
      currentDate,
      currentMonthYear,
      calendarDates,
      t,
      router,
      maskedAccountNumber,
      showFullAccountNumber,
      toggleAccountNumber,
    };
  },
  methods: {
    previousMonth() {
      this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() - 1);
    },
    nextMonth() {
      this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1);
    },
    isCurrentMonth(date) {
      return date.getMonth() === this.currentDate.getMonth();
    },
    isToday(date) {
      const today = new Date();
      return date.getDate() === today.getDate() &&
             date.getMonth() === today.getMonth() &&
             date.getFullYear() === today.getFullYear();
    },
    handleMobileNavClick(item) {
      this.isMobileMenuOpen = false;
      if (item.label === this.t('logout')) {
        this.handleLogout();
      } else if (item.label === this.t('send_money')) {
        this.$router.push('/payment-form');
      } else if (item.route) {
        this.$router.push(item.route);
      }
    },
    handleLogout() {
      this.userStore.logout();
      this.$router.push('/');
    },
    toggleMobileMenu() {
      this.isMobileMenuOpen = !this.isMobileMenuOpen;
    }
  },
};
</script>

<style scoped>
.account-number {
  margin-left: 0.25rem; /* Adjust this value as needed */
}
.visible {
  visibility: visible;
}

.invisible {
  visibility: hidden;
}

.calendar-day {
  transition: background-color 0.3s;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}

.menu-enter-active,
.menu-leave-active {
  transition: opacity 0.3s, transform 0.3s;
}

.menu-enter-from,
.menu-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

.transform {
  transition: transform 0.3s;
}

.rotate-180 {
  transform: rotate(180deg);
}

.inset-x-0 {
  left: 0;
  right: 0;
}
</style>
