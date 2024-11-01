import { defineStore } from 'pinia';
import axios from 'axios';

// Define the API base URL
const API_BASE_URL = process.env.VUE_APP_API_BASE_URL || 'http://localhost:3000';

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null,
    token: localStorage.getItem('token') || null,
    userId: localStorage.getItem('userId') || null, // Load user ID from localStorage
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
    async fetchUserData() {
      if (!this.token || !this.userId) {
        console.error('No token or user ID found, please login');
        return;
      }

      try {
        const response = await axios.get(`${API_BASE_URL}/api/v1/user_data`, { // Adjust endpoint if necessary
          headers: { Authorization: `Bearer ${this.token}` },
        });
        this.user = response.data.user; // Make sure this matches your API response
      } catch (error) {
        console.error('Failed to fetch user data:', error.response ? error.response.data : error.message);
        // Optionally handle token expiry or invalidation here
      }
    },
    logout() {
      this.user = null;
      this.token = null;
      this.userId = null; // Clear user ID
      localStorage.removeItem('token');
      localStorage.removeItem('userId'); // Clear persisted user ID
    },
  },
  getters: {
    isAuthenticated: (state) => !!state.user,
  },
  persist: true, // Ensure persist plugin is correctly configured if using
});
