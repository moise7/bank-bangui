<template>
  <div class="signup bg-gray-200 min-h-screen flex flex-col items-center justify-center p-4">
    <h3 class="text-2xl font-bold mb-6">Inscription</h3>
    <form @submit="onSignUp" class="w-full max-w-md bg-white p-6 rounded-lg shadow-md">
      <!-- First Name -->
      <input
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        type="text"
        v-model="firstName"
        placeholder="Prénom *"
        required
      />

      <!-- Middle Name -->
      <input
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        type="text"
        v-model="middleName"
        placeholder="Deuxième Prénom (optionnel)"
      />

      <!-- Last Name -->
      <input
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        type="text"
        v-model="lastName"
        placeholder="Nom de Famille *"
        required
      />

      <!-- Date of Birth -->
      <div class="relative w-full mb-4">
        <div class="relative">
          <input
            class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none"
            type="date"
            v-model="dateOfBirth"
            :min="minDate"
            :max="maxDate"
            :placeholder="'JJ/MM/AAAA *'"
            required
          />
          <div class="absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-gray-400">
            <i class="fas fa-calendar"></i>
          </div>
        </div>
      </div>

      <!-- Country Dropdown -->
      <select
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        v-model="country"
        required
      >
        <option disabled value="">Sélectionnez un Pays *</option>
        <option value="République Centrafricaine">République Centrafricaine</option>
      </select>

      <!-- Town Dropdown -->
      <div v-if="country === 'République Centrafricaine'" class="relative">
      <select
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        v-model="town"
        :disabled="isLoadingTowns"
      >
        <option disabled value="">
          {{ isLoadingTowns ? 'Chargement des villes...' : 'Sélectionnez une Ville' }}
        </option>
        <option v-for="townItem in towns" :key="townItem" :value="townItem">
          {{ townItem }}
        </option>
      </select>

      <!-- Loading indicator -->
      <div v-if="isLoadingTowns" class="absolute right-3 top-1/2 -translate-y-1/2">
        <svg class="animate-spin h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>
      </div>

      <!-- Phone Number -->
      <input
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        type="text"
        v-model="phoneNumber"
        placeholder="Numéro de Téléphone *"
        required
      />

      <!-- Username -->
      <input
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        type="text"
        id="username"
        v-model="username"
        placeholder="Nom d'utilisateur *"
        @focus="showUsernameExample = true"
        @blur="showUsernameExample = false"
        required
      />
      <div v-if="showUsernameExample" class="username-example">
        <p>Exemple d'un bon nom d'utilisateur :</p>
        <p><strong>{{ generateUsernameExample() }}</strong></p>
        <p>Conseils pour un nom d'utilisateur fort :</p>
        <ul>
          <li>Incluez à la fois des lettres et des chiffres</li>
          <li>Évitez d'utiliser votre nom complet</li>
          <li>Envisagez d'ajouter des caractères spéciaux comme '_' ou '-' </li>
        </ul>
      </div>

      <!-- Email -->
      <input
        class="w-full p-3 mb-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
        type="email"
        v-model="email"
        placeholder="Email *"
        required
      />

      <!-- Password -->
    <label for="password" class="block text-gray-700 font-medium mb-2">Mot de Passe *</label>
    <input
      id="password"
      class="w-full p-3 mb-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
      type="password"
      v-model="password"
      placeholder="Mot de Passe *"
      @input="evaluateStrength"
      required
    />
    <!-- Password Strength Meter -->
    <div class="w-full h-2 bg-gray-300 rounded mb-2">
      <div
        :class="strengthClass"
        :style="{ width: strengthPercentage + '%' }"
        class="h-full rounded transition-all duration-300"
      ></div>
    </div>
    <p class="text-sm mb-4" :class="messageClass">{{ strengthMessage }}</p>

    <!-- Confirm Password -->
    <label for="passwordConfirmation" class="block text-gray-700 font-medium mb-2">Confirmez le Mot de Passe *</label>
    <input
      id="passwordConfirmation"
      class="w-full p-3 mb-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
      type="password"
      v-model="passwordConfirmation"
      placeholder="Confirmez le Mot de Passe *"
      @input="validatePasswordMatch"
      required
    />
    <!-- Password Match Validation -->
    <p v-if="passwordError" class="text-red-500 text-sm">{{ passwordError }}</p>

      <!-- Submit Button -->
      <button
        type="submit"
        class="w-full py-3 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition-colors duration-300 font-semibold cursor-pointer"
      >
        S'inscrire
      </button>
    </form>

    <!-- Error Message -->
    <div v-if="signUpError" class="text-red-500 mt-4">
      {{ signUpError }}
    </div>

    <!-- Link to Login -->
    <p class="text-gray-600 mt-4">
      Vous avez déjà un compte ?
      <router-link
        to="/login"
        class="text-yellow-500 font-semibold hover:underline hover:text-yellow-600 transition-colors duration-300"
      >
        Connectez-vous
      </router-link>
    </p>
  </div>
</template>

<script>
import { ref, onMounted, watch, computed } from 'vue';
import { useUserStore } from '@/stores/user';
import { useRouter } from 'vue-router';
import { storeToRefs } from 'pinia';

export default {
  name: "SignUp",
  setup() {
    const userStore = useUserStore();
    const router = useRouter();
    const { towns } = storeToRefs(userStore);

    const firstName = ref("");
    const middleName = ref("");
    const lastName = ref("");
    const dateOfBirth = ref("");
    const town = ref("");
    const country = ref("");
    const phoneNumber = ref("");
    const username = ref("");
    const email = ref("");
    const password = ref("");
    const passwordConfirmation = ref("");
    const signUpError = ref(null);
    const isLoadingTowns = ref(false);

    // Password Strength Meter
    const strengthPercentage = ref(0);
    const strengthMessage = ref("");
    const strengthClass = ref("bg-red-500");
    const passwordError = ref("");

    const evaluateStrength = () => {
      const score = calculateStrength(password.value);
      updateStrength(score);
    };

    const calculateStrength = (password) => {
      let score = 0;

      if (password.length >= 8) score += 1;
      if (/[A-Z]/.test(password)) score += 1;
      if (/[a-z]/.test(password)) score += 1;
      if (/\d/.test(password)) score += 1;
      if (/\W/.test(password)) score += 1;

      return score;
    };

    const updateStrength = (score) => {
      const levels = [
        { class: "bg-red-500", message: "Faible", percentage: 20 },
        { class: "bg-yellow-500", message: "Moyen", percentage: 60 },
        { class: "bg-green-500", message: "Fort", percentage: 100 },
      ];

      if (score <= 2) {
        strengthClass.value = levels[0].class;
        strengthMessage.value = levels[0].message;
        strengthPercentage.value = levels[0].percentage;
      } else if (score === 3 || score === 4) {
        strengthClass.value = levels[1].class;
        strengthMessage.value = levels[1].message;
        strengthPercentage.value = levels[1].percentage;
      } else if (score === 5) {
        strengthClass.value = levels[2].class;
        strengthMessage.value = levels[2].message;
        strengthPercentage.value = levels[2].percentage;
      }
    };

    const validatePasswordMatch = () => {
      if (passwordConfirmation.value && password.value !== passwordConfirmation.value) {
        passwordError.value = "Les mots de passe ne correspondent pas.";
      } else {
        passwordError.value = "";
      }
    };

    // Optimized towns fetching function
    const fetchTowns = async () => {
      if (isLoadingTowns.value || towns.value.length > 0) return;

      isLoadingTowns.value = true;
      try {
        await userStore.fetchTowns();
      } catch (error) {
        console.error("Failed to fetch towns:", error);
      } finally {
        isLoadingTowns.value = false;
      }
    };

    // Computed property for towns visibility
    const showTowns = computed(() => {
      return country.value === 'République Centrafricaine' && towns.value.length > 0;
    });

    // Preload towns on mount
    onMounted(() => {
      if (!towns.value.length) {
        fetchTowns();
      }
    });

    // Optimized watch for country changes
    watch(country, (newCountry) => {
      if (newCountry === 'République Centrafricaine') {
        fetchTowns();
      } else {
        town.value = "";
      }
    });

    const onSignUp = async (event) => {
      event.preventDefault();

      // Validate required fields
      if (!firstName.value || !lastName.value || !dateOfBirth.value || !email.value || !password.value) {
        signUpError.value = "Veuillez remplir tous les champs obligatoires.";
        return;
      }

      const data = {
        user: {
          first_name: firstName.value,
          middle_name: middleName.value,
          last_name: lastName.value,
          date_of_birth: dateOfBirth.value,
          town: town.value,
          country: country.value,
          phone_number: phoneNumber.value,
          username: username.value,
          email: email.value,
          password: password.value,
          password_confirmation: passwordConfirmation.value,
        }
      };

      try {
        await userStore.signUpUser(data);
        if (userStore.isAuthenticated && userStore.user?.id) {
          router.push(`/dashboard/${userStore.user.id}`);
        } else {
          signUpError.value = "Les données utilisateur ne sont pas disponibles.";
        }
      } catch (error) {
        console.error('Erreur d\'inscription:', error.response?.data || error.message);
        signUpError.value = "Une erreur est survenue lors de l'inscription. Veuillez réessayer.";
      }
    };

    // Add the generateUsernameExample method here
    const generateUsernameExample = () => {
      const randomNum = Math.floor(Math.random() * 1000);
      return `${username.value || 'Utilisateur'}_${randomNum}`;
    };

    return {
      firstName,
      middleName,
      lastName,
      dateOfBirth,
      town,
      towns,
      country,
      phoneNumber,
      username,
      email,
      password,
      passwordConfirmation,
      signUpError,
      onSignUp,
      isLoadingTowns,
      showTowns,
      strengthPercentage,
      strengthMessage,
      strengthClass,
      passwordError,
      evaluateStrength,
      validatePasswordMatch,
      generateUsernameExample, // Return it so you can use it in the template
    };
  },
};
</script>
