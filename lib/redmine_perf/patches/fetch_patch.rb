

module  RedminePerf
  module  Patches
    module FetchPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :project_ids, :perf

        end
      end
    end
    module ClassMethods
    end

    module InstanceMethods
      def project_ids_with_perf
        Array.wrap(@projects.pluck(:id))
      end
    end

  end
end
