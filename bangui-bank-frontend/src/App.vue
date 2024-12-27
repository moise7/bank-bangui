<template>
  <div id="app" class="flex flex-col min-h-screen bg-slate-400">
    <!-- Language switcher buttons -->

    <!-- Display content using translated text -->
    <router-view />
  </div>
</template>

<script>
import { useI18n } from 'vue-i18n';
import { useLanguageStore } from './stores/language'; // Import the store

export default {
  name: 'App',
  setup() {
    const { locale } = useI18n({ useScope: 'global' });
    const languageStore = useLanguageStore();

    // Function to switch the language
    const switchLanguage = (language) => {
      languageStore.setLanguage(language);  // Update language in Pinia store
      locale.value = language;  // Update the language locale in i18n
    };

    return {
      switchLanguage,  // Function to change the language
    };
  },
};
</script>