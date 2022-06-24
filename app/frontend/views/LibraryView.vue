<script setup>
import * as icons from '@/icons'
import { useMeta } from 'vue-meta'

useMeta({ title: 'Library' })
</script>

<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Library</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Library
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list>
        <ion-item
          button
          router-link="/songsheets"
        >
          <ion-icon
            slot="start"
            size="small"
            :icon="icons.song"
          />
          <ion-label>Songs</ion-label>
        </ion-item>
        <ion-item
          button
          router-link="/artists"
        >
          <ion-icon
            slot="start"
            size="small"
            :icon="icons.artist"
          />
          <ion-label>Artists</ion-label>
        </ion-item>
        <ion-item
          button
          router-link="/setlists"
        >
          <ion-icon
            slot="start"
            size="small"
            :icon="icons.setlist"
          />
          <ion-label>Setlists</ion-label>
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-page>
</template>
