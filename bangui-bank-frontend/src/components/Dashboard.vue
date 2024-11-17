<template>
  <div class="dashboard font-mona bg-background1">
    <nav class="bg-goldColor text-black shadow-md relative z-50">
  <!-- Desktop Navigation -->
  <div class="hidden sm:flex justify-between items-center max-w-7xl mx-auto px-4 py-3">
    <div class="flex flex-wrap gap-6">
      <div v-for="(category, index) in navItems" :key="index" class="relative group">
        <button class="flex items-center gap-2 hover:text-white transition-colors duration-200 font-medium">
          {{ category.category }}
          <i class="fas fa-chevron-down text-xs transition-transform group-hover:rotate-180"></i>
        </button>

        <!-- Dropdown Menu -->
        <div class="absolute left-0 mt-2 w-64 bg-white rounded-lg shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform -translate-y-2 group-hover:translate-y-0">
          <div class="py-2">
            <a v-for="item in category.items"
               :key="item.label"
               href="#"
               @click="handleNavClick(item.label)"
               class="flex items-center gap-3 px-4 py-2 hover:bg-gray-100 transition-colors duration-200">
              <i :class="[item.icon, 'w-5 text-goldColor']"></i>
              {{ item.label }}
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Mobile Navigation -->
  <div class="sm:hidden">
    <div class="flex items-center justify-between px-4 py-3">
      <div class="text-xl font-semibold flex items-center gap-2">
        <i class="fas fa-bars"></i> Menu
      </div>
      <button @click="isMobileMenuOpen = !isMobileMenuOpen"
              class="text-black focus:outline-none">
        <i class="fas fa-chevron-down transition-transform duration-200"
           :class="{ 'transform rotate-180': isMobileMenuOpen }"></i>
      </button>
    </div>

    <!-- Mobile Menu Dropdown -->
    <div class="absolute w-full bg-white shadow-lg transition-all duration-300 ease-in-out"
         :class="{ 'opacity-100 translate-y-0': isMobileMenuOpen,
                  'opacity-0 -translate-y-full pointer-events-none': !isMobileMenuOpen }">
      <div class="py-2">
        <div v-for="(category, index) in navItems" :key="index">
          <div class="px-4 py-2 text-sm font-semibold text-gray-500 bg-gray-50">
            {{ category.category }}
          </div>
          <a v-for="item in category.items"
             :key="item.label"
             href="#"
             @click="handleMobileNavClick(item.label)"
             class="flex items-center gap-3 px-6 py-3 hover:bg-gray-50 transition-colors duration-200 border-b border-gray-100">
            <i :class="[item.icon, 'w-5 text-goldColor']"></i>
            {{ item.label }}
          </a>
        </div>
      </div>
    </div>
  </div>
</nav>

    <div class="title text-3xl text-center mt-6" v-if="userStore.user && userStore.user.username">
      <h1><strong>Bienvenue,</strong> {{ userStore.user.first_name }}</h1>
    </div>

    <!-- Accounts Section -->
    <div class="accounts-section bg-white p-6 mt-4 rounded-lg shadow-lg"
         v-if="userStore.user && userStore.user.username">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-2xl font-bold">Compte Principal</h2>
        <select v-model="selectedCurrency"
                class="p-2 border border-gray-300 rounded-lg bg-gray-50 focus:ring-2 focus:ring-goldColor focus:border-transparent">
          <option value="€">Euro (€)</option>
          <option value="$">Dollar ($)</option>
          <option value="CFA">CFA Franc (CFA)</option>
        </select>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="bg-gradient-to-r from-goldColor to-yellow-600 p-6 rounded-lg text-white">
          <p class="text-sm opacity-80">Solde disponible</p>
          <p class="text-3xl font-bold mt-1">{{ formattedBalance }}</p>
        </div>

        <div class="bg-gray-50 p-6 rounded-lg">
          <p class="text-sm text-gray-600">Informations du compte</p>
          <p class="mt-1"><i class="far fa-calendar-alt mr-2"></i> Créé le: {{ new Date(userStore.user.created_at).toLocaleDateString('fr-FR') }}</p>
        </div>
      </div>
    </div>

    <div class="dashboard-content grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 p-4">
      <!-- Payment History Section -->
      <div class="payment-history bg-gray-100 p-4 rounded-md shadow-md">
        <h3 class="text-xl font-bold mb-4">Historique des paiements</h3>
        <div class="flex font-bold border-b-2 border-gray-800 mb-2">
          <div class="flex-1 text-left py-1">Date</div>
          <div class="flex-1 text-left py-2">Nom</div>
          <div class="flex-1 text-left py-2">Description</div>
          <div class="flex-1 text-left py-2">Montant</div>
        </div>

        <ul class="list-none p-0">
          <li
            v-for="(payment, index) in userStore.payments"
            :key="payment.id"
            :class="{'bg-gray-200': index % 2 === 0, 'bg-white': index % 2 !== 0}"
            class="flex py-3 border-b border-gray-300"
          >
            <div class="flex-1">{{ new Date(payment.created_at).toLocaleDateString('fr-FR') }}</div>
            <div class="flex-1">{{ payment.recipient_first_name }} {{ payment.recipient_last_name }}</div>
            <div class="flex-1">{{ payment.description }}</div>
            <div class="flex-1">{{ formatCurrency(payment.amount) }}</div>
          </li>
        </ul>
      </div>

      <!-- Calculator and Calendar Section -->
      <div class="calculator-and-calendar space-y-4">
        <div class="calculator bg-gray-100 p-4 rounded-md shadow-md">
          <div class="calculator-display bg-gray-200 p-2 text-right text-2xl" ref="calculatorDisplay">0</div>
          <div class="calculator-buttons grid grid-cols-4 gap-2 mt-2">
            <button v-for="btn in calculatorButtons"
                    :key="btn"
                    @click="handleCalculatorButtonClick(btn)"
                    class="bg-goldColor text-white py-2 rounded hover:bg-black transition">
              {{ btn }}
            </button>
          </div>
        </div>

        <div class="calendar bg-gray-100 p-4 rounded-md shadow-md">
          <div class="calendar-header flex justify-between items-center mb-4">
            <button @click="previousMonth" class="bg-goldColor text-white py-1 px-2 rounded hover:bg-black transition">&lt;</button>
            <h3 class="text-lg font-bold">{{ currentMonthYear }}</h3>
            <button @click="nextMonth" class="bg-goldColor text-white py-1 px-2 rounded hover:bg-black transition">&gt;</button>
          </div>
          <div class="calendar-grid grid grid-cols-7">
            <div v-for="day in daysOfWeek" :key="day" class="calendar-day-header font-bold text-center">{{ day }}</div>
            <div v-for="date in calendarDates" :key="date.getTime()"
                  :class="['calendar-day border text-center p-2', { 'bg-blue-100': isCurrentMonth(date), 'bg-blue-300': isToday(date) }]">
              {{ date.getDate() }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { onMounted } from 'vue';
import { useUserStore } from '@/stores/user';
import { useRouter } from 'vue-router';

export default {
  name: 'BankingDashboard',
  data() {
    return {
      navItems: [
        {
          category: 'Gestion de Compte',
          items: [
            { label: 'Comptes', icon: 'fas fa-wallet' },
            { label: 'Transférer de l\'argent', icon: 'fas fa-exchange-alt' },
          ]
        },
        {
          category: 'Services',
          items: [
            { label: 'Outils financiers', icon: 'fas fa-tools' },
            { label: 'Contrôle de carte', icon: 'fas fa-credit-card' },
            { label: 'Envoyer de l\'argent', icon: 'fas fa-paper-plane' },
          ]
        },
        {
          category: 'Autres',
          items: [
            { label: 'Services supplémentaires', icon: 'fas fa-plus-circle' },
            { label: 'Déconnexion', icon: 'fas fa-sign-out-alt' },
          ]
        }
      ],
      currentDate: new Date(),
      daysOfWeek: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'],
      calculatorButtons: ['C', '±', '%', '÷', '7', '8', '9', '×', '4', '5', '6', '-', '1', '2', '3', '+', '0', '.', '='],
      selectedCurrency: '€', // Default currency symbol
      isMobileMenuOpen: false
    };
  },
  setup() {
    const userStore = useUserStore();
    const router = useRouter();

    function handleNavClick(item) {
      if (item === 'Déconnexion') {
        userStore.logout();
        router.push('/');
      } else if (item === 'Envoyer de l\'argent') {
        router.push('/payment-form');
      }
    }

    onMounted(async () => {
      await userStore.fetchUserData();
      await userStore.fetchPayments();
      console.log('test', userStore.fetchPayments());
    });

    return {
      userStore,
      handleNavClick,
    };
  },
  computed: {
    formattedBalance() {
      return this.formatCurrency(this.userStore.user.balance);
    },
    currentMonthYear() {
      return this.currentDate.toLocaleString('fr-FR', { month: 'long', year: 'numeric' });
    },
    calendarDates() {
      const year = this.currentDate.getFullYear();
      const month = this.currentDate.getMonth();
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);

      const dates = [];
      const daysToIncludeBefore = firstDay.getDay();
      const daysToIncludeAfter = 6 - lastDay.getDay();

      for (let i = -daysToIncludeBefore; i < lastDay.getDate() + daysToIncludeAfter; i++) {
        dates.push(new Date(year, month, i + 1));
      }

      return dates;
    },
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
    handleCalculatorButtonClick(button) {
      const display = this.$refs.calculatorDisplay;
      let currentText = display.innerText;

      if (button === 'C') {
        display.innerText = '0';
      } else if (button === '=') {
        try {
          display.innerText = eval(currentText);
        } catch {
          display.innerText = 'Erreur';
        }
      } else {
        if (currentText === '0') {
          display.innerText = button;
        } else {
          display.innerText += button;
        }
      }
    },
    formatCurrency(amount) {
      if (this.selectedCurrency === 'CFA') {
        return `${amount} CFA`;
      }
      return `${this.selectedCurrency}${amount}`;
    },
    handleMobileNavClick(item) {
      this.isMobileMenuOpen = false;
    this.handleNavClick(item);
    },
  },
};
</script>

<style scoped>
.translate-y-0 {
  transform: translateY(0);
}

.-translate-y-full {
  transform: translateY(-100%);
}

.pointer-events-none {
  pointer-events: none;
}
.calendar-day {
  transition: background-color 0.3s;
}

.from-goldColor {
  --tw-gradient-from: #D4AF37;
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to, rgb(212 175 55 / 0));
}

.to-yellow-600 {
  --tw-gradient-to: #CA8A04;
}

/* Dropdown animations */
.group:hover .group-hover\:rotate-180 {
  transform: rotate(180deg);
}

.group:hover .group-hover\:translate-y-0 {
  transform: translateY(0);
}

/* Enhanced transitions */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}
</style>
