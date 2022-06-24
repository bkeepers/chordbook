<script setup>
import DataSource from '@/DataSource'
import AlbumItem from '@/components/AlbumItem.vue'
import LibraryPlaceholder from '@/components/LibraryPlaceholder.vue'
import { computed, reactive } from 'vue'
import { useRoute } from 'vue-router'
import { useMeta } from 'vue-meta'

useMeta({ title: 'Albums' })
const route = useRoute()
const dataSource = reactive(new DataSource(route.path, { params: route.query }))
const backLink = computed(() => route.path.replace('/albums', ''))

dataSource.load()
</script>

<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            class="md:hidden"
            text="Library"
            :default-href="backLink"
          />
        </ion-buttons>
        <ion-title>Albums</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <library-placeholder
        v-if="!dataSource.loading && dataSource.items.length === 0"
        type="album"
      />

      <ion-list>
        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8">
          <album-item
            v-for="album in dataSource.items"
            :key="album.id"
            :album="album"
          />
        </div>
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
