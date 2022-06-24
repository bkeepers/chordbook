<script setup>
import DataSource from '@/DataSource'
import ArtistItem from '@/components/ArtistItem.vue'
import LibraryPlaceholder from '@/components/LibraryPlaceholder.vue'
import { useMeta } from 'vue-meta'
import { useRoute } from 'vue-router'
import { reactive, computed } from 'vue'

useMeta({ title: 'Artists' })
const route = useRoute()
const backLink = computed(() => route.path.replace('/artists', '') || '/library')
const dataSource = reactive(new DataSource(route.path, { params: route.query }))

dataSource.load()
</script>

<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Artists</ion-title>

        <ion-buttons slot="start">
          <ion-back-button
            class="md:hidden"
            text="Library"
            :default-href="backLink"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Artists
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <library-placeholder
        v-if="!dataSource.loading && dataSource.items.length === 0"
        type="artist"
      />

      <ion-list>
        <artist-item
          v-for="artist in dataSource.items"
          :key="artist.id"
          :artist="artist"
        />
      </ion-list>

      <ion-infinite-scroll
        threshold="500px"
        :disabled="dataSource.loading || dataSource.disabled"
        @ion-infinite="dataSource.load().then(() => $event.target.complete())"
      >
        <ion-infinite-scroll-content
          loading-spinner="bubbles"
          loading-text="Loading…"
        />
      </ion-infinite-scroll>
    </ion-content>
  </ion-page>
</template>
