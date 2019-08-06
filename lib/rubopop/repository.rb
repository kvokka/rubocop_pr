module Rubopop
  # abstract repository class
  class Repository
    class << self
      def all
        @all ||= {}
      end

      def inherited(base)
        name = base.name.split('::').slice(-2).downcase
        all[name] = base
      end

      # Array of Class which respond_to ::call and raise if check do not pass
      def checks
        []
      end
    end
  end
end
