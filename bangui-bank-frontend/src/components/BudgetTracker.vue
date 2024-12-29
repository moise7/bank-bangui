<template>
  <div class="relative min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 p-6">
    <!-- Budget Tracker Form -->
    <div class="max-w-2xl mx-auto bg-white rounded-xl shadow-lg p-4">
      <!-- Header Section -->
      <h1 class="text-2xl font-bold text-center text-goldColor mb-4">{{ t('budget_tracker') }}</h1>

      <!-- Form -->
      <form @submit.prevent="updateProgress" class="space-y-4">
        <!-- Total Budget -->
        <div class="input-group">
          <label for="totalBudget" class="block text-sm font-medium text-gray-700">{{ t('total_budget') }}</label>
          <input
            type="number"
            id="totalBudget"
            v-model="totalBudget"
            placeholder="{{ t('enter_total_budget') }}"
            class="border border-gray-300 shadow-sm p-3 rounded-lg w-full focus:ring-2 focus:ring-goldColor"
          />
        </div>

        <!-- Category Spending -->
        <div v-for="category in categories" :key="category.name" class="input-group">
          <label for="category" class="block text-sm font-medium text-gray-700">{{ category.name }}</label>
          <input
            type="number"
            :id="category.name"
            v-model="category.amountSpent"
            placeholder="{{ t('enter_amount_spent') }}"
            class="border border-gray-300 shadow-sm p-3 rounded-lg w-full focus:ring-2 focus:ring-goldColor"
          />
          <span :class="{
            'text-red-500': category.percentage > 100,
            'text-green-500': category.percentage <= 100
          }">
            {{ category.percentage !== undefined ? category.percentage.toFixed(2) : '0.00' }}%
            {{ category.percentage > 100 ? '(Over Budget!)' : '' }}
          </span>
        </div>

        <!-- Update Button -->
        <button
          @click="updateProgress"
          class="bg-goldColor text-white p-3 rounded-lg w-full hover:bg-yellow-600 transition duration-200 mt-4"
        >
          {{ t('update_budget') }}
        </button>

        <!-- Alert Message -->
        <div v-if="alertMessage" class="text-red-500 mt-4 text-center font-semibold">{{ alertMessage }}</div>

        <!-- Congratulatory/Encouraging Message -->
        <div v-if="monthEndMessage" class="mt-4 text-center font-semibold text-green-500">
          {{ monthEndMessage }}
        </div>

        <!-- Back to Dashboard Button -->
        <button
          @click="goToDashboard"
          type="button"
          class="bg-gray-100 text-gray-700 px-6 py-3 rounded-lg w-full mt-4 hover:bg-gray-200 transition duration-200"
        >
          {{ t('back_to_dashboard') }}
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useI18n } from 'vue-i18n'; // Import useI18n
import { useRouter } from 'vue-router'; // For navigating back to dashboard

export default {
  setup() {
    const { t } = useI18n(); // Get the translation function
    const router = useRouter(); // For navigation

    const totalBudget = ref(0);
    const categories = ref([
      { name: 'Groceries', amountSpent: 0, percentage: undefined },
      { name: 'Entertainment', amountSpent: 0, percentage: undefined },
      { name: 'Utilities', amountSpent: 0, percentage: undefined },
      { name: 'Other', amountSpent: 0, percentage: undefined },
    ]);
    const alertMessage = ref('');
    const monthEndMessage = ref('');

    // Compute percentages for each category
    const updateProgress = () => {
      let totalSpent = 0;
      categories.value.forEach((category) => {
        totalSpent += category.amountSpent;
        category.percentage = (category.amountSpent / totalBudget.value) * 100;
      });

      // Check for alerts
      alertMessage.value = '';
      categories.value.forEach((category) => {
        if (category.percentage > 100) {
          alertMessage.value = `${category.name} is over budget! Reduce spending in this category.`;
        }
      });

      // Check if user met their goal
      if (totalSpent <= totalBudget.value) {
        monthEndMessage.value = "Congratulations! You've met your goal!";
      } else {
        monthEndMessage.value = "Keep going! Set a new goal for next month.";
      }
    };

    const goToDashboard = () => {
      router.push('/dashboard'); // Navigate back to the dashboard
    };

    return {
      t,
      totalBudget,
      categories,
      alertMessage,
      monthEndMessage,
      updateProgress,
      goToDashboard,
    };
  },
};
</script>

<style scoped>
/* Full-Screen Layout with responsive design */
@media (max-width: 640px) {
  .h-screen {
    height: 100%;
  }

  .input-group input, .input-group select {
    padding: 1rem;
  }

  button {
    padding: 1rem;
  }
}

.input-group label {
  font-size: 1rem;
  margin-bottom: 0.5rem;
}

.input-group input,
.input-group select {
  font-size: 1.125rem;
  margin-bottom: 1rem;
}

/* Gold button styles */
.bg-goldColor {
  background-color: #ffbc00;
}

button:hover {
  background-color: #e6a900;
}

.bg-gray-100 {
  background-color: #f3f4f6;
}

button:hover {
  background-color: #e6e8eb;
}
</style>
