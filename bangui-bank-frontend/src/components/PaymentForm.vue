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
        <h1 class="text-3xl font-bold text-gray-800 mb-2">{{ $t('money_transfer') }}</h1>
        <p class="text-gray-600">{{ $t('send_money_description') }}</p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-xl shadow-xl p-6 md:p-8">
        <form @submit.prevent="makePayment" class="space-y-6">
          <!-- Balance Information -->
          <div class="bg-gray-50 rounded-lg p-4 mb-6">
            <div class="flex justify-between items-center">
              <span class="text-gray-600">{{ $t('available_balance') }}:</span>
              <span class="text-xl font-bold text-gray-800">
                {{ userStore.user?.balance || '0.00' }} €
              </span>
            </div>
          </div>

          <!-- Payment Type Selection -->
          <div class="space-y-4">
            <label class="block text-sm font-medium text-gray-700">{{ $t('transfer_type') }}</label>
            <div class="flex items-center gap-6">
              <div>
                <input type="radio" id="user-transfer" value="user" v-model="paymentType" />
                <label for="user-transfer" class="text-gray-700">{{ $t('send_to_user') }}</label>
              </div>
              <div>
                <input type="radio" id="mobile-wallet" value="mobile" v-model="paymentType" />
                <label for="mobile-wallet" class="text-gray-700">{{ $t('send_to_mobile_wallet') }}</label>
              </div>
            </div>
          </div>

          <!-- Receiver Email (Visible if 'user' is selected) -->
          <div v-if="paymentType === 'user'" class="space-y-2">
            <label for="receiver-email" class="block text-sm font-medium text-gray-700">
              {{ $t('receiver_email') }}
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

          <!-- Mobile Wallet Information -->
          <div v-if="paymentType === 'mobile'" class="space-y-2 text-center py-6 bg-gray-50 rounded-lg shadow-md">
            <p class="text-2xl font-bold text-gray-800">
              {{ $t('feature_coming_soon') }}
            </p>
            <p class="text-lg text-gray-600">
              {{ $t('feature_coming_soon_description') }}
            </p>
          </div>

          <!-- Amount -->
          <div class="space-y-2">
            <label for="amount" class="block text-sm font-medium text-gray-700">
              {{ $t('amount_to_send') }}
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
              {{ $t('description') }}
            </label>
            <div class="relative">
              <i class="fas fa-comment absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              <input type="text"
                     v-model="description"
                     required
                     class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-goldColor focus:border-transparent"
                     placeholder="{{ $t('transfer_reason') }}" />
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
              {{ $t('send') }}
            </button>
            <button @click="goToDashboard"
                    type="button"
                    class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center gap-2">
              <i class="fas fa-arrow-left"></i>
              {{ $t('back_to_dashboard') }}
            </button>
          </div>
        </form>
      </div>

      <!-- Security Notice -->
      <div class="mt-8 text-center text-sm text-gray-600">
        <p class="flex items-center justify-center gap-2">
          <i class="fas fa-shield-alt"></i>
          {{ $t('secure_transactions') }}
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
    const paymentType = ref('user');  // 'user' or 'mobile'

    // Fetch user data when component mounts
    onMounted(async () => {
      await userStore.fetchUserData();
    });

    const makePayment = async () => {
      try {
        if (paymentType.value === 'mobile') {
          error.value = 'Cette fonctionnalité sera bientôt disponible.';
          return;
        }

        loading.value = true;
        error.value = '';
        successNotificationMessage.value = '';
        showSuccessNotification.value = false;

        await userStore.createPayment({
          receiver_email: paymentType.value === 'user' ? receiverEmail.value : null,
          amount: Number(amount.value),
          description: description.value
        });

        successNotificationMessage.value = 'Paiement complété, redirection vers le tableau de bord...';

        receiverEmail.value = '';
        amount.value = '';
        description.value = '';

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
      loading,
      loadingMessage,
      showSuccessNotification,
      successNotificationMessage,
      paymentType,
      makePayment,
      goToDashboard,
      userStore
    };
  },
};
</script>
