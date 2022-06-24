<script setup>
import useAuthStore from '@/stores/auth'
import { defineProps, ref } from 'vue'
import { useRouter, useMeta } from 'vue-router'

useMeta({ title: 'Reset Your Password' })

const auth = useAuthStore()
const router = useRouter()
const props = defineProps({
  token: {
    type: String,
    default: null
  }
})
const params = ref({
  token: props.token
})

const { execute, data, onFetchResponse } = auth.resetPassword(params, { immediate: false })

onFetchResponse((response) => {
  router.push('#signin')
})
</script>

<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>Reset Your Password</ion-title>
        <ion-buttons slot="end">
          <ion-back-button
            role="cancel"
            icon=""
            text="Cancel"
            default-href="#signin"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <div class="max-w-md m-auto flex flex-col justify-center h-full">
        <form @submit.prevent="execute">
          <ion-item :class="{ 'ion-invalid': data?.error?.password }">
            <ion-label position="floating">
              New Password
            </ion-label>
            <ion-input
              v-model="params.password"
              type="password"
              autocomplete="new-password"
            />
            <ion-note slot="error">
              {{ data?.error?.password?.join(', ') }}
            </ion-note>
          </ion-item>

          <div class="ion-margin">
            <ion-button
              type="submit"
              expand="block"
            >
              Set Password
            </ion-button>
          </div>
          <div class="ion-margin text-center text-sm text-muted">
            Did you remember your password?
            <router-link to="#signin">
              Sign In
            </router-link>
          </div>
        </form>
      </div>
      <ion-alert
        v-if="data?.error?.message"
        header="Error"
        :message="data?.error?.message"
        :buttons="['Ok']"
        @did-dismiss="router.push({ name: 'password/forgot' })"
      />
    </ion-content>
  </ion-page>
</template>
