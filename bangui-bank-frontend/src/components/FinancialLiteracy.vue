<template>
  <div class="min-h-screen bg-gray-50 p-4 md:p-8">
    <div class="max-w-4xl mx-auto">
      <!-- Header Section -->
      <div class="bg-goldColor rounded-lg p-6 mb-8 text-white shadow-lg">
        <h1 class="text-2xl md:text-4xl font-bold mb-4">
          Éducation Financière
        </h1>
        <p class="text-lg opacity-90">
          Les bases essentielles pour une meilleure gestion de vos finances
        </p>
      </div>

      <!-- Learning Modules -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div v-for="(module, index) in learningModules"
             :key="index"
             class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
        >
          <div class="h-40 bg-gradient-to-r from-goldColor to-yellow-600 p-6">
            <i :class="[module.icon, 'text-white text-4xl mb-4']"></i>
            <h2 class="text-xl font-bold text-white">{{ module.title }}</h2>
          </div>
          <div class="p-6">
            <ul class="space-y-3">
              <li v-for="(point, idx) in module.points"
                  :key="idx"
                  class="flex items-start space-x-3"
              >
                <i class="fas fa-check text-goldColor mt-1"></i>
                <span class="text-gray-700">{{ point }}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Financial Tools -->
      <div class="bg-white rounded-lg shadow-md p-6 mb-8">
        <h2 class="text-2xl font-bold mb-6">Outils de Calcul Financier</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Budget Calculator -->
          <div class="border rounded-lg p-4">
            <h3 class="font-semibold mb-4">Calculateur de Budget</h3>
            <div class="space-y-4">
              <div>
                <label class="block text-sm text-gray-600 mb-1">Revenu Mensuel</label>
                <input type="number" v-model="budget.income"
                       class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div>
                <label class="block text-sm text-gray-600 mb-1">Dépenses Fixes</label>
                <input type="number" v-model="budget.expenses"
                       class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div class="bg-gray-100 p-3 rounded">
                <p class="font-semibold">Épargne Possible:</p>
                <p class="text-xl text-goldColor">{{ calculateSavings }} €</p>
              </div>
            </div>
          </div>

          <!-- Savings Goals -->
          <div class="border rounded-lg p-4">
            <h3 class="font-semibold mb-4">Objectifs d'Épargne</h3>
            <div class="space-y-4">
              <div>
                <label class="block text-sm text-gray-600 mb-1">Objectif (€)</label>
                <input type="number" v-model="savings.goal"
                       class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div>
                <label class="block text-sm text-gray-600 mb-1">Épargne Mensuelle</label>
                <input type="number" v-model="savings.monthly"
                       class="w-full p-2 border rounded focus:ring-2 focus:ring-goldColor">
              </div>
              <div class="bg-gray-100 p-3 rounded">
                <p class="font-semibold">Temps nécessaire:</p>
                <p class="text-xl text-goldColor">{{ calculateTimeToGoal }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Financial Tips -->
      <div class="bg-gradient-to-r from-goldColor to-yellow-600 rounded-lg p-6 text-white">
        <h2 class="text-xl font-bold mb-4">Conseils Financiers du Jour</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div v-for="(tip, index) in dailyTips"
               :key="index"
               class="bg-white bg-opacity-20 p-4 rounded-lg"
          >
            <p class="text-sm">{{ tip }}</p>
          </div>
        </div>
      </div>

      <div class="mt-8 bg-gradient-to-r from-goldColor to-yellow-600 rounded-lg p-6 text-white text-center">
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
export default {
  name: 'FinancialLiteracy',
  data() {
    return {
      learningModules: [
        {
          icon: 'fas fa-piggy-bank',
          title: 'Bases de l\'Épargne',
          points: [
            'Comprendre les différents types de comptes d\'épargne',
            'Stratégies d\'épargne automatique',
            'Comment définir des objectifs d\'épargne réalistes'
          ]
        },
        {
          icon: 'fas fa-chart-pie',
          title: 'Gestion Budgétaire',
          points: [
            'Création d\'un budget mensuel',
            'Suivi des dépenses',
            'Identification des dépenses superflues'
          ]
        },
        {
          icon: 'fas fa-coins',
          title: 'Investissement',
          points: [
            'Principes de base de l\'investissement',
            'Diversification du portefeuille',
            'Comprendre les risques et rendements'
          ]
        },
        {
          icon: 'fas fa-university',
          title: 'Crédit et Endettement',
          points: [
            'Comprendre votre score de crédit',
            'Gestion responsable du crédit',
            'Stratégies de remboursement de dettes'
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
      return (this.budget.income - this.budget.expenses).toFixed(2)
    },
    calculateTimeToGoal() {
      if (!this.savings.monthly || !this.savings.goal) return '0 mois'
      const months = Math.ceil(this.savings.goal / this.savings.monthly)
      return `${months} mois`
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