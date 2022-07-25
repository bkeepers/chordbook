<template>
  <ion-content
    v-if="song"
    :scroll-y="columns == 1"
    :scroll-x="columns == 2"
    fullscreen
    :scroll-events="true"
    v-scroll-direction
  >
    <slot name="top" />
    <div :class="'ion-padding ' + (columns == 1 ? 'single-column' : 'horizontal-columns')">
      <!-- Hidden sprite of chord diagrams -->
      <svg
        hidden
        xmlns="http://www.w3.org/2000/svg"
      >
        <chord-diagram
          v-for="chord in chords"
          :key="chord + instrument"
          :name="chord"
          :instrument="instrument"
        />
      </svg>

      <slot name="header">
        <h1 class="text-xl md:text-2xl my-1">
          {{ song?.title }}
        </h1>
        <div
          v-if="song.artist"
          class="my-1"
        >
          <span class="text-muted">by</span> {{ formatArray(song.artist) }}
        </div>
      </slot>

      <div
        ref="output"
        class="chord-sheet mt-2"
      >
        <div
          v-if="song.capo"
          class="capo my-4"
        >
          Capo {{ song.capo }}
        </div>
        <div
          v-if="song.subtitle"
          class="my-1"
        >
          {{ song.subtitle }}
        </div>

        <div
          v-for="{ type, lines } in song.paragraphs"
          :key="type + JSON.stringify(lines)"
          :class="type + ' paragraph'"
        >
          <template
            v-for="line in lines"
            :key="JSON.stringify(line)"
          >
            <div
              v-if="line.hasRenderableItems()"
              class="row"
            >
              <template
                v-for="item in line.items"
                :key="JSON.stringify(item)"
              >
                <component
                  :is="componentFor(item)"
                  v-if="item.isRenderable()"
                  :item="item"
                />
              </template>
            </div>
          </template>
        </div>
      </div>
    </div>
    <slot name="footer" />
  </ion-content>
  <ion-footer
    v-if="showChords"
    translucent
  >
    <ion-toolbar translucent>
      <div class="flex gap-2 overflow-x-auto place-content-center pt-2 px-4">
        <div
          v-for="name in chords"
          :key="name"
          class="text-center text-sm"
        >
          <div class="chord">
            {{ name }}
          </div>
          <svg
            class="chord-diagram inline-block"
            xmlns="http://www.w3.org/2000/svg"
            role="image"
            :title="name"
          >
            <use
              :xlink:href="`#chord-${name}`"
              viewBox="0 0 50 65"
            />
          </svg>
        </div>
      </div>
    </ion-toolbar>
  </ion-footer>
</template>

<script>
import detectFormat from '@/lib/detect_format'
import ChordLyricsPair from '@/components/ChordLyricsPair.vue'
import SongSheetComment from '@/components/SongSheetComment.vue'
import ChordDiagram from '@/components/ChordDiagram.vue'
import arrify from 'arrify'
import useSongsheetSettingsStore from '@/stores/songsheet-settings'
import { mapState } from 'pinia'

export default {
  components: { ChordLyricsPair, SongSheetComment, ChordDiagram },

  props: {
    source: {
      type: String,
      default: null
    }
  },

  emits: ['update:key', 'parse', 'error'],

  data () {
    return {
      columnWidth: 0
    }
  },

  computed: {
    ...mapState(useSongsheetSettingsStore, ['transpose', 'showChords', 'instrument', 'columns']),

    format () {
      return detectFormat(this.source)
    },

    parsedSong () {
      try {
        // FIXME: somehow \r is getting added by Ace
        const song = this.format?.parse(this.source.replace(/\r\n/gm, '\n'))
        return song.key ? song : song.setKey(guessKey(song))
      } catch (error) {
        console.error(error)
        this.$emit('error', error)
        return null
      }
    },

    song () {
      return this.parsedSong.transpose(this.transpose)
    },

    chords () {
      return chordSet(this.song)
    },

    key () {
      return this.parsedSong.key
    }
  },

  watch: {
    columns () {
      this.updateColumnWidth()
    },

    key: {
      immediate: true,
      handler (key) {
        this.$emit('update:key', key)
      }
    },

    song: {
      immediate: true,
      handler (song) {
        this.$emit('parse', song)
      }
    }
  },

  mounted () {
    this.updateColumnWidth()
  },

  updated () {
    this.updateColumnWidth()
  },

  methods: {
    componentFor (item) {
      return [ChordLyricsPair, SongSheetComment].find(c => c.for(item))
    },

    updateColumnWidth () {
      const output = this.$refs.output
      if (!output) return

      output.classList.add('content-width')
      requestAnimationFrame(() => {
        this.columnWidth = output.offsetWidth + 'px'
        output.classList.remove('content-width')
      })
    },

    toggleTuner () {
      this.showTuner = !this.showTuner
    },

    formatArray (args) {
      return new Intl.ListFormat().format(arrify(args))
    }
  }
}

function chordSet (song) {
  const chords = new Set()

  song.lines.forEach(line => {
    line.items.forEach(pair => {
      if (pair.chords) chords.add(pair.chords)
    })
  })

  return chords
}

function guessKey (song) {
  // FIXME: use intelligent key detection
  return chordSet(song).values().next()
}
</script>

<style>
.horizontal-columns {
  @apply h-full;
  column-count: auto;
  column-width: v-bind(columnWidth);
  min-width: v-bind(columnWidth);
}
.horizontal-columns .column-span-all { column-span: all; }

.single-column .row { flex-wrap: wrap; }

.content-width {
  overflow: auto !important;
  max-width: max-content !important;
  min-width: max-content !important;
  width: max-content !important;
  display: inline-block !important;
  flex-wrap: nowrap !important;
  padding: none !important;
}

.chord-sheet {
  counter-reset: verse;
}

.paragraph {
  @apply leading-tight break-inside-avoid;
}

.paragraph + .paragraph {
  @apply mt-6;
}

.row {
  @apply flex flex-nowrap relative break-inside-avoid;
}

.column {
  @apply flex flex-col
}

.comment, .chorus:before, .verse::before, .capo {
  @apply font-semibold text-sm text-zinc-600 break-after-avoid;
}

.chord, .lyrics {
  @apply whitespace-pre
}

.tab {
  @apply font-mono text-xs;
}

.chord-sheet *:not(.tab) .chord {
  @apply text-indigo-800 dark:text-indigo-300 pr-1 font-medium text-sm;
}

.chorus {
  @apply border-neutral-200 dark:border-neutral-700 pl-4 border-l-4;
}

*:not(.chorus) + .chorus::before {
  content: "Chorus:";
}

.chorus + .chorus {
  @apply mt-0 pt-6;
}

.verse::before {
  counter-increment: verse;
  content: "Verse " counter(verse) ":";
}

.chord:after, .lyrics:after {
  content: '\200b';
}

.chord-diagram {
  width: 50px;
  height: 65px;
}
</style>
