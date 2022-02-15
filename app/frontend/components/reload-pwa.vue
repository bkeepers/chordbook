<template>
  <ion-toast
    :is-open="needRefresh"
    message="Updated content is available."
    position="top"
    :buttons="[
      { text: 'Not Now', role: 'cancel', handler: close },
      { text: 'Update', handler: updateServiceWorker }
    ]"
    animated
  />
  <ion-toast
    :is-open="installPrompt"
    message="Add to home screen?"
    position="top"
    :buttons="[
      { text: 'Not Now', role: 'cancel' },
      { text: 'Add', handler: addToHomeScreen }
    ]"
    :duration="5000"
  />
</template>

<script setup>
import { useRegisterSW } from 'virtual:pwa-register/vue'
import { ref } from 'vue'
import { IonToast } from '@ionic/vue'

const { needRefresh, updateServiceWorker } = useRegisterSW()

let installPrompt = ref(null)

// Save prompt for installing to home screen
// https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Add_to_home_screen
window.addEventListener('beforeinstallprompt', (e) => {
  // Stash the event so it can be triggered later.
  installPrompt = e

  console.log('saved install prompt')
})

function addToHomeScreen (e) {
  // Show the prompt
  installPrompt.value.prompt()
  // Wait for the user to respond to the prompt
  installPrompt.value.userChoice.then((choiceResult) => {
    if (choiceResult.outcome === 'accepted') {
      console.log('User accepted the A2HS prompt')
    } else {
      console.log('User dismissed the A2HS prompt')
    }
    installPrompt = null
  })
}

function close () {
  needRefresh.value = false
}
</script>
