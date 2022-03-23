# frozen_string_literal: true

class InputOutput
  def out(string)
    $stdout.puts string
  end

  def read
    $stdin.gets
  end
end
