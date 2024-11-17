<template>
  <div class="min-h-screen bg-gray-50 p-4 md:p-8">
    <div class="max-w-4xl mx-auto">
      <!-- Header Section -->
      <div class="bg-goldColor rounded-lg p-6 mb-8 text-white shadow-lg">
        <h1 class="text-2xl md:text-4xl font-bold mb-4">
          Services Bancaires Numériques
        </h1>
        <p class="text-lg opacity-90">
          Découvrez les avantages de la banque digitale moderne
        </p>
      </div>

      <!-- Features Overview -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div v-for="(feature, index) in digitalFeatures"
             :key="index"
             class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow duration-300"
        >
          <i :class="[feature.icon, 'text-goldColor text-3xl mb-4']"></i>
          <h3 class="text-xl font-semibold mb-2">{{ feature.title }}</h3>
          <p class="text-gray-600">{{ feature.description }}</p>
        </div>
      </div>

      <!-- Mobile Banking Guide -->
      <div class="bg-white rounded-lg shadow-md p-6 mb-8">
        <h2 class="text-2xl font-bold mb-6">Guide de la Banque Mobile</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div v-for="(guide, index) in mobileGuide"
               :key="index"
               class="border rounded-lg p-4"
          >
            <div class="flex items-center mb-3">
              <div class="w-8 h-8 bg-goldColor rounded-full flex items-center justify-center text-white font-bold mr-3">
                {{ index + 1 }}
              </div>
              <h3 class="font-semibold">{{ guide.title }}</h3>
            </div>
            <p class="text-gray-600 mb-3">{{ guide.description }}</p>
            <div class="bg-gray-50 p-3 rounded">
              <p class="text-sm font-semibold text-goldColor">Conseil Pro:</p>
              <p class="text-sm text-gray-700">{{ guide.tip }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Digital Services -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div v-for="(service, index) in digitalServices"
             :key="index"
             class="bg-white rounded-lg shadow-md overflow-hidden"
        >
          <div class="h-40 bg-gradient-to-r from-goldColor to-yellow-600 p-6 text-white">
            <h3 class="text-xl font-bold mb-2">{{ service.title }}</h3>
            <p class="opacity-90">{{ service.subtitle }}</p>
          </div>
          <div class="p-6">
            <ul class="space-y-3">
              <li v-for="(feature, idx) in service.features"
                  :key="idx"
                  class="flex items-start space-x-3"
              >
                <i class="fas fa-check-circle text-goldColor mt-1"></i>
                <span class="text-gray-700">{{ feature }}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- FAQ Section -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-2xl font-bold mb-6">Questions Fréquentes</h2>
        <div class="space-y-4">
          <div v-for="(faq, index) in faqs"
               :key="index"
               class="border rounded-lg"
          >
            <button
              class="w-full text-left p-4 flex justify-between items-center"
              @click="faq.isOpen = !faq.isOpen"
            >
              <span class="font-semibold">{{ faq.question }}</span>
              <i class="fas" :class="faq.isOpen ? 'fa-chevron-up' : 'fa-chevron-down'"></i>
            </button>
            <div v-show="faq.isOpen" class="p-4 bg-gray-50 border-t">
              <p class="text-gray-700">{{ faq.answer }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DigitalBanking',
  data() {
    return {
      digitalFeatures: [
        {
          icon: 'fas fa-mobile-alt',
          title: 'Banking Mobile',
          description: 'Gérez vos comptes 24/7 depuis votre smartphone avec notre application sécurisée'
        },
        {
          icon: 'fas fa-bolt',
          title: 'Paiements Instantanés',
          description: 'Envoyez et recevez de l\'argent instantanément entre utilisateurs'
        },
        {
          icon: 'fas fa-chart-line',
          title: 'Suivi en Temps Réel',
          description: 'Visualisez vos dépenses et suivez votre budget en temps réel'
        }
      ],
      mobileGuide: [
        {
          title: 'Première Connexion',
          description: 'Téléchargez l\'application et suivez le processus d\'inscription sécurisé',
          tip: 'Utilisez un mot de passe unique et activez la reconnaissance biométrique'
        },
        {
          title: 'Virements et Paiements',
          description: 'Effectuez des virements et payez vos factures en quelques clics',
          tip: 'Enregistrez vos bénéficiaires fréquents pour des paiements plus rapides'
        },
        {
          title: 'Gestion des Cartes',
          description: 'Gérez vos cartes bancaires directement depuis l\'application',
          tip: 'Activez les notifications pour chaque transaction'
        },
        {
          title: 'Support Client',
          description: 'Contactez notre service client via le chat intégré',
          tip: 'Consultez notre FAQ avant de contacter le support'
        }
      ],
      digitalServices: [
        {
          title: 'Services Bancaires Quotidiens',
          subtitle: 'Gérez votre argent facilement',
          features: [
            'Consultation des soldes et transactions',
            'Virements nationaux et internationaux',
            'Paiement de factures',
            'Gestion des cartes bancaires'
          ]
        },
        {
          title: 'Services Premium',
          subtitle: 'Fonctionnalités avancées',
          features: [
            'Analyse des dépenses personnalisée',
            'Assurance voyage premium',
            'Service client prioritaire',
            'Retraits à l\'étranger illimités'
          ]
        }
      ],
      faqs: [
        {
          question: 'Comment activer mon compte en ligne ?',
          answer: 'Téléchargez notre application, suivez le processus d\'inscription et validez votre identité avec une pièce d\'identité officielle.',
          isOpen: false
        },
        {
          question: 'Les services digitaux sont-ils sécurisés ?',
          answer: 'Oui, nous utilisons les dernières technologies de cryptage et l\'authentification à deux facteurs pour protéger vos données.',
          isOpen: false
        },
        {
          question: 'Puis-je utiliser l\'application à l\'étranger ?',
          answer: 'Oui, l\'application est accessible partout dans le monde avec une connexion internet.',
          isOpen: false
        },
        {
          question: 'Que faire en cas de perte de téléphone ?',
          answer: 'Contactez immédiatement notre service client pour désactiver l\'accès mobile et sécuriser votre compte.',
          isOpen: false
        }
      ]
    }
  }
}
</script> 