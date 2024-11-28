// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import { useUserStore } from '@/stores/user';
import ErrorPage from '@/views/ErrorPage.vue';
import Home from '../components/Home.vue';
import Login from '../components/Login.vue';
import Signup from '../components/Signup.vue';
import Dashboard from '../components/Dashboard.vue';
import PaymentForm from '../components/PaymentForm.vue';
import AccountBenefits from '../components/AccountBenefits.vue';
import FinancialLiteracy from '../components/FinancialLiteracy.vue';
import SecurityAwareness from '../components/SecurityAwareness.vue';
import DigitalBanking from '../components/DigitalBanking.vue';

const routes = [
  { path: '/', component: Home },
  { path: '/login', component: Login },
  { path: '/signup', component: Signup },
  { path: '/dashboard/:userId', component: Dashboard }, // Fixed the dynamic userId param
  { path: '/payment-form', component: PaymentForm },
  {
    path: '/education',
    children: [
      {
        path: 'account-benefits',
        component: AccountBenefits,
        name: 'account-benefits',
        meta: { title: 'Avantages Bancaires' }
      },
      {
        path: 'financial-literacy',
        component: FinancialLiteracy,
        name: 'financial-literacy',
        meta: { title: 'Éducation Financière' }
      },
      {
        path: 'security',
        component: SecurityAwareness,
        name: 'security',
        meta: { title: 'Sécurité Bancaire' }
      },
      {
        path: 'digital-banking',
        component: DigitalBanking,
        name: 'digital-banking',
        meta: { title: 'Services Numériques' }
      },
      {
        path: '/reset-password',
        name: 'ResetPassword',
        component: () => import('@/components/ResetPassword.vue')
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: ErrorPage,
    props: {
      title: 'Page non trouvée',
      message: 'La page que vous recherchez n\'existe pas.',
      statusCode: 404
    }
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Global navigation guard
router.beforeEach(async (to, from, next) => {
  const userStore = useUserStore();

  try {
    if (to.matched.some(record => record.meta.requiresAuth)) {
      if (!userStore.isAuthenticated) {
        // Redirect to login if not authenticated
        next({
          path: '/login',
          query: { redirect: to.fullPath }
        });
        return;
      }

      // Verify token validity
      const isTokenValid = await userStore.verifyToken();
      if (!isTokenValid) {
        userStore.logout();
        next({
          path: '/login',
          query: { redirect: to.fullPath }
        });
        return;
      }
    }
    next();
  } catch (error) {
    console.error('Navigation error:', error);
    // Handle timeout or server errors
    if (error.code === 'ECONNABORTED' || error.response?.status >= 500) {
      next({
        name: 'not-found',
        props: {
          title: 'Erreur de connexion',
          message: 'Un problème est survenu avec le serveur. Veuillez réessayer plus tard.',
          statusCode: error.response?.status || 500
        }
      });
    } else {
      next();
    }
  }
});

export default router;
