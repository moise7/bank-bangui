<template>
  <div class="login bg-gray-100 min-h-screen flex flex-col items-center justify-center py-8 px-4 font-mona">
    <h3 class="text-3xl font-extrabold text-gray-700 mb-6">{{ $t('welcome_back') }}</h3>

    <!-- Success Message -->
    <transition
      enter-active-class="transform ease-out duration-300 transition"
      enter-from-class="translate-y-2 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition ease-in duration-100"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="resetSuccess"
        class="w-full max-w-md mb-4 p-4 bg-green-50 rounded-lg flex items-start border-l-4 border-green-400"
      >
        <div class="flex-shrink-0">
          <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
          </svg>
        </div>
        <div class="ml-3">
          <p class="text-sm font-medium text-green-800">
            {{ $t('instructions_sent') }}
          </p>
          <p class="mt-1 text-sm text-green-700">
            {{ $t('check_your_inbox') }}
          </p>
        </div>
      </div>
    </transition>

    <!-- Error Message -->
    <div v-if="resetError" class="w-full max-w-md mb-4 p-4 bg-red-100 text-red-700 rounded-lg">
      {{ resetError }}
    </div>

    <form @submit="onLogin" class="w-full max-w-md shadow-md rounded-lg bg-white p-6">
      <input
        class="w-full p-3 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-300"
        type="text"
        v-model="loginUsername"
        :placeholder="$t('username_placeholder')"
      />
      <input
        type="password"
        class="w-full p-3 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-300"
        v-model="loginPassword"
        :placeholder="$t('password_placeholder')"
      />
      <div class="flex justify-end mb-4">
        <button
          type="button"
          @click="showResetModal = true"
          class="text-sm text-yellow-500 hover:text-yellow-600"
        >
          {{ $t('forgot_password') }}
        </button>
      </div>
      <input
        type="submit"
        :value="$t('login')"
        class="w-full py-3 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition-colors duration-300 cursor-pointer"
      />
    </form>

    <!-- Password Reset Modal -->
    <div v-if="showResetModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h4 class="text-xl font-bold mb-4">{{ $t('reset_password') }}</h4>
        <form @submit.prevent="requestPasswordReset">
          <input
            type="email"
            v-model="resetEmail"
            :placeholder="$t('your_email')"
            class="w-full p-3 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-300"
            required
          />
          <div class="flex justify-end space-x-3">
            <button
              type="button"
              @click="closeResetModal"
              class="px-4 py-2 text-gray-600 hover:text-gray-800"
            >
              {{ $t('cancel') }}
            </button>
            <button
              type="submit"
              class="px-4 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600"
              :disabled="isResetting"
            >
              {{ isResetting ? $t('sending') : $t('send') }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="loginError" class="text-red-500 mt-4">
      {{ loginError }}
    </div>
    <p class="text-gray-600 mt-6">
      {{ $t('no_account') }}
      <router-link
        to="/signup"
        class="text-yellow-500 font-semibold hover:underline hover:text-yellow-600 transition-colors duration-300"
      >
        {{ $t('signup') }}
      </router-link>
    </p>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useUserStore } from '@/stores/user';
import { useRouter, useRoute } from 'vue-router';

export default {
  name: "Login",
  setup() {
    const userStore = useUserStore();
    const router = useRouter();
    const route = useRoute();

    const loginUsername = ref("");
    const loginPassword = ref("");
    const loginError = ref(null);
    const showResetModal = ref(false);
    const resetEmail = ref("");
    const isResetting = ref(false);
    const resetError = ref("");
    const resetSuccess = ref(false);

    onMounted(() => {
      // Check for reset success query parameter
      if (route.query.reset_success === 'true') {
        resetSuccess.value = true;
        // Clear the query parameter after showing the message
        router.replace({ query: {} });

        // Auto-hide success message after 5 seconds
        setTimeout(() => {
          resetSuccess.value = false;
        }, 8000); // Hide after 8 seconds
      }
    });

    const closeResetModal = () => {
      showResetModal.value = false;
      resetEmail.value = "";
      resetError.value = "";
    };

    const requestPasswordReset = async () => {
      if (!resetEmail.value) {
        resetError.value = "Veuillez entrer votre adresse email";
        return;
      }

      isResetting.value = true;
      resetError.value = "";

      try {
        await userStore.requestPasswordReset({
          user: {
            email: resetEmail.value
          }
        });
        closeResetModal();
        // Remove the alert and show the success message instead
        resetSuccess.value = true;

        // Auto-hide success message after 5 seconds
        setTimeout(() => {
          resetSuccess.value = false;
        }, 8000);
      } catch (error) {
        resetError.value = error.response?.data?.error ||
          'Erreur lors de la demande de réinitialisation. Veuillez réessayer.';
      } finally {
        isResetting.value = false;
      }
    };

    const onLogin = async (event) => {
      event.preventDefault();
      loginError.value = null;

      try {
        await userStore.loginUser({
          username: loginUsername.value,
          password: loginPassword.value,
        });

        if (userStore.isAuthenticated && userStore.user?.id) {
          router.push(`/dashboard/${userStore.user.id}`);
        } else {
          loginError.value = "Les données utilisateur ne sont pas disponibles.";
        }
      } catch (error) {
        console.error('Erreur de connexion:', error);
        loginError.value = "Identifiants invalides. Veuillez réessayer.";
      }
    };

    return {
      loginUsername,
      loginPassword,
      loginError,
      onLogin,
      showResetModal,
      resetEmail,
      isResetting,
      requestPasswordReset,
      closeResetModal,
      resetError,
      resetSuccess
    };
  },
};
</script>

