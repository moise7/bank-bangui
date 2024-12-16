<template>
  <div>
    <canvas id="budget-chart"></canvas>
    <div v-if="progress.percentage > 100" class="text-red-500">
      Over Budget! Reduce Spending.
    </div>
    <div v-else class="text-green-500">
      Great Job! You’re within budget.
    </div>
  </div>
</template>

<script>
import { onMounted, ref } from 'vue';
import Chart from 'chart.js/auto';

export default {
  props: ['progress'],
  setup(props) {
    const chart = ref(null);

    onMounted(() => {
      const ctx = document.getElementById('budget-chart').getContext('2d');
      chart.value = new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: ['Spent', 'Remaining'],
          datasets: [
            {
              data: [props.progress.total_spent, props.progress.remaining],
              backgroundColor: ['#ff6b6b', '#1dd1a1'],
            },
          ],
        },
      });
    });

    return { chart };
  },
};
</script>
