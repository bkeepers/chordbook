<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/songsheets"
          />
          <ion-button
            :id="`versions-button-${id}`"
            :disabled="otherVersions.length == 0"
          >
            <ion-icon :icon="icons.list" />
          </ion-button>
        </ion-buttons>

        <ion-buttons slot="end">
          <ion-button
            :color="showPlayer ? 'secondary' : ''"
            :disabled="songsheet.media?.length == 0"
            @click="showPlayer = !showPlayer"
          >
            <ion-icon
              slot="icon-only"
              :icon="icons.play"
            />
          </ion-button>
          <ion-button :id="`settings-button-${id}`">
            <ion-icon
              slot="icon-only"
              :icon="icons.transpose"
            />
          </ion-button>
          <add-to-library-button
            v-if="songsheet.uid"
            :uid="songsheet.uid"
          />
          <ion-button
            :id="`songsheet-context-${songsheet.id}`"
            fill="clear"
            @click.prevent=""
          >
            <ion-icon
              slot="icon-only"
              size="small"
              :ios="icons.iosEllipsis"
              :md="icons.mdEllipsis"
            />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <song-sheet
      v-if="songsheet.source"
      :source="songsheet.source"
      @update:key="(v) => key = v"
    >
      <template #top>
        <Transition name="slide-down">
          <songsheet-media
            v-show="showPlayer"
            :songsheet="songsheet"
          />
        </Transition>
      </template>
      <template
        v-if="songsheet.track"
        #header
      >
        <div class="flex gap-3 md:gap-4 items-center">
          <div
            v-if="songsheet.track?.album"
            class="aspect-square w-20 rounded overflow-hidden shadow-lg flex place-content-center items-center bg-slate-100 dark:bg-slate-800"
          >
            <img :src="songsheet.track?.album.thumbnail">
          </div>

          <div>
            <h1 class="text-xl md:text-2xl my-1">
              {{ songsheet.title }}
            </h1>

            <ion-label
              v-if="songsheet.track.artist"
              button
              :router-link="{ name: 'artist', params: { id: songsheet.track.artist.id } }"
              class="block ion-activatable ion-focusable my-0"
            >
              <span class="text-muted">by </span>
              <span class="text-teal-500">{{ songsheet.track.artist.name }}</span>
            </ion-label>
            <ion-label
              v-if="songsheet.track.album"
              button
              :router-link="{ name: 'album', params: { id: songsheet.track.album.id } }"
              class="block ion-activatable ion-focusable truncate overflow-hidden my-1"
            >
              <span class="text-muted">from </span>
              <span class="text-teal-500">{{ songsheet.track.album.title }}</span>
            </ion-label>
          </div>
        </div>
      </template>

      <template #footer>
        <div class="ion-padding text-sm opacity-50 mb-8 flex gap-4">
          <div>Updated {{ formatDate(songsheet.updated_at) }}</div>
          <div v-if="songsheet.imported_from">
            Imported from
            <a
              target="_blank"
              :href="songsheet.imported_from"
              class="text-inherit no-underline"
            >
              {{ hostname(songsheet.imported_from) }}
            </a>
          </div>
        </div>
      </template>
    </song-sheet>

    <songsheet-versions-modal
      :trigger="`versions-button-${id}`"
      :versions="otherVersions"
    />
    <songsheet-settings-modal
      :trigger="`settings-button-${id}` "
      :note="key"
    />
    <ion-popover
      :trigger="`songsheet-context-${songsheet.id}`"
      dismiss-on-select
    >
      <ion-list>
        <ion-item
          button
          detail
          :router-link="{ name: 'songsheet.edit', params: { id: songsheet.id } }"
          :detail-icon="icons.edit"
        >
          <ion-label>Edit</ion-label>
        </ion-item>
        <add-to-setlist-item :songsheet="songsheet" />
        <ion-item
          v-if="songsheet.track?.artist"
          button
          detail
          :detail-icon="icons.artist"
          :router-link="{ name: 'artist', params: { id: songsheet.track.artist.id } }"
        >
          View Artist
        </ion-item>
        <ion-item
          v-if="songsheet.track?.album"
          button
          detail
          :detail-icon="icons.album"
          :router-link="{ name: 'album', params: { id: songsheet.track.album.id } }"
        >
          View Album
        </ion-item>
        <share-item
          :title="songsheet.title"
          :router-link="{ name: 'songsheet', params: { id: songsheet.id }}"
        />
        <ion-item
          button
          detail
          :detail-icon="icons.tuningFork"
          lines="none"
          @click="openTuner"
        >
          Tuner
        </ion-item>
      </ion-list>
    </ion-popover>
  </ion-page>
</template>

<script>
import client from '@/client'
import { modalController } from '@ionic/vue'
import SongSheet from '@/components/SongSheet.vue'
import SongsheetVersionsModal from '@/components/SongsheetVersionsModal.vue'
import SongsheetSettingsModal from '@/components/SongsheetSettingsModal.vue'
import SongsheetMedia from '@/components/SongsheetMedia.vue'
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import TunerView from '@/views/TunerView.vue'
import { Insomnia } from '@awesome-cordova-plugins/insomnia'
import AddToSetlistItem from '@/components/AddToSetlistItem.vue'
import ShareItem from '@/components/ShareItem.vue'
import * as icons from '@/icons'

export default {
  components: { SongSheet, AddToSetlistItem, SongsheetVersionsModal, SongsheetSettingsModal, SongsheetMedia, AddToLibraryButton, ShareItem },

  props: {
    id: {
      type: String,
      required: true
    },

    type: {
      type: String,
      default () { return 'songsheet' }
    }
  },

  metaInfo () {
    return { title: this.songsheet.title }
  },

  data () {
    return {
      songsheet: {},
      versions: [],
      source: '',
      key: 'C',
      showTuner: false,
      icons,
      showPlayer: false
    }
  },

  computed: {
    otherVersions () {
      return this.versions.filter(v => v.id !== this.songsheet.id)
    }
  },

  ionViewWillEnter () {
    this.fetchData()
  },

  ionViewDidEnter () {
    return Insomnia.keepAwake()
  },

  ionViewWillLeave () {
    return Insomnia.allowSleepAgain()
  },

  methods: {
    async fetchData () {
      if (this.type === 'songsheet') {
        await this.fetchSongsheet(this.id)
        if (this.songsheet.track) {
          await this.fetchVersions(this.songsheet.track.id)
        }
      } else {
        await this.fetchVersions(this.id)
        if (this.versions.length > 0) {
          this.fetchSongsheet(this.versions[0].id)
        } else {
          this.$router.push({ name: 'songsheet.new', params: { track: this.id }, replace: true })
        }
      }
    },

    async fetchSongsheet (id) {
      this.songsheet = (await client.get(`songsheets/${id}.json`)).data
    },

    async fetchVersions (id) {
      this.versions = (await client.get(`tracks/${id}/songsheets.json`)).data
    },

    async openTuner () {
      const modal = await modalController
        .create({
          component: TunerView,
          initialBreakpoint: 0.5,
          breakpoints: [0, 0.5]
        })
      return modal.present()
    },

    formatDate (input) {
      if (!input) return ''
      const date = new Date(input)
      return new Intl.DateTimeFormat(navigator.language).format(date)
    },

    hostname (url) {
      return new URL(url).hostname
    }
  }
}
</script>
