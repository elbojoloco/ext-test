import { MESSAGE_INPUT_SELECTOR } from '../constants'

export default {
  getMessageInput: () => {
    return document.querySelector(MESSAGE_INPUT_SELECTOR) as HTMLInputElement
  },
}
