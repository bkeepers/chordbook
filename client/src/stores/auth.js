import { defineStore } from 'pinia'
import { useFetch } from '@/client'
import { useStorage } from '@vueuse/core'
import { unref, computed } from 'vue'
import { useRouter } from 'vue-router'

let timeout = null

export default defineStore('auth', () => {
  // Accepting the security trade-offs of persisting in localStorage. There is no other reasonable
  // method to keep the user signed across page reloads and multiple browser tabs. The access token
  // expiry is short and the refresh token is rotated every time it is used, so risk is reduced.
  // If anyone knows a better way to persist this securely, please share it.
  const user = useStorage('user', {})
  const accessToken = useStorage('accessToken', null)
  const expireAt = useStorage('expireAt', new Date())
  const refreshToken = useStorage('refreshToken', null)
  const isAuthenticated = computed(() => !!user.value.id)
  const ttl = computed(() => +expireAt.value - new Date())
  const headers = computed(() => {
    return {
      Authorization: `Bearer ${accessToken.value}`
    }
  })

  function signUp (data, useFetchOptions = {}) {
    const fetch = useFetch('users', useFetchOptions).post(data).json()
    fetch.onFetchResponse(() => authenticated(fetch))
    return fetch
  }

  function signIn (data, useFetchOptions = {}) {
    const fetch = useFetch('authenticate', useFetchOptions).post(data).json()
    fetch.onFetchResponse(() => authenticated(fetch))
    return fetch
  }

  function forgotPassword (data, useFetchOptions = {}) {
    return useFetch('password', useFetchOptions).post(data).json()
  }

  function resetPassword (data, useFetchOptions = {}) {
    return useFetch('password', useFetchOptions).put(data).json()
  }

  function signOut () {
    return useFetch('authenticate', { afterFetch: clear }).delete()
  }

  function refresh (force = false) {
    if (!refreshToken.value) return
    if (!force && ttl.value > 0) return

    useFetch('authenticate')
      .put({ refresh_token: refreshToken.value })
      .json()
      .then(authenticated)
      .catch(clear)
  }

  function clear () {
    user.value = {}
    accessToken.value = null
    refreshToken.value = null
    expireAt.value = new Date()
  }

  function authenticated ({ data, response }) {
    accessToken.value = unref(response).headers.get('access-token')
    expireAt.value = new Date(unref(response).headers.get('expire-at') * 1000)
    refreshToken.value = unref(response).headers.get('refresh-token')
    user.value = unref(data)

    // FIXME: this won't work for multiple browser tabs. One of them will succeed with the refresh
    clearTimeout(timeout)
    timeout = setTimeout(refresh, ttl.value)
  }

  const router = useRouter()

  function assert () {
    if (isAuthenticated.value) return true

    router.push('#signup')
    return false
  }

  function guard (callback) {
    return () => assert() && callback()
  }

  return { user, isAuthenticated, headers, signUp, signIn, signOut, forgotPassword, resetPassword, refresh, assert, guard }
})
