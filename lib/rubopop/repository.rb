module Rubopop
  # abstract repository class
  class Repository
    class << self
      def all
        @all ||= ::ActiveSupport::HashWithIndifferentAccess.new
      end

      def inherited(base)
        all[base.name.demodulize.underscore] = base
      end

      # Array of Class which respond_to ::call and raise if check do not pass
      def checks
        []
      end

      # return Integer issue number
      def create_issue(*)
        raise NotImplemented, 'should be implemented on sub-class'
      end
    end
  end
end
