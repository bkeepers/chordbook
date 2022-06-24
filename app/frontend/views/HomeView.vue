<script setup>
import { logoGithub, handLeft, cashOutline } from 'ionicons/icons'
import ColorizedImg from '@/components/ColorizedImg.vue'
import { useMeta } from 'vue-meta'

useMeta({ title: 'Home' })
</script>

<template>
  <ion-page>
    <ion-content>
      <div
        class="ion-padding bg-black text-shadow min-h-screen-1/2 shadow-inner bg-center bg-cover flex flex-col place-content-center text-center"
        style="background-image: url(https://images.pexels.com/photos/144428/pexels-photo-144428.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260)"
      >
        <h1 class="text-6xl sm:text-8xl text-white font-semibold">
          Just music,<br>no
          <span class="censored"><span>b</span><span>u</span><span>l</span><span>l</span><span>s</span><span>λ</span><span>!</span><span>τ</span></span>.
        </h1>
        <h2 class="text-base sm:text-xl md:text-2xl text-white font-normal">
          Chord sheets and tab for guitar and ukulele.<br>
          Made for and by amateur musicians.
        </h2>
      </div>

      <div
        id="contribute"
        class="lg:px-8"
      >
        <div class="text-center mt-10 sm:mt-20 ion-padding">
          <h2 class="ion-margin text-4xl sm:text-5xl">
            Let's play music better, together.
          </h2>
          <p class="text-xl sm:text-2xl max-w-4xl mx-auto text-muted">
            Chord Book is made by amateur musicians and volunteers. Here's how you can lend your talent, time, or money to help make it even better…
          </p>
        </div>

        <div class="grid md:grid-cols-3 md:mb-6">
          <ion-card class="flex flex-col">
            <colorized-img
              class="aspect-16/9 w-full"
              src="https://images.pexels.com/photos/1407322/pexels-photo-1407322.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=720"
            />

            <ion-card-header>
              <ion-card-subtitle>Musicians</ion-card-subtitle>
              <ion-card-title>Improve Charts</ion-card-title>
            </ion-card-header>
            <ion-card-content class="grow">
              <p>
                Volunteer to be an editor and get full access to add new charts or make corrections to existing ones.
              </p>
            </ion-card-content>
            <p class="text-center">
              <ion-button
                class="w-40"
                href="mailto:help@chordbook.app?subject=I'd%20like%20to%20volunteer"
              >
                <ion-icon
                  slot="start"
                  :icon="handLeft"
                />
                Volunteer
              </ion-button>
            </p>
          </ion-card>
          <ion-card class="flex flex-col">
            <colorized-img
              class="aspect-16/9 w-full"
              src="https://images.pexels.com/photos/48171/guitar-case-street-musicians-donate-donation-48171.jpeg?auto=compress&cs=tinysrgb&w=640"
            />
            <ion-card-header>
              <ion-card-subtitle>Patrons</ion-card-subtitle>
              <ion-card-title>Leave a Tip</ion-card-title>
            </ion-card-header>
            <ion-card-content class="grow">
              <p>
                Show your appreciation and support the costs of building and running the app.
              </p>
            </ion-card-content>
            <p class="text-center">
              <ion-button
                class="w-40"
                href="https://www.patreon.com/chordbook"
              >
                <ion-icon
                  slot="start"
                  :icon="cashOutline"
                />
                Donate
              </ion-button>
            </p>
          </ion-card>
          <ion-card class="flex flex-col">
            <colorized-img
              class="aspect-16/9 w-full"
              src="https://images.pexels.com/photos/374563/pexels-photo-374563.jpeg?auto=compress&cs=tinysrgb&dpr=3w=640"
            />

            <ion-card-header>
              <ion-card-subtitle>Developers</ion-card-subtitle>
              <ion-card-title>Contribute Code</ion-card-title>
            </ion-card-header>
            <ion-card-content class="grow">
              <p>
                This app is open source! Help us fix bugs, improve features, and make progress on our <a href="https://github.com/bkeepers/chordbook/projects/1">roadmap</a>.
              </p>
            </ion-card-content>
            <p class="text-center">
              <ion-button
                class="w-40"
                href="https://github.com/bkeepers/chordbook"
                target="_blank"
                rel="noopener"
              >
                <ion-icon
                  slot="start"
                  :icon="logoGithub"
                />
                Contribute
              </ion-button>
            </p>
          </ion-card>
        </div>
      </div>
    </ion-content>
  </ion-page>
</template>

<style>
.censored {
  @apply text-transparent
}

.censored span:nth-of-type(1)  { text-shadow: 0 0 2px rgba(255,255,255,1); }
.censored span:nth-of-type(2)  { text-shadow: 0 0 4px rgba(255,255,255,1); }
.censored span:nth-of-type(3)  { text-shadow: 0 0 6px rgba(255,255,255,1); }
.censored span:nth-of-type(4)  { text-shadow: 0 0 8px rgba(255,255,255,1); }
.censored span:nth-of-type(5)  { text-shadow: 0 0 10px rgba(255,255,255,1); }
.censored span:nth-of-type(6)  { text-shadow: 0 0 12px rgba(255,255,255,1); }
.censored span:nth-of-type(7)  { text-shadow: 0 0 10px rgba(255,255,255,1); }
.censored span:nth-of-type(8)  { text-shadow: 0 0 8px rgba(255,255,255,1); }
</style>
