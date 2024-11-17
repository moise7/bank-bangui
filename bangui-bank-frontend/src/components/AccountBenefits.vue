<template>
  <div class="min-h-screen bg-gray-50 p-4 md:p-8">
    <div class="max-w-4xl mx-auto">
      <!-- Header Section -->
      <div class="bg-goldColor rounded-lg p-6 mb-8 text-white shadow-lg">
        <h1 class="text-2xl md:text-4xl font-bold mb-4">
          Pourquoi Avoir un Compte Bancaire ?
        </h1>
        <p class="text-lg opacity-90">
          Découvrez les avantages essentiels d'un compte bancaire dans le monde moderne
        </p>
      </div>

      <!-- Main Content -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Key Benefits Cards -->
        <div v-for="(benefit, index) in benefits"
             :key="index"
             class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-300"
        >
          <div class="flex items-center mb-4">
            <i :class="[benefit.icon, 'text-goldColor text-2xl mr-3']"></i>
            <h2 class="text-xl font-semibold">{{ benefit.title }}</h2>
          </div>
          <p class="text-gray-600">{{ benefit.description }}</p>
        </div>
      </div>

      <!-- Additional Information -->
      <div class="mt-8 bg-white rounded-lg p-6 shadow-md">
        <h2 class="text-2xl font-bold mb-4">Le Saviez-vous ?</h2>
        <div class="space-y-4">
          <div v-for="(fact, index) in facts"
               :key="index"
               class="flex items-start space-x-3"
          >
            <i class="fas fa-check-circle text-goldColor mt-1"></i>
            <p class="text-gray-700">{{ fact }}</p>
          </div>
        </div>
      </div>

      <!-- Call to Action -->
      <div class="mt-8 bg-gradient-to-r from-goldColor to-yellow-600 rounded-lg p-6 text-white text-center">
        <h3 class="text-xl md:text-2xl font-bold mb-3">
          Prêt à commencer votre voyage financier ?
        </h3>
        <p class="mb-4">
          Ouvrez un compte aujourd'hui et prenez le contrôle de vos finances
        </p>
        <button class="bg-white text-goldColor px-6 py-2 rounded-full font-bold hover:bg-gray-100 transition-colors duration-300">
          Ouvrir un Compte
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AccountBenefits',
  data() {
    return {
      benefits: [
        {
          icon: 'fas fa-shield-alt',
          title: 'Sécurité Maximale',
          description: "Protégez votre argent contre le vol et la perte. Les comptes bancaires offrent une sécurité garantie par l'État."
        },
        {
          icon: 'fas fa-mobile-alt',
          title: 'Paiements Simplifiés',
          description: 'Effectuez des transactions en ligne, payez vos factures et gérez votre argent depuis votre téléphone.'
        },
        {
          icon: 'fas fa-chart-line',
          title: 'Croissance Financière',
          description: "Accédez à des options d'épargne et d'investissement pour faire fructifier votre argent."
        },
        {
          icon: 'fas fa-history',
          title: 'Historique Financier',
          description: 'Construisez un historique financier solide pour accéder plus facilement aux crédits et services bancaires.'
        }
      ],
      facts: [
        'Plus de 80% des adultes en Europe possèdent un compte bancaire.',
        "Les services bancaires mobiles permettent d'économiser en moyenne 2 heures par mois.",
        'Un compte bancaire est essentiel pour recevoir un salaire dans la plupart des entreprises.',
        "Les paiements électroniques sont jusqu'à 10 fois moins coûteux que les transactions en espèces."
      ]
    }
  }
}
</script>

<style scoped>
/* Add any custom styles here */
.from-goldColor {
  --tw-gradient-from: #B8860B;
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to, rgb(184 134 11 / 0));
}

.to-yellow-600 {
  --tw-gradient-to: #D97706;
}
</style>