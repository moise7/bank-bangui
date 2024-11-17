import axios from 'axios';
import router from '@/router';
import { useUserStore } from '@/stores/user';

const axiosInstance = axios.create({
  baseURL: process.env.VUE_APP_API_BASE_URL,
  timeout: 10000, // 10 seconds timeout
});

// Add a response interceptor
axiosInstance.interceptors.response.use(
  response => response,
  error => {
    const userStore = useUserStore();

    if (error.code === 'ECONNABORTED') {
      // Timeout error
      router.push({
        name: 'not-found',
        props: {
          title: 'Erreur de connexion',
          message: 'La connexion au serveur a échoué. Veuillez réessayer plus tard.',
          statusCode: 408
        }
      });
    } else if (error.response?.status === 401) {
      // Unauthorized error
      userStore.logout();
      router.push('/login');
    } else if (error.response?.status === 404) {
      // Not found error
      router.push({
        name: 'not-found'
      });
    } else if (error.response?.status >= 500) {
      // Server error
      router.push({
        name: 'not-found',
        props: {
          title: 'Erreur serveur',
          message: 'Un problème est survenu avec le serveur. Veuillez réessayer plus tard.',
          statusCode: error.response.status
        }
      });
    }

    return Promise.reject(error);
  }
);

export default axiosInstance; 