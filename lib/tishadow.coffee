{CompositeDisposable,BufferedProcess} = require 'atom'

module.exports = Tishadow =
  tishadowView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command
    @subscriptions.add atom.commands.add 'atom-workspace', 'tishadow:pipe': => @pipe()

  deactivate: ->
    @subscriptions.dispose()

  pipe: ->
    if editor = atom.workspace.getActiveTextEditor()
      snippet = JSON.stringify(editor.getSelectedText() || editor.getText())
      command = 'sh'
      args = ["-c","echo #{snippet} | ts repl --pipe"]
      stdout = (output) -> console.log(output)
      exit = (code) -> console.log("ts pipe exit with #{code}")
      process = new BufferedProcess({command, args, stdout, exit})
