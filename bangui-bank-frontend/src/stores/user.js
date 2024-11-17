import { defineStore } from 'pinia';
import axios from 'axios';

// Define API base URL here, use environment variable or default to localhost
const API_BASE_URL = process.env.VUE_APP_API_BASE_URL || 'http://localhost:3000';
const EXCHANGE_RATE_API_KEY = '63ba201cc54aa08a5db80f44';

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null,
    token: localStorage.getItem('token') || null,
    userId: localStorage.getItem('userId') || null, // Load user ID from localStorage
    towns: [],
    payments: [],
    exchangeRates: null,
    lastRatesUpdate: null,
    baseCurrency: 'EUR',
    selectedCurrency: '€',
    isLoadingRates: false
  }),
  actions: {
    async loginUser(credentials) {
      try {
        const response = await axios.post(`${API_BASE_URL}/api/v1/sign_in`, {
          user: {
            username: credentials.username,
            password: credentials.password,
          }
        });
        this.user = response.data.user;
        this.token = response.data.token;
        this.userId = response.data.user.id; // Store user ID
        localStorage.setItem('token', this.token);
        localStorage.setItem('userId', this.userId); // Persist user ID
      } catch (error) {
        console.error('Login failed:', error.response ? error.response.data : error.message);
      }
    },
    async signUpUser(userData) {
      try {
        const response = await axios.post(`${API_BASE_URL}/api/v1/sign_up`, userData);
        this.user = response.data.user;
        this.token = response.data.token;
        this.userId = response.data.user.id; // Store user ID
        localStorage.setItem('token', this.token);
        localStorage.setItem('userId', this.userId); // Persist user ID
      } catch (error) {
        console.error('Registration failed:', error.response ? error.response.data : error.message);
      }
    },
    async fetchUserData() {
      if (!this.token || !this.userId) {
        console.error('No token or user ID found, please login');
        return;
      }

      try {
        const response = await axios.get(`${API_BASE_URL}/api/v1/user_data`, {
          headers: { Authorization: `Bearer ${this.token}` },
        });
        this.user = response.data.user; // Adjust this based on your API response structure
      } catch (error) {
        if (error.response && error.response.status === 401) {
          this.logout();
          console.error('Token expired, please log in again');
        } else {
          console.error('Failed to fetch user data:', error.response ? error.response.data : error.message);
        }
      }
    },
    async fetchTowns() {
      try {
        const response = await axios.get(`${API_BASE_URL}/api/v1/locations/towns`);
        this.towns = response.data.towns; // Store fetched towns in state
      } catch (error) {
        console.error('Error fetching towns:', error);
        this.error = 'Failed to fetch towns. Please try again later.'; // Optionally set an error message
      }
    },
    async fetchPayments() {
      if (!this.token || !this.userId) {
        console.error('No token or user ID found, please login');
        return;
      }

      try {
        const response = await axios.get(`${API_BASE_URL}/api/v1/payments`, {
          headers: { Authorization: `Bearer ${this.token}` },
        });
        this.payments = response.data.payments; // Store fetched payments in state
      } catch (error) {
        console.error('Failed to fetch payments:', error.response ? error.response.data : error.message);
      }
    },
    logout() {
      this.user = null;
      this.token = null;
      this.userId = null; // Clear user ID
      localStorage.removeItem('token');
      localStorage.removeItem('userId'); // Clear persisted user ID
    },
    async fetchExchangeRates() {
      // Check if rates were fetched in the last hour
      const oneHourAgo = new Date(Date.now() - 3600000);
      if (this.exchangeRates && this.lastRatesUpdate > oneHourAgo) {
        return this.exchangeRates;
      }

      this.isLoadingRates = true;
      try {
        const response = await axios.get(
          `https://v6.exchangerate-api.com/v6/${EXCHANGE_RATE_API_KEY}/latest/${this.baseCurrency}`
        );

        this.exchangeRates = response.data.conversion_rates;
        this.lastRatesUpdate = new Date();
        return this.exchangeRates;
      } catch (error) {
        console.error('Error fetching exchange rates:', error);
        throw error;
      } finally {
        this.isLoadingRates = false;
      }
    },
    setSelectedCurrency(currency) {
      this.selectedCurrency = currency;
    },
    convertAmount(amount) {
      if (!this.exchangeRates) return amount;

      const rates = {
        '€': 1, // EUR (base currency)
        '$': this.exchangeRates.USD,
        'CFA': this.exchangeRates.XAF
      };

      const rate = rates[this.selectedCurrency] || 1;
      return (amount * rate).toFixed(2);
    },
  },
  getters: {
    isAuthenticated: (state) => !!state.user, // Return true if user is logged in
    formattedAmount: (state) => (amount) => {
      const converted = state.convertAmount(amount);

      switch (state.selectedCurrency) {
        case 'CFA':
          return `${converted} CFA`;
        case '$':
          return `$${converted}`;
        default:
          return `€${converted}`;
      }
    },
    currentExchangeRates: (state) => {
      if (!state.exchangeRates) return null;

      return {
        USD: state.exchangeRates.USD,
        XAF: state.exchangeRates.XAF,
        EUR: 1
      };
    }
  },
  persist: {
    paths: ['user', 'token', 'userId', 'selectedCurrency', 'exchangeRates', 'lastRatesUpdate']
  },
});
