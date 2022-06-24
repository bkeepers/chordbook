<script setup>
import { useMeta } from 'vue-meta'

useMeta({ title: 'Not Found' })
</script>

<template>
  <div class="h-full flex flex-col place-content-center">
    <div class="prose max-w-xl mx-auto p-8 m-4 bg-white border rounded shadow-xl">
      <h1 class="text-3xl mb-2">
        Not Found
      </h1>

      <p>Uh oh! The page you're looking seems to be missing.</p>

      <p>
        <router-link to="/">
          Return to home page
        </router-link>
      </p>
    </div>
  </div>
</template>
