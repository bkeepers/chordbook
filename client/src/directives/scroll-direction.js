import { useCssVar } from '@vueuse/core'

export default {
  async mounted(el, binding, vnode, prevVnode) {
    const scroller = await el.getScrollElement()
    const scrollDistanceVar = useCssVar('--scroll-distance', el)

    const prev = {
      scrollTop: 0,
      direction: 'down',
      distance: 0
    }

    scroller.addEventListener('scroll', (e) => {
      // Get the current scroll position
      const { scrollTop } = e.target

      // Because of momentum scrolling on mobiles, we shouldn't continue if it is less than zero
      if (scrollTop < 0) return

      const distance = scrollTop - prev.scrollTop
      const direction = distance > 0 ? 'down' : 'up'

      console.log({ scrollTop, distance, direction })
      console.log('prev', prev)

      // Change of direction, reset total distance traveled
      if (direction !== prev.direction) {
        prev.distance = 0
      }

      el.classList.toggle('scroll-up', direction === 'up')
      el.classList.toggle('scroll-down', direction === 'down')

      // Set the current scroll position as the last scroll position
      Object.assign(prev, { scrollTop, direction, distance: prev.distance + distance })

      scrollDistanceVar.value = -(prev.distance / 1.5) + 'px'
    })
  }
}
