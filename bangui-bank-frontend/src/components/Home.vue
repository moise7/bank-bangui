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
              {{ $t('login') }}
            </router-link>
            <router-link to="/signup" custom v-slot="{ navigate }">
              <button @click="navigate" type="button" class="py-3 px-5 inline-flex items-center gap-x-2 text-base font-medium rounded-lg border border-goldColor bg-goldColor text-gray-800 shadow-sm hover:bg-gray-50 focus:outline-none focus:bg-gray-50 transition duration-200">
                {{ $t('signup') }}
              </button>
            </router-link>

            <!-- Language Dropdown -->
            <div class="relative">
              <button @click="toggleLanguageMenu" type="button" class="py-2 px-4 inline-flex items-center gap-x-2 text-base font-medium rounded-lg border border-white bg-goldColor text-gray-800 shadow-sm hover:bg-gray-50 focus:outline-none focus:bg-gray-50 transition duration-200">
                <span>{{ currentLanguage === 'fr' ? 'Français' : 'English' }}</span>
                <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                </svg>
              </button>
              <div v-if="isLanguageMenuOpen" class="absolute right-0 mt-2 w-48 bg-black text-white rounded-lg shadow-lg z-50">
                <button @click="changeLanguage('fr')" class="block px-4 py-2 text-sm w-full text-left hover:bg-gray-700 focus:outline-none focus:bg-gray-700">
                  Français
                </button>
                <button @click="changeLanguage('en')" class="block px-4 py-2 text-sm w-full text-left hover:bg-gray-700 focus:outline-none focus:bg-gray-700">
                  English
                </button>
              </div>
            </div>
          </div>

          <!-- Mobile Menu Button Area -->
          <div class="sm:hidden flex items-center gap-2">
            <!-- Language Dropdown for Mobile -->
            <div class="relative">
              <button @click="toggleLanguageMenu" type="button" class="py-1 px-2 inline-flex items-center gap-x-1 text-sm font-medium rounded-lg border border-white bg-goldColor text-gray-800 shadow-sm hover:bg-gray-50 focus:outline-none focus:bg-gray-50 transition duration-200">
                <span>{{ currentLanguage === 'fr' ? 'Français' : 'English' }}</span>
                <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                </svg>
              </button>
              <div v-if="isLanguageMenuOpen" class="absolute right-0 mt-1 w-32 bg-black text-white rounded-lg shadow-lg z-50">
                <button @click="changeLanguage('fr')" class="block px-2 py-1 text-xs w-full text-left hover:bg-gray-700 focus:outline-none focus:bg-gray-700">
                  Français
                </button>
                <button @click="changeLanguage('en')" class="block px-2 py-1 text-xs w-full text-left hover:bg-gray-700 focus:outline-none focus:bg-gray-700">
                  English
                </button>
              </div>
            </div>

            <button type="button" @click="isMenuOpen = !isMenuOpen" class="relative size-8 flex justify-center items-center rounded-lg border border-white text-white hover:bg-white hover:text-black transition duration-200">
              <svg class="shrink-0 size-4" :class="{ 'hidden': isMenuOpen }" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" x2="21" y1="6" y2="6"/><line x1="3" x2="21" y1="12" y2="12"/><line x1="3" x2="21" y1="18" y2="18"/></svg>
              <svg class="shrink-0 size-4" :class="{ 'hidden': !isMenuOpen }" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
            </button>
          </div>
        </div>

        <!-- Mobile Menu -->
        <div class="sm:hidden fixed top-[120px] left-0 right-0 bg-gradient-to-r from-black/95 to-goldColor/95 backdrop-blur-sm transition-all duration-300 ease-in-out z-50 border-t border-goldColor/20 shadow-lg" :class="{'opacity-100 translate-y-0': isMenuOpen, 'opacity-0 -translate-y-full pointer-events-none': !isMenuOpen}">
          <div class="flex flex-col divide-y divide-goldColor/10 max-w-[85rem] mx-auto">
            <router-link @click="isMenuOpen = false" to="/login" class="text-white px-6 py-4 hover:bg-white/10 transition-all duration-200 flex items-center space-x-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
              </svg>
              <span class="font-medium">{{ $t('login') }}</span>
            </router-link>
            <router-link @click="isMenuOpen = false" to="/signup" class="text-white px-6 py-4 hover:bg-white/10 transition-all duration-200 flex items-center space-x-3">
              <span class="font-medium">{{ $t('signup') }}</span>
            </router-link>

          </div>
        </div>
      </nav>
    </header>
    <div class="bg-gradient-to-r from-black to-goldColor py-8 sm:py-16 animate__animated animate__fadeInRight">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-8 items-center px-4 sm:px-8 mx-auto max-w-screen-xl">
        <div class="flex flex-col justify-center items-start -mt-6">
          <h1 class="text-3xl sm:text-4xl lg:text-5xl font-bold leading-tight sm:leading-normal mb-3 sm:mb-4 text-white font-mona animate__animated animate__fadeInLeft">
            {{ $t('financial_partner') }}
          </h1>
          <p class="mb-4 text-base sm:text-lg font-mona text-white leading-relaxed animate__animated animate__fadeInLeft animate__delay-1s">
            {{ $t('fintech_solutions') }}
          </p>
          <div class="flex flex-col sm:flex-row gap-3 sm:space-x-4 w-full sm:w-auto">
            <router-link to="/education/digital-banking" class="w-full sm:w-auto bg-goldColor text-black rounded py-2 px-4 hover:bg-goldColor-light transition duration-300 text-center">
              {{ $t('discover_services') }}
            </router-link>

            <div class="relative">
              <button @click="toggleServicesDropdown" class="w-full sm:w-auto bg-transparent border border-goldColor text-white rounded py-2 px-4 hover:bg-goldColor hover:text-black transition duration-300">
                {{ $t('all_services') }}
              </button>
              <div v-if="isServicesDropdownOpen" class="absolute z-50 mt-2 w-48 bg-white rounded-md shadow-lg py-1">
                <router-link v-for="service in educationalServices" :key="service.path" :to="service.path" class="block px-4 py-2 text-sm text-gray-700 hover:bg-goldColor hover:text-white" @click="isServicesDropdownOpen = false">
                  {{ service.title }}
                </router-link>
              </div>
            </div>
          </div>
        </div>

        <div class="flex justify-center items-center mt-8 sm:-mt-6 ml-0 sm:ml-12">
          <img src="../assets/images/glass-credit.png" alt="Fintech Solutions" class="max-w-full sm:max-w-3xl animate-zoomInOut">
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 sm:gap-8 px-4 sm:px-8 mx-auto max-w-screen-xl mt-8 sm:mt-16">
        <div class="bg-white/5 backdrop-blur-sm rounded-xl p-6 transform hover:scale-105 transition-all duration-300">
          <h3 class="text-xl sm:text-2xl font-bold mb-3 sm:mb-4 text-goldColor font-mona">
            {{ $t('fast_transfer') }}
          </h3>
          <p class="text-base sm:text-lg font-mona text-white/90 leading-relaxed">
            {{ $t('fast_transfer_description') }}
          </p>
        </div>
        <div class="bg-white/5 backdrop-blur-sm rounded-xl p-6 transform hover:scale-105 transition-all duration-300">
          <h3 class="text-xl sm:text-2xl font-bold mb-3 sm:mb-4 text-goldColor font-mona">
            {{ $t('easy_to_use_system') }}
          </h3>
          <p class="text-base sm:text-lg font-mona text-white/90 leading-relaxed">
            {{ $t('easy_to_use_description') }}
          </p>
        </div>
      </div>
    </div>

    <!-- New Financial Literacy Section -->
    <div class="relative bg-white py-16 lg:py-24 overflow-hidden">
      <div class="absolute inset-0 bg-grid-pattern opacity-5"></div>
      <div class="relative max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-y-12 md:gap-x-16 items-center">
          <div class="order-1 md:order-1 animate__animated animate__fadeInLeft">
            <div class="relative group">
              <div class="absolute -inset-2 bg-gradient-to-r from-goldColor/20 to-amber-500/20 rounded-xl blur-xl group-hover:blur-2xl transition duration-500"></div>
              <div class="relative overflow-hidden rounded-2xl shadow-2xl">
                <img src="../assets/images/man-holding-card.png" alt="Financial Literacy" class="w-full h-auto transform transition duration-700 group-hover:scale-105" loading="lazy">
                <div class="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
              </div>
            </div>
          </div>

          <div class="order-2 md:order-2 animate__animated animate__fadeInRight">
            <div class="space-y-6">
              <span class="inline-block px-4 py-1 rounded-full bg-goldColor/10 text-goldColor text-sm font-semibold tracking-wide">
                {{ $t('financial_education') }}
              </span>
              <h2 class="text-3xl md:text-4xl font-bold font-mona bg-gradient-to-r from-goldColor to-amber-500 bg-clip-text text-transparent">
                {{ $t('financial_literacy_title') }}
              </h2>
              <p class="text-gray-600 text-lg leading-relaxed font-mona">
                {{ $t('financial_literacy_description') }}
              </p>
              <router-link to="/education/financial-literacy" class="group inline-flex items-center gap-2 px-6 py-3 bg-goldColor text-black rounded-lg transition-all duration-300 hover:shadow-lg hover:shadow-goldColor/30 transform hover:-translate-y-0.5">
                <span>{{ $t('read_more') }}</span>
                <svg class="w-5 h-5 transition-transform duration-300 group-hover:translate-x-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="relative bg-white py-16 lg:py-24 overflow-hidden">
      <div class="absolute inset-0 bg-grid-pattern opacity-5"></div>
      <div class="relative max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-y-12 md:gap-x-16 items-center">
          <!-- Move the image to the left -->
          <div class="order-1 md:order-1 animate__animated animate__fadeInLeft">
            <div class="relative group">
              <div class="absolute -inset-2 bg-gradient-to-r from-goldColor/20 to-amber-500/20 rounded-xl blur-xl group-hover:blur-2xl transition duration-500"></div>
              <div class="relative overflow-hidden rounded-2xl shadow-2xl">
                <img src="../assets/images/man-holding-card.png" alt="Personal Bank" class="w-full h-auto transform transition duration-700 group-hover:scale-105" loading="lazy">
                <div class="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
              </div>
            </div>
          </div>

          <div class="order-2 md:order-2 animate__animated animate__fadeInRight">
            <div class="space-y-6">
              <span class="inline-block px-4 py-1 rounded-full bg-goldColor/10 text-goldColor text-sm font-semibold tracking-wide">
                {{ $t('financial_education') }}
              </span>
              <h2 class="text-3xl md:text-4xl font-bold font-mona bg-gradient-to-r from-goldColor to-amber-500 bg-clip-text text-transparent">
                {{ $t('why_is_account_important') }}
              </h2>
              <p class="text-gray-600 text-lg leading-relaxed font-mona">
                {{ $t('account_importance_description') }}
              </p>
              <router-link to="/education/account-benefits" class="group inline-flex items-center gap-2 px-6 py-3 bg-goldColor text-black rounded-lg transition-all duration-300 hover:shadow-lg hover:shadow-goldColor/30 transform hover:-translate-y-0.5">
                <span>{{ $t('learn_more') }}</span>
                <svg class="w-5 h-5 transition-transform duration-300 group-hover:translate-x-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="relative bg-gradient-to-r from-gray-50 to-gray-100 py-16 sm:py-24 overflow-hidden">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 lg:gap-16 items-center px-4 sm:px-8 mx-auto max-w-screen-xl">
        <div class="flex flex-col justify-center items-start space-y-6 animate__animated animate__fadeInLeft">
          <div class="inline-block">
            <span class="bg-goldColor/10 text-goldColor text-sm font-semibold px-3 py-1 rounded-full">
              {{ $t('our_vision') }}
            </span>
          </div>
          <h2 class="text-3xl sm:text-4xl font-bold mb-4 font-mona bg-gradient-to-r from-goldColor to-amber-500 bg-clip-text text-transparent">
            {{ $t('why_choose_fintech') }}
          </h2>
          <p class="text-gray-600 text-base sm:text-lg leading-relaxed">
            {{ $t('fintech_solutions') }}
          </p>
        </div>
        <div class="flex justify-center items-center relative animate__animated animate__fadeInRight">
          <div class="absolute -z-10 w-72 h-72 bg-goldColor/10 rounded-full blur-3xl"></div>
          <div class="relative group perspective-1000">
            <div class="absolute -inset-1 bg-gradient-to-r from-goldColor to-amber-500 rounded-lg blur opacity-25 group-hover:opacity-40 transition duration-1000 group-hover:duration-200"></div>
            <img src="../assets/images/payment-by-phone.png" alt="Fintech Solutions" class="relative rounded-lg shadow-2xl transform transition-all duration-500 hover:scale-105 max-w-full md:max-w-lg xl:max-w-xl group-hover:rotate-y-12" loading="lazy">
          </div>
        </div>
        <div class="flex flex-col sm:flex-row gap-4 pt-4">
          <router-link to="/education/financial-literacy" class="group relative inline-flex items-center justify-center px-6 py-3 bg-goldColor text-black rounded-lg overflow-hidden transition-all duration-300 ease-out hover:scale-105 hover:shadow-lg">
            <span class="relative flex items-center gap-2">
              {{ $t('discover_services') }}
              <svg class="w-5 h-5 transition-transform duration-300 group-hover:translate-x-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
            </span>
          </router-link>
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
              <a href="#" class="hover:underline me-4 md:me-6">{{ $t('about') }}</a>
            </li>
            <li>
              <a href="#" class="hover:underline me-4 md:me-6">{{ $t('privacy_policy') }}</a>
            </li>
            <li>
              <a href="#" class="hover:underline me-4 md:me-6">{{ $t('licensing') }}</a>
            </li>
            <li>
              <a href="#" class="hover:underline">{{ $t('contact') }}</a>
            </li>
          </ul>
        </div>
        <hr class="my-6 border-gray-200 sm:mx-auto dark:border-gray-700 lg:my-8" />
        <span class="block text-sm text-gray-500 sm:text-center dark:text-gray-400">{{ $t('copyright') }}</span>
      </div>
    </footer>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n';

export default {
  name: 'Home',
  data() {
    return {
      isLanguageMenuOpen: false,
      currentLanguage: 'en',
    };
  },
  computed: {
    currentLanguage() {
      return this.$i18n.locale; // Get the current language
    }
  },
  methods: {
    toggleLanguageMenu() {
      this.isLanguageMenuOpen = !this.isLanguageMenuOpen;
    },
    changeLanguage(language) {
      this.currentLanguage = language;
      this.$i18n.locale = language; // Change the language
    }
  },
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
.backdrop-blur-sm {
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}
.bg-grid-pattern {
  background-image: radial-gradient(#CBD5E1 1px, transparent 1px);
  background-size: 24px 24px;
}

/* 3D Transform utilities */
.perspective-1000 {
  perspective: 1000px;
}

.rotate-y-12 {
  transform: rotateY(12deg);
}

/* Smooth transitions */
.transition-all {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Enhanced hover states */
.hover\:shadow-lg:hover {
  --tw-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

/* Gradient text support */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}

/* Animation utilities */
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}

/* Mobile optimizations */
@media (max-width: 640px) {
  .text-3xl {
    font-size: 1.875rem;
    line-height: 2.25rem;
  }

  .text-lg {
    font-size: 1.125rem;
    line-height: 1.75rem;
  }

  .px-6 {
    padding-left: 1.25rem;
    padding-right: 1.25rem;
  }

  .py-3 {
    padding-top: 0.75rem;
    padding-bottom: 0.75rem;
  }
}

/* Hover effects */
.group:hover .group-hover\:rotate-y-12 {
  transform: rotateY(12deg);
}

.group:hover .group-hover\:translate-x-1 {
  transform: translateX(0.25rem);
}

/* Loading states */
.blur-loading {
  animation: blurPulse 1.5s infinite;
}

@keyframes blurPulse {
  0%, 100% { filter: blur(0px); }
  50% { filter: blur(4px); }
}

/* Add this to your existing styles */
.absolute {
  position: absolute;
}

.z-50 {
  z-index: 50; /* Ensure the dropdown appears above other elements */
}

.mt-2 {
  margin-top: 0.5rem; /* Space between the button and dropdown */
}

.w-48 {
  width: 12rem; /* Set a fixed width for the dropdown */
}

.bg-black {
  background-color: black; /* Background color for the dropdown */
}

.text-white {
  color: white; /* Text color for the dropdown items */
}

.rounded-lg {
  border-radius: 0.5rem; /* Rounded corners for the dropdown */
}

.shadow-lg {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); /* Shadow for dropdown */
}
</style>
