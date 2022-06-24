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
            :default-href="backLink"
          />
        </ion-buttons>
        <ion-title>Songs</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-list>
        <track-item
          v-for="track in dataSource.items"
          :key="track.id"
          :track="track"
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
import TrackItem from '@/components/TrackItem.vue'

export default {
  components: { TrackItem },

  metaInfo () {
    return {
      title: 'Songs'
    }
  },

  data () {
    const dataSource = new DataSource(this.$route.path, { params: this.$route.query })

    return {
      dataSource
    }
  },

  computed: {
    backLink () {
      return this.$route.path.replace('/tracks', '')
    }
  },

  created () {
    this.dataSource.load()
  }

}
</script>
