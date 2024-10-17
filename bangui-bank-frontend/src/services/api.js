// src/services/api.js
import axios from 'axios';

const apiClient = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  timeout: 1000,
});


export default {
    getUsers() {
        return apiClient.get('/users');
    },
    // other API calls...
};
