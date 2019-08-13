module RubocopPr
  # Simple representation of the Cop
  class Cop
    attr_reader :name

    def initialize(name:)
      @name = name
    end

    def to_s
      name.to_s
    end

    def branch
      "rubocop-fix-#{name.underscore.tr('/_', '-')}"
    end
  end
end
