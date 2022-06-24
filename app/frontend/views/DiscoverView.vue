<template>
  <ion-page>
    <ion-header
      collapse="fade"
      class="ion-no-border"
    >
      <ion-toolbar>
        <ion-title>Discover</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-header
        v-show="!isSearching"
        collapse="condense"
      >
        <ion-toolbar>
          <ion-title size="large">
            Discover
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-header
        collapse="fade"
        class="sticky top-0"
      >
        <ion-toolbar>
          <ion-searchbar
            ref="input"
            v-model="params.q"
            :show-cancel-button="isSearching ? 'always' : 'focus'"
            debounce="150"
            animated
            @ion-focus="hasFocus = true"
            @ion-blur="hasFocus = false"
          />
        </ion-toolbar>
        <ion-toolbar v-show="isSearching">
          <ion-segment
            :value="params.type"
            @ion-change="params.type = $event.detail.value"
          >
            <ion-segment-button
              v-for="id, name in types"
              :key="id"
              :value="id"
            >
              <ion-label>{{ name }}</ion-label>
            </ion-segment-button>
          </ion-segment>
        </ion-toolbar>
      </ion-header>

      <ion-list v-show="isSearching">
        <Transition>
          <ion-item
            v-if="isFinished && (!data || data.length == 0)"
            lines="none"
          >
            No results
          </ion-item>
        </Transition>
        <ion-item
          v-for="result in data"
          :key="result.type + result.id"
          button
          :router-link="{ name: result.type.toLowerCase(), params: { id: result.id } }"
        >
          <ion-avatar slot="start">
            <img :src="result.thumbnail"> <!-- class="rounded" -->
          </ion-avatar>
          <ion-label>
            <p class="uppercase">
              {{ result.type }}
            </p>
            <h2>{{ result.title }}</h2>
            <p>{{ result.subtitle }}</p>
          </ion-label>
        </ion-item>
        <Transition name="slide-down">
          <ion-item
            v-if="isFetching"
            lines="none"
          >
            <ion-spinner name="dots" />
          </ion-item>
        </Transition>
      </ion-list>
      <GenreListView v-show="!isSearching" />
    </ion-content>
  </ion-page>
</template>

<script setup>
import GenreListView from '@/views/GenreListView.vue'
import { useRouteQuery } from '@vueuse/router'
import { useFetch } from '@/client'
import { computed, ref, unref, reactive, watch } from 'vue'
import { useMeta } from 'vue-meta'

const types = {
  All: '',
  Artists: 'Artist',
  Albums: 'Album',
  Songs: 'Track,Songsheet'
}

useMeta({ title: 'Discover' })

const params = reactive({
  q: useRouteQuery('q'),
  type: useRouteQuery('type', '')
})

const hasFocus = ref(false)
const isSearching = computed(() => !!unref(params.q || hasFocus))
const { execute, data, isFetching, isFinished, abort } = useFetch('search', { params, immediate: params.q }).get().json()

watch(params, () => {
  if (params.q) {
    abort()
    execute()
  }
})
</script>
