<script setup>
import { defineProps } from 'vue'
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from '@headlessui/vue'
import YoutubeEmbed from '@/components/YoutubeEmbed.vue'
import { logoYoutube } from 'ionicons/icons'

defineProps({
  songsheet: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <div
    v-if="songsheet.media?.length > 0"
    class="z-10 sticky hide-on-scroll-down md:fixed top-0 md:top-20 md:right-5 md:shadow-md md:border dark:border-zinc-800 md:w-96"
  >
    <TabGroup>
      <TabPanels class="bg-black md:rounded overflow-hidden">
        <TabPanel
          v-for="src in songsheet.media"
          :key="src"
        >
          <youtube-embed :src="src" />
        </TabPanel>
      </TabPanels>
      <TabList
        v-show="songsheet.media.length > 1"
        class="p-2 flex gap-2 bg-slate-100 dark:bg-zinc-800 md:border-none"
      >
        <Tab
          v-for="media in songsheet.media"
          v-slot="{ selected }"
          :key="media"
          as="template"
        >
          <button
            :class="['px-4 py-2 rounded inline-flex align-center outline-none active:ring border', selected ? 'bg-blue-500 hover:bg-blue-400 text-white' : 'bg-slate-50 text-black hover:bg-zinc-200']"
          >
            <ion-icon :icon="logoYoutube" />
          </button>
        </Tab>
      </TabList>
    </TabGroup>
  </div>
</template>
