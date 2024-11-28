<template>
  <div class="min-h-screen bg-gray-100 flex flex-col items-center justify-center py-8 px-4">
    <div class="w-full max-w-md bg-white rounded-lg shadow-md p-6">
      <h2 class="text-2xl font-bold mb-6">Réinitialiser votre mot de passe</h2>
      <form @submit.prevent="handleReset">
        <input
          type="password"
          v-model="newPassword"
          placeholder="Nouveau mot de passe"
          class="w-full p-3 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-300"
          required
        />
        <input
          type="password"
          v-model="confirmPassword"
          placeholder="Confirmer le mot de passe"
          class="w-full p-3 mb-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-300"
          required
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
import { ref } from 'vue';
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

    const handleReset = async () => {
      if (newPassword.value !== confirmPassword.value) {
        alert('Les mots de passe ne correspondent pas');
        return;
      }

      isResetting.value = true;
      try {
        await userStore.resetPassword(route.query.token, newPassword.value);
        alert('Mot de passe réinitialisé avec succès');
        router.push('/login');
      } catch (error) {
        alert('Erreur lors de la réinitialisation. Veuillez réessayer.');
      } finally {
        isResetting.value = false;
      }
    };

    return {
      newPassword,
      confirmPassword,
      isResetting,
      handleReset,
    };
  },
};
</script> 