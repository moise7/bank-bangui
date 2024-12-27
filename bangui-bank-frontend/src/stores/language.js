import { defineStore } from 'pinia';
import { i18n } from '../i18n'; // Import your i18n instance

export const useLanguageStore = defineStore('language', {
  state: () => ({
    currentLanguage: localStorage.getItem('language') || 'fr', // Default to French
  }),
  actions: {
    setLanguage(language) {
      this.currentLanguage = language;
      localStorage.setItem('language', language); // Persist in localStorage
      i18n.global.locale = language; // Update the i18n instance
    },
  },
});