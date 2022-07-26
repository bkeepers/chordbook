<template>
  <ion-menu
    class="dark mod maxw-minw width-state"
  >
    <ion-header class="flex">
      <ion-toolbar>
        <ion-item
          :router-link="{ name: 'home' }"
          lines="none"
          router-direction="root"
          class="ion-padding-horizontal ion-item-custom"
        >
          <!-- Logo, light & dark, open & collapsed -->
          <img
            v-if="isNotCollapsed"
            slot="start"
            class="inline dark:hidden logo"
            :src="icons.logoLight"
            style="height: 20px"
            image="logo"
          >
          <img
            v-else
            slot="start"
            class="hidden"
            :src="icons.logoLight"
            image="logo"
          >
          <img
            v-if="isNotCollapsed"
            slot="start"
            class="hidden dark:inline logo"
            :src="icons.logo"
            image="logo"
          >
          <img
            v-else
            slot="start"
            class="hidden"
            :src="icons.logo"
            image="logo"
          >
          <!-- Wordmark, light & dark. Menu:open -->
          <ion-label
            v-if="isNotCollapsed"
            class="wordmark-label"
          >
            <img
              alt="Chord Book"
              class="inline dark:hidden"
              :src="icons.wordmarkLight"
              style="height: 14px"
            >
            <img
              alt="Chord Book"
              class="hidden dark:inline"
              :src="icons.wordmarkDark"
              style="height: 14px"
            >
          </ion-label>
          <!-- Wordmark, light & dark. Menu:collapsed -->
          <ion-label
            v-else
            class="wordmark-label--collapsed"
          >
            <img
              alt="Chord Book"
              class="hidden"
              :src="icons.wordmarkLight"
            >
            <img
              alt="Chord Book"
              class="hidden"
              :src="icons.wordmarkDark"
            >
          </ion-label>
          <ion-button
            v-if="isNotCollapsed"
            class="collapse-button"
            shape="round"
            fill="clear"
            style="display: flex; align-items: center; justify-content: center;"
            @click="collapse"
          >
            <ion-icon
              slot="start"
              size="small"
              class="hamburger-icon"
              :src="icons.chevronBack"
            />
          </ion-button>
          <ion-button
            v-else
            class="collapse-button--collapsed"
            shape="round"
            fill="clear"
            style="display: flex; align-items: center; justify-content: center;"
            @click="collapse"
          >
            <ion-icon
              slot="start"
              size="small"
              class="hamburger-icon"
              :src="icons.chevronForward"
            />
          </ion-button>
        </ion-item>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ion-padding-horizontal width-only">
      <ion-list lines="none">
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            :router-link="{ name: 'home' }"
            router-direction="root"
            :detail="false"
            :color="colorFor('home')"
          >
            <ion-icon
              v-if="isNotCollapsed"
              slot="start"
              size="small"
              :icon="icons.home"
            />
            <ion-icon
              v-else
              :icon="icons.home"
              size="small"
              class="collapsed-icon"
            />
            <ion-label v-if="isNotCollapsed">
              Home
            </ion-label>
            <ion-label v-else />
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            :router-link="{ name: 'discover' }"
            router-direction="root"
            :detail="false"
            :color="colorFor('discover')"
          >
            <ion-icon
              v-if="isNotCollapsed"
              slot="start"
              size="small"
              :icon="icons.search"
            />
            <ion-icon
              v-else
              :icon="icons.search"
              size="small"
              class="collapsed-icon"
            />
            <ion-label v-if="isNotCollapsed">
              Discover
            </ion-label>
            <ion-label v-else />
          </ion-item>
        </ion-menu-toggle>
      </ion-list>

      <ion-list lines="none">
        <ion-list-header
          v-if="isNotCollapsed"
          style="fontSize: 14px"
          lines="none"
        >
          Library
        </ion-list-header>
        <ion-list-header
          v-else
          lines="none"
          class="collapsed-text"
        >
          ·
        </ion-list-header>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            router-link="/songsheets"
            router-direction="root"
            :detail="false"
            :color="colorFor('songs')"
          >
            <ion-icon
              v-if="isNotCollapsed"
              slot="start"
              size="small"
              :icon="icons.song"
            />
            <ion-icon
              v-else
              :icon="icons.song"
              size="small"
              class="collapsed-icon"
            />
            <ion-label v-if="isNotCollapsed">
              Songs
            </ion-label>
            <ion-label v-else />
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            :router-link="{ name: 'artists' }"
            router-direction="root"
            :detail="false"
            :color="colorFor('artists')"
          >
            <ion-icon
              v-if="isNotCollapsed"
              slot="start"
              size="small"
              :icon="icons.artist"
            />
            <ion-icon
              v-else
              :icon="icons.artist"
              size="small"
              class="collapsed-icon"
            />
            <ion-label v-if="isNotCollapsed">
              Artists
            </ion-label>
            <ion-label v-else />
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            :router-link="{ name: 'albums' }"
            router-direction="root"
            :detail="false"
            :color="colorFor('albums')"
          >
            <ion-icon
              v-if="isNotCollapsed"
              slot="start"
              size="small"
              :icon="icons.album"
            />
            <ion-icon
              v-else
              :icon="icons.album"
              size="small"
              class="collapsed-icon"
            />
            <ion-label v-if="isNotCollapsed">
              Albums
            </ion-label>
            <ion-label v-else />
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            :router-link="{ name: 'setlists' }"
            router-direction="root"
            :detail="false"
            :color="colorFor('setlists')"
          >
            <ion-icon
              v-if="isNotCollapsed"
              slot="start"
              size="small"
              :icon="icons.setlist"
            />
            <ion-icon
              v-else
              :icon="icons.setlist"
              size="small"
              class="collapsed-icon"
            />
            <ion-label v-if="isNotCollapsed">
              Setlists
            </ion-label>
            <ion-label v-else />
          </ion-item>
        </ion-menu-toggle>
      </ion-list>
    </ion-content>
    <ion-footer>
      <ion-toolbar class="text-center">
        <current-user :is-not-collapsed="isNotCollapsed" />
      </ion-toolbar>
    </ion-footer>
  </ion-menu>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import * as icons from '@/icons'
import CurrentUser from './CurrentUser.vue'

const route = useRoute()
const selected = ref('discover')

watch(route, () => (selected.value = route.meta?.selected || selected.value), { immediate: true })

function colorFor (item) {
  return item === selected.value ? 'primary' : ''
}

</script>

<script>
export default {
  data () {
    return {
      isNotCollapsed: true,
      menuWidth: '330px',
      hamburgerIconHeight: '14px',
      rMargin: '32px',
      wordmarkOpacity: '1'
    }
  },
  methods: {
    collapse (e) {
      e.preventDefault()
      if (this.isNotCollapsed) {
        this.isNotCollapsed = false
        this.menuWidth = '50px'
        this.rMargin = '10px'
        this.wordmarkOpacity = '0'
      } else {
        this.isNotCollapsed = true
        this.menuWidth = '330px'
        this.hamburgerIconHeight = '16px'
        this.rMargin = '32px'
        this.wordmarkOpacity = '1'
      }
    }
  }
}
</script>
<style scoped>
* {
  transition: 0.4s ease-in-out;
}

.logo {
  margin-right: v-bind('rMargin');
}

ion-menu {
  @apply border-r dark:border-zinc-900;
}

.ios ion-toolbar {
  /* --background: transparent; */
}

.ios ion-item {
  @apply rounded-lg;
}

.ion-item-custom::part(native){
  --padding-end: 5px;
}

.maxw-minw {
  max-width: 500px;
  min-width: 100px;
}
.item-inner {
  padding-right: 0px;
}
.width-state {
  max-width: v-bind('menuWidth');
}

.wordmark-label {
  opacity: v-bind(wordmarkOpacity);
}

.wordmark-label--collapsed {
  opacity: v-bind(wordmarkOpacity);
  display: none;
}

.collapse-button {
  --background: none;
  --padding-end: 5px;
  --padding-start: 5px;
  --ripple-color: transparent;
  width: fit-content;
  margin-right: 0px;
  margin-left: 0px;
  transition: 0.6s ease;
}

.collapse-button--collapsed {
  --ripple-color: transparent;
  margin-left: 0px;
  margin-right: 2px;
}

.hamburger-icon {
  height: v-bind('hamburgerIconHeight');
  margin-inline: 0px;
}

.collapsed-icon{
  margin-left: 7px;
}

.collapsed-text {
  font-family: 'Times New Roman';
  color: #686868;
  font-size: 30px;
  margin-left: 10px;
}
</style>
