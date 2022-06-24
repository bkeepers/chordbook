<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/discover"
          />
        </ion-buttons>
        <ion-title>{{ data?.name }}</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            {{ data?.name }}
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list v-if="data?.tracks.length > 0">
        <ion-list-header>
          <ion-label>Top Songs</ion-label>
          <ion-button :router-link="{ name: 'genre.tracks', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4">
          <track-item
            v-for="track in data.tracks"
            :key="track.id"
            :track="track"
          />
        </div>
      </ion-list>

      <ion-list v-if="data?.artists.length > 0">
        <ion-list-header>
          <ion-label>Top Artists</ion-label>
          <ion-button :router-link="{ name: 'genre.artists', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8">
          <artist-card
            v-for="artist in data.artists"
            :key="artist.id"
            :artist="artist"
          />
        </div>
      </ion-list>

      <ion-list v-if="data?.albums.length > 0">
        <ion-list-header>
          <ion-label>Top Albums</ion-label>
          <ion-button :router-link="{ name: 'genre.albums', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8">
          <album-item
            v-for="album in data.albums"
            :key="album.id"
            :album="album"
          />
        </div>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script setup>
import { useFetch } from '@/client'
import { defineProps, computed } from 'vue'
import { useMeta } from 'vue-meta'
import ArtistCard from '@/components/ArtistCard.vue'
import AlbumItem from '@/components/AlbumItem.vue'
import TrackItem from '@/components/TrackItem.vue'

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const { data } = useFetch(`genres/${props.id}.json`).get().json()
useMeta(computed(() => ({ title: data.value?.name ?? 'Genre' })))
</script>
