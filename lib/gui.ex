defmodule Gui do

  def run do
    ExNcurses.initscr()

    ExNcurses.listen()
    ExNcurses.flushinp()
    ExNcurses.endwin()
  end

end
