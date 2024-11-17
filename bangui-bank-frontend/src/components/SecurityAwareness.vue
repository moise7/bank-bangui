<template>
  <div class="min-h-screen bg-gray-50 p-4 md:p-8">
    <div class="max-w-4xl mx-auto">
      <!-- Header Section -->
      <div class="bg-goldColor rounded-lg p-6 mb-8 text-white shadow-lg">
        <h1 class="text-2xl md:text-4xl font-bold mb-4">
          Sécurité Bancaire
        </h1>
        <p class="text-lg opacity-90">
          Protégez vos informations bancaires et évitez les fraudes
        </p>
      </div>

      <!-- Security Alerts Banner -->
      <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-8 rounded-r-lg">
        <div class="flex items-center">
          <i class="fas fa-exclamation-triangle text-red-500 text-xl mr-3"></i>
          <div>
            <h2 class="text-red-800 font-semibold">Alerte de Sécurité Importante</h2>
            <p class="text-red-700">Nous ne vous demanderons jamais vos identifiants bancaires par email ou téléphone.</p>
          </div>
        </div>
      </div>

      <!-- Security Best Practices -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div v-for="(practice, index) in securityPractices"
             :key="index"
             class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow duration-300"
        >
          <div class="flex items-center mb-4">
            <i :class="[practice.icon, 'text-goldColor text-2xl mr-3']"></i>
            <h3 class="text-xl font-semibold">{{ practice.title }}</h3>
          </div>
          <ul class="space-y-3">
            <li v-for="(tip, idx) in practice.tips"
                :key="idx"
                class="flex items-start space-x-3"
            >
              <i class="fas fa-check-circle text-goldColor mt-1"></i>
              <span class="text-gray-700">{{ tip }}</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Fraud Detection -->
      <div class="bg-white rounded-lg shadow-md p-6 mb-8">
        <h2 class="text-2xl font-bold mb-6">Reconnaître les Tentatives de Fraude</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div v-for="(fraud, index) in fraudTypes"
               :key="index"
               class="border rounded-lg p-4 bg-red-50"
          >
            <div class="flex items-center mb-3">
              <i class="fas fa-warning text-red-500 mr-2"></i>
              <h3 class="font-semibold text-red-800">{{ fraud.type }}</h3>
            </div>
            <p class="text-gray-700 mb-3">{{ fraud.description }}</p>
            <div class="bg-white p-3 rounded">
              <p class="font-semibold text-sm text-red-800">Comment se protéger:</p>
              <p class="text-sm text-gray-700">{{ fraud.protection }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Security Checklist -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-2xl font-bold mb-6">Checklist de Sécurité Quotidienne</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div v-for="(item, index) in securityChecklist"
               :key="index"
               class="flex items-center space-x-3 p-3 border rounded hover:bg-gray-50"
          >
            <input type="checkbox"
                   :id="'check-' + index"
                   class="form-checkbox h-5 w-5 text-goldColor">
            <label :for="'check-' + index" class="text-gray-700">{{ item }}</label>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SecurityAwareness',
  data() {
    return {
      securityPractices: [
        {
          icon: 'fas fa-lock',
          title: 'Mots de Passe Sécurisés',
          tips: [
            'Utilisez des mots de passe complexes avec des caractères spéciaux',
            'Changez vos mots de passe régulièrement',
            'Ne réutilisez pas les mêmes mots de passe'
          ]
        },
        {
          icon: 'fas fa-shield-alt',
          title: 'Authentification à Deux Facteurs',
          tips: [
            'Activez l\'authentification à deux facteurs',
            'Utilisez une application d\'authentification',
            'Ne partagez jamais vos codes de vérification'
          ]
        },
        {
          icon: 'fas fa-wifi',
          title: 'Sécurité en Ligne',
          tips: [
            'Évitez les réseaux Wi-Fi publics',
            'Utilisez un VPN pour les transactions',
            'Vérifiez toujours l\'URL du site bancaire'
          ]
        },
        {
          icon: 'fas fa-mobile-alt',
          title: 'Sécurité Mobile',
          tips: [
            'Verrouillez votre téléphone avec un code',
            'Installez uniquement des applications officielles',
            'Maintenez votre système à jour'
          ]
        }
      ],
      fraudTypes: [
        {
          type: 'Phishing',
          description: 'Emails ou SMS frauduleux imitant votre banque',
          protection: 'Ne cliquez jamais sur les liens suspects et vérifiez toujours l\'adresse de l\'expéditeur'
        },
        {
          type: 'Skimming',
          description: 'Vol de données de carte bancaire aux distributeurs',
          protection: 'Vérifiez l\'apparence du distributeur et cachez votre code'
        },
        {
          type: 'Usurpation d\'identité',
          description: 'Utilisation frauduleuse de vos informations personnelles',
          protection: 'Surveillez régulièrement vos relevés bancaires et signalez toute activité suspecte'
        },
        {
          type: 'Arnaque au support technique',
          description: 'Faux appels du service client bancaire',
          protection: 'Ne donnez jamais vos identifiants par téléphone et raccrochez en cas de doute'
        }
      ],
      securityChecklist: [
        'Vérifier mes relevés bancaires',
        'Utiliser une connexion sécurisée',
        'Maintenir mes appareils à jour',
        'Surveiller les notifications bancaires',
        'Vérifier les autorisations des applications',
        'Sauvegarder mes documents importants',
        'Scanner mon appareil pour les virus',
        'Vérifier les paramètres de sécurité'
      ]
    }
  }
}
</script> 