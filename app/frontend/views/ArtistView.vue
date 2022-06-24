<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/artists"
          />
        </ion-buttons>
        <ion-title>{{ artist.name }}</ion-title>
        <ion-buttons slot="end">
          <add-to-library-button
            v-if="artist.uid"
            :uid="artist.uid"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <ion-header>
        <div
          :style="`background-image: linear-gradient(rgba(0,0,0,0) 33%, rgba(0,0,0,0.8)), url(${artist.banner}); background-position: 50% 25%`"
          class="bg-slate-700 bg-cover aspect-16/9-max-h-screen-1/2"
        >
          <ion-toolbar class="absolute bottom-0 w-full ion-padding text-white text-shadow">
            <ion-note
              v-if="artist.genre"
              button
              :router-link="{ name: 'genre', params: { id: artist.genre.id } }"
              class="block text-lg text-white opacity-70 ion-activatable ion-focusable"
            >
              {{ artist.genre.name }}
            </ion-note>
            <h1 class="text-4xl font-bold m-0">
              {{ artist.name }}
            </h1>
          </ion-toolbar>
        </div>
      </ion-header>

      <ion-list v-if="tracks.length > 0">
        <ion-list-header>
          <ion-label>Top Songs</ion-label>
          <ion-button :router-link="{ name: 'artist.tracks', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4">
          <track-item
            v-for="track in tracks"
            :key="track.id"
            :track="track"
          />
        </div>
      </ion-list>

      <ion-list
        v-if="albums.length > 0"
        lines="none"
      >
        <ion-list-header>
          <ion-label>Top Albums</ion-label>
          <ion-button :router-link="{ name: 'artist.albums', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 2xl:auto-cols-1/6">
          <album-item
            v-for="album in albums"
            :key="album.id"
            :album="album"
            :show-artist="false"
          />
        </div>
      </ion-list>

      <div v-if="artist.biography">
        <ion-list-header>
          <ion-label>About</ion-label>
        </ion-list-header>
        <div class="ion-padding">
          <p
            class="text-sm line-clamp-6 overflow-hidden"
            onclick="this.classList.toggle('line-clamp-6')"
          >
            {{ artist.biography }}
          </p>
        </div>
      </div>
    </ion-content>
  </ion-page>
</template>

<script setup>
import client from '@/client'
import TrackItem from '@/components/TrackItem.vue'
import AlbumItem from '@/components/AlbumItem.vue'
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import { ref, computed, defineProps } from 'vue'
import { useMeta } from 'vue-meta'

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const artist = ref({})
const tracks = ref([])
const albums = ref([])

useMeta(computed(() => ({
  title: artist.value.name ?? 'Artist',
  description: artist.value.biography ?? ''
})))

function fetchData () {
  return Promise.all([
    client.get(`artists/${props.id}.json`).then(response => {
      artist.value = response.data
    }),
    client.get(`artists/${props.id}/albums.json`).then(response => {
      albums.value = response.data
    }),
    client.get(`artists/${props.id}/tracks.json`).then(response => {
      tracks.value = response.data
    })
  ])
}

fetchData()
</script>

<style scoped>
/* Safari does not respect max-height with aspect-ratio, so workaround it */
.aspect-16\/9-max-h-screen-1\/2 {
  @apply max-h-screen-1/2 overflow-hidden relative;
}
.aspect-16\/9-max-h-screen-1\/2:before {
  content: '';
  @apply block aspect-16/9;
}

ion-content ion-toolbar {
  --background: transparent
}
</style>
