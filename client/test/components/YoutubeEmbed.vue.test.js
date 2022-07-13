import { mount } from '@vue/test-utils'
import YoutubeEmbed from '@/components/YoutubeEmbed.vue'
import { expect, test } from 'vitest'

test('works with youtube.com src', async () => {
  const wrapper = mount(YoutubeEmbed, { props: { src: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' } })
  const iframe = wrapper.get('iframe')
  expect(iframe.attributes().src).toEqual('https://www.youtube.com/embed/dQw4w9WgXcQ')
})

test('works with youtu.be src', async () => {
  const wrapper = mount(YoutubeEmbed, { props: { src: 'https://youtu.be/dQw4w9WgXcQ' } })
  const iframe = wrapper.get('iframe')
  expect(iframe.attributes().src).toEqual('https://www.youtube.com/embed/dQw4w9WgXcQ')
})
