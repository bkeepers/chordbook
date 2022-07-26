<script setup>
import useAuthStore from '@/stores/auth'
import * as icons from '@/icons'

const auth = useAuthStore()
</script>

<script>
export default {
  props: {
    isNotCollapsed: Boolean
  }
}
</script>
<template>
  <div v-if="auth.isAuthenticated">
    <ion-chip
      v-if="isNotCollapsed"
      id="current-user"
    >
      <ion-avatar>
        <img :src="icons.avatar">
      </ion-avatar>
      <ion-label>{{ auth.user.email }}</ion-label>
    </ion-chip>
    <ion-chip
      v-else
      id="current-user--collapsed"
    >
      <ion-avatar
        class="ion-avatar--collapsed"
      >
        <img :src="icons.avatar">
      </ion-avatar>
    </ion-chip>
    <ion-popover
      v-if="isNotCollapsed"
      trigger="current-user"
      side="top"
      alignment="center"
      translucent
      dismiss-on-select
      :show-backdrop="false"
      :arrow="false"
      style="--offset-y:-5rem"
    >
      <ion-list>
        <ion-item
          lines="none"
          button
          detail
          :detail-icon="icons.signout"
          @click="auth.signOut"
        >
          Sign Out
        </ion-item>
      </ion-list>
    </ion-popover>
    <ion-popover
      v-else
      trigger="current-user--collapsed"
      side="top"
      alignment="center"
      translucent
      dismiss-on-select
      :show-backdrop="false"
      :arrow="false"
      style="--offset-y:-5rem;"
      class="ion-popover--collapsed"
    >
      <ion-list>
        <ion-item
          lines="none"
          button
          detail
          :detail-icon="icons.signout"
          @click="auth.signOut"
        >
          Sign Out
          <span class="user-email">
            {{ auth.user.email }}
          </span>
        </ion-item>
      </ion-list>
    </ion-popover>
  </div>
  <div v-else>
    <ion-button
      v-if="isNotCollapsed"
      color="dark"
      fill="outline"
      router-link="#signin"
    >
      Sign In
    </ion-button>
    <ion-button
      v-else
      color="dark"
      fill="outline"
      style="transform: scale(0.7)"
      router-link="#signin"
    >
      Sign In
    </ion-button>
    <ion-button
      v-if="isNotCollapsed"
      color="dark"
      fill="clear"
      router-link="#signup"
    >
      Sign Up
    </ion-button>
    <ion-button
      v-else
      color="dark"
      fill="clear"
      style="transform: scale(0.7)"
      router-link="#signup"
    >
      Sign Up
    </ion-button>
  </div>
</template>

<style scoped>

ion-button {
  transition: 0.6s ease;
}

#current-user, #current-user-collapsed {
  transition: 0.5s ease;
}

#current-user-collapsed {
  --background: white;
}
.ion-popover--collapsed {
  --width: fit-content;
}

.ion-avatar--collapsed {
  margin-inline: 0px;
}

.user-email {
  font-size: 12px;
  margin-left: 20px;
  margin-right: 10px;
  color: #ABABAB;
}
</style>
