import elements from '../utils/elements'

export default function useUi() {
  return {
    fillForm: (text: string) => {
      console.log('Filling form')

      const input = elements.getMessageInput()

      if (!input) return

      input.value = text
    },
  }
}
