import './application.css'

import { createApp } from 'vue'
import { createMetaManager, plugin as metaPlugin } from 'vue-meta'
import { createPinia } from 'pinia'
import { IonicVue } from '@ionic/vue'
import App from './views/App.vue'
import VueAxios from 'vue-axios'
import client from './client'
import router from './router'
import telemetry from './telemetry'
import * as components from './components'

const app = createApp(App)
  .use(createPinia())
  .use(IonicVue)
  .use(VueAxios, client)
  .use(router)
  .use(createMetaManager())
  .use(metaPlugin)

for (const name in components) {
  app.component(name, components[name])
}

router.isReady().then(() => {
  telemetry()
  app.mount('[data-behavior=vue]')
})
