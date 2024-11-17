<template>
  <div>
    <header class="bg-gradient-to-r from-black to-goldColor w-full shadow relative z-50">
      <nav class="max-w-[85rem] w-full mx-auto px-4 py-0 sm:py-4">
        <div class="flex items-center justify-between">
          <!-- Logo -->
          <a class="flex-none focus:outline-none focus:opacity-80" href="#">
            <img src="../assets/images/meya-logo.png" alt="Meya Logo" class="h-44 w-auto block p-0 mt-0 align-middle">
          </a>

          <!-- Desktop Navigation -->
          <div class="hidden sm:flex items-center gap-4">
            <router-link to="/login" class="font-medium text-white focus:outline-none border border-white py-2 px-4 rounded-lg hover:bg-white hover:text-black transition duration-200" aria-current="page">
              Se connecter
            </router-link>
            <router-link to="/signup" custom v-slot="{ navigate }">
              <button @click="navigate" type="button" class="py-3 px-5 inline-flex items-center gap-x-2 text-base font-medium rounded-lg border border-goldColor bg-goldColor text-gray-800 shadow-sm hover:bg-gray-50 focus:outline-none focus:bg-gray-50 transition duration-200">
                S'incrire
              </button>
            </router-link>
          </div>

          <!-- Mobile Menu Button Area -->
          <div class="sm:hidden flex items-center gap-2">
            <!-- Sign Up Button for Mobile -->
            <router-link to="/signup" custom v-slot="{ navigate }">
              <button @click="navigate" type="button" class="py-2 px-3 text-sm font-medium rounded-lg border border-goldColor bg-goldColor text-gray-800 shadow-sm hover:bg-gray-50 focus:outline-none focus:bg-gray-50 transition duration-200">
                S'incrire
              </button>
            </router-link>

            <!-- Menu Button -->
            <button type="button"
              @click="isMenuOpen = !isMenuOpen"
              class="relative size-8 flex justify-center items-center rounded-lg border border-white text-white hover:bg-white hover:text-black transition duration-200">
              <svg class="shrink-0 size-4" :class="{ 'hidden': isMenuOpen }" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" x2="21" y1="6" y2="6"/><line x1="3" x2="21" y1="12" y2="12"/><line x1="3" x2="21" y1="18" y2="18"/></svg>
              <svg class="shrink-0 size-4" :class="{ 'hidden': !isMenuOpen }" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
            </button>
          </div>
        </div>

        <!-- Mobile Menu -->
        <div
          class="sm:hidden fixed top-[120px] left-0 right-0 bg-gradient-to-r from-black/95 to-goldColor/95 backdrop-blur-sm transition-all duration-300 ease-in-out z-50 border-t border-goldColor/20 shadow-lg"
          :class="{
            'opacity-100 translate-y-0': isMenuOpen,
            'opacity-0 -translate-y-full pointer-events-none': !isMenuOpen
          }">
          <div class="flex flex-col divide-y divide-goldColor/10 max-w-[85rem] mx-auto">
            <router-link
              @click="isMenuOpen = false"
              to="/login"
              class="text-white px-6 py-4 hover:bg-white/10 transition-all duration-200 flex items-center space-x-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
              </svg>
              <span class="font-medium">Se connecter</span>
            </router-link>
          </div>
        </div>
      </nav>
    </header>
  <div class="bg-gradient-to-r from-black to-goldColor py-8 sm:py-16 animate__animated animate__fadeInRight">
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-8 items-center px-4 sm:px-8 mx-auto max-w-screen-xl">
    <div class="flex flex-col justify-center items-start -mt-6">
      <!-- Responsive heading -->
      <h1 class="text-3xl sm:text-4xl lg:text-5xl font-bold leading-tight sm:leading-normal mb-3 sm:mb-4 text-white font-mona">
        Votre partenaire financier tout-en-un
      </h1>
      <!-- Responsive paragraph -->
      <p class="mb-4 text-base sm:text-lg font-mona text-white leading-relaxed">
        Notre fintech vous propose des solutions innovantes pour gérer vos finances en toute simplicité.
        Avec des frais réduits, des transferts rapides, et une carte de débit intuitive, nous facilitons l'accès aux services bancaires pour tous.
      </p>
      <!-- Responsive buttons -->
      <div class="flex flex-col sm:flex-row gap-3 sm:space-x-4 w-full sm:w-auto">
        <router-link
          to="/education/digital-banking"
          class="w-full sm:w-auto bg-goldColor text-black rounded py-2 px-4 hover:bg-goldColor-light transition duration-300 text-center"
        >
          Découvrir nos services
        </router-link>

        <!-- Dropdown button for all services -->
        <div class="relative">
          <button
            @click="toggleServicesDropdown"
            class="w-full sm:w-auto bg-transparent border border-goldColor text-white rounded py-2 px-4 hover:bg-goldColor hover:text-black transition duration-300"
          >
            Tous nos services
          </button>
          <div v-if="isServicesDropdownOpen"
               class="absolute z-50 mt-2 w-48 bg-white rounded-md shadow-lg py-1">
            <router-link
              v-for="service in educationalServices"
              :key="service.path"
              :to="service.path"
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-goldColor hover:text-white"
              @click="isServicesDropdownOpen = false"
            >
              {{ service.title }}
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <!-- Responsive image container -->
    <div class="flex justify-center items-center mt-8 sm:-mt-6 ml-0 sm:ml-12">
      <img
        src="../assets/images/glass-credit.png"
        alt="Fintech Solutions"
        class="max-w-full sm:max-w-3xl animate-zoomInOut"
      >
    </div>
  </div>

  <!-- Features section -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6 sm:gap-8 items-center px-4 sm:px-8 mx-auto max-w-screen-xl mt-8 sm:mt-16">
    <div class="flex flex-col justify-center items-start">
      <h3 class="text-xl sm:text-2xl font-bold leading-tight sm:leading-normal mb-3 sm:mb-4 text-goldColor font-mona">
        1. Transfert Rapide
      </h3>
      <p class="mb-4 text-base sm:text-lg font-mona text-white leading-relaxed">
        Profitez d'un transfert instantané, sécurisé et sans tracas pour vos besoins financiers. Rapidité et efficacité garanties.
      </p>
    </div>
    <div class="flex flex-col justify-center items-start">
      <h3 class="text-xl sm:text-2xl font-bold leading-tight sm:leading-normal mb-3 sm:mb-4 text-goldColor font-mona">
        2. Système Facile à Utiliser
      </h3>
      <p class="mb-4 text-base sm:text-lg font-mona text-white leading-relaxed">
        Interface intuitive pour des opérations rapides et sans effort. Simplifiez vos tâches quotidiennes facilement.
      </p>
    </div>
  </div>
</div>
    <!-- Section 1: Importance of Bank Account -->
    <div class="bg-white py-16 animate__animated animate__fadeInLeft">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 items-center px-8 mx-auto max-w-screen-xl">
        <div class="flex justify-center items-center">
          <!-- Image placeholder -->
          <img src="../assets/images/man-holding-card.png" alt="Personal Bank" class="max-w-lg rounded-lg">
        </div>
        <div class="flex flex-col justify-center items-start">
          <h1 class="text-2xl font-bold mb-4 font-mona text-goldColor">Pourquoi un compte bancaire est important ?</h1>
          <p class="mb-4 text-lg font-mona">
            Un compte bancaire vous donne accès à des services essentiels comme les paiements, l'épargne, et la gestion de vos finances.
            C'est un élément crucial pour assurer votre sécurité financière et profiter d'une meilleure gestion de votre argent au quotidien.
          </p>
          <router-link
            to="/education/account-benefits"
            class="bg-goldColor text-black rounded py-2 px-4 hover:bg-goldColor-light transition duration-300 text-center"
          >
            En savoir plus
          </router-link>
        </div>
      </div>
    </div>

    <!-- Section 2: Why Choose Our Fintech -->
    <div class="bg-gray-100 py-16 animate__animated animate__fadeInRight">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 items-center px-8 mx-auto max-w-screen-xl">
        <div class="flex flex-col justify-center items-start">
          <h1 class="text-2xl font-bold mb-4 font-mona text-goldColor">Pourquoi choisir notre fintech ?</h1>
          <p class="mb-4 text-lg">
            Notre fintech vous propose des solutions innovantes pour gérer vos finances en toute simplicité.
            Avec des frais réduits, des transferts rapides, et une carte de débit intuitive, nous facilitons l'accès aux services bancaires pour tous.
          </p>
          <router-link
            to="/education/financial-literacy"
            class="bg-goldColor text-black rounded py-2 px-4 hover:bg-goldColor-light transition duration-300 text-center"
          >
            Découvrir nos services
          </router-link>
        </div>
        <div class="flex justify-center items-center">
          <!-- Image placeholder -->
          <img src="../assets/images/payment-by-phone.png" alt="Fintech Solutions" class="max-w-lg rounded-lg">
        </div>
      </div>
    </div>

    <footer class="bg-white dark:bg-black">
      <div class="w-full max-w-screen-xl mx-auto p-4 md:py-8">
        <div class="sm:flex sm:items-center sm:justify-between">
          <a href="https://flowbite.com/" class="flex items-center mb-4 sm:mb-0 space-x-3 rtl:space-x-reverse">
              <img src="../assets/images/meya-logo.png" class="h-10" alt="Meya Logo" />
              <span class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">Meya</span>
          </a>
          <ul class="flex flex-wrap items-center mb-6 text-sm font-medium text-gray-500 sm:mb-0 dark:text-gray-400">
              <li>
                  <a href="#" class="hover:underline me-4 md:me-6">About</a>
              </li>
              <li>
                  <a href="#" class="hover:underline me-4 md:me-6">Privacy Policy</a>
              </li>
              <li>
                  <a href="#" class="hover:underline me-4 md:me-6">Licensing</a>
              </li>
              <li>
                  <a href="#" class="hover:underline">Contact</a>
              </li>
          </ul>
        </div>
        <hr class="my-6 border-gray-200 sm:mx-auto dark:border-gray-700 lg:my-8" />
        <span class="block text-sm text-gray-500 sm:text-center dark:text-gray-400">© 2024 <a href="https://flowbite.com/" class="hover:underline">Meya™</a>. All Rights Reserved.</span>
      </div>
    </footer>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

export default {
  name: 'Home',
  setup() {
    const email = ref('')
    const router = useRouter()
    const isMenuOpen = ref(false)
    const isServicesDropdownOpen = ref(false)
    const isMobile = ref(window.innerWidth < 640)

    const educationalServices = [
      {
        path: '/education/account-benefits',
        title: 'Avantages Bancaires'
      },
      {
        path: '/education/financial-literacy',
        title: 'Éducation Financière'
      },
      {
        path: '/education/security',
        title: 'Sécurité Bancaire'
      },
      {
        path: '/education/digital-banking',
        title: 'Services Numériques'
      }
    ]

    const toggleServicesDropdown = () => {
      isServicesDropdownOpen.value = !isServicesDropdownOpen.value
    }

    const handleClickOutside = (event) => {
      if (!event.target.closest('.services-dropdown')) {
        isServicesDropdownOpen.value = false
      }
    }

    const signUp = async () => {
      console.log("Sign up with email:", email.value)
    }

    const handleResize = () => {
      isMobile.value = window.innerWidth < 640
      if (!isMobile.value) {
        isMenuOpen.value = false
        isServicesDropdownOpen.value = false
      }
    }

    onMounted(() => {
      window.addEventListener('resize', handleResize)
      document.addEventListener('click', handleClickOutside)
    })

    onUnmounted(() => {
      window.removeEventListener('resize', handleResize)
      document.removeEventListener('click', handleClickOutside)
    })

    return {
      email,
      signUp,
      isMenuOpen,
      isMobile,
      isServicesDropdownOpen,
      educationalServices,
      toggleServicesDropdown
    }
  }
}
</script>

<style>
/* Custom styles for background and animation */
.bg-background2 {
  background-color: #f7f7f7;
}
.max-h-0 {
  max-height: 0;
}

.max-h-96 {
  max-height: 24rem;
}
/* .translate-y-0 {
  transform: translateY(0);
}

.-translate-y-full {
  transform: translateY(-100%);
} */
.backdrop-blur-sm {
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}
</style>
