<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-title>Songs</ion-title>

        <ion-buttons slot="start">
          <ion-back-button
            class="md:hidden"
            text="Library"
            default-href="/library"
          />
        </ion-buttons>

        <ion-buttons slot="end">
          <ion-button :router-link="{ name: 'songsheet.new' }">
            <ion-icon
              slot="icon-only"
              :icon="icons.add"
            />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Songs
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <library-placeholder
        v-if="!dataSource.loading && dataSource.items.length === 0"
        type="song"
      />

      <ion-list>
        <songsheet-item
          v-for="songsheet in songsheets"
          :key="songsheet.id"
          :songsheet="songsheet"
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

<script>
import DataSource from '@/DataSource'
import SongsheetItem from '@/components/SongsheetItem.vue'
import LibraryPlaceholder from '../components/LibraryPlaceholder.vue'
import { add } from 'ionicons/icons'

export default {
  components: { SongsheetItem, LibraryPlaceholder },

  metaInfo () {
    return { title: 'Songs' }
  },

  data () {
    const dataSource = new DataSource(this.$route.path, { params: this.$route.query })
    return {
      dataSource,
      songsheets: dataSource.items,
      icons: { add }
    }
  },

  created () {
    this.dataSource.load()
  }
}
</script>
