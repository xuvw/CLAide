class String
  # @return [String] The method strips the characters preceding a special
  # margin character. Useful for HEREDOCs and other multi-line strings.
  #
  # @example
  #
  #   code = <<-END.strip_margin('|')
  #     |def test
  #     |  some_method
  #     |  other_method
  #     |end
  #   END
  #
  #   #=> "def\n  some_method\n  \nother_method\nend"
  #
  # @note Extracted from the powerpack gem available under the MIT license
  #       and copyright (c) 2013 Bozhidar Batsov.
  #
  def strip_margin(margin_characters)
    margin = Regexp.quote(margin_characters)
    gsub(/^\s+#{margin}/, '')
  end
end
