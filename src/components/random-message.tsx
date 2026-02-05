import useUi from '../hooks/use-ui'

export default function RandomMessage() {
  const { fillForm } = useUi()

  return (
    <div>
      <h1>Random message</h1>

      <button
        onClick={() => fillForm(Math.random().toString(36).substring(2, 15))}
      >
        Fill form
      </button>
    </div>
  )
}
