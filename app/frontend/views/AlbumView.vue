<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            v-if="album.artist"
            text=""
            :default-href="`/artists/${album.artist.id}`"
          />
        </ion-buttons>
        <ion-title>{{ album.title }}</ion-title>
        <ion-buttons slot="end">
          <add-to-library-button
            v-if="album.uid"
            :uid="album.uid"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <div class="ion-padding ion-margin flex gap-4 md:gap-6 flex-col md:flex-row">
        <div class="text-center flex-shrink-0 flex place-content-center">
          <div class="aspect-square w-3/4 md:w-60 rounded overflow-hidden shadow-lg flex place-content-center items-center bg-slate-100 dark:bg-slate-800">
            <img
              v-if="album.thumbnail"
              :src="album.thumbnail"
            >
            <ion-icon
              v-else
              :icon="placeholderIcon"
              class="text-slate-300 dark:text-slate-700 text-6xl"
            />
          </div>
        </div>
        <div class="text-center md:text-left md:pt-6">
          <h1 class="text-xl md:text-3xl m-0">
            {{ album.title }}
          </h1>
          <ion-label
            v-if="album.artist"
            button
            :router-link="{ name: 'artist', params: { id: album.artist.id } }"
            class="block text-xl md:text-2xl text-teal-500 ion-activatable ion-focusable"
          >
            {{ album.artist.name }}
          </ion-label>
          <ion-note class="text-xs uppercase font-semibold">
            <ion-label
              v-if="album.genre"
              :router-link="{ name: 'genre', params: { id: album.genre.id } }"
            >
              {{ album.genre?.name }}
            </ion-label>
            •
            {{ album.released }}
          </ion-note>

          <ion-note
            class="block text-sm line-clamp-3 overflow-hidden mt-4"
            onclick="this.classList.toggle('line-clamp-3')"
          >
            {{ album.description }}
          </ion-note>
        </div>
      </div>

      <ion-list v-if="album.tracks && album.tracks.length > 0">
        <ion-item
          v-for="track in album.tracks"
          :key="track.id"
          :href="`/tracks/${track.id}`"
          :class="{'text-neutral-500/50 hover:text-current transition-opacity': !track.has_songsheet}"
        >
          <ion-text slot="start">
            <span class="text-sm text-muted w-4 text-right inline-block">{{ track.number }}</span>
          </ion-text>
          <ion-label>
            <h2>{{ track.title }}</h2>
          </ion-label>
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import { album as placeholderIcon } from '@/icons'

export default {
  components: { AddToLibraryButton },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  metaInfo () {
    return { title: this.album?.title }
  },

  data () {
    return {
      album: {},
      placeholderIcon
    }
  },

  ionViewWillEnter () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      this.album = (await client.get(`albums/${this.id}.json`)).data
    }
  }
}
</script>
