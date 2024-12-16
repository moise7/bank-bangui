<template>
  <div>
    <p v-if="streak >= goal">🎉 Congratulations! You’ve met your goal!</p>
    <p v-else>Keep going! You’re on a {{ streak }}-day streak.</p>
  </div>
</template>

<script>
import { ref } from 'vue';

export default {
  props: ['streak', 'goal'],
};
</script>
