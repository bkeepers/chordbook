import ChordSheetJS from 'chordsheetjs'

const PARSERS = [
  {
    pattern: /\[(Verse.*|Chorus)\]/i,
    parser: new ChordSheetJS.UltimateGuitarParser({ preserveWhitespace: false })
  },
  {
    pattern: /{\w+:.*|\[[A-G].*\]/i,
    parser: new ChordSheetJS.ChordProParser()
  },
  {
    pattern: /.*/,
    parser: new ChordSheetJS.ChordSheetParser({ preserveWhitespace: false })
  }
]

export default function detectFormat (source) {
  if (!source) return
  return PARSERS.find(({ pattern }) => source.match(pattern))?.parser
}
