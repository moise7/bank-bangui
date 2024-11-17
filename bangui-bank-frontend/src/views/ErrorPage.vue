<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-xl p-8 max-w-md w-full text-center">
      <div class="mb-6">
        <i class="fas fa-exclamation-circle text-6xl text-goldColor"></i>
      </div>
      <h1 class="text-2xl font-bold text-gray-800 mb-4">
        {{ title || "Une erreur est survenue" }}
      </h1>
      <p class="text-gray-600 mb-8">
        {{ message || "La page que vous recherchez n'est pas disponible." }}
      </p>
      <div class="space-y-4">
        <button @click="goHome"
                class="w-full bg-goldColor hover:bg-yellow-600 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200">
          Retour à l'accueil
        </button>
        <button @click="goBack"
                class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-lg font-medium transition-colors duration-200">
          Page précédente
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { useRouter } from 'vue-router';
import { useUserStore } from '@/stores/user';

export default {
  name: 'ErrorPage',
  props: {
    title: String,
    message: String,
    statusCode: {
      type: Number,
      default: 404
    }
  },
  setup() {
    const router = useRouter();
    const userStore = useUserStore();

    const goHome = () => {
      userStore.logout(); // Clear user data
      router.push('/');
    };

    const goBack = () => {
      router.back();
    };

    return {
      goHome,
      goBack
    };
  }
};
</script> 