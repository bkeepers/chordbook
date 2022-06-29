import { mount } from '@vue/test-utils'
import { render } from '@testing-library/vue'
import YoutubeEmbed from '@/components/YoutubeEmbed.vue'
import { expect } from 'vitest'

test('youtube.com src', async () => {
  const wrapper = mount(YoutubeEmbed, { props: { src: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' } })
  const iframe = wrapper.get('iframe')
  expect(iframe.attributes().src).toEqual('https://www.youtube.com/embed/dQw4w9WgXcQ')
})

test('youtu.be src', async () => {
  const wrapper = mount(YoutubeEmbed, { props: { src: 'https://youtu.be/dQw4w9WgXcQ' } })
  const iframe = wrapper.get('iframe')
  expect(iframe.attributes().src).toEqual('https://www.youtube.com/embed/dQw4w9WgXcQ')
})
