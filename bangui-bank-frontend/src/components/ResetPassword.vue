<template>
  <div class="min-h-screen bg-gray-100 flex flex-col items-center justify-center py-8 px-4">
    <div class="w-full max-w-md bg-white rounded-lg shadow-md p-6">
      <h2 class="text-2xl font-bold mb-6">Réinitialiser votre mot de passe</h2>

       <!-- Success Message -->
       <transition
        enter-active-class="transform ease-out duration-300 transition"
        enter-from-class="translate-y-2 opacity-0"
        enter-to-class="translate-y-0 opacity-100"
      >
        <div v-if="showSuccess" class="mb-4 p-4 bg-green-50 rounded-lg flex items-start border-l-4 border-green-400">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <p class="text-sm font-medium text-green-800">
              Instructions envoyées !
            </p>
            <p class="mt-1 text-sm text-green-700">
              Veuillez vérifier votre boîte de réception pour réinitialiser votre mot de passe.
            </p>
          </div>
        </div>
      </transition>

      <!-- Error Message -->
      <transition
        enter-active-class="transform ease-out duration-300 transition"
        enter-from-class="translate-y-2 opacity-0"
        enter-to-class="translate-y-0 opacity-100"
        leave-active-class="transition ease-in duration-100"
        leave-from-class="opacity-100"
        leave-to-class="opacity-0"
      >
        <div v-if="error" class="mb-4 p-4 bg-red-50 rounded-lg flex items-start">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <p class="text-sm font-medium text-red-800">{{ error }}</p>
          </div>
        </div>
      </transition>

      <div v-if="error" class="mb-4 p-3 bg-red-100 text-red-700 rounded-lg">
        {{ error }}
      </div>

      <form @submit.prevent="handleReset" v-if="!showSuccess">
        <input
          type="password"
          v-model="newPassword"
          placeholder="Nouveau mot de passe"
          class="w-full p-3 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-300"
          required
          minlength="6"
        />
        <input
          type="password"
          v-model="confirmPassword"
          placeholder="Confirmer le mot de passe"
          class="w-full p-3 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-300"
          required
          minlength="6"
        />
        <button
          type="submit"
          class="w-full py-3 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600"
          :disabled="isResetting"
        >
          {{ isResetting ? 'Réinitialisation...' : 'Réinitialiser' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useUserStore } from '@/stores/user';
import { useRouter, useRoute } from 'vue-router';

export default {
  setup() {
    const userStore = useUserStore();
    const router = useRouter();
    const route = useRoute();

    const newPassword = ref('');
    const confirmPassword = ref('');
    const isResetting = ref(false);
    const error = ref('');
    const resetToken = ref('');
    const email = ref('');
    const showSuccess = ref(false);

    onMounted(() => {
      resetToken.value = route.query.reset_password_token;
      console.log('Reset token from URL:', resetToken.value); // Debug log
      if (!resetToken.value) {
        error.value = 'Token de réinitialisation manquant';
      }
    });


    // ResetPassword.vue
    const handleReset = async () => {
      try {
        error.value = '';
        console.log('Starting reset with token:', resetToken.value); // Debug log

        if (!resetToken.value) {
          error.value = 'Token de réinitialisation invalide';
          return;
        }

        if (newPassword.value !== confirmPassword.value) {
          error.value = 'Les mots de passe ne correspondent pas';
          return;
        }

        if (newPassword.value.length < 6) {
          error.value = 'Le mot de passe doit contenir au moins 6 caractères';
          return;
        }

        isResetting.value = true;

        const resetData = {
          user: {
            reset_password_token: resetToken.value,
            password: newPassword.value
          }
        };

        console.log('Sending reset data:', resetData); // Debug log

        // Call the resetPassword function from the store
        await userStore.resetPassword(resetToken.value, newPassword.value);

        showSuccess.value = true;

        setTimeout(() => {
          router.push({
            path: '/login',
            query: { reset_success: 'true' }
          });
        }, 2000);
      } catch (err) {
        console.error('Reset error:', err.response?.data || err); // Debug log
        error.value = err.response?.data?.error || 'Erreur lors de la réinitialisation. Veuillez réessayer.';
      } finally {
        isResetting.value = false;
      }
    };

    return {
      newPassword,
      confirmPassword,
      isResetting,
      handleReset,
      error,
      showSuccess  // Added this line
    };
  },
};
</script>