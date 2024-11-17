<template>
  <div>
    <header class="bg-gradient-to-r from-black to-goldColor flex flex-wrap sm:justify-start sm:flex-nowrap w-full -mb-10 shadow -mt-6">
      <nav class="max-w-[85rem] w-full mx-auto px-4 sm:flex sm:items-center sm:justify-between">
        <div class="flex items-center justify-between">
          <a class="flex-none focus:outline-none focus:opacity-80" href="#">
            <img
              src="../assets/images/meya-logo.png"
              alt="Meya Logo"
              class="h-16 w-auto block p-0 mt-0 sm:h-44"
            />
          </a>
          <div class="sm:hidden">
            <button type="button" class="hs-collapse-toggle size-7 relative">
              <!-- Button content remains unchanged -->
            </button>
          </div>
        </div>

        <div id="hs-navbar-dark" class="hidden hs-collapse sm:block">
          <div class="flex flex-col gap-3 mt-5 sm:flex-row sm:items-center sm:justify-end sm:mt-0">
            <router-link
              to="/login"
              class="font-medium text-white border border-white py-2 px-4 rounded-lg hover:bg-white hover:text-black transition duration-200"
            >
              Se connecter
            </router-link>
            <router-link to="/signup" custom v-slot="{ navigate }">
              <button
                @click="navigate"
                type="button"
                class="py-3 px-5 inline-flex items-center gap-x-2 text-base font-medium rounded-lg border border-goldColor bg-goldColor text-gray-800 shadow-sm hover:bg-gray-50 focus:outline-none focus:bg-gray-50 transition"
              >
                S'inscrire
              </button>
            </router-link>
          </div>
        </div>
      </nav>
    </header>

    <!-- Hero Section -->
    <div class="bg-gradient-to-r from-black to-goldColor py-16 px-4 sm:px-8">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 items-center max-w-screen-xl mx-auto">
        <div class="flex flex-col justify-center items-start">
          <h1 class="text-3xl sm:text-5xl font-bold text-white mb-4">
            Votre partenaire financier tout-en-un
          </h1>
          <p class="text-lg sm:text-xl text-white mb-6">
            Notre fintech vous propose des solutions innovantes pour gérer vos finances en toute simplicité.
          </p>
          <div class="flex flex-wrap gap-4">
            <button class="bg-goldColor text-black py-2 px-4 rounded-lg hover:bg-goldColor-light">
              Découvrir nos services
            </button>
            <button class="bg-transparent border border-goldColor text-white py-2 px-4 rounded-lg hover:bg-goldColor hover:text-black">
              En savoir plus
            </button>
          </div>
        </div>
        <div class="flex justify-center items-center">
          <img
            src="../assets/images/glass-credit.png"
            alt="Fintech Solutions"
            class="max-w-full h-auto rounded-lg"
          />
        </div>
      </div>
    </div>

    <!-- Section 1 -->
    <div class="bg-white py-16 px-4 sm:px-8">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-screen-xl mx-auto">
        <div class="flex justify-center items-center">
          <img
            src="../assets/images/man-holding-card.png"
            alt="Personal Bank"
            class="max-w-full h-auto rounded-lg"
          />
        </div>
        <div class="flex flex-col">
          <h2 class="text-xl sm:text-2xl font-bold text-goldColor mb-4">
            Pourquoi un compte bancaire est important ?
          </h2>
          <p class="text-base sm:text-lg mb-6">
            Un compte bancaire vous donne accès à des services essentiels comme les paiements, l'épargne, et la gestion de vos finances.
          </p>
          <button class="bg-goldColor text-black py-2 px-4 rounded-lg hover:bg-goldColor-light">
            En savoir plus
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
