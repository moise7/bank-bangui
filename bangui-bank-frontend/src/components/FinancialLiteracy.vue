<template>
  <div class="min-h-screen bg-gray-50 p-4 md:p-8">
    <div class="max-w-4xl mx-auto">
      <!-- Header Section -->
      <div class="bg-goldColor rounded-lg p-6 mb-8 text-white shadow-lg">
        <h1 class="text-2xl md:text-4xl font-bold mb-4">{{ $t('financial_education') }}</h1>
        <p class="text-lg opacity-90">{{ $t('financial_literacy_description') }}</p>
      </div>

      <!-- Key Topics Section -->
      <div class="mb-8">
        <h2 class="text-2xl font-bold mb-4">{{ $t('key_topics_in_financial_education') }}</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div v-for="(module, index) in learningModules" :key="index" class="bg-white rounded-lg shadow-md p-6">
            <h3 class="text-xl font-semibold mb-2">{{ $t(module.title) }}</h3>
            <ul>
              <li v-for="(point, idx) in module.points" :key="idx">{{ $t(point) }}</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Financial Tools Section -->
      <div class="bg-white rounded-lg shadow-md p-6 mb-8">
        <h2 class="text-2xl font-bold mb-6">{{ $t('financial_tools') }}</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Budget Calculator -->
          <div class="border rounded-lg p-4">
            <h3 class="font-semibold mb-4">{{ $t('budget_tracker') }}</h3>
            <div class="space-y-4">
              <div>
                <label class="block text-sm text-gray-600 mb-1">{{ $t('total_budget') }}</label>
                <input type="number" v-model="budget.income" class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div>
                <label class="block text-sm text-gray-600 mb-1">{{ $t('amount_spent') }}</label>
                <input type="number" v-model="budget.expenses" class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div class="bg-gray-100 p-3 rounded">
                <p class="font-semibold">{{ $t('amount_spent') }}:</p>
                <p class="text-xl text-goldColor">{{ calculateSavings }} €</p>
              </div>
            </div>
          </div>

          <!-- Savings Goals -->
          <div class="border rounded-lg p-4">
            <h3 class="font-semibold mb-4">{{ $t('savings') }}</h3>
            <div class="space-y-4">
              <div>
                <label class="block text-sm text-gray-600 mb-1">{{ $t('goal') }} (€)</label>
                <input type="number" v-model="savings.goal" class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div>
                <label class="block text-sm text-gray-600 mb-1">{{ $t('monthly_savings') }}</label>
                <input type="number" v-model="savings.monthly" class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div class="bg-gray-100 p-3 rounded">
                <p class="font-semibold">{{ $t('time_needed') }}:</p>
                <p class="text-xl text-goldColor">{{ calculateTimeToGoal }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Financial Tips Section -->
      <div class="bg-gradient-to-r from-goldColor to-yellow-600 rounded-lg p-6 text-white">
        <h2 class="text-xl font-bold mb-4">{{ $t('daily_tips') }}</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div v-for="(tip, index) in dailyTips" :key="index" class="bg-white bg-opacity-20 p-4 rounded-lg">
            <p class="text-sm">{{ tip }}</p>
          </div>
        </div>
      </div>

      <!-- Conditionally Rendered Financial Journey Section -->
      <div v-if="!isUserLoggedIn" class="mt-8 bg-gradient-to-r from-goldColor to-yellow-600 rounded-lg p-6 text-white text-center">
        <h3 class="text-xl md:text-2xl font-bold mb-3">
          Prêt à commencer votre voyage financier ?
        </h3>
        <p class="mb-4">
          Ouvrez un compte aujourd'hui et prenez le contrôle de vos finances
        </p>
        <router-link to="/signup" custom v-slot="{ navigate }">
          <button
            @click="navigate"
            type="button"
            class="py-2 px-3 text-sm font-medium rounded-lg border border-goldColor bg-goldColor text-gray-800 shadow-sm hover:bg-gray-50 focus:outline-none focus:bg-gray-50 transition duration-200"
          >
            Ouvrir un Compte
          </button>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
import { useI18n } from 'vue-i18n';
import { computed } from 'vue';
import { useStore } from 'vuex';

export default {
  name: 'FinancialLiteracy',
  setup() {
    const { t } = useI18n();
    return {
      t,
    };
  },
  data() {
    return {
      learningModules: [
        {
          title: 'what_is_budgeting',
          points: [
            'budgeting_description'
          ]
        },
        {
          title: 'why_budgeting_is_important',
          points: [
            'budgeting_importance_description'
          ]
        },
        {
          title: 'the_50_30_20_rule',
          points: [
            'the_50_30_20_rule_description'
          ]
        },
        {
          title: 'credit_and_debt_management',
          points: [
            'understanding_credit',
            'building_good_credit',
            'managing_debt'
          ]
        },
        {
          title: 'investing',
          points: [
            'what_is_investing',
            'types_of_investments',
            'risk_and_return'
          ]
        },
        {
          title: 'banking_services',
          points: [
            'opening_a_bank_account',
            'types_of_bank_accounts',
            'benefits_of_using_a_bank'
          ]
        },
        {
          title: 'insurance',
          points: [
            'what_is_insurance',
            'types_of_insurance',
            'why_you_need_insurance'
          ]
        },
        {
          title: 'retirement_planning',
          points: [
            'why_plan_for_retirement',
            'retirement_savings_accounts',
            'start_early'
          ]
        },
        {
          title: 'financial_goal_setting',
          points: [
            'short_term_goals',
            'long_term_goals',
            'smart_goals'
          ]
        },
        {
          title: 'taxation',
          points: [
            'what_are_taxes',
            'types_of_taxes',
            'tax_planning'
          ]
        },
        {
          title: 'tips_for_improving_financial_knowledge',
          points: [
            'stay_informed',
            'take_courses',
            'consult_with_financial_advisors',
            'use_financial_tools'
          ]
        },
        {
          title: 'why_financial_education_is_important',
          points: [
            'financial_stability',
            'better_decision_making',
            'debt_avoidance',
            'empowerment'
          ]
        }
      ],
      budget: {
        income: 0,
        expenses: 0
      },
      savings: {
        goal: 0,
        monthly: 0
      },
      dailyTips: [
        'La règle des 50-30-20 : 50% pour les besoins, 30% pour les envies, 20% pour l\'épargne',
        'Créez un fonds d\'urgence couvrant 3 à 6 mois de dépenses',
        'Automatisez vos versements d\'épargne dès réception de votre salaire',
        'Suivez vos dépenses quotidiennes pour identifier les économies potentielles'
      ]
    }
  },
  computed: {
    calculateSavings() {
      return (this.budget.income - this.budget.expenses).toFixed(2);
    },
    calculateTimeToGoal() {
      if (!this.savings.monthly || !this.savings.goal) return '0 mois';
      const months = Math.ceil(this.savings.goal / this.savings.monthly);
      return `${months} mois`;
    }
  }
}
</script>

<style scoped>
/* Add any custom styles here */
input[type="number"] {
  -moz-appearance: textfield;
}
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>