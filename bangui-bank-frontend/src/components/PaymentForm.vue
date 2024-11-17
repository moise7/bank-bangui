<template>
  <div class="relative min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 p-4 font-mona">
    <!-- Loading Overlay -->
    <div v-if="loading"
         class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 backdrop-blur-sm">
      <div class="bg-white p-6 rounded-lg shadow-xl flex flex-col items-center">
        <div class="animate-spin rounded-full h-12 w-12 border-4 border-goldColor border-t-transparent"></div>
        <p class="mt-4 text-gray-700">{{ loadingMessage }}</p>
      </div>
    </div>

    <!-- Success Notification -->
    <div v-if="showSuccessNotification"
         class="fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-xl transform transition-all duration-300 ease-out z-40"
         :class="showSuccessNotification ? 'translate-y-0' : 'translate-y-full'">
      <div class="flex items-center gap-3">
        <i class="fas fa-check-circle text-xl"></i>
        <span>{{ successNotificationMessage }}</span>
        <button @click="showSuccessNotification = false"
                class="ml-2 hover:text-gray-200 transition-colors">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <!-- Main Content -->
    <div class="max-w-4xl mx-auto mt-8">
      <!-- Header -->
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-2">Transfert d'argent</h1>
        <p class="text-gray-600">Envoyez de l'argent à un autre membre de Bangui Bank</p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-xl shadow-xl p-6 md:p-8">
        <form @submit.prevent="makePayment" class="space-y-6">
          <!-- Balance Information -->
          <div class="bg-gray-50 rounded-lg p-4 mb-6">
            <div class="flex justify-between items-center">
              <span class="text-gray-600">Solde disponible:</span>
              <span class="text-xl font-bold text-gray-800">
                {{ userStore.user?.balance || '0.00' }} €
              </span>
            </div>
          </div>

          <!-- Receiver Email -->
          <div class="space-y-2">
            <label for="receiver-email" class="block text-sm font-medium text-gray-700">
              Email du destinataire
            </label>
            <div class="relative">
              <i class="fas fa-envelope absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              <input type="email"
                     v-model="receiverEmail"
                     required
                     class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-goldColor focus:border-transparent"
                     placeholder="exemple@bangui-bank.com" />
            </div>
          </div>

          <!-- Amount -->
          <div class="space-y-2">
            <label for="amount" class="block text-sm font-medium text-gray-700">
              Montant à envoyer
            </label>
            <div class="relative">
              <i class="fas fa-coins absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              <input type="number"
                     v-model="amount"
                     required
                     min="0.01"
                     step="0.01"
                     class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-goldColor focus:border-transparent"
                     placeholder="0.00" />
            </div>
          </div>

          <!-- Description -->
          <div class="space-y-2">
            <label for="description" class="block text-sm font-medium text-gray-700">
              Description
            </label>
            <div class="relative">
              <i class="fas fa-comment absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              <input type="text"
                     v-model="description"
                     required
                     class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-goldColor focus:border-transparent"
                     placeholder="Motif du transfert" />
            </div>
          </div>

          <!-- Error Message -->
          <div v-if="error"
               class="bg-red-50 border-l-4 border-red-500 p-4 rounded">
            <div class="flex items-center">
              <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
              <p class="text-red-700">{{ error }}</p>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 pt-4">
            <button type="submit"
                    class="flex-1 bg-goldColor hover:bg-yellow-600 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center gap-2">
              <i class="fas fa-paper-plane"></i>
              Envoyer
            </button>
            <button @click="goToDashboard"
                    type="button"
                    class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center gap-2">
              <i class="fas fa-arrow-left"></i>
              Retour au tableau de bord
            </button>
          </div>
        </form>
      </div>

      <!-- Security Notice -->
      <div class="mt-8 text-center text-sm text-gray-600">
        <p class="flex items-center justify-center gap-2">
          <i class="fas fa-shield-alt"></i>
          Vos transactions sont sécurisées et cryptées
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '@/stores/user';

export default {
  setup() {
    const router = useRouter();
    const userStore = useUserStore();
    const receiverEmail = ref('');
    const amount = ref('');
    const description = ref('');
    const error = ref('');
    const loadingMessage = ref('Traitement en cours...');
    const successNotificationMessage = ref('');
    const loading = ref(false);
    const showSuccessNotification = ref(false);
    const userBalance = ref(0);

    // Fetch user data when component mounts
    onMounted(async () => {
      await userStore.fetchUserData();
    });

    const makePayment = async () => {
      try {
        loading.value = true;
        error.value = '';
        successNotificationMessage.value = '';
        showSuccessNotification.value = false;

        await userStore.createPayment({
          receiver_email: receiverEmail.value,
          amount: Number(amount.value),
          description: description.value
        });

        successNotificationMessage.value = 'Paiement complété, redirection vers le tableau de bord...';

        setTimeout(() => {
          showSuccessNotification.value = true;
          setTimeout(() => {
            router.push(`/dashboard/${userStore.userId}`);
          }, 100);
        }, 900);

      } catch (err) {
        error.value = err.response?.data?.error || 'Une erreur est survenue lors du paiement';
      } finally {
        loading.value = false;
      }
    };

    const goToDashboard = () => {
      router.push(`/dashboard/${userStore.userId}`);
    };

    return {
      receiverEmail,
      amount,
      description,
      error,
      loadingMessage,
      successNotificationMessage,
      loading,
      showSuccessNotification,
      makePayment,
      goToDashboard,
      userStore
    };
  }
};
</script>

<style scoped>
.from-goldColor {
  --tw-gradient-from: #D4AF37;
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to, rgb(212 175 55 / 0));
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}

/* Mobile Responsive Adjustments */
@media (max-width: 640px) {
  .max-w-4xl {
    width: 100%;
  }

  .p-6 {
    padding: 1rem;
  }

  .text-3xl {
    font-size: 1.5rem;
  }
}

/* Input Focus Styles */
input:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(212, 175, 55, 0.2);
}

/* Smooth Transitions */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}
</style>
