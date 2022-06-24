<script setup>
import { ref } from 'vue'
import useAuthStore from '@/stores/auth'
import { useMeta } from 'vue-meta'

useMeta({ title: 'Reset Password' })
const auth = useAuthStore()
const params = ref({})
const { isFinished, error, execute, data } = auth.forgotPassword(params, { immediate: false })
</script>

<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>
          Reset Password
        </ion-title>
        <ion-buttons slot="end">
          <ion-back-button
            role="cancel"
            icon=""
            text="Cancel"
            default-href="/"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <div class="max-w-md m-auto flex flex-col justify-center h-full">
        <div
          v-if="isFinished && !error"
          class="text-center"
        >
          <p class="text-lg">
            {{ data.message }}
          </p>
        </div>
        <form
          v-else
          @submit.prevent="execute"
        >
          <ion-item :class="{ 'ion-invalid': error }">
            <ion-label position="floating">
              Email
            </ion-label>
            <ion-input
              v-model="params.email"
              type="email"
              autocomplete="email"
              required
            />
            <ion-note
              v-if="error"
              slot="error"
            >
              {{ data.error }}
            </ion-note>
          </ion-item>
          <div class="ion-margin ">
            <ion-button
              type="submit"
              expand="block"
            >
              Reset Password
            </ion-button>
          </div>
          <div class="ion-margin text-center text-sm text-muted">
            <router-link to="#signin">
              Sign In
            </router-link>
            •
            <router-link to="#signup">
              Sign Up
            </router-link>
          </div>
        </form>
      </div>
    </ion-content>
  </ion-page>
</template>
